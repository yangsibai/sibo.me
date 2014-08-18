_ = require("underscore")
env = "dev"

isProduct = exports.isProduct = ()->
	env is "pro"

###
    mysql config
###
exports.dbConfig = ()->
	if isProduct()
		host: 'localhost',
		user: 'root',
		port: 3306,
		password: '',
		database: "sibo"
	else
		host: '192.168.1.88',
		user: 'root',
		port: 3306,
		password: '',
		database: "sibo"

###
    port config
###
exports.port =
	app: 4000 #sibo.me
	api: 4001 #api.sibo.me