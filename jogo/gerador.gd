extends Area3D

signal ligado

@onready var sprite: Sprite3D = $Sprite
@onready var luz: OmniLight3D = $Luz


func _physics_process(_delta: float) -> void:
	for corpo in get_overlapping_bodies():
		if corpo.entregar_carga():
			sprite.frame = 1
			luz.visible = true
			$"../../Sons/Gerador".play()
			ligado.emit()
			set_physics_process(false)
