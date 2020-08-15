{Product,BudgetItem} = require \../lib/schema

@include = ->
    @passport = require \passport
    CookieStore = require \cookie-sessions
    @use @express.static __dirname + \/../_public
    @use \bodyParser
    @use CookieStore secret: @config.cookie_secret, onError: ->
        return {}
    @app.use @passport.initialize!
    @app.use @passport.session!
    if @config.use_basic_auth
      @basicauth = require \./basicauth
      @app.use @basicauth
    @use @app.router
    @app.set("trust proxy", true);
    @app.set("views", "#{__dirname}/../app")
    encryptlib = require \../lib/encrypt
    log = @log

    RealBin = require \path .dirname do
        require \fs .realpathSync __filename
    RealBin -= /\/server/

    sendFile = (file) -> ->
        @response.contentType \text/html
        @response.sendfile "#RealBin/_public/#file"

    JsonType = { \Content-Type : 'application/json; charset=utf-8' }

    @helper ensureAuthenticated: (next) ->
        if @request?isAuthenticated! => return next!
        @response.send 401

    @get '/1/products/:query': ->
        err, res <~ Product.find!
        .exec
        results = for i in [1 to 10]
            name: \ONE, categoryKey: \htc:one, products: res
        @response.send results

    @get '/1/profile': ->
        <~ @ensureAuthenticated
        @response.send @request.user

    @get '/1/budgetitems': ->
        err, item <~ BudgetItem.find {}, 'key nhates nconfuses nlikes ncuts'
        .exec
        @response.send item

    @get '/1/budgetitems/:key': ->
        err, item <~ BudgetItem.findOne {key: @params.key}, 'key nhates nconfuses nlikes ncuts tags'
        .exec
        log.info @params.key, item
        @response.send item

    @post '/1/budgetitems/:key/tags/:tag': ->
        key = @params.key
        tag = @params.tag

        done = (err, item) ~>
            errr, updated <~ item.update $addToSet: tags: tag
            log.info errr, updated
            err, item <~ BudgetItem.findOne 'key': key
            @response.send item

        err, item <- BudgetItem.findOne 'key': key
        return done(null, item) if item?id
        item = new BudgetItem do
            key: key
        err <- item.save
        return done(err, null) if err
        done(null, item)
    @post '/1/budgetitems/:key/:what': ->
        key = @params.key
        done = (err, item) ~>
            log.info item
            if @params.what in <[likes confuses hates cuts]>
                log.info item._id
                user_id = @request.user?_id ? @request.ip

                errr, updated <~ BudgetItem.update {_id: item._id, "#{@params.what}": {$ne: user_id}}, do 
                    $inc: "n#{@params.what}": 1
                    $push: { "#{@params.what}": user_id }
                log.info errr, updated
                err, item <~ BudgetItem.findOne 'key': key
                @response.send item
            else
                @response.send item

        err, item <- BudgetItem.findOne 'key': key
        return done(null, item) if item?id
        item = new BudgetItem do
            key: key
        err <- item.save
        return done(err, null) if err
        done(null, item)

    @include \auth
    @include \opengraph
    @csv2012 = null
    @loadCsv \app/assets/data/tw2012ap.csv, (hash) ~> 
      @csv2012 = hash
    getOpenGraph = (code) ~> @getOpenGraph @csv2012,code
    locals = {}
    locals[\twitter_auth] = encryptlib.encrypt @config.twitter_auth, @config.twitter_key
    locals[\twitter_proxy_host] = @config.twitter_proxy_host
    locals[\twitter_proxy_port] = @config.twitter_proxy_port
    locals[\web_host] = @config.web_host
    locals[\access_analysis_id] = @config.access_analysis_id

    @get '/:what': ->
        #sendFile \index.html
        @render 'index.static.jade', locals

    @get '/budget/:code': ->
        code = (@request.path.match /\/budget\/(\S+)/)[1]
        localsForOpenGraph = getOpenGraph code
        localsWithOpenGraph = Object.assign(locals, localsForOpenGraph)
        @render 'index.static.jade', localsWithOpenGraph
