// Generated by CoffeeScript 1.7.1
(function() {
  var dataHelper, pinBll;

  pinBll = require("../model/bll/pin");

  dataHelper = require("../helper/dataHelper");

  exports.index = function(req, res) {
    return pinBll.all(dataHelper.pageState.inProgress, function(err, pageData) {
      if (err) {
        return res.err(err.message);
      } else {
        return res.render("index", {
          title: "Pin It",
          pageData: pageData,
          auth: req.session.auth
        });
      }
    });
  };


  /*
      get page data
   */

  exports.data = function(req, res) {
    var state;
    state = parseInt(req.query.state || "0");
    if (state === 0 || state === 1) {
      return pinBll.all(state, function(err, pageData) {
        if (err) {
          return res.err(err);
        } else {
          return res.data({
            pageData: pageData
          });
        }
      });
    }
  };


  /*
      archive page
   */

  exports.archive_$auth = function(req, res) {
    var pageId;
    pageId = req.query.id;
    return pinBll.archive(pageId, function(err) {
      if (err) {
        return res.err(err);
      } else {
        return res.ok();
      }
    });
  };


  /*
      search page
   */

  exports.search_POST = function(req, res) {
    var keyword;
    keyword = req.body.keyword;
    return pinBll.search(keyword, function(err, data) {
      if (err) {
        return res.err(err);
      } else {
        return res.data({
          result: data
        });
      }
    });
  };

}).call(this);

//# sourceMappingURL=pinIt.map
