// Generated by CoffeeScript 1.7.1
(function() {
  var pinBll;

  pinBll = require('../model/bll/pin');

  exports.new_POST = function(req, res) {
    var data;
    data = req.body;
    return pinBll["new"](data, function(err, id) {
      if (err) {
        return res.send({
          code: 1,
          message: err.message
        });
      } else {
        return res.send({
          code: 0,
          message: "ok",
          id: id
        });
      }
    });
  };

  exports.countOnPage = function(req, res) {
    var url;
    url = decodeURIComponent(req.query.url);
    return pinBll.countOnPage(url, function(err, count) {
      if (err) {
        return res.send({
          code: 1,
          message: err.message
        });
      } else {
        return res.send({
          code: 0,
          message: "ok",
          count: count
        });
      }
    });
  };

  exports.pinOnPage = function(req, res) {
    var url;
    url = decodeURIComponent(req.query.url);
    return pinBll.pinOnPage(url, function(err, data) {
      if (err) {
        return res.send({
          code: 1,
          message: err.message
        });
      } else {
        return res.send({
          code: 0,
          message: "ok",
          pins: data
        });
      }
    });
  };

}).call(this);

//# sourceMappingURL=pinIt.map
