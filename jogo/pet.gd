extends Area3D

const MATERIAL := preload("res://jogo/material_pet.tscn")
const VELOCIDADE := 1.2
const ALCANCE := 0.8

var direcao := 1.0
var tempo := 0.0

@onready var centro := position.x
@onready var sprite: Sprite3D = $Sprite


func _ready() -> void:
	body_entered.connect(_ao_tocar)


func _physics_process(delta: float) -> void:
	position.x += direcao * VELOCIDADE * delta
	if absf(position.x - centro) >= ALCANCE:
		position.x = centro + signf(position.x - centro) * ALCANCE
		direcao *= -1.0
	tempo += delta
	sprite.frame = int(tempo * 5.0) % 2
	sprite.flip_h = direcao < 0.0


func derrotar() -> void:
	if is_queued_for_deletion():
		return
	$"../../Sons/Acerto".play()
	var material := MATERIAL.instantiate()
	material.position = position
	get_parent().add_child(material)
	queue_free()


func _ao_tocar(corpo: Node3D) -> void:
	corpo.empurrar(global_position.x)
