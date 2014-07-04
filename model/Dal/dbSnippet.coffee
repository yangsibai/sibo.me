dbHelper = require('mysql-dbhelper')
dbSnippetRevision = require("./dbSnippetRevision")
dbConfig = require('../../config').dbConfig()
_ = require('underscore')

###
    新建
###
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

###
    获取列表
###
exports.list = (cb)->
	sql = """select id,title,addTime
			from snippet
			where state=0
			order by id desc;"""
	conn = dbHelper.createConnection dbConfig
	conn.connect()
	conn.execute sql, (err, snippets)->
		conn.end()
		cb err, snippets

###
    单条
###
single = exports.single = (id, cb)->
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

###
    更新
###
exports.update = (snippet, cb)->
	single snippet.id, (err, snip)->
		if err
			cb err
		else
			dbSnippetRevision.new snip, (err)->
				if err
					cb err
				else
					conn = dbHelper.createConnection(dbConfig)
					conn.connect()
					sql = """
						update snippet
						set title=?,
						content=?,
						html=?,
						updateTime=now(),
						version=version+1
						where id=?
						"""
					conn.update sql, [
						snippet.title
						snippet.content
						snippet.html
						snippet.id
					], (err, success)->
						sql = """
							delete from snippet_tag
							where snippetId=?
							"""
						conn.execute sql, [
							snippet.id
						], (err)->
							if err
								conn.end()
								cb err
							else
								finished = _.after snippet.tags.length, ()->
									conn.end()
									cb err, success
								for tag in snippet.tags
									insertTag conn, snippet.id, tag, (err, success)->
										if err
											console.dir err
										finished()

###
    delete
###
exports.delete = (id, cb)->
	sql = """
		update snippet set state=4 where id=?
		"""
	conn = dbHelper.createConnection(dbConfig)
	conn.connect()
	conn.update sql, [
		id
	], (err, success)->
		conn.end()
		cb err, success

###
    插入标签
###
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

###
    插入单个标签
###
insert_Snippet_Tag = (conn, snippetId, tagId, cb)->
	sql = "insert into snippet_tag(snippetId,tagId,addTime) values(?,?,now())"
	conn.insert sql, [
		snippetId
		tagId
	], cb