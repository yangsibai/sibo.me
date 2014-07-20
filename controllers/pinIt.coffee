pinBll = require("../model/bll/pin")
dataHelper = require("../helper/dataHelper")

exports.index = (req, res)->
	pinBll.all dataHelper.pageState.inProgress, (err, pageData)->
		if err
			res.err err.message
		else
			res.render "index",
				title: "Pin It"
				pageData: pageData
				auth: req.session.auth

###
    get page data
###
exports.data = (req, res)->
	state = parseInt(req.query.state or "0")
	if state in [0, 1]
		pinBll.all state, (err, pageData)->
			if err
				res.err err
			else
				res.data
					pageData: pageData

###
    archive page
###
exports.archive_$auth = (req, res)->
	pageId = req.query.id
	pinBll.archive pageId, (err)->
		if err
			res.err err
		else
			res.ok()

###
    search page
###
exports.search_POST=(req,res)->
	keyword=req.body.keyword
	pinBll.search keyword,(err,data)->
		if err
			res.err err
		else
			res.data
				result:data
