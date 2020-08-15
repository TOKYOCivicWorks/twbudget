log = require \../lib/log

argv = try require \optimist .argv
json = try JSON.parse do
    require \fs .readFileSync \environment.json \utf8
node_env = process.env.NODE_ENV ? \development
defaults = json.defaults[node_env]
host = argv?host or \0.0.0.0
port = Number(argv?port or json?TWITTER_PROXY_PORT or process.env.TWITTER_PROXY_PORT
    or defaults.TWITTER_PROXY_PORT)
basepath = (argv?basepath or "") - /\/$/
webHost = argv?webhost or process.env.WEB_HOST or defaults.WEB_HOST
webPort = argv?webport or process.env.WEB_PORT or defaults.WEB_PORT
twitterKey = argv?twitterkey or process.env.TWITTER_AUTH_ENCRYPT_KEY
log.setLogLevel defaults.LOG_LEVEL

log.info "NODE_ENV: #node_env"
log.info "Please connect to: http://#{
    if host is \0.0.0.0 then require \os .hostname! else host
}:#port/"

<- (require \zappajs) port, host
@BASEPATH = basepath

@config = json ? {}
@config.twitter_key ?= twitterKey
@config.web_host ?= webHost
@config.web_port ?= webPort
@log = log

if @config.twitter_key === undefined
    log.fatal "twitter_key is undefined. Please set TWITTER_AUTH_ENCRYPT_KEY"

@include \main
