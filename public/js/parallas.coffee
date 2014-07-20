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

		@front = new Walls()
		stage.addChild(@front)

		@viewportX = 0
	setViewportX: (viewportX)->
		@viewportX = viewportX
		@far.setViewportX(viewportX)
		@mid.setViewportX(viewportX)
		@front.setViewportX(viewportX) 
	getViewportX: ()->
		return @viewportX
	moveViewportXBy: (units)->
		newViewportX = @viewportX + units
		@setViewportX(newViewportX)

class WallSpritesPool
	constructor: ()->
		@createWindows()
		@createDecorations()
		@createFrontEdges()
		@createBackEdges()
		@createSteps()
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
		for i in [1..amount]
			sprite = PIXI.Sprite.fromFrame(frameId)
			@windows.push sprite
	borrowWindow: ()->
		@windows.shift()
	returnWindow: (sprite)->
		@windows.push sprite
	createDecorations: ()->
		@decorations = []
		@addDecorationSprites(6, "decoration_01")
		@addDecorationSprites(6, "decoration_02")
		@addDecorationSprites(6, "decoration_03")
		@shuffle(@decorations)
	addDecorationSprites: (amount, frameId)->
		for i in [1..amount]
			sprite = PIXI.Sprite.fromFrame(frameId)
			@decorations.push sprite
	borrowDecoration: ()->
		@decorations.shift()
	returnDecoration: (sprite)->
		@decorations.push(sprite)
	createFrontEdges: ()->
		@frontEdges = []
		@addFrontEdgeSprites(2, "edge_01")
		@addFrontEdgeSprites(2, "edge_02")
		@shuffle(@frontEdges)
	addFrontEdgeSprites: (amount, frameId)->
		for i in [1..amount]
			sprite = new PIXI.Sprite(PIXI.Texture.fromFrame(frameId))
			@frontEdges.push sprite
	borrowFrontEdge: ()->
		return @frontEdges.shift()
	returnFrontEdge: (sprite)->
		@frontEdges.push(sprite)
	createBackEdges: ()->
		@backEdges = []
		@addBackEdgeSprites(2, "edge_01");
		@addBackEdgeSprites(2, "edge_02");
		@shuffle(@backEdges);
	addBackEdgeSprites: (amount, frameId)->
		for i in [1..amount]
			sprite = new PIXI.Sprite(PIXI.Texture.fromFrame(frameId))
			sprite.anchor.x = 1
			sprite.scale.x = -1
			@backEdges.push sprite
	borrowBackEdge: ()->
		return @backEdges.shift()
	returnBackEdge: (sprite)->
		@backEdges.push(sprite)
	createSteps: ()->
		@steps = []
		@addStepsSprites(2, "step_01")
	addStepsSprites: (amount, frameId)->
		for i in [1..amount]
			sprite = new PIXI.Sprite(PIXI.Texture.fromFrame(frameId))
			sprite.anchor.y = 0.25
			@steps.push sprite
	borrowStep: ()->
		return @steps.shift()
	returnStep: (sprite)->
		@steps.push(sprite)

class SliceType
	@FRONT: 0
	@BACK: 1
	@STEP: 2
	@DECORATION: 3
	@WINDOW: 4
	@GAP: 5

class WallSlice
	@WIDTH: 64
	constructor: (@type, @y)->
		@sprite = null

class Walls extends PIXI.DisplayObjectContainer
	@VIEWPORT_WIDTH: 512
	@VIEWPORT_NUM_SLICES: Math.ceil(@VIEWPORT_WIDTH / WallSlice.WIDTH) + 1
	constructor: ->
		super(this)
		@pool = new WallSpritesPool()
		@createLookupTables()

		@slices = []
		@createTestMap()

		@viewportX = 0
		@viewportSliceX = 0
	createLookupTables: ()->
		@borrowWallSpriteLookup = []
		@borrowWallSpriteLookup[SliceType.FRONT] = @pool.borrowFrontEdge
		@borrowWallSpriteLookup[SliceType.BACK] = @pool.borrowBackEdge
		@borrowWallSpriteLookup[SliceType.STEP] = @pool.borrowStep
		@borrowWallSpriteLookup[SliceType.DECORATION] = @pool.borrowDecoration
		@borrowWallSpriteLookup[SliceType.WINDOW] = @pool.borrowWindow

		@returnWallSpriteLookup = []
		@returnWallSpriteLookup[SliceType.FRONT] = @pool.returnFrontEdge
		@returnWallSpriteLookup[SliceType.BACK] = @pool.returnBackEdge
		@returnWallSpriteLookup[SliceType.STEP] = @pool.returnStep
		@returnWallSpriteLookup[SliceType.DECORATION] = @pool.returnDecoration
		@returnWallSpriteLookup[SliceType.WINDOW] = @pool.returnWindow
	borrowWallSprite: (sliceType)->
		return @borrowWallSpriteLookup[sliceType].call(@pool)
	returnWallSprite: (sliceType, sliceSprite)->
		return @returnWallSpriteLookup[sliceType].call(@pool, sliceSprite)
	addSlice: (sliceType, y)->
		slice = new WallSlice(sliceType, y)
		@slices.push slice
	setViewportX: (viewportX)->

	createTestWallSpan: ()->
		@addSlice(SliceType.FRONT, 192)
		@addSlice(SliceType.WINDOW, 192)
		@addSlice(SliceType.DECORATION, 192)
		@addSlice(SliceType.WINDOW, 192)
		@addSlice(SliceType.DECORATION, 192)
		@addSlice(SliceType.WINDOW, 192)
		@addSlice(SliceType.DECORATION, 192)
		@addSlice(SliceType.WINDOW, 192)
		@addSlice(SliceType.BACK, 192)
	createTestSteppedWallSpan: ()->
		@addSlice(SliceType.FRONT, 192)
		@addSlice(SliceType.WINDOW, 192)
		@addSlice(SliceType.DECORATION, 192)
		@addSlice(SliceType.STEP, 256)
		@addSlice(SliceType.WINDOW, 256)
		@addSlice(SliceType.BACK, 256)
	createTestGap: ()->
		@addSlice(SliceType.GAP)
	createTestMap: ()->
		for i in [1..10]
			@createTestWallSpan()
			@createTestGap()
			@createTestSteppedWallSpan()
			@createTestGap()

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

window.init = ()->
	window.main = new Main()