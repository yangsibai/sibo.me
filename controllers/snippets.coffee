snippetBll = require('../model/Bll/snippet')

exports.$mvcConfig =
	route:
		single:
			path: "/snippets/single/:id"


exports.index = (req, res)->
	snippetBll.all (err, snippets)->
		if err
			res.send
				code: 1
				message: err.message
		else
			res.render "index",
				snippets: snippets

exports.single = (req, res)->
	sId = req.params.id
	snippetBll.single sId, (err, snippet)->
		if err
			res.send
				code: 1
				message: err.message
		else
			res.render "single",
				snippet: snippet

exports.new_GET_POST = (req, res)->
	if req.method is "GET"
		res.render "new"
	else
		snippetBll.new req.body, (err)->
			if err
				res.send
					code: 1
					message: err.message
			else
				res.send
					code: 0
					message: "ok"