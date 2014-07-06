dbPin = require('../dal/dbPin')

exports.new = (data, cb)->
	dbPin.new data, cb

exports.countOnPage = (url, cb)->
	dbPin.countOnPage url, cb

exports.pinOnPage = (url, cb)->
	dbPin.pinOnPage url, cb

exports.all = (cb)->
	dbPin.all cb