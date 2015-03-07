_ = require("underscore")

###
    pretty print date
###
exports.prettyDate = (date)->
    if _.isString(date)
        date = new Date(date)
    datePart(date)

###
    pretty print datetime
###
exports.prettyDateTime = (date)->
    if _.isString(date)
        date = new Date(date)
    "#{datePart date} #{timePart date}"

datePart = (date)->
    d = date.getDate()
    monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    m = monthNames[date.getMonth()]
    y = date.getFullYear()
    "#{d} #{m} #{y}"

timePart = (date)->
    h = date.getHours()
    m = date.getMinutes()
    "#{h}:#{m}"

###
    page state
###
exports.pageState =
    inProgress: 0
    archive: 1
    delete: 4
