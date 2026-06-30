extends CharacterBody2D

class_name RatEnemy

const speed = 10
var chasing: bool

var health = 20
var healthMax = 20
var healthMin = 0

var dead: bool = false
var damaged: bool = false
var attack = 2
var attacking: bool = false

var dir: Vector2
const gravity = 20
var kBForce = 100
var roaming: bool = true


func _on_direction_timeout() -> void:
	$Direction.wait_time = choose([1.5,2.0,2.5])
	
func choose(array):
	array.shuffle()
	return array.front()
