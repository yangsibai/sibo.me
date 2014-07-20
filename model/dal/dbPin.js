// Generated by CoffeeScript 1.7.1
(function() {
  var $insertPin, $insertTag, dataHelper, dbConfig, dbHelper, dbTag, _;

  dbHelper = require('mysql-dbhelper');

  dbConfig = require('../../config').dbConfig();

  dbTag = require("./dbTag");

  _ = require('underscore');

  dataHelper = require('../../helper/dataHelper');


  /*
      create new pin
   */

  exports["new"] = function(data, cb) {
    var conn, sql;
    conn = dbHelper.createConnection(dbConfig);
    sql = "select id\nfrom page\nwhere url=?\nlimit 1;";
    return conn.executeScalar(sql, [data.url], function(err, pageId) {
      if (err) {
        conn.end();
        return cb(err);
      } else if (!pageId) {
        sql = "insert into page(url,title,width,height,addTime,updateTime,pinCount,state)\nvalues(?,?,?,?,now(),now(),1,?)";
        return conn.insert(sql, [data.url, data.title, data.width, data.height, dataHelper.pageState.inProgress], function(err, success, pageId) {
          if (err) {
            conn.end();
            return cb(err);
          } else if (!success) {
            conn.end();
            return cb(new Error("fail"));
          } else {
            return $insertPin(conn, data, pageId, cb);
          }
        });
      } else {
        sql = "update page\nset title=?,\nwidth=?,\nheight=?,\nupdateTime=now(),\npinCount=pinCount+1\nwhere id=?";
        return conn.update(sql, [data.title, data.width, data.height, pageId], function(err, success) {
          if (err) {
            conn.end();
            return cb(err);
          } else if (!success) {
            conn.end();
            return cb(new Error("fail"));
          } else {
            return $insertPin(conn, data, pageId, cb);
          }
        });
      }
    });
  };


  /*
      插入pin
   */

  $insertPin = function(conn, data, pageId, cb) {
    var sql;
    sql = "insert into pin(pageId,x,y,message,addTime,state)\nvalues(?,?,?,?,now(),0);";
    return conn.insert(sql, [pageId, data.x, data.y, data.message], function(err, success, pinId) {
      conn.end();
      if (err) {
        return cb(err);
      } else if (!success) {
        return cb(new Error("fail"));
      } else {
        return cb(null);
      }
    });
  };


  /*
      get pin count on a page
   */

  exports.countOnPage = function(url, cb) {
    var conn, sql;
    sql = "select pinCount\nfrom page\nwhere url=?;";
    conn = dbHelper.createConnection(dbConfig);
    return conn.executeScalar(sql, [url], function(err, count) {
      conn.end();
      if (err) {
        return cb(err);
      } else {
        return cb(null, count || 0);
      }
    });
  };


  /*
  	get all pin on a page
   */

  exports.pinOnPage = function(url, cb) {
    var conn, sql;
    sql = "select p.*\nfrom pin p\ninner join page a\non p.pageId=a.id\nwhere a.url=?\norder by p.y,p.x;";
    conn = dbHelper.createConnection(dbConfig);
    return conn.execute(sql, [url], function(err, data) {
      conn.end();
      return cb(err, data);
    });
  };


  /*
      get all pages
   */

  exports.all = function(state, cb) {
    var conn, sql;
    sql = "select a.id,a.url,a.title,a.addTime,a.updateTime,a.pinCount,\np.message,p.addTime as pinTime\nfrom page a\ninner join pin p\non a.id=p.pageId\nWHERE a.state=?\norder by p.id desc";
    conn = dbHelper.createConnection(dbConfig);
    return conn.execute(sql, [state], function(err, results) {
      var hasAdd, page, pageData, row, _i, _j, _len, _len1;
      conn.end();
      if (err) {
        return cb(err);
      } else if (results.length <= 0) {
        return cb(null, null);
      } else {
        pageData = [];
        for (_i = 0, _len = results.length; _i < _len; _i++) {
          row = results[_i];
          hasAdd = false;
          for (_j = 0, _len1 = pageData.length; _j < _len1; _j++) {
            page = pageData[_j];
            if (page.id === row.id) {
              hasAdd = true;
              if (page.pins.length < 3 && row.message) {
                page.pins.push({
                  message: row.message,
                  pinTime: row.pinTime
                });
              }
              break;
            }
          }
          if (!hasAdd) {
            page = {
              id: row.id,
              url: row.url,
              title: row.title,
              addTime: row.addTime,
              updateTime: row.updateTime,
              pinCount: row.pinCount,
              pins: []
            };
            if (row.message) {
              page.pins.push({
                message: row.message,
                pinTime: row.pinTime
              });
            }
            pageData.push(page);
          }
        }
        return cb(null, pageData);
      }
    });
  };


  /*
      update a page info
   */

  exports.updatePage = function(info, cb) {
    var conn, sql;
    sql = "update page\nset comment=?,updateTime=now()\nwhere id=?";
    conn = dbHelper.createConnection(dbConfig);
    return conn.update(sql, [info.comment, info.id], function(err) {
      if (err) {
        conn.end();
        return cb(err);
      } else {
        return $insertTag(conn, info.id, info.tags, cb);
      }
    });
  };


  /*
      insert tags
   */

  $insertTag = function(conn, pageId, tags, cb) {
    var sql;
    sql = "DELETE FROM page_tag\nWHERE pageId=?";
    return conn.executeNonQuery(sql, [pageId], function(err) {
      var finished;
      if (err) {
        return cb(err);
      } else {
        finished = _.after(tags.length, function() {
          conn.end();
          return cb(null);
        });
        return _.each(tags, function(tag) {
          return dbTag["new"](conn, tag, function(err) {
            if (err) {
              console.dir(err);
            }
            return finished();
          });
        });
      }
    });
  };


  /*
      archive page
   */

  exports.archive = function(id, cb) {
    var conn, sql;
    sql = "UPDATE page SET state=? WHERE id=?";
    conn = dbHelper.createConnection(dbConfig);
    return conn.update(sql, [dataHelper.pageState.archive, id], function() {
      conn.end();
      return cb.apply(this, arguments);
    });
  };


  /*
     search page
   */

  exports.search = function(keyword, cb) {
    var conn, sql;
    sql = "select *\nfrom page\nwhere state<> 4 and ( title like ? or title like ?)\norder by id desc;";
    keyword = "%" + keyword + "%";
    conn = dbHelper.createConnection(dbConfig);
    return conn.execute(sql, [keyword, keyword], function(err, result) {
      conn.end();
      return cb(err, result);
    });
  };

}).call(this);

//# sourceMappingURL=dbPin.map
