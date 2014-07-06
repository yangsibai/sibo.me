pinBll = require("../model/bll/pin")

exports.index = (req, res)->
	pinBll.all (err, pageData)->
		if err
			res.send err.message
		else
			res.render "index",
				title: "Pin It"
				pageData: pageData