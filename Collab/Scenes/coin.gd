extends Area2D




func _on_body_entered(body):
	if body == GlobalVar.playerBody:
		$"/root/GlobalVar".money += 1
		queue_free()
