dbHelper = require('mysql-dbhelper')
dbConfig = require('../../config').dbConfig()
_ = require('underscore')

###
    认证
###
exports.auth = (email, password, cb)->
	sql = """
		select id
		from user
		where email=?
		and password=?
		and state =0;
		"""
	conn = dbHelper.createConnection(dbConfig)
	conn.connect()
	conn.executeFirstRow sql, [
		email
		password
	], (err, row)->
		conn.end()
		if err
			cb err
		else if row
			cb null
		else
			cb new Error("fail")