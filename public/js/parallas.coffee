window.init = ()->
	stage = new PIXI.Stage(0x66FF99)
	gameCanvas = document.getElementById("game-canvas")
	renderer = PIXI.autoDetectRenderer gameCanvas.width, gameCanvas.height, gameCanvas

	farTexture = PIXI.Texture.fromImage("/img/game/parallas/bg-far.png")
	far = new PIXI.TilingSprite(farTexture, 512, 256)
	far.position.x = 0
	far.position.y = 0
	far.tilePosition.x = 0
	far.tilePosition.y = 0
	stage.addChild(far)

	midTexture = PIXI.Texture.fromImage("/img/game/parallas/bg-mid.png");
	mid = new PIXI.TilingSprite(midTexture, 512, 256)
	mid.position.x = 0
	mid.position.y = 128
	mid.tilePosition.x = 0
	mid.tilePosition.y = 0
	stage.addChild(mid)

	update = ()->
		far.tilePosition.x -= 0.128
		mid.tilePosition.x -= 0.64
		renderer.render(stage)
		requestAnimFrame(update)

	requestAnimFrame(update)