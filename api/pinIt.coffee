pinBll = require('../model/bll/pin')

exports.new_POST = (req, res)->
	data = req.body
	pinBll.new data, (err, id)->
		if err
			res.send
				code: 1
				message: err.message
		else
			res.send
				code: 0
				message: "ok"
				id: id

exports.countOnPage = (req, res)->
	url = decodeURIComponent(req.query.url)
	pinBll.countOnPage url, (err, count)->
		if err
			res.send
				code: 1
				message: err.message
		else
			res.send
				code: 0
				message: "ok"
				count: count

exports.pinOnPage = (req, res)->
	url = decodeURIComponent(req.query.url)
	pinBll.pinOnPage url, (err, data)->
		if err
			res.send
				code: 1
				message: err.message
		else
			res.send
				code: 0
				message: "ok"
				pins: data