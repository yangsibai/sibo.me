dbHelper = require("./dbHelper")
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
    conn = dbHelper.createConnection()
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
    ], ()->
        conn.end()
        cb.apply this, arguments
