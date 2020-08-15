auth = require \basic-auth

user_list = { \testuser : { password : 'jpbudget2020' }}

module.exports = (request, response, next) ->
  user = auth(request)
  if !user || !user_list[user.name] || user_list[user.name].password !== user.pass
    response.set('WWW-Authenticate', 'Basic realm="Auth Test"')
    return response.status(401).send()
  return next()
