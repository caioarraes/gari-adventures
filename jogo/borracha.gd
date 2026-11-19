extends Area3D


func _physics_process(_delta: float) -> void:
	for corpo in get_overlapping_bodies():
		corpo.guardar_borracha()
		queue_free()
