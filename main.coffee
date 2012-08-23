
GAME_STATE_SPLASH = 1
GAME_STATE_PLAYING = 2
GAME_STATE_LOST = 3
game_state = GAME_STATE_SPLASH

current_time = 0

# get a reference to the canvas object(1)
canvas = document.getElementById "game"

# set global width/height(2)
GAME_HEIGHT = canvas.height
GAME_WIDTH = canvas.width
GUTTER = 20

# get the canvas context(3)
ctx = canvas.getContext "2d"

# create a text object
class Text

	constructor: (@context, @text, @x, @y, @size) ->

	draw: ->
		@context.font = @size + ' bold Arial'
		@context.fillStyle = '#20ff1b'
		@context.fillText(@text, @x, @y)

	updateText: (@text) ->

# create a base sprite
class Sprite

	# create a constructor that takes in the path to the image,
	# the 2d context, the initial x,y position and the speed (4)
	constructor: (@path, @context, @x, @y, @speed) ->
		# create a bounds object to hold the bounds
		# that this sprite is constrained to (5)	
		@bounds = 
			left: 0
			right: 0
			top: 0
			bottom: 0
		@initial_x = @x
		@initial_y = @y
		@initial_speed = @speed

		# create a default width/height for the sprite

		# store the original x and y locations for reset (6)
		
		# create an HTML image element from the path (7)
		@image = new Image()
		@image.src = @path
	
		# the image won't load in time to be drawn
		# listen to the image onload event
		# FAT ARROW (8)
		@image.onload = =>

			# log that it loaded		
		
			# set the width and height
			@width = @image.width
			@height = @image.height

			# set the bounds of the game (9)
			@bounds.bottom = (GAME_HEIGHT - GUTTER) - @height
			@bounds.right = GAME_WIDTH - @width
			@bounds.top = GUTTER

		# everything could collide with something

	# create a draw loop in the sprite (different from the main draw loop)
	# which uses the context to draw the sprite at the specified location (10)
	draw: ->
		@context.drawImage @image, @x, @y
	# do a collision test and return items collided with (11)
	collides: (item) ->	
	
		# now do simple bounding box collision testing (12)
		left1 = @x
		left2 = item.x
		right1 = @x + @width
		right2 = item.x + item.width
		top1 = @y
		top2 = item.y
		bottom1 = @y + @height
		bottom2 = item.y + item.height

		# if the it's above, below, to the left or right of the item, 
		# they aren't colliding	(13)
		if bottom1 < top2 or top1 > bottom2 or right1 < left2 or left1 > right2
			return false
		
		# otherwise they are!
		return true
		
	# reset the game (14)

# create a paddle sprite that extends the base sprite (15)
class Paddle extends Sprite
	# create a move function that will move the sprite around based on
	# a y value that is passed in (16)
	move: (y) ->

		# did we move past the upper or lower bounds? (17)
		if y > @bounds.top and y < @bounds.bottom
			@y = y

# create a ball class that extends the base sprite (18)
class Ball extends Sprite
	# create a constructor that adds a velocity object (19)
	constructor: ->
		@velocity =
			x: 1
			y: 1
		@initial_velocity = @velocity

		# don't forget to call super!
		super

	# reset the ball to start a new game
	reset: ->
		@x = @initial_x
		@y = @initial_y
		@speed = @initial_speed
		@velocity.x = 1
		@velocity.y = 1
		game_state = GAME_STATE_PLAYING
		current_time = 0

	# create a move function that moves the ball around (20)
	move: ->
		@x += @speed * @velocity.x
		@y += @speed * @velocity.y

	# override the draw function to check the bounds
	draw: ->
		# does this ball collides with anything, we need to reverse
		# the direction (21)
		if @collides(cpu)
			@x = (cpu.x - @width)
			@velocity.x *= -1
			beep.play()
			
		if @collides(player)
			@x = (player.x + player.width) - 1
			@velocity.x *= -1
			beep.play()

		# is this ball headed out of bounds on the top or bottom? (22)
		if @y < @bounds.top or @y > @bounds.bottom
			@velocity.y *= -1
			plop.play()

		# did someone score? (23)
		if (@x + @width) < 0
			game_state = GAME_STATE_LOST

		super

