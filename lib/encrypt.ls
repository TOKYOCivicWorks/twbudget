CryptoJS = require \crypto-js

exports.encrypt = (str, key) ->
    CryptoJS.AES.encrypt(str, key).toString()

exports.decrypt = (str, key) ->
    CryptoJS.AES.decrypt(str, key).toString(CryptoJS.enc.Utf8)
