extends Area3D

@onready var sprite: Sprite3D = $Sprite


func _ready() -> void:
	body_entered.connect(_ao_tocar, CONNECT_ONE_SHOT)


func _ao_tocar(corpo: Node3D) -> void:
	sprite.frame = 1
	corpo.marcar_retorno(global_position)
