extends CharacterBody3D

const SPEED := 7.0
const JUMP_SPEED := 9.0
const GRAVITY := 24.0
var view_yaw := 0.0
var active := false

func _physics_process(delta: float) -> void:
	if not active:
		return
	var axis := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := Vector3(axis.x, 0.0, axis.y).rotated(Vector3.UP, view_yaw)
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_SPEED
	move_and_slide()
	position.x = clampf(position.x, -35.0, 35.0)
	position.z = clampf(position.z, -35.0, 35.0)
	if direction.length_squared() > 0.01:
		$Model.rotation.y = lerp_angle($Model.rotation.y, atan2(direction.x, direction.z), delta * 12.0)