# create an audio class (24)
class Sound
	constructor: (@path) ->
		@sound = new Audio()
		@sound.src = @path

	play: ->
		@sound.play()

# create a background sprite (25)
background = new Sprite "images/background.png", ctx, 0, 0

# create a player paddle on the left (it's 14 by 30) (26)
player = new Paddle "images/player.png", ctx, 20, (GAME_HEIGHT / 2) - 30
# create a cpu paddle on the right (it's 14 by 30) (27)
cpu = new Paddle "images/player.png", ctx, (GAME_WIDTH - 14) - 20, (GAME_HEIGHT / 2) - 30
# create the ball in the middle of the screen (its 16 x 16) (28)
ball = new Ball "images/ball.png", ctx, (GAME_WIDTH / 2) - 8, (GAME_HEIGHT / 2) - 8, 5
# create the sounds (29)
beep = new Sound("audio/beep.ogg")
plop = new Sound("audio/plop.ogg")

pong_text = new Text ctx, 'PONG', 72, 90, '50px'
play_text = new Text ctx, 'Tap to play', 90, 130, '20px'
art_heading = new Text ctx, 'ART AND SOUND', 260, 130, '20px'
art_text = new Text ctx, 'opengameart.org', 280, 155, '20px'
programming_heading = new Text ctx, 'PROGRAMMING', 260, 210, '20px'
programming_text1 = new Text ctx, 'Burke Holland', 280, 235, '20px'
programming_text2 = new Text ctx, 'Kyle Davis', 280, 255, '20px'

timer_text = new Text ctx, 'timer', 400, 300, '20px'

you_lose_text = new Text ctx, 'GAME   OVER', 72, 90, '50px'
reset_text = new Text ctx, 'Tap to reset', 90, 130, '20px'


# create a draw function
draw = ->

	background.draw()

	player.draw()

	cpu.draw()

	if game_state is GAME_STATE_SPLASH
		pong_text.draw()
		play_text.draw()
		art_heading.draw()
		art_text.draw()
		programming_heading.draw()
		programming_text1.draw()
		programming_text2.draw()

	if game_state is GAME_STATE_PLAYING
		ball.draw()
		ball.move()
		cpu.move(ball.y)
		timer_text.draw()

	if game_state is GAME_STATE_LOST
		you_lose_text.draw()
		reset_text.draw()
		timer_text.draw()

	# get the animation frame and loop the loop (30)
	getAnimationFrame()(draw, canvas)

# add a little AI... (31)
setInterval(-> 
	ball.speed += .2
,1000)

setInterval(-> 
	if game_state is GAME_STATE_PLAYING
		current_time += .1
		timer_text.updateText(current_time.toFixed(1))
,100)

# normalize request animation frame (32)
getAnimationFrame = ->
	return window.requestAnimationFrame || window.webkitRequestAnimationFrame || 
	window.mozRequestAnimationFrame || window.oRequestAnimationFrame || 
	window.msRequestAnimationFrame || (callback, element) ->
		return window.setTimeout callback, 1000 / 60

# listen for the mouse events (33)
document.body.addEventListener 'mousemove', (event) ->
	if game_state is GAME_STATE_PLAYING
		player.move event.y - (player.height / 2)
, false

document.body.addEventListener 'click', (event) ->
	touchOrClick()

document.body.addEventListener 'touchend', (event) ->
	touchOrClick()

touchOrClick = () ->
	if game_state is GAME_STATE_SPLASH
		ball.reset()
		game_state = GAME_STATE_PLAYING
	if game_state is GAME_STATE_LOST
		ball.reset()

draw()