exports.temple = (req, res)->
    res.write("temple")
    res.end()

###
    three circle
###
exports.circle = (req, res)->
    res.render("circle")

exports.parallasScroller = (req, res)->
    res.render("parallasScroller")
