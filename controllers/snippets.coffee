snippetBll = require('../model/Bll/snippet')
dataHelper = require('../helper/dataHelper')

exports.$mvcConfig =
	route:
		single:
			path: "/snippets/single/:id"

###
    /snippets/
###
exports.index = (req, res)->
	snippetBll.all (err, snippets)->
		if err
			res.send
				code: 1
				message: err.message
		else
			for snippet in snippets
				snippet.addTime = dataHelper.prettyDateTime(snippet.addTime)
			res.render "index",
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
				snippet: snippet

###
    new snippet
    /snippets/new
###
exports.new_GET_POST = (req, res)->
	if req.method is "GET"
		res.render "new"
	else
		snippetBll.new req.body, (err, id)->
			if err
				res.send
					code: 1
					message: err.message
			else
				res.redirect("/snippets/single/#{id}")