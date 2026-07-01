extends ProgressBar

var health = 0 : set = _set_health

func _set_health(new_health):
	var prevHealth = health
	health = min(max_value, new_health)
	value = health

func init_health(_health):
	health = _health
	max_value = _health
	value = _health
