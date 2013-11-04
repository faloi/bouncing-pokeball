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

	view: => @renderer.view

	onClick: (action) =>
		$(@view()).click action

class PokeBall extends PIXI.Sprite
	constructor: (@speed) ->
		texture = PIXI.Texture.fromImage("../images/poke.png")
		super texture		

		# rotate around center
		@anchor.x = 0.5
		@anchor.y = 0.5

		stage.addChildCentered @

	rotateLeft: => 
		@rotation -= 0.06

	move: =>
		@position.x += @speed.x
		@position.y += @speed.y

		if stage.collidesOnLeft(@) || stage.collidesOnRight(@)
			@flip 'x'

		if stage.collidesOnTop(@) || stage.collidesOnBottom(@)
			@flip 'y'

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
stage.onClick -> 
	pokeBalls.push(new PokeBall x: -5, y: -5)

document.getElementById("bouncing-ball").appendChild stage.view()

pokeBalls = [
	new PokeBall
		x: -10
		y: 10
]

new Game( ->
	pokeBalls.forEach (it) ->
		it.rotateLeft()
		it.move()

	stage.update()
).start()
