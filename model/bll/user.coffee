dbUser = require('../dal/dbUser')

###
    认证
###
exports.auth = (email, password, cb)->
	if email and password
		dbUser.auth email, password, cb
	else
		cb new Error("invalid request")