const logLevels = {
    'FATAL': 0,
    'ERROR': 1,
    'INFO': 2,
    'DEBUG': 3,
}

class LogClass
    ->
        @currentLogLevel = logLevels['INFO']

    setLogLevel: (level) ->
        @currentLogLevel = logLevels[level]

    getLogLevel: ->
        @currentLogLevel

    fatal: ->
        if @currentLogLevel >= logLevels['FATAL']
            if typeof arguments[0] == 'string'
                arguments[0] = "[FATAL] " + @_getDateString() + arguments[0]
            console.error.apply(this, arguments)
            throw new Error 'fatal'

    error: ->
        if @currentLogLevel >= logLevels['ERROR']
            if typeof arguments[0] == 'string'
                arguments[0] = "[ERROR] " + @_getDateString() + arguments[0]
            console.error.apply(this, arguments)

    info: ->
        if @currentLogLevel >= logLevels['INFO']
            if typeof arguments[0] == 'string'
                arguments[0] = "[INFO] " + @_getDateString() + arguments[0]
            console.log.apply(this, arguments)

    debug: ->
        if @currentLogLevel >= logLevels['DEBUG']
            if typeof arguments[0] == 'string'
                arguments[0] = "[DEBUG] " + @_getDateString() + arguments[0]
            console.log.apply(this, arguments)

    _getDateString: ->
        new Date().toLocaleString('ja')  + "| "

if typeof module != 'undefined'
    # for server, twitter_proxy
    module.exports = new LogClass()
else
    # for app
    log = new LogClass()
