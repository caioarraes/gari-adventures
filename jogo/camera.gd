extends Camera3D

const DISTANCIA := Vector3(0.0, 3.5, 17.0)
const SUAVIDADE := 6.0
const DISTANCIA_DE_CORTE := 12.0

@onready var gari: Node3D = $"../Gari"


func _physics_process(delta: float) -> void:
	var alvo := gari.global_position + DISTANCIA
	if global_position.distance_to(alvo) > DISTANCIA_DE_CORTE:
		global_position = alvo
		reset_physics_interpolation()
		return
	global_position = global_position.lerp(alvo, 1.0 - exp(-SUAVIDADE * delta))
