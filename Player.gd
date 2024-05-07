extends CharacterBody3D

const BASE_SPEED = 5.0
const JUMP_VELOCITY = 4.0
const ROLL_SPEED = 25.0
var speed = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_rolling = false
@onready
var animation_player = %"Character".get_node("AnimationPlayer") as AnimationPlayer
var movementDirection: Vector3

func _physics_process(delta):
	var input_dir = Input.get_vector("move_right", "move_left", "move_down", "move_up")
	movementDirection = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	handle_jump(delta)
	handle_roll()
	handle_movement(delta)

func handle_jump(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta
		animation_player.play("Fall")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_player.play("Fall")

func handle_roll():
	if movementDirection and Input.is_action_just_pressed("roll") and is_on_floor():
		$Pivot.basis = Basis.looking_at(movementDirection)
		var timer = Timer.new()
		timer.wait_time = 0.5
		timer.autostart = true
		timer.one_shot = true
		add_child(timer)
		animation_player.play("Flip")
		is_rolling = true
		velocity.x = -movementDirection.x * ROLL_SPEED
		velocity.z = -movementDirection.z * ROLL_SPEED
		await timer.timeout 
		is_rolling = false
		
		
func handle_movement(delta: float):
	if(not is_rolling):
		if movementDirection:
			$Pivot.basis = Basis.looking_at(movementDirection)
			if Input.is_action_pressed("sprint"):
				animation_player.play("Run")
				speed = BASE_SPEED*2
			else:
				animation_player.play("Walk")
				speed = BASE_SPEED
			velocity.x = -movementDirection.x * speed
			velocity.z = -movementDirection.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
			animation_player.play("Idle") 
	move_and_slide()
