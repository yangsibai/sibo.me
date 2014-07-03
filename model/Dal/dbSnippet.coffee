dbHelper = require('mysql-dbhelper')
dbConfig = require('../../config').dbConfig()
_ = require('underscore')

exports.new = (snippet, cb)->
	sql = """
		insert into snippet(
			title,content,html,addTime,updateTime,version,state
		)values(
			?,?,?,now(),now(),1,0
		)
		"""
	conn = dbHelper.createConnection dbConfig
	conn.connect()
	conn.insert sql, [
		snippet.title
		snippet.content
		snippet.html
	], (err, success, insertId)->
		if err
			conn.end()
			cb err
		else unless success
			conn.end()
			cb new Error("fail")
		else
			finished = _.after snippet.tags.length, ()->
				conn.end()
				cb null, insertId

			for tag in snippet.tags
				insertTag conn, insertId, tag, (err, success, insertId)->
					if err
						console.dir err
					finished()

exports.all = (cb)->
	sql = """select id,title,addTime
	from snippet;"""
	conn = dbHelper.createConnection dbConfig
	conn.connect()
	conn.execute sql, (err, snippets)->
		conn.end()
		cb err, snippets

exports.single = (id, cb)->
	sql = """
		select *
		from snippet
		where id=?
		limit 1;
		"""
	conn = dbHelper.createConnection dbConfig
	conn.connect()
	conn.executeFirstRow sql, [
		id
	], (err, row)->
		sql = """
select t.id,t.name
from snippet_tag st
inner join tag t
on st.tagId=t.id
where st.snippetId=?;
"""
		if row
			conn.execute sql, [
				id
			], (err, results)->
				conn.end()
				row.tags = results
				cb err, row
		else
			conn.end()
			cb err, row

insertTag = (conn, snippetId, tag, cb)->
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
						insert_Snippet_Tag conn, snippetId, tagId, cb
			else
				insert_Snippet_Tag conn, snippetId, tagId, cb

insert_Snippet_Tag = (conn, snippetId, tagId, cb)->
	sql = "insert into snippet_tag(snippetId,tagId,addTime) values(?,?,now())"
	conn.insert sql, [
		snippetId
		tagId
	], cb