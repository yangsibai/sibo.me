###
Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")
config = require("./config")
app = express()

app.use express.favicon(__dirname + "/public/favicon.ico")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "public"))

# development only
app.use express.errorHandler()  unless config.isProduct()


app.use(express.cookieParser('sibo.me'));
require("multi-process-session")(app)
require("simple-mvc")
	defaultEngine: "jade"
	defaultViewEngine: "jade", app


http.createServer(app).listen config.port.app, ->
	console.log "Express server listening on port " + config.port.app
