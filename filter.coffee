exports.$auth = (req, res, next)->
	if req.session && req.session.auth
		next()
	else
		res.redirect("/user/login")