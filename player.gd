extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var cam = $Camera3D

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _ready():
	cam.current = is_multiplayer_authority()


func _physics_process(delta: float) -> void:
	
	if is_multiplayer_authority():  #Don't run physica if not multiplayer authority
		if Input.is_action_just_pressed("exit"):
			$"../".exit_game(name.to_int())
			get_tree().quit()
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
	#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#		velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
