extends Area3D

const COBRE := preload("res://jogo/cobre.tscn")
const VELOCIDADE := 2.0
const ALCANCE := 1.2
const INTERVALO := 2.0
const DURACAO_CHICOTE := 0.35
const DISTANCIA_CHICOTE := 2.6
const POSICAO_CHICOTE := 0.95

var direcao := 1.0
var espera := INTERVALO
var tempo_chicote := 0.0

@onready var centro := position.x
@onready var sprite: Sprite3D = $Sprite
@onready var chicote: CollisionShape3D = $Chicote
@onready var gari: Node3D = $"../../Gari"


func _ready() -> void:
	body_entered.connect(_ao_tocar)


func _physics_process(delta: float) -> void:
	if tempo_chicote > 0.0:
		tempo_chicote -= delta
		if tempo_chicote <= 0.0:
			chicote.set_deferred("disabled", true)
			sprite.frame = 0
		return

	position.x += direcao * VELOCIDADE * delta
	if absf(position.x - centro) >= ALCANCE:
		position.x = centro + signf(position.x - centro) * ALCANCE
		direcao *= -1.0
	sprite.flip_h = direcao < 0.0

	espera -= delta
	var distancia := gari.global_position - global_position
	if espera <= 0.0 and absf(distancia.x) < DISTANCIA_CHICOTE and absf(distancia.y) < 1.5:
		espera = INTERVALO
		tempo_chicote = DURACAO_CHICOTE
		var lado := signf(distancia.x)
		sprite.flip_h = lado < 0.0
		sprite.frame = 1
		chicote.position.x = lado * POSICAO_CHICOTE
		chicote.set_deferred("disabled", false)
		$"../../Sons/Chicote".play()


func derrotar() -> void:
	if is_queued_for_deletion():
		return
	$"../../Sons/Acerto".play()
	var cobre := COBRE.instantiate()
	cobre.position = position
	get_parent().add_child(cobre)
	queue_free()


func _ao_tocar(corpo: Node3D) -> void:
	corpo.empurrar(global_position.x)
