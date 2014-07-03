dbSnippet = require('../Dal/dbSnippet')
marked = require("marked")

###
    新建
###
exports.new = (snippet, cb)->
	if snippet.title and snippet.content and snippet.tags
		if snippet.title.indexOf('.md') > 0
			snippet.html = marked(snippet.content)
		else
			snippet.html = snippet.content
		snippet.tags = snippet.tags.split('|')
		dbSnippet.new(snippet, cb)

###
    单条
###
exports.single = (id, cb)->
	if id > 0
		dbSnippet.single id, cb
	else
		cb new Error("invalid request")

exports.all = (cb)->
	dbSnippet.all cb