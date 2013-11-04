class Randomizer
	constructor: (@min, @max) ->

	get: =>
  		Math.floor Math.random() * (@max - @min + 1) + @min

class Stage extends PIXI.Stage
	WIDTH = 1300
	HEIGHT = 800

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
		aChild

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
	constructor: () ->
		texture = PIXI.Texture.fromImage("../images/poke.png")
		super texture		

		# rotate around center
		@anchor.x = 0.5
		@anchor.y = 0.5

		@randomizeSpeed()

	randomizeSpeed: =>
		randomizer = new Randomizer -10, 10
		@speed =
			x: randomizer.get()
			y: randomizer.get()

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

class Counter extends PIXI.Text
	constructor: (@elements, @label) ->
		super label, fill: "white"

	count: => @elements.length		

	update: => @setText @label + @count()

stage = new Stage()
stage.onClick -> pokeBalls.push stage.addChildCentered(new PokeBall())

document.getElementById("bouncing-ball").appendChild stage.view()

pokeBalls = [ stage.addChildCentered new PokeBall() ]

ballsCounter = new Counter pokeBalls, "Balls: "
stage.addChild ballsCounter

new Game( ->
	pokeBalls.forEach (it) ->
		it.rotateLeft()
		it.move()

	ballsCounter.update()
	stage.update()
).start()
