ext2ModeMap =
	coffee: "coffee"
	csharp: "cs"
	css: "css"
	html: "html"
	java: "java"
	javascript: "js"
	markdown: [
		"md"
		"markdown"
	]
	sql: "sql"
	text: "txt"

@codeEditor = (editorId, type)->
	editor = ace.edit(editorId)
	editor.setTheme("ace/theme/tomorrow_night_bright")
	setMode("text")
	editor.getSession().setTabSize(4)
	editor.setAutoScrollEditorIntoView(true);
	editor.setOption("maxLines", 30);
	editor.setOption("minLines", 20);
	editor.setFontSize(14);

	$("#submit").click ()->
		title = $("#title").val().trim()
		tags = $("#tags").val().trim()
		content = editor.getValue()
		if type is "new"
			$.post "/snippets/new",
				title: title
				content: content
				tags: tags
			, (data)->
				if data.code is 0
					window.location.href = "/snippets/single/#{data.id}"
				else
					alert data.message

	$(".language").change ()->
		modeName = $(@).val()
		setMode(modeName)
		updateFileName(modeName)

	$("#title").keyup ()->
		title = $(@).val()
		updateLanguageAndMode(title)

	$("#title").blur ()->
		currentTitle = $(@).val()
		trimTitle = currentTitle.trim()
		if currentTitle isnt trimTitle
			$(@).val(trimTitle)
			updateLanguageAndMode(trimTitle)

	updateFileName = (modeName)->
		title = $("#title").val().trim()
		extensions = ext2ModeMap[modeName]
		if title
			dotInx = title.lastIndexOf('.')
			if dotInx isnt -1
				ext = title.slice(dotInx + 1)
				return if legalExt(extensions, ext)
				title = title.slice(0, dotInx)
			newExt = if Array.isArray(extensions) then extensions[0] else extensions
			title = "#{title}.#{newExt}"
		else
			title = if Array.isArray(extensions) then "new-file.#{extensions[0]}" else "new-file.#{extensions}"
		$("#title").val(title)

	updateLanguageAndMode = (title)->
		dotInx = title.lastIndexOf('.')
		if dotInx isnt -1
			ext = title.slice(dotInx + 1)
			for key,value of ext2ModeMap
				if legalExt(value, ext)
					setMode(key)
					setLanguage(key)
					return
		setMode("text")
		setLanguage("text")

	setMode = (modeName)->
		editor.session.setMode("ace/mode/#{modeName}")

	setLanguage = (modeName)->
		$(".language").val(modeName)

	legalExt = (extensions, ext)->
		if (Array.isArray(extensions) and extensions.indexOf(ext) isnt -1) or ext is extensions
			return true
		return false