userBll = require("../../../model/bll/user")


exports.login_GET_POST = (req, res)->
    if req.method is "GET"
        res.render "login"
    else
        email = req.body.email
        password = req.body.password
        userBll.auth email, password, (err)->
            if err
                res.write(err.message)
                res.end()
            else
                res.session.auth = true
                res.redirect("/snippets")
