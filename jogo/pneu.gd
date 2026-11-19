extends Area3D

const BORRACHA := preload("res://jogo/borracha.tscn")
const VELOCIDADE := 3.0
const ALCANCE := 1.2
const ALTURA_QUIQUE := 0.7
const RITMO_QUIQUE := 5.0

var direcao := 1.0
var tempo := 0.0

@onready var centro := position.x
@onready var chao := position.y
@onready var sprite: Sprite3D = $Sprite


func _ready() -> void:
	body_entered.connect(_ao_tocar)


func _physics_process(delta: float) -> void:
	position.x += direcao * VELOCIDADE * delta
	if absf(position.x - centro) >= ALCANCE:
		position.x = centro + signf(position.x - centro) * ALCANCE
		direcao *= -1.0
	tempo += delta
	position.y = chao + absf(sin(tempo * RITMO_QUIQUE)) * ALTURA_QUIQUE
	sprite.frame = int(tempo * 8.0) % 2


func derrotar() -> void:
	if is_queued_for_deletion():
		return
	$"../../Sons/Acerto".play()
	var borracha := BORRACHA.instantiate()
	borracha.position = Vector3(position.x, chao, position.z)
	get_parent().add_child(borracha)
	queue_free()


func _ao_tocar(corpo: Node3D) -> void:
	corpo.empurrar(global_position.x)
