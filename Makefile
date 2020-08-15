JS_FILES=server/app.js server/main.js server/auth.js server/basicauth.js server/opengraph.js lib/user.js lib/schema.js lib/encrypt.js lib/log.js
JS_FILES_FOR_TWITTER_PROXY=twitter_proxy/app.js twitter_proxy/main.js lib/encrypt.js lib/log.js

.ls.js:
	env PATH="$$PATH:./node_modules/livescript/bin" lsc -c  $<

server :: $(JS_FILES)
clean-server:
	rm -f $(JS_FILES)

twitter-proxy :: $(JS_FILES_FOR_TWITTER_PROXY)
clean-twitter-proxy:
	rm -f $(JS_FILES_FOR_TWITTER_PROXY)

client ::
	env PATH="$$PATH:./node_modules/brunch/bin" brunch b

run :: server
	node server/app.js

run-twitter-proxy :: twitter-proxy
	node twitter_proxy/app.js

.SUFFIXES: .jade .html .ls .js
