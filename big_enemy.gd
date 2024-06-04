extends CharacterBody3D

@export var defeated = false

func _on_area_3d_body_entered(body):
	print("collided with ", body)
	SignalBus.battle.emit(self, body)
