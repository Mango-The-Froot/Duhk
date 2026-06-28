extends CharacterBody2D


const range = 10
const speed = 3
var currentDist = 0
var direction = 1
var counter = 0
const gravity = 20

func _physics_process(delta: float) -> void:
	counter += 1
	
	if(currentDist < range):
		position.x += speed * direction
		if(counter % 20 == 0):
			currentDist += range / speed
	elif(currentDist >= range):
		direction *= -1
		currentDist = 0
	if !is_on_floor():
		velocity.y += gravity

	move_and_slide()
