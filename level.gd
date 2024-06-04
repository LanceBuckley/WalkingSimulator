extends Node3D
@onready var enemies = get_tree().get_nodes_in_group("Enemy") 
var arena_scene: PackedScene = load("res://arena.tscn")
signal battle_transition(enemy, player)


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Enemies: ", enemies)
	print("Defeated Enemies: ", Globals.defeated_enemies)
	SignalBus.connect("battle", _on_enemy_battle)
	for enemy in Globals.defeated_enemies:
		if enemy in enemies:
			enemy.defeated = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_enemy_battle(enemy, player):
	battle_transition.emit(enemy, player)

func setup():
	for enemy in enemies:
		if enemy.defeated == true:
			enemy.queue_free()