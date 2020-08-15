log = require \../lib/log

argv = try require \optimist .argv
json = try JSON.parse do
    require \fs .readFileSync \environment.json \utf8
node_env = process.env.NODE_ENV ? \development
defaults = json.defaults[node_env]
host = argv?host or \0.0.0.0
port = Number(argv?port or json?WEB_PORT or process.env.WEB_PORT or defaults.WEB_PORT)
basepath = (argv?basepath or "") - /\/$/
useBasicAuth = defaults.USE_BASIC_AUTH
twitterProxyHost = argv?twitterproxyhost or process.env.TWITTER_PROXY_HOST
    or defaults.TWITTER_PROXY_HOST
twitterProxyPort = argv?twitterproxyport or process.env.TWITTER_PROXY_PORT
    or defaults.TWITTER_PROXY_PORT
twitterAuth = argv?twitterauth or process.env.TWITTER_BEARER_TOKEN
twitterKey = argv?twitterkey or process.env.TWITTER_AUTH_ENCRYPT_KEY
webHost = argv?webhost or process.env.WEB_HOST or defaults.WEB_HOST
accessAnalysisID = defaults.ACCESS_ANALYSIS_ID
log.setLogLevel defaults.LOG_LEVEL

log.info "NODE_ENV: #node_env"
log.info "Please connect to: http://#{
    if host is \0.0.0.0 then require \os .hostname! else host
}:#port/"

<- (require \zappajs) port, host
@BASEPATH = basepath

@mongoose = require \mongoose
@mongoose.connect json?MONGOLAB_URI ? process.env?MONGOLAB_URI ? \mongodb://localhost/ydh
@config = json ? {}
@config.cookie_secret ?= 'its-secret'
@config.authproviders ?= {}
@config.use_basic_auth ?= useBasicAuth
@config.web_host ?= webHost
@config.twitter_auth ?= twitterAuth
@config.twitter_key ?= twitterKey
@config.twitter_proxy_host ?= twitterProxyHost
@config.twitter_proxy_port ?= twitterProxyPort
@config.access_analysis_id ?= accessAnalysisID
@log = log

if @config.twitter_auth === undefined
    log.fatal "twitter_auth is undefined. Please set TWITTER_BEARER_TOKEN"
if @config.twitter_key === undefined
    log.fatal "twitter_key is undefined. Please set TWITTER_AUTH_ENCRYPT_KEY"
if @config.web_host === undefined
    log.fatal "web_host is undefined. Please set WEB_HOST in environment.json defaults section."

@include \main
