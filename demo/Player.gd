
extends KinematicBody2D

func _ready() -> void:
	$NPCDetector.connect("area_entered", self, "_on_NPCDetector_changed", [true])
	$NPCDetector.connect("area_exited", self, "_on_NPCDetector_changed", [false])

var gravity_vector := Vector2(0.0, 198)

export var speed: float = 200.0

var is_over_npc: bool = false
var npc_to_talk_to

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if is_over_npc:
			if npc_to_talk_to.has_method("talk"):
				npc_to_talk_to.talk()


func _physics_process(_delta: float) -> void:
	var input_vector = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			0.0
		).normalized()
	var velocity: Vector2 = (input_vector * speed) + gravity_vector
	move_and_slide(velocity, Vector2.UP)


func _on_NPCDetector_changed(body, entered) -> void:
	is_over_npc = entered
	npc_to_talk_to = body
