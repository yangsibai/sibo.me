dbSnippet = require('../dal/dbSnippet')
marked = require("marked")

###
    新建
###
exports.new = (snippet, cb)->
	if snippet.title and snippet.content and snippet.tags
		if snippet.title.indexOf('.md') > 0
			snippet.html = marked(snippet.content)
		else
			snippet.html = ""
		snippet.tags = snippet.tags.split('|')
		dbSnippet.new snippet, cb

###
    更新
###
exports.update = (snippet, cb)->
	if snippet.title.toLowerCase().indexOf('.md') > 0
		snippet.html = marked(snippet.content)
	else
		snippet.html = ""
	snippet.tags = snippet.tags.split('|')
	dbSnippet.update snippet, cb

###
    单条
###
exports.single = (id, cb)->
	if id > 0
		dbSnippet.single id, cb
	else
		cb new Error("invalid request")

###
    delete
###
exports.delete = (id, cb)->
	if id > 0
		dbSnippet.delete id, cb
	else
		cb new Error("invalid request")

###
    列表
###
exports.list = (cb)->
	dbSnippet.list cb