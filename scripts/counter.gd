extends Area2D
class_name Counter


func _on_body_entered(body):
	if body is ThrownIcecream:
		body.sell()
