snippetBll = require('../model/bll/snippet')
dataHelper = require('../helper/dataHelper')

exports.$mvcConfig =
	route:
		single:
			path: "/snippets/single/:id"
		edit:
			path: "/snippets/edit/:id"
		delete:
			path: "/snippets/delete/:id"

###
    /snippets/
###
exports.index = (req, res)->
	snippetBll.list (err, snippets)->
		if err
			res.send
				code: 1
				message: err.message
		else
			for snippet in snippets
				snippet.addTime = dataHelper.prettyDateTime(snippet.addTime)
			res.render "index",
				auth: req.session.auth
				title: "All snippets"
				snippets: snippets

###
    /snippets/single/1
###
exports.single = (req, res)->
	sId = req.params.id
	snippetBll.single sId, (err, snippet)->
		if err
			res.send
				code: 1
				message: err.message
		else
			snippet.addTime = dataHelper.prettyDateTime(snippet.addTime)
			res.render "single",
				auth: req.session.auth
				title: snippet.title
				snippet: snippet

###
    编辑
###
exports.edit_GET_POST_$auth = (req, res)->
	id = req.params.id
	if req.method is "GET"
		snippetBll.single id, (err, snip)->
			if err
				throw err
			else
				tagNameArr = []
				for tag in snip.tags
					tagNameArr.push tag.name
				snip.tags = tagNameArr.join('|')
				res.render "edit",
					title: "Edit - #{snip.title}"
					snippet: snip
	else
		title = req.body.title
		content = req.body.content
		tags = req.body.tags
		snippetBll.update
			id: id
			title: title
			content: content
			tags: tags
		, (err)->
			if err
				res.send
					code: 1
					message: err.message
			else
				res.send
					code: 0
					message: "ok"

###
    new snippet
    /snippets/new
###
exports.new_GET_POST_$auth = (req, res)->
	if req.method is "GET"
		res.render "new"
	else
		snippetBll.new req.body, (err, id)->
			if err
				res.send
					code: 1
					message: err.message
			else
				res.send
					code: 0
					message: "ok"
					id: id

###
    删除
###
exports.delete_$auth = (req, res)->
	id = req.params.id
	snippetBll.delete id, (err)->
		if err
			res.write(err.message)
			res.end()
		else
			res.redirect("/snippets")