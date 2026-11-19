extends Area3D

const VIDA := 1.6

var velocidade := Vector3.ZERO
var tempo := VIDA


func _ready() -> void:
	area_entered.connect(_ao_acertar_inimigo)
	body_entered.connect(_ao_acertar_gari)


func _physics_process(delta: float) -> void:
	position += velocidade * delta
	tempo -= delta
	if tempo <= 0.0:
		queue_free()


func _ao_acertar_inimigo(inimigo: Area3D) -> void:
	if is_queued_for_deletion():
		return
	inimigo.derrotar.call_deferred()
	queue_free()


func _ao_acertar_gari(corpo: Node3D) -> void:
	if is_queued_for_deletion():
		return
	corpo.empurrar(global_position.x)
	queue_free()
