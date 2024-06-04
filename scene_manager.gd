extends Node

# Declare variables to store scenes or scene paths
@onready var current_scene = $Level

func _ready():
	# This connects the enemy defeated signal, defined in SignalBus, to scene manager, when the signal is recieved it calls transition
	SignalBus.connect("enemy_defeated", transition)

# Function to load a new scene
func load_scene(scene_path):
	var scene_instance = scene_path.instantiate()
	# After instantiation we call the scene's setup function, in the current case this is to remove enemies from the level scene
	scene_instance.setup()
	return scene_instance

# Function to transition to the next scene
func transition(next_scene):
	# Unload current scene
	current_scene.queue_free()

	# Set the now empty current scene as the next scene, then add next scene as a child to the scene manager
	current_scene = next_scene
	add_child(next_scene)
	


func _on_level_battle_transition(enemy, player):
	var arena_scene = load("res://arena.tscn")
	var arena_instance = load_scene(arena_scene)
	transition(arena_instance)

	print("finished")
	# This gets all enemy/player positions from the arena(though currently there is only one position and so I isolate the 0th index)
	var enemy_positions = current_scene.find_children("EnemyPosition")
	var player_positions = current_scene.find_children("PlayerPosition")
	var enemy_position = enemy_positions[0]
	var player_position = player_positions[0]
	print(enemy_position.position, player_position.position)
	# The following is zombie code atm, keeping it around just in case
	#var enemy_scene: PackedScene = preload("res://enemy.tscn")
	#var player_scene: PackedScene = preload("res://player.tscn")
	#var enemy_instance = enemy_scene.instantiate()
	#var player_instance = player_scene.instantiate()
	# I have learned about the remove_child method and tried utilizing it but to no avail. I need to rethink the code logic as it is if I want to use it
	# I create a clone of the enmy and player as I cannot add them directly to arena due to "object already has parent". This compounds issues later when I try to keep track of what enemies have died
	var arena_enemy = enemy.duplicate()
	var arena_player = player.duplicate()
	arena_enemy.position = enemy_position.position
	arena_player.position = player_position.position
	# I add the enemy and player clones to the current scene(which is now the arena)
	current_scene.add_child(arena_enemy)
	current_scene.add_child(arena_player)
	# I connect the battle transition signal from arena and attach the appropriate callable
	current_scene.connect("battle_transition", _on_arena_battle_transition)


func _on_arena_battle_transition(level, enemy):
	# The new level needs to connect the signal back to the scenemanager, the defeated enemy needs to be removed
	level.connect("battle_transition", _on_level_battle_transition)
	print(enemy.name)
	var defeated_enemy = level.find_child(enemy.name)
	defeated_enemy.defeated = true
	Globals.defeated_enemies.append(defeated_enemy.name)
	defeated_enemy.queue_free()
	level.setup()
	print("arena battle transition")
