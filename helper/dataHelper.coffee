_ = require("underscore")
exports.prettyDate = (date)->
	if _.isString(date)
		date = new Date(date)
	datePart(date)

exports.prettyDateTime = (date)->
	if _.isString(date)
		date = new Date(date)
	"#{datePart date} #{timePart date}"

datePart = (date)->
	d = date.getDate()
	monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]
	m = monthNames[date.getMonth()]
	y = date.getFullYear()
	"#{d} #{m} #{y}"

timePart = (date)->
	h = date.getHours()
	m = date.getMinutes()
	"#{h}:#{m}"