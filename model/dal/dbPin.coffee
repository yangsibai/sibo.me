dbHelper = require('mysql-dbhelper')
dbConfig = require('../../config').dbConfig()
dbTag = require("./dbTag")
_ = require('underscore')
dataHelper = require('../../helper/dataHelper')

###
    create new pin
###
exports.new = (data, cb)->
	conn = dbHelper.createConnection(dbConfig)
	sql = """
		select id
		from page
		where url=?
		limit 1;
	"""
	conn.executeScalar sql, [
		data.url
	], (err, pageId)->
		if err
			conn.end()
			cb err
		else if not pageId
			sql = """
				insert into page(url,title,width,height,addTime,updateTime,pinCount,state)
				values(?,?,?,?,now(),now(),1,?)
				"""
			conn.insert sql, [
				data.url
				data.title
				data.width
				data.height
				dataHelper.pageState.inProgress
			], (err, success, pageId)->
				if err
					conn.end()
					cb err
				else unless success
					conn.end()
					cb new Error("fail")
				else
					$insertPin(conn, data, pageId, cb)
		else
			sql = """
					update page
					set title=?,
					width=?,
					height=?,
					updateTime=now(),
					pinCount=pinCount+1
					where id=?
					"""
			conn.update sql, [
				data.title
				data.width
				data.height
				pageId
			], (err, success)->
				if err
					conn.end()
					cb err
				else unless success
					conn.end()
					cb new Error("fail")
				else
					$insertPin(conn, data, pageId, cb)

###
    插入pin
###
$insertPin = (conn, data, pageId, cb)->
	sql = """
		insert into pin(pageId,x,y,message,addTime,state)
		values(?,?,?,?,now(),0);
		"""
	conn.insert sql, [
		pageId
		data.x
		data.y
		data.message
	], (err, success, pinId)->
		conn.end()
		if err
			cb err
		else unless success
			cb new Error("fail")
		else
			cb null

###
    get pin count on a page
###
exports.countOnPage = (url, cb)->
	sql = """
		select pinCount
		from page
		where url=?;
		"""
	conn = dbHelper.createConnection(dbConfig)
	conn.executeScalar sql, [
		url
	], (err, count)->
		conn.end()
		if err
			cb err
		else
			cb null, count or 0

###
	get all pin on a page
###
exports.pinOnPage = (url, cb)->
	sql = """
		select p.*
		from pin p
		inner join page a
		on p.pageId=a.id
		where a.url=?
		order by p.y,p.x;
		"""
	conn = dbHelper.createConnection(dbConfig)
	conn.execute sql, [
		url
	], (err, data)->
		conn.end()
		cb err, data

###
    get all pages
###
exports.all = (state, cb)->
	sql = """
		select a.id,a.url,a.title,a.addTime,a.updateTime,a.pinCount,
		p.message,p.addTime as pinTime
		from page a
		inner join pin p
		on a.id=p.pageId
		WHERE a.state=?
		order by p.id desc
		"""
	conn = dbHelper.createConnection(dbConfig)
	conn.execute sql, [
		state
	], (err, results)->
		conn.end()
		if err
			cb err
		else if results.length <= 0
			cb null, null
		else
			pageData = []
			for row in results
				hasAdd = false;
				for page in pageData
					if page.id is row.id
						hasAdd = true
						if page.pins.length < 3 and row.message
							page.pins.push
								message: row.message
								pinTime: row.pinTime
						break
				unless hasAdd
					page =
						id: row.id
						url: row.url
						title: row.title
						addTime: row.addTime
						updateTime: row.updateTime
						pinCount: row.pinCount
						pins: []
					if row.message
						page.pins.push
							message: row.message
							pinTime: row.pinTime
					pageData.push page
			cb null, pageData

###
    update a page info
###
exports.updatePage = (info, cb)->
	sql = """
		update page
		set comment=?,updateTime=now()
		where id=?
		"""
	conn = dbHelper.createConnection(dbConfig)
	conn.update sql, [
		info.comment
		info.id
	], (err)->
		if err
			conn.end()
			cb err
		else
			$insertTag conn, info.id, info.tags, cb

###
    insert tags
###
$insertTag = (conn, pageId, tags, cb)->
	sql = """
		DELETE FROM page_tag
		WHERE pageId=?
		"""
	conn.executeNonQuery sql, [
		pageId
	], (err)->
		if err
			cb err
		else
			finished = _.after tags.length, ()->
				conn.end()
				cb null
			_.each tags, (tag)->
				dbTag.new conn, tag, (err)->
					if err
						console.dir err
					finished()

###
    archive page
###
exports.archive = (id, cb)->
	sql = "UPDATE page SET state=? WHERE id=?"
	conn = dbHelper.createConnection(dbConfig)
	conn.update sql, [
		dataHelper.pageState.archive
		id
	], ()->
		conn.end()
		cb.apply this,arguments

###
   search page
###
exports.search = (keyword, cb)->
	sql = """
		select *
		from page
		where state<> 4 and ( title like ? or title like ?)
		order by id desc;
		"""
	keyword = "%#{keyword}%"
	conn = dbHelper.createConnection(dbConfig)
	conn.execute sql, [
		keyword
		keyword
	], (err, result)->
		conn.end()
		cb err,result
