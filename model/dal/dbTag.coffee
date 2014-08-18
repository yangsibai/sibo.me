###
    管理 tag 表
###

exports.new = (conn, tag, cb)->
	sql = "select id from tag where name=? limit 1"
	conn.executeScalar sql, [
		tag
	], (err, tagId)->
		if err
			cb err
		else
			unless tagId
				sql = "insert into tag(name,addTime) values(?,now())"
				conn.insert sql, [
					tag
				], (err, success, tagId)->
					if err
						cb err
					else unless success
						cb new Error("fail to add tag #{tag}")
					else
						cb null, tagId
			else
				cb null, tagId
