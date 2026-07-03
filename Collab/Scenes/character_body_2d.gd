extends CharacterBody2D

var deaths = 0

const SPEED = 250.0
const JUMP_VELOCITY = -400.0
var gravity = 20
var health
var maxHealth
var isAlive = true

var hasDash = false
var tween: Tween
const dash = 800.0
var dashSpeed = 0.0
var dashCD = 60
var dashCDTimer = 0

var hasFlap = false
var feathers = 1
var maxFeathers = 1

var hasGlide = false
var canGlide = false

var canTakeDamage = true
var attacking: bool
var attackType: String

var coyoteTime = 0
var isCoyote = true

@onready var healthBar = $CanvasLayer/HealthBar
@onready var animate = $PlayerAnims
@onready var damageZone = $PlayerDamageZone

func _ready():
	GlobalVar.playerBody = self
	health = 60
	maxHealth = health
	healthBar.init_health(health)
	attacking = false
	#healthBar.init_health(health)

func _physics_process(delta: float) -> void:
	#GlobalVar.playerDamageZone = damageZone
	GlobalVar.playerHitbox = $PlayerHitBox
	GlobalVar.playerDamageZone = damageZone
	GlobalVar.playerDamage = 10
	GlobalVar.playerDeaths = deaths
	if !attacking:
		if Input.is_action_just_pressed("Attack"):
			attacking = true
			handleAttackAnim()
	
	var direction = Input.get_axis("Left", "Right")
	
	if health <= 0:
		if deaths < 1:
			deaths += 1
			global_position = GlobalVar.nextZone.global_position
			_set_health(maxHealth)
	
	movement()
	if hasDash:
		dashFunc()
	
	if hasFlap:
		isCoyote = false	
	
	handleMovementAnimation(direction)

func toggleFlipSprite(dir):
	if dir == 1:
		animate.flip_h = true
		damageZone.position.x *= abs(damageZone.position.x) / damageZone.position.x
	if dir == -1:
		animate.flip_h = false
		damageZone.position.x *= abs(damageZone.position.x) / damageZone.position.x * -1

func handleMovementAnimation(dir):
	toggleFlipSprite(dir)
	if is_on_floor() && !attacking:
		if !velocity:
			pass #Idle
		if velocity.x != 0:
			animate.play("DuckWalk")
			toggleFlipSprite(dir)
		else:
			animate.stop()
	elif !is_on_floor():
		animate.play("DuckFall")
		
func handleAttackAnim():
	if attacking:
		animate.play("DuckAttack")
		toggleDamageCollisions()
		
func toggleDamageCollisions():
	var damageZoneCollision = damageZone.get_node("CollisionShape2D")
	var waitTime = .2
	damageZoneCollision.disabled = false
	await get_tree().create_timer(waitTime).timeout
	damageZoneCollision.disabled = true
	

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
		coyoteTime -= 1
	else:
		if isCoyote:
			coyoteTime = 10

	# Handle jump.
	if Input.is_action_just_pressed("Jump") && (is_on_floor() || coyoteTime > 0):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction := Input.get_axis("Left", "Right")
	
	if direction:
		velocity.x = direction * (SPEED + dashSpeed)
		#Animates walk cycle only while on ground and while moving
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#Handels air jumping
	if Input.is_action_just_pressed("Jump") && !is_on_floor():
		if hasFlap:
			if feathers >= 1:
				velocity.y = JUMP_VELOCITY
				feathers -= 1
				
	
	#Resets air jumps once touching ground
	if is_on_floor() && feathers == 0:
		feathers = maxFeathers
	checkHitbox()
	move_and_slide()

func checkHitbox():
	var hitboxAreas = $PlayerHitBox.get_overlapping_areas()
	var damage: int
	if hitboxAreas:
		var hitbox = hitboxAreas.front()
		if hitbox.get_parent() is RatEnemy:
			damage = GlobalVar.ratDamage
		elif hitbox.get_parent() is BossRat:
			damage = GlobalVar.bossRatDmg
		if canTakeDamage:
			takeDamage(damage)

func takeDamageCD(cooldown):
	canTakeDamage = false
	await get_tree().create_timer(cooldown).timeout
	canTakeDamage = true

func takeDamage(damage):
	if damage != 0:
		if health > 0:
			health -= damage
			print("player health: ", health)
			_set_health(health)
			takeDamageCD(1.0)

#Handels changes to the health bar
func _set_health(value):
	healthBar._set_health(value)
	health = value



func _on_player_anims_animation_finished():
	await get_tree().create_timer(.5).timeout
	attacking = false


func _on_unlock_dash_area_entered(area: Area2D) -> void:
	hasDash = true


func _on_unlock_jump_area_entered(area: Area2D) -> void:
	hasFlap = true


func _on_teleporter_area_entered(area: Area2D) -> void:
	global_position = GlobalVar.lastZone.global_position
