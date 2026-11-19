extends CanvasLayer

const COR_VAZIO := Color(0.1, 0.12, 0.15, 0.75)
const COR_PET := Color(0.55, 0.88, 0.98, 1)
const COR_COMPONENTE := Color(0.3, 0.95, 0.55, 1)
const COR_BORRACHA := Color(0.88, 0.63, 0.38, 1)
const COR_VIDA := Color(0.95, 0.25, 0.25, 1)

@onready var gari = $"../Gari"
@onready var titulo_componentes: Label = $LinhaComponentes/Titulo
@onready var info_pet: Label = $LinhaPet/Info
@onready var info_componentes: Label = $LinhaComponentes/Info
@onready var controles: Label = $Controles
@onready var linha_borracha: Control = $LinhaBorracha
@onready var info_borracha: Label = $LinhaBorracha/Info

var pips_pet: Array[ColorRect] = []
var pips_componentes: Array[ColorRect] = []
var pips_borracha: Array[ColorRect] = []
var pips_vida: Array[ColorRect] = []


func _ready() -> void:
	pips_vida = _criar_pips($LinhaVida/Pips, gari.VIDA_MAXIMA)
	pips_pet = _criar_pips($LinhaPet/Pips, gari.PET_POR_BOLSA)
	pips_componentes = _criar_pips($LinhaComponentes/Pips, gari.CAPACIDADE_MAXIMA)
	pips_borracha = _criar_pips($LinhaBorracha/Pips, gari.BORRACHA_PARA_SOLADO)


func _criar_pips(linha: HBoxContainer, quantidade: int) -> Array[ColorRect]:
	var pips: Array[ColorRect] = []
	for i in quantidade:
		var pip := ColorRect.new()
		pip.custom_minimum_size = Vector2(24, 24)
		pip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		linha.add_child(pip)
		pips.append(pip)
	return pips


func _process(_delta: float) -> void:
	for i in pips_vida.size():
		pips_vida[i].color = COR_VIDA if i < gari.vida else COR_VAZIO
	_mostrar_pet()
	_mostrar_componentes()
	_mostrar_borracha()
	controles.text = "A/D: andar   Espaço: pular   J: vassourada"
	if gari.tem_arma:
		controles.text += "   K: atirar"


func _mostrar_pet() -> void:
	var bolsa_no_maximo: bool = gari.nivel_bolsa >= gari.NIVEL_MAXIMO_BOLSA
	for i in pips_pet.size():
		pips_pet[i].visible = not bolsa_no_maximo
		pips_pet[i].color = COR_PET if i < gari.pet else COR_VAZIO

	if bolsa_no_maximo:
		info_pet.text = "Bolsa no nível máximo"
	elif gari.pet >= gari.PET_POR_BOLSA:
		info_pet.text = "[E] Fazer bolsa: +%d espaços" % gari.ESPACOS_POR_BOLSA
	else:
		var faltam: int = gari.PET_POR_BOLSA - gari.pet
		info_pet.text = "%s %d para a bolsa (+%d espaços)" % [_verbo_faltar(faltam), faltam, gari.ESPACOS_POR_BOLSA]


func _mostrar_componentes() -> void:
	for i in pips_componentes.size():
		pips_componentes[i].visible = i < gari.capacidade
		pips_componentes[i].color = COR_COMPONENTE if i < gari.componentes else COR_VAZIO

	titulo_componentes.text = "Balas" if gari.tem_arma else "Componentes"
	if gari.tem_arma and gari.componentes == 0:
		info_componentes.text = "Sem balas: 1 volta em instantes"
	elif gari.tem_arma:
		info_componentes.text = "Monitores dão mais balas"
	elif gari.componentes >= gari.COMPONENTES_PARA_PISTOLA:
		info_componentes.text = "[R] Montar pistola"
	else:
		var faltam: int = gari.COMPONENTES_PARA_PISTOLA - gari.componentes
		info_componentes.text = "%s %d para a pistola" % [_verbo_faltar(faltam), faltam]


func _mostrar_borracha() -> void:
	linha_borracha.visible = gari.borracha > 0 or gari.tem_solado
	for i in pips_borracha.size():
		pips_borracha[i].visible = not gari.tem_solado
		pips_borracha[i].color = COR_BORRACHA if i < gari.borracha else COR_VAZIO

	if gari.tem_solado:
		info_borracha.text = "Solado de pneu: você pula mais alto"
	elif gari.borracha >= gari.BORRACHA_PARA_SOLADO:
		info_borracha.text = "[F] Fazer solado: pulo mais alto"
	else:
		var faltam: int = gari.BORRACHA_PARA_SOLADO - gari.borracha
		info_borracha.text = "%s %d para o solado" % [_verbo_faltar(faltam), faltam]


func _verbo_faltar(quantidade: int) -> String:
	return "Falta" if quantidade == 1 else "Faltam"
