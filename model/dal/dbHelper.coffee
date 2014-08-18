config = require("../../config")
dbHelper = require("mysql-dbhelper")
	dbConfig: config.dbConfig()

exports.createConnection = dbHelper.createConnection
