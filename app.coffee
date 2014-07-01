###
Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")
config = require("./config")
app = express()

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
app.use express.favicon(__dirname + "/public/favicon.ico")
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "public"))

# development only
app.use express.errorHandler()  if "development" is app.get("env")

require("simple-mvc")
	defaultEngine: "jade"
	defaultViewEngine: "jade", app

http.createServer(app).listen config.port.app, ->
	console.log "Express server listening on port " + config.port.app
