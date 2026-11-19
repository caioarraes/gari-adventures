extends Camera3D

const DISTANCIA := Vector3(0.0, 3.5, 17.0)
const SUAVIDADE := 6.0

@onready var gari: Node3D = $"../Gari"


func _physics_process(delta: float) -> void:
	var alvo := gari.global_position + DISTANCIA
	global_position = global_position.lerp(alvo, 1.0 - exp(-SUAVIDADE * delta))
