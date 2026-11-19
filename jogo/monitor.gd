extends Area3D

signal derrotado

const COMPONENTE := preload("res://jogo/componente.tscn")
const FAISCA := preload("res://jogo/faisca_inimiga.tscn")
const INTERVALO := 1.8
const VELOCIDADE_FAISCA := 5.0
const ALCANCE_X := 6.0
const ALCANCE_Y := 2.5
const ALTURA_FAISCA := 0.7
const DURACAO_CLARAO := 0.2

var tempo := INTERVALO

@onready var gari: Node3D = $"../../Gari"
@onready var sprite: Sprite3D = $Sprite


func _ready() -> void:
	body_entered.connect(_ao_tocar)


func _physics_process(delta: float) -> void:
	tempo -= delta
	sprite.frame = 1 if tempo > INTERVALO - DURACAO_CLARAO else 0
	if tempo > 0.0:
		return
	var distancia := gari.global_position - global_position
	if absf(distancia.x) > ALCANCE_X or absf(distancia.y) > ALCANCE_Y:
		return
	tempo = INTERVALO
	$"../../Sons/FaiscaInimiga".play()
	var faisca := FAISCA.instantiate()
	faisca.position = position + Vector3(0.0, ALTURA_FAISCA, 0.0)
	faisca.velocidade = Vector3(signf(distancia.x) * VELOCIDADE_FAISCA, 0.0, 0.0)
	get_parent().add_child(faisca)


func derrotar() -> void:
	if is_queued_for_deletion():
		return
	$"../../Sons/Acerto".play()
	var componente := COMPONENTE.instantiate()
	componente.position = position
	get_parent().add_child(componente)
	derrotado.emit()
	queue_free()


func _ao_tocar(corpo: Node3D) -> void:
	corpo.empurrar(global_position.x)
