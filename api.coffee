###
Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")
config = require("./config")
app = express()

cluster = require('cluster')
numCPUs = require('os').cpus().length

app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router

app.use(express.cookieParser('sibo.me'));
require("simple-mvc")
	controllerPath: "api", app

# development only
app.use express.errorHandler() unless config.isProduct()

app.use (req, res)->
	res.send "404:not found!"

app.use (err, req, res)->
	res.send "500:server error!"

process.on "uncaughtException", (err)->
	console.dir(err)

if cluster.isMaster
	for i in [1..numCPUs]
		cluster.fork()
	cluster.on 'death', (worker)->
		console.log "#{worker.id} dir"
		cluster.fork()
else
	worker = cluster.worker
	http.createServer(app).listen config.port.api, ->
		console.log "worker #{worker.id} listening on port #{config.port.api}"