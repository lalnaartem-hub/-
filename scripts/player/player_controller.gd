extends CharacterBody3D

@export var walk_speed: float = 4.8
@export var run_speed: float = 9.5
@export var jump_velocity: float = 5.8
@export var gravity: float = 18.0
@export var acceleration: float = 14.0
@export var air_control: float = 4.0
@export var mouse_sensitivity: float = 0.0025

@onready var camera_pivot: Node3D = $CameraPivot

var is_running: bool = false
var look_x: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		look_x = clamp(look_x - event.relative.y * mouse_sensitivity, -1.2, 1.2)
		camera_pivot.rotation.x = look_x
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	is_running = Input.is_action_pressed("run")
	var target_speed := run_speed if is_running else walk_speed
	var direction := (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

	var control := acceleration if is_on_floor() else air_control
	velocity.x = move_toward(velocity.x, direction.x * target_speed, control * delta)
	velocity.z = move_toward(velocity.z, direction.z * target_speed, control * delta)

	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	move_and_slide()
