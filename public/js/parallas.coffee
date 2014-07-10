class Far extends PIXI.TilingSprite
	@DELTA_X: 0.128
	constructor: ()->
		texture = PIXI.Texture.fromImage("/img/game/parallas/bg-far.png")
		super(texture, 512, 256)
		@position.x = 0
		@position.y = 0
		@tilePosition.x = 0
		@tilePosition.y = 0

		@viewportX = 0

	setViewportX: (newViewportX)->
		distanceTravelled = newViewportX - @viewportX
		@viewportX = newViewportX
		@tilePosition.x -= (distanceTravelled * @constructor.DELTA_X)

class Mid extends PIXI.TilingSprite
	@DELTA_X: 0.64
	constructor: ()->
		texture = PIXI.Texture.fromImage("/img/game/parallas/bg-mid.png")
		super(texture, 512, 256)

		@position.x = 0
		@position.y = 128

		@tilePosition.x = 0
		@tilePosition.y = 0

		@viewportX = 0

	setViewportX: (newViewportX)->
		distanceTravelled = newViewportX - @viewportX
		@viewportX = newViewportX
		@tilePosition.x -= (distanceTravelled * @constructor.DELTA_X)

class Scroller
	constructor: (stage)->
		@far = new Far()
		stage.addChild(@far)

		@mid = new Mid()
		stage.addChild(@mid)

		@viewportX = 0

	setViewportX: (viewportX)->
		@viewportX = viewportX
		@far.setViewportX(viewportX)
		@mid.setViewportX(viewportX)

	getViewportX: ()->
		return @viewportX

	moveViewportXBy: (units)->
		newViewportX = @viewportX + units
		@setViewportX(newViewportX)

class WallSpritesPool
	constructor: ()->
		@createWindows()
	shuffle: (array)->
		len = array.length
		shuffles = len * 3
		for i in [1..shuffles]
			wallSlice = array.pop()
			pos = Math.floor(Math.random() * (len - 1))
			array.splice(pos, 0, wallSlice)
	createWindows: ()->
		@windows = []
		@addWindowsSprites(6, "window_01")
		@addWindowsSprites(6, "window_02")
		@shuffle(@windows)
	addWindowsSprites: (amount, frameId)->
		for i in[1..amount]
			sprite = PIXI.Sprite.fromFrame(frameId)
			@windows.push sprite
	borrowWindow: ()->
		@windows.shift()
	returnWindows: (sprite)->
		@windows.push sprite

class Main
	@SCROLL_SPEED: 5
	constructor: ()->
		@stage = new PIXI.Stage(0x66FF99)
		gameCanvas = document.getElementById("game-canvas")
		@renderer = new PIXI.autoDetectRenderer(512, 384, gameCanvas)
		@loadSpriteSheet()
	update: ->
		@scroller.moveViewportXBy(@constructor.SCROLL_SPEED)
		@renderer.render(@stage)
		requestAnimFrame(@update.bind(this))
	loadSpriteSheet: ->
		assetsToLoad = [
			"/img/game/parallas/bg-far.png"
			"/img/game/parallas/bg-mid.png"
			"/img/game/parallas/wall.json"
		]
		loader = new PIXI.AssetLoader(assetsToLoad)
		loader.onComplete = @spriteSheetLoaded.bind(this)
		loader.load()
	spriteSheetLoaded: ->
		@scroller = new Scroller(@stage)
		requestAnimFrame(@update.bind(this))

		@pool = new WallSpritesPool()
		@wallSlices = []
	borrowWallSprites: (num)->
		for i in [0..(num - 1)]
			sprite = @pool.borrowWindow()
			sprite.position.x = -32 + (i * 64)
			sprite.position.y = 128

			@wallSlices.push(sprite)

			@stage.addChild(sprite)
	returnWallSprites: ->
		for i in [0..(@wallSlices.length - 1)]
			sprite = @wallSlices[i]
			@stage.removeChide(sprite)
			@pool.returnWindow(sprite)

		@wallSlices = []

window.init = ()->
	window.main = new Main()