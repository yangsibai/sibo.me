html_readability = require("html-readability")
request = require("request")

exports.index = (req, res)->
	demoSites = [
		"http://weblogs.asp.net/bsimser/day-to-day-with-subversion"
		"http://jianshu.io/p/77c949565112"
		"http://sports.sina.com.cn/nba/2014-08-24/03547305054.shtml"
		"https://medium.com/code-adventures/farewell-node-js-4ba9e7f3e52b"
	]
	res.render "index",
		demoSites: demoSites

exports.demo = (req, res)->
	console.log "demo"
	url = req.query.url
	console.log url
	if url
		try
			url = decodeURIComponent(url)
			request url, (err, response, body)->
				if err
					res.send err
				else
					readability = new html_readability
						url: url
						debug: true
						content: body.toString()
					article = readability.run()
					res.render "demo",
						title: article.title
						article: article
		catch e
			res.send e
	else
		res.send "must have a url"