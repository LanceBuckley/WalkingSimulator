extends Node3D

@onready var level_scene = load("res://level.tscn")
@onready var level_instance = level_scene.instantiate()
signal battle_transition(level, enemy)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Arena loaded")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# This is definitely a bad way doing this
	if $UI.enemy_health == 0:
		SignalBus.enemy_defeated.emit(level_instance)
		# This is deprecated since I am no longer dynamiclly adding objects to the enemy group
		var enemy_instance = get_tree().get_nodes_in_group("Enemy")
		# Originally this would only grab the clone of the enemy added to the arena, and so I would isolate it and send it, but the code needs to be changed
		battle_transition.emit(level_instance, enemy_instance[0])

func setup():
	pass

