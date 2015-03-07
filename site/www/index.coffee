###
Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")
p2r = require("p2r")
_ = require("underscore")

config = p2r.require("config.json")
app = express()

app.use express.favicon(p2r.path("/public/favicon.png"))
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use express.static(p2r.path("public"))

app.use(express.cookieParser('sibo.me'));
require("multi-process-session")(app)

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
    defaultViewEngine: "jade"
    controllerPath: "/site/www/controllers"
    viewPath: "/site/www/views", app

app.use (req, res)->
    res.send "404:not found!"

app.use (err, req, res)->
    res.send "500:server error!"

process.on "uncaughtException", (err)->
    console.dir(err)

http.createServer(app).listen config.port.app, ->
    console.log "www.sibo.me listening on port #{config.port.app}"
