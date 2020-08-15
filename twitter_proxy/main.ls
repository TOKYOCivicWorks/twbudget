@include = ->
    @use \bodyParser
    @app.set("trust proxy", true);
    @fetch = require \node-fetch
    @passport = require \passport
    @bearer = require \passport-http-bearer
    @app.use @passport.initialize!
    @app.use @passport.session!
    @use @app.router
    encryptlib = require \../lib/encrypt
    log = @log

    @passport.use new @bearer.Strategy (token, done) ->
        log.info "token: " + token
        if token and token.length > 0 then
            return done(null, 'Anonymous', { \scope : 'read' })
        else
            return done(null, false)

    if @config.web_port == '80'
        CrossOrigin = 'http://' + @config.web_host
    else
        CrossOrigin = 'http://' + @config.web_host + ':' + @config.web_port
    log.info("Set cross origin as " + CrossOrigin)

    RealBin = require \path .dirname do
        require \fs .realpathSync __filename
    RealBin -= /\/server/

    sendJson = (json, response) ->
        if json.errors
            for err in json.errors
                log.error("json.errors[].message: " + err.message)
            log.info "json: ", json
            return

        log.info "json.meta.result_count: %d" json.meta.result_count
        response.header 'Access-Control-Allow-Origin' CrossOrigin
        response.header 'Access-Control-Allow-Headers' 'Origin, X-Requested-With, Content-Type, Accept'
        response.header 'Access-Control-Allow-Methods' 'OPTIONS, GET'
        response.contentType \text/json
        response.json json

    sendError = (err, response) ->
        response.header 'Access-Control-Allow-Origin' CrossOrigin
        response.header 'Access-Control-Allow-Headers' 'Origin, X-Requested-With, Content-Type, Accept'
        response.header 'Access-Control-Allow-Methods' 'OPTIONS, GET'
        response.status 401
        response.send err

    sendRequest = (req, cb, cb_error, res) ~>
        log.info "req.ip:", req.ip, req.ips
        log.info "req.headers:"
        log.info req.headers
        options = {
            method : 'GET',
            headers : req.headers,
            timeout : 10000
        }

        # Remove '_' from req.query (this was attached by ajax get function with cache: false)
        if req.query._
            delete req.query._

        qs = new URLSearchParams(req.query)
        url = "https://api.twitter.com/2/tweets/search/recent?" + qs
        log.info "url: " + url
        log.info "req.query: "
        log.info req.query
        options.headers['referer'] = req.headers['host']
        options.headers['host'] = 'api.twitter.com'
        options.headers['accept'] = 'text/json,application/json,text/html,application/xhtml+xml,application/xml; charset=utf-8'
        auth = req.headers['authorization']
        type_token = auth.split(' ')
        decrypted_token = encryptlib.decrypt(type_token[1], @config.twitter_key)
        options.headers['authorization'] = type_token[0] + ' ' + decrypted_token

        @fetch url, options
            .then (r) ->
                r.json()
            .then (json) ->
                cb json, res
            .catch (err) ->
                log.error(err)
                cb_error err, res

    @options '*': (req, res) ->
        res.header 'Access-Control-Allow-Origin' CrossOrigin
        res.header 'Access-Control-Allow-Headers' 'Authorization, Origin, X-Requested-With, Content-Type, Accept'
        res.header 'Access-Control-Allow-Methods' 'OPTIONS, GET'
        res.send 200

    @get '/api/search':
        @passport.authenticate 'bearer', { \session : false }
        (req, res) -> sendRequest req, sendJson, sendError, res
