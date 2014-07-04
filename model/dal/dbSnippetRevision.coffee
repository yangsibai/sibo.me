dbHelper = require('mysql-dbhelper')
dbConfig = require('../../config').dbConfig()
_ = require('underscore')

exports.new = (snippet, cb)->
	sql = """
		insert into snippet_revision(
			snippetId,
			version,
			title,
			content,
			tags,
			addTime,
			state
		)
		values(
			?,?,?,?,?,now(),0
		)
		"""
	conn = dbHelper.createConnection(dbConfig)
	conn.connect()
	tagNameArr = []
	for tag in snippet.tags
		tagNameArr.push tag.name
	conn.insert sql, [
		snippet.id
		snippet.version
		snippet.title
		snippet.content
		tagNameArr.join('|')
	], cb