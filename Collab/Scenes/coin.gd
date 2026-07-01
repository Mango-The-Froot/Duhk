extends Area2D




func _on_body_entered(body: Node2D) -> void:
	#print("+1 coin") #REPLACE WITH COLLECTION LATER
	GlobalVar.money += 1
	print(GlobalVar.money)
	queue_free()
