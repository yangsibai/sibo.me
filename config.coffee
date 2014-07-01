env = "dev"

isProduct = exports.isProduct = ()->
	env is "dev"

###
    mysql config
###
exports.dbConfig = ()->
	if isProduct()
		host: 'localhost',
		user: 'root',
		port: 3306,
		password: ' ',
		database: 'sibo'
	else
		host: 'localhost',
		user: 'root',
		port: 3306,
		password: '',
		database: 'sibo'

###
    port config
###
exports.port =
	app: 4000 #heshui.la