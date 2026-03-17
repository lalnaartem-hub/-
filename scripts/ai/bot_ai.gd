extends CharacterBody3D

@export var role: String = "hunter"
@export_range(0.0, 1.0) var aggression: float = 0.5
@export var awareness_radius: float = 40.0
@export var patrol_speed: float = 2.2
@export var chase_speed: float = 4.6

var current_state: String = "patrol"
var target_position: Vector3 = Vector3.ZERO

func _ready() -> void:
	target_position = global_position

func _physics_process(_delta: float) -> void:
	_update_state()
	_apply_movement()

func _update_state() -> void:
	match role:
		"hunter":
			current_state = "track_prey" if aggression > 0.6 else "patrol"
		"builder":
			current_state = "gather_resources"
		"defender":
			current_state = "guard_base"
		"farmer":
			current_state = "harvest"
		_:
			current_state = "patrol"

func _apply_movement() -> void:
	var speed: float = patrol_speed
	if current_state == "track_prey":
		speed = chase_speed

	if current_state in ["patrol", "track_prey"]:
		if global_position.distance_to(target_position) < 0.75:
			target_position = global_position + Vector3(randf_range(-8.0, 8.0), 0.0, randf_range(-8.0, 8.0))
		var direction: Vector3 = (target_position - global_position).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, 0.2)
		velocity.z = move_toward(velocity.z, 0.0, 0.2)

	move_and_slide()
