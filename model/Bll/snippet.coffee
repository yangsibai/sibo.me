dbSnippet = require('../Dal/dbSnippet')

exports.new = (snnippet, cb)->
	if snnippet.title and snnippet.content and snnippet.tags
		snnippet.tags = snnippet.tags.split('|')
		dbSnippet.new(snnippet, cb)


exports.single = (id, cb)->
	if id > 0
		dbSnippet.single id, cb
	else
		cb new Error("invalid request")

exports.all = (cb)->
	dbSnippet.all cb