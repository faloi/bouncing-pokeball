class Stage extends PIXI.Stage
	WIDTH = 1024
	HEIGHT = 600

	constructor: ->
		super 0x0
		@renderer = PIXI.autoDetectRenderer WIDTH, HEIGHT

	center: (anObject) =>
		anObject.position.x = @width() / 2
		anObject.position.y = @height() / 2

	width: -> @renderer.width
	height: -> @renderer.height		

	update: =>
		@renderer.render @

	addChildCentered: (aChild) =>
		@center aChild
		@addChild aChild

	collidesOnLeft: (anObject) =>
		anObject.position.x - anObject.width / 2 < @position.x

	collidesOnTop: (anObject) =>
		anObject.position.y - anObject.width / 2 < @position.y

	collidesOnBottom: (anObject) =>
		anObject.position.y + anObject.width / 2 > @position.y + @height()

	collidesOnRight: (anObject) =>
		anObject.position.x + anObject.width / 2 > @position.x + @width()

class PokeBall extends PIXI.Sprite
	constructor: (@stage, @speed) ->
		texture = PIXI.Texture.fromImage("../images/poke.png")
		super texture		

		# rotate around center
		@anchor.x = 0.5
		@anchor.y = 0.5

		stage.addChildCentered @

	rotateLeft: => 
		@rotation -= 0.06
		@stage.update()

	move: =>
		@position.x += @speed.x
		@position.y += @speed.y

		if stage.collidesOnLeft(@) || stage.collidesOnRight(@)
			@flip 'x'

		if stage.collidesOnTop(@) || stage.collidesOnBottom(@)
			@flip 'y'

		@stage.update()

	flip: (coordinate) => 
		@speed[coordinate] *= -1

class Game
	constructor: (@render) ->

	start: =>
		gameLoop = =>
		  requestAnimFrame gameLoop
		  @render()

		requestAnimFrame gameLoop			

stage = new Stage()

document.getElementById("bouncing-ball").appendChild stage.renderer.view

pokeBall = new PokeBall stage, 
	x: -10
	y: 10

new Game( ->
  pokeBall.rotateLeft()
  pokeBall.move()
).start()
