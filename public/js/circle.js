// Generated by CoffeeScript 1.7.1
(function() {
  var animate, bunny, renderer, stage, texture;

  stage = new PIXI.Stage(0x66FF99);

  renderer = PIXI.autoDetectRenderer(400, 300);

  document.body.appendChild(renderer.view);

  console.log(typeof animate);

  texture = PIXI.Texture.fromImage("/img/bunny.png");

  bunny = new PIXI.Sprite(texture);

  bunny.anchor.x = 0.5;

  bunny.anchor.y = 0.5;

  bunny.position.x = 200;

  bunny.position.y = 150;

  stage.addChild(bunny);

  animate = function() {
    requestAnimFrame(animate);
    bunny.rotation += 0.1;
    return renderer.render(stage);
  };

  requestAnimFrame(animate);

}).call(this);

//# sourceMappingURL=circle.map