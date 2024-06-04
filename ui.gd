extends CanvasLayer

@export var player_health: int = 100
@export var enemy_health: int = 100
signal health_changed

func _ready():
	connect("health_changed", _on_health_changed)
	_on_health_changed()


func _on_button_pressed():
	enemy_health = enemy_health - 20
	health_changed.emit()
	
func _on_health_changed():
	$PlayerUI/VBoxContainer/Label.text = "Health: " + str(player_health)
	$EnemeyUI/VBoxContainer/Label.text = "Health: " + str(enemy_health)
