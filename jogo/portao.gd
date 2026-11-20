extends CSGBox3D

const ALTURA_ABERTO := 4.5
const DURACAO := 0.9


func abrir() -> void:
	$"../../Sons/Portao".play()
	create_tween().tween_property(self, "position:y", position.y + ALTURA_ABERTO, DURACAO)
