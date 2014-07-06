// Generated by CoffeeScript 1.7.1
(function() {
  var env, isProduct, _;

  _ = require("underscore");

  env = "dev";

  isProduct = exports.isProduct = function() {
    return env === "dev";
  };


  /*
      mysql config
   */

  exports.dbConfig = function() {
    if (isProduct()) {
      return {
        host: 'localhost',
        user: 'root',
        port: 3306,
        password: ' ',
        database: "sibo"
      };
    } else {
      return {
        host: 'localhost',
        user: 'root',
        port: 3306,
        password: '',
        database: "sibo"
      };
    }
  };


  /*
      port config
   */

  exports.port = {
    app: 4000,
    api: 4001
  };

}).call(this);

//# sourceMappingURL=config.map
