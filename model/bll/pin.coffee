dbPin = require('../dal/dbPin')

###
    create a new pin
###
exports.new = (data, cb)->
    dbPin.new data, cb

###
    get pin count on a page
###
exports.countOnPage = (url, cb)->
    dbPin.countOnPage url, cb

###
    get all pin on a page
###
exports.pinOnPage = (url, cb)->
    dbPin.pinOnPage url, cb

###
    get all pin by state
###
exports.all = (state, cb)->
    dbPin.all state, cb

###
    update a page info
###
exports.updatePage = (info, cb)->
    dbPin.updatePage info, cb

###
    archive page
###
exports.archive = (id, cb)->
    dbPin.archive id, cb

exports.search = (key, cb)->
    if key
        dbPin.search key, cb
    else
        cb new Error("key word can't be empty")
