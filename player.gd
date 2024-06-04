extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var sensitivity = 1000

var physicsPaused = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Pause physics processing if the parent is "Arena"
func _ready():
	var parent_name = get_parent().get_name()
	if get_parent().get_name() == "Arena":
		physicsPaused = true
	print(parent_name)


func _physics_process(delta):
	
	if physicsPaused:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _input(event):
	if event is InputEventMouseMotion:
		# The camera rotates around the y axis making it move left and right
		rotation.y -= event.relative.x / sensitivity

		$CameraPivot.rotation.x -= event.relative.y / sensitivity
		# clamp is used to stop the movement from going over or under certain positions
		$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-45), deg_to_rad(90))
