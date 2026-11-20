extends CanvasLayer

const ITENS := {
	"powerbank": {
		"titulo": "Powerbank de células recicladas",
		"etapas": [
			["res://arte/notebook.png", 2, "Notebook"],
			["res://arte/celula.png", 1, "Célula 18650"],
			["res://arte/powerbank.png", 1, "Powerbank"],
		],
		"real": "quando a bateria de um notebook para, quase sempre só algumas células estragaram, e o circuito de proteção desliga o conjunto inteiro. Técnicos e cooperativas abrem a carcaça, testam cada célula 18650 e usam as boas em powerbanks e lanternas de LED.",
		"cuidado": "Cuidado real: células de lítio inchadas ou danificadas podem esquentar e pegar fogo. Elas devem ir para o descarte correto.",
		"jogo": "No jogo: cada powerbank aumenta a carga máxima da pistola.",
	},
	"pistola": {
		"titulo": "Dínamo de motor de micro-ondas",
		"etapas": [
			["res://arte/microondas.png", 2, "Micro-ondas"],
			["res://arte/motor.png", 1, "Motor do prato"],
			["res://arte/pistola.png", 1, "Pistola-dínamo"],
		],
		"real": "o pequeno motor que gira o prato do micro-ondas também funciona como gerador. Girando o eixo com uma manivela, ele produz eletricidade suficiente para carregar um celular ou acender uma lâmpada pequena.",
		"cuidado": "Cuidado real: o capacitor do micro-ondas guarda alta tensão mesmo com o aparelho desligado. Só profissionais devem abrir a carcaça.",
		"jogo": "No jogo: a pistola-dínamo gera a própria carga aos poucos.",
	},
	"malha": {
		"titulo": "Malha de aterramento de cobre",
		"etapas": [
			["res://arte/fio.png", 2, "Fios usados"],
			["res://arte/cobre.png", 1, "Cobre"],
			["res://arte/malha.png", 1, "Malha de aterramento"],
		],
		"real": "desencapar fios descartados para recuperar o cobre é uma das reciclagens mais comuns no Brasil. O cobre pode ser reciclado muitas vezes sem perder qualidade e evita a mineração, que é a etapa de maior impacto ambiental do metal.",
		"cuidado": "Cuidado real: queimar fios para tirar o plástico solta fumaça tóxica. O certo é desencapar o fio.",
		"jogo": "No jogo: a malha deixa você atravessar o chão eletrificado e levar a corrente até o gerador.",
	},
}

const DURACAO_ENTRADA := 0.35
const ATRASO_ETAPA := 0.45
const LETRAS_POR_SEGUNDO := 55.0

var tween: Tween
var ja_mostrados := {}

@onready var fundo: ColorRect = $Fundo
@onready var titulo: Label = $Fundo/Titulo
@onready var etapas: Array = [$Fundo/Cadeia/Etapa1, $Fundo/Cadeia/Etapa2, $Fundo/Cadeia/Etapa3]
@onready var setas: Array = [$Fundo/Cadeia/Seta1, $Fundo/Cadeia/Seta2]
@onready var real: Label = $Fundo/Real
@onready var cuidado: Label = $Fundo/Cuidado
@onready var jogo: Label = $Fundo/Jogo
@onready var continuar: Label = $Fundo/Continuar
@onready var sons: Node = $"../Sons"


func _ready() -> void:
	visible = false


func mostrar(item: String) -> void:
	if ja_mostrados.has(item):
		return
	ja_mostrados[item] = true
	var dados: Dictionary = ITENS[item]
	get_tree().paused = true
	visible = true

	titulo.text = dados.titulo
	real.text = "Na vida real: " + dados.real
	cuidado.text = dados.cuidado
	jogo.text = dados.jogo
	for i in etapas.size():
		var etapa: Control = etapas[i]
		var info: Array = dados.etapas[i]
		var textura: Texture2D = load(info[0])
		var quadro := AtlasTexture.new()
		quadro.atlas = textura
		quadro.region = Rect2(0, 0, textura.get_width() / info[1], textura.get_height())
		etapa.get_node("Imagem").texture = quadro
		etapa.get_node("Nome").text = info[2]

	fundo.modulate.a = 0.0
	titulo.position.y = -60.0
	real.visible_ratio = 0.0
	for no in etapas + setas + [cuidado, jogo, continuar]:
		no.modulate.a = 0.0
	for etapa in etapas:
		etapa.scale = Vector2(0.3, 0.3)
	await get_tree().process_frame
	for etapa in etapas:
		etapa.pivot_offset = etapa.size / 2.0

	tween = create_tween()
	tween.tween_property(fundo, "modulate:a", 1.0, DURACAO_ENTRADA)
	tween.tween_property(titulo, "position:y", 48.0, DURACAO_ENTRADA).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	for i in etapas.size():
		if i > 0:
			tween.tween_property(setas[i - 1], "modulate:a", 1.0, 0.15)
		tween.tween_callback(sons.get_node("Coleta").play)
		tween.tween_property(etapas[i], "modulate:a", 1.0, 0.12)
		tween.parallel().tween_property(etapas[i], "scale", Vector2.ONE, ATRASO_ETAPA).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(real, "visible_ratio", 1.0, real.text.length() / LETRAS_POR_SEGUNDO)
	tween.tween_property(cuidado, "modulate:a", 1.0, 0.3)
	tween.tween_property(jogo, "modulate:a", 1.0, 0.3)
	tween.tween_callback(sons.get_node("Fabricar").play)
	tween.tween_property(continuar, "modulate:a", 1.0, 0.3)


func _process(delta: float) -> void:
	if not visible:
		return
	if continuar.modulate.a > 0.99:
		continuar.self_modulate.a = 0.55 + 0.45 * sin(Time.get_ticks_msec() / 250.0)
	if not Input.is_action_just_pressed("pular"):
		return
	if tween and tween.is_running():
		tween.custom_step(999.0)
	else:
		fechar()


func fechar() -> void:
	if tween:
		tween.kill()
	visible = false
	get_tree().paused = false
