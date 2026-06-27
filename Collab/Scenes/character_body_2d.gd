extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var gravity = 20
var health
var isAlive = true

var hasDash = true
var tween: Tween
const dash = 800.0
var dashSpeed = 0.0
var dashCD = 60
var dashCDTimer = 0

var hasFlap = true
var feathers = 1
var maxFeathers = 1

var hasGlide = false
var canGlide = false

@onready var healthBar = $CanvasLayer/HealthBar
@onready var playerSprite = $PlayerAnims
@onready var animate = $PlayerAnims

func _ready():
	health = 6
	healthBar.init_health(health)

func _physics_process(delta: float) -> void:
	if velocity.x > 0:
		playerSprite.flip_h = true
	if velocity.x < 0:
		playerSprite.flip_h = false
	movement()
	if hasDash:
		dashFunc()

#Handels dashing
func dashFunc():
	if Input.is_action_just_pressed("Dash") && dashCDTimer == 0:
		dashCDTimer = dashCD
		dashSpeed = dash
		if tween:
			tween.stop()
		tween = create_tween()
		tween.tween_property(self, "dashSpeed", 0, 0.2).set_ease(Tween.EASE_OUT)
	#Creates a cooldown period in b/w dashes
	if dashCDTimer > 0:
		dashCDTimer -= 1

#Handels general movement
func movement():
	# Add the gravity.
	if !is_on_floor():
		velocity.y += gravity

	# Handle jump.
	if Input.is_action_just_pressed("Jump") && is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction := Input.get_axis("Left", "Right")
	
	if direction:
		velocity.x = direction * (SPEED + dashSpeed)
		#Animates walk cycle only while on ground and while moving
		if is_on_floor():
			animate.play("DuckWalk")
		else:
			animate.stop()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animate.stop()
	
	#Handels air jumping
	if Input.is_action_just_pressed("Jump") && !is_on_floor():
		if hasFlap:
			if feathers >= 1:
				velocity.y = JUMP_VELOCITY
				feathers -= 1
	
	#Resets air jumps once touching ground
	if is_on_floor() && feathers == 0:
		feathers = maxFeathers
	move_and_slide()

#Handels changes to the health bar
func _set_health(value):
	healthBar._set_health(value)
