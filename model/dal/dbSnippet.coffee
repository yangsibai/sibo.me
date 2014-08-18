dbHelper = require("./dbHelper")
dbSnippetRevision = require("./dbSnippetRevision")
dbConfig = require('../../config').dbConfig()
dbTag = require("./dbTag")
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
	conn = dbHelper.createConnection()
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
			insertTag conn, insertId, snippet.tags, (err)->
				conn.end()
				if err
					cb err
				else
					cb null, insertId

###
    获取列表
###
exports.list = (cb)->
	sql = """select id,title,addTime
			from snippet
			where state=0
			order by id desc;"""
	conn = dbHelper.createConnection()
	conn.$execute sql, cb

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
	conn = dbHelper.createConnection()
	conn.executeFirstRow sql, [
		id
	], (err, row)->
		if row
			sql = """
				select t.id,t.name
				from snippet_tag st
				inner join tag t
				on st.tagId=t.id
				where st.snippetId=?;
				"""
			conn.$execute sql, [
				id
			], (err, results)->
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
					conn = dbHelper.createConnection()
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
					], (err)->
						insertTag conn, snippet.id, snippet.tags, ()->
							conn.end()
							cb.apply this, arguments

###
    delete
###
exports.delete = (id, cb)->
	sql = """
		update snippet set state=4 where id=?
		"""
	conn = dbHelper.createConnection()
	conn.update sql, [
		id
	], (err, success)->
		conn.end()
		cb err, success

###
    插入标签
###
insertTag = (conn, snippetId, tags, cb)->
	sql = """
		delete from snippet_tag
		where snippetId=?
		"""
	conn.execute sql, [
		snippetId
	], (err)->
		if err
			conn.end()
			cb err
		else
			finished = _.after tags.length, ()->
				cb null
			for tag in tags
				dbTag.new conn, tag, (err, tagId)->
					if err
						console.dir err
					else
						sql = "insert into snippet_tag(snippetId,tagId,addTime) values(?,?,now())"
						conn.insert sql, [
							snippetId
							tagId
						], (err)->
							if err
								console.dir err
							finished()
