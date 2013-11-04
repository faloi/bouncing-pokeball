class Stage extends PIXI.Stage
	WIDTH = 1024
	HEIGHT = 600

	constructor: ->
		super 0x0
		@renderer = PIXI.autoDetectRenderer WIDTH, HEIGHT

	center: (anObject) =>
		anObject.position.x = WIDTH / 2
		anObject.position.y = HEIGHT / 2

	update: =>
		@renderer.render @

	addChildCentered: (aChild) =>
		@center aChild
		@addChild aChild

	collidesWith: (anObject) =>
		@collidesOnLeft(anObject) || @collidesOnRight(anObject)

	collidesOnLeft: (anObject) =>
		anObject.position.x - anObject.width / 2 < @position.x

	collidesOnRight: (anObject) =>
		anObject.position.x + anObject.width / 2 > @position.x + WIDTH

class PokeBall extends PIXI.Sprite
	constructor: (@stage, @speed) ->
		texture = PIXI.Texture.fromImage("../images/Poke%20Ball.png")
		super texture		

		# rotate around center
		@anchor.x = 0.5
		@anchor.y = 0.5

		stage.addChildCentered @

	rotateLeft: => 
		@rotation -= 0.06
		@stage.update()

	move: =>
		@position.x += @speed

		if @stage.collidesWith @
			@flip()

		@stage.update()

	flip: => @speed *= -1

stage = new Stage()

document.getElementById("container").appendChild stage.renderer.view

pokeBall = new PokeBall stage, -5

gameLoop = ->
  requestAnimFrame gameLoop
  pokeBall.rotateLeft()
  pokeBall.move()

requestAnimFrame gameLoop
