extends CharacterBody3D

var min_speed = 8
var max_speed = 12
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready
var animation_player = %"Character".get_node("AnimationPlayer") as AnimationPlayer

func _ready():
	animation_player.play("Idle")


func spawn():
	pass
