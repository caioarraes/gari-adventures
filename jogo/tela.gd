extends CanvasLayer

var estado := "inicio"

@onready var painel: Control = $Painel
@onready var titulo: Label = $Painel/Titulo
@onready var texto: Label = $Painel/Texto
@onready var gari = $"../Gari"
@onready var sons: Node = $"../Sons"


func _ready() -> void:
	get_tree().paused = true
	titulo.text = "GARI ADVENTURES"
	texto.text = "Um gari reaproveita tudo o que o mundo jogou fora.\n\nAperte Espaço para começar"


func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("pular"):
		return
	if estado == "inicio":
		comecar()
	elif estado == "fim":
		get_tree().paused = false
		get_tree().reload_current_scene()


func comecar() -> void:
	estado = "jogando"
	painel.visible = false
	get_tree().paused = false
	sons.get_node("Musica").play()


func _ao_chegar(_corpo: Node3D) -> void:
	_vencer.call_deferred()


func _vencer() -> void:
	estado = "fim"
	get_tree().paused = true
	sons.get_node("Musica").stop()
	sons.get_node("Vitoria").play()
	titulo.text = "Rua limpa!"
	var bolsa := "Sua bolsa chegou ao nível %d." % gari.nivel_bolsa if gari.nivel_bolsa > 0 else "Você terminou sem bolsa."
	texto.text = "%s\nO lixo eletrônico virou sua pistola.\n\nAperte Espaço para jogar de novo" % bolsa
	painel.visible = true
