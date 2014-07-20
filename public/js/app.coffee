app = angular.module "app", [
]

app.controller("pinItCtrl", ($scope, apiHelper)->
	$scope.currentState = 0
	$scope.archive = (index)->
		page = $scope.data[index]
		apiHelper.get "/pinIt/archive",
			id: page.id
		, (data)->
			if data.code is 0
				$scope.data.splice index, 1
			else
				alert data.message

	$scope.getData = (state)->
		getData(state)

	getData = (state)->
		$scope.currentState = state
		apiHelper.get "/pinIt/data",
			state: state
		, (data)->
			if data.code is 0
				$scope.data = data.pageData
			else
				alert(data.message)

	$scope.search = (keyword)->
		apiHelper.post "/pinIt/search",
			keyword: keyword
		, (data)->
			if data.code is 0
				$scope.data = data.result
			else
				alert(data.message)

	getData(0)
)

app.service('apiHelper', ($http)->
	this.get = (apiUrl, params, onSuccess)->
		getServer(apiUrl, params, onSuccess)

	this.post = (apiUrl, params, onSuccess)->
		postServer(apiUrl, params, onSuccess)

	getServer = (apiUrl, params, onSuccess)->
		if typeof params is "function"
			onSuccess = params
			params = {}

		$http.get(apiUrl,
			params: params
		).success((data)->
			onSuccess(data)
		).error((data, status)->
			console.dir data
			console.log status
		)

	postServer = (apiUrl, params, onSuccess)->
		if typeof params is "function"
			onSuccess = params
			params = {}

		$http(
			url: apiUrl
			method: "POST"
			data: JSON.stringify(params)
			headers:
				'Content-Type': 'application/json'
		)
		.success((data)->
			onSuccess(data)
		)
		.error((data, status)->
			console.dir data
			console.log status
		)

	return undefined
)

app.filter('prettyTime', ()->
	return (input)->
		if (input)
			date = new Date(input)
			year = date.getFullYear()
			month = date.getMonth() + 1
			day = date.getDate()
			hour = date.getHours()
			minute = date.getMinutes()
			return month + '/' + day + ',' + year + ' ' + hour + ':' + minute
)