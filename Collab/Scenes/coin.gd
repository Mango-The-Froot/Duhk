extends Area2D




func _on_body_entered(body: Node2D) -> void:
	$"/root/GlobalData".money += 1
	queue_free()
