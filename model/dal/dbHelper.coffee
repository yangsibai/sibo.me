config = require("../../config.json")
dbHelper = require("mysql-dbhelper")
    dbConfig: config.dbConfig

exports.createConnection = dbHelper.createConnection
