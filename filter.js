// Generated by CoffeeScript 1.7.1
(function() {
  exports.$auth = function(req, res, next) {
    if (req.session && req.session.auth) {
      return next();
    } else {
      return res.redirect("/user/login");
    }
  };

}).call(this);

//# sourceMappingURL=filter.map
