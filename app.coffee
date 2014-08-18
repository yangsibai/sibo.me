###
Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")
config = require("./config")
app = express()
_ = require("underscore")

app.use express.favicon(__dirname + "/public/favicon.ico")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "public"))

app.use(express.cookieParser('sibo.me'));
require("multi-process-session")(app)

# development only
app.use express.errorHandler() unless config.isProduct()

app.use (req, res, next)->
	res.err = (err)->
		res.send
			code: 1
			message: err.message

	res.data = (data)->
		if _.isUndefined(data.code)
			data.code = 0
		if _.isUndefined(data.message)
			data.message = "ok"
		res.send data

	res.ok = ()->
		res.send
			code: 0
			message: "ok"

	next()

require("simple-mvc")
	defaultEngine: "jade"
	defaultViewEngine: "jade", app

app.use (req, res)->
	res.send "404:not found!"

app.use (err, req, res)->
	res.send "500:server error!"

process.on "uncaughtException", (err)->
	console.dir(err)

http.createServer(app).listen config.port.app, ->
	console.log "www.sibo.me listening on port #{config.port.app}"
