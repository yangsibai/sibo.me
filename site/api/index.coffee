###
Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")
p2r = require("p2r")
config = p2r.require("config.json")
app = express()

app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router

app.use(express.cookieParser('sibo.me'))
require("simple-mvc")
    controllerPath: "/site/api/controllers"
    filter: p2r.require("filter"), app

app.use (req, res)->
    res.send "404:not found!"

app.use (err, req, res)->
    res.send "500:server error!"

process.on "uncaughtException", (err)->
    console.dir(err)

http.createServer(app).listen config.port.api, ->
    console.log "api.sibo.me listening on port #{config.port.api}"
