###
Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")
config = require("./config.json")
app = express()

app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router

app.use(express.cookieParser('sibo.me'));
require("simple-mvc")
	controllerPath: "api", app

app.use (req, res)->
	res.send "404:not found!"

app.use (err, req, res)->
	res.send "500:server error!"

process.on "uncaughtException", (err)->
	console.dir(err)

http.createServer(app).listen config.port.api, ->
	console.log "api.sibo.me listening on port #{config.port.api}"