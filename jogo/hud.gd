extends CanvasLayer

const COR_VAZIO := Color(0.1, 0.12, 0.15, 0.75)
const COR_CELULA := Color(0.3, 0.95, 0.55, 1)
const COR_MOTOR := Color(0.85, 0.5, 0.25, 1)
const COR_ENERGIA := Color(1.0, 0.86, 0.3, 1)
const COR_COBRE := Color(0.95, 0.6, 0.3, 1)
const COR_VIDA := Color(0.95, 0.25, 0.25, 1)

@onready var gari = $"../Gari"
@onready var info_celulas: Label = $Linhas/LinhaCelulas/Info
@onready var linha_motores: Control = $Linhas/LinhaMotores
@onready var info_motores: Label = $Linhas/LinhaMotores/Info
@onready var linha_energia: Control = $Linhas/LinhaEnergia
@onready var info_energia: Label = $Linhas/LinhaEnergia/Info
@onready var controles: Label = $Controles
@onready var linha_cobre: Control = $Linhas/LinhaCobre
@onready var info_cobre: Label = $Linhas/LinhaCobre/Info

var pips_celulas: Array[ColorRect] = []
var pips_motores: Array[ColorRect] = []
var pips_energia: Array[ColorRect] = []
var pips_cobre: Array[ColorRect] = []
var pips_vida: Array[ColorRect] = []


func _ready() -> void:
	pips_vida = _criar_pips($LinhaVida/Pips, gari.VIDA_MAXIMA)
	pips_celulas = _criar_pips($Linhas/LinhaCelulas/Pips, gari.CELULAS_POR_POWERBANK)
	pips_motores = _criar_pips($Linhas/LinhaMotores/Pips, gari.MOTORES_PARA_PISTOLA)
	pips_energia = _criar_pips($Linhas/LinhaEnergia/Pips, gari.ENERGIA_MAXIMA_TOTAL)
	pips_cobre = _criar_pips($Linhas/LinhaCobre/Pips, gari.COBRE_PARA_MALHA)


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
	_mostrar_celulas()
	_mostrar_motores()
	_mostrar_energia()
	_mostrar_cobre()
	controles.text = "A/D: andar   Espaço: pular   J: vassourada"
	if gari.tem_arma:
		controles.text += "   K: atirar"


func _mostrar_celulas() -> void:
	var no_maximo: bool = gari.powerbanks >= gari.MAXIMO_POWERBANKS
	for i in pips_celulas.size():
		pips_celulas[i].visible = not no_maximo
		pips_celulas[i].color = COR_CELULA if i < gari.celulas else COR_VAZIO

	if no_maximo:
		info_celulas.text = "%d powerbanks nas costas" % gari.powerbanks
	elif gari.celulas >= gari.CELULAS_POR_POWERBANK:
		info_celulas.text = "[Q] Montar powerbank: +%d de energia" % gari.ENERGIA_POR_POWERBANK
	else:
		var faltam: int = gari.CELULAS_POR_POWERBANK - gari.celulas
		info_celulas.text = "%s %d para o powerbank (+%d de energia)" % [_verbo_faltar(faltam), faltam, gari.ENERGIA_POR_POWERBANK]


func _mostrar_motores() -> void:
	linha_motores.visible = gari.motores > 0 and not gari.tem_arma
	for i in pips_motores.size():
		pips_motores[i].color = COR_MOTOR if i < gari.motores else COR_VAZIO

	if gari.motores >= gari.MOTORES_PARA_PISTOLA:
		info_motores.text = "[R] Montar pistola-dínamo"
	else:
		var faltam: int = gari.MOTORES_PARA_PISTOLA - gari.motores
		info_motores.text = "%s %d para a pistola-dínamo" % [_verbo_faltar(faltam), faltam]


func _mostrar_energia() -> void:
	linha_energia.visible = gari.tem_arma
	for i in pips_energia.size():
		pips_energia[i].visible = i < gari.energia_maxima
		pips_energia[i].color = COR_ENERGIA if i < gari.energia else COR_VAZIO

	if gari.energia < gari.energia_maxima:
		info_energia.text = "[K] Atirar. O dínamo gera mais carga"
	else:
		info_energia.text = "[K] Atirar. Carga cheia"


func _mostrar_cobre() -> void:
	linha_cobre.visible = gari.cobre > 0 or gari.tem_malha
	for i in pips_cobre.size():
		pips_cobre[i].visible = not gari.tem_malha
		pips_cobre[i].color = COR_COBRE if i < gari.cobre else COR_VAZIO

	if gari.tem_malha:
		info_cobre.text = "Malha de aterramento: o chão eletrificado carrega você para o gerador"
	elif gari.cobre >= gari.COBRE_PARA_MALHA:
		info_cobre.text = "[F] Fazer malha de aterramento"
	else:
		var faltam: int = gari.COBRE_PARA_MALHA - gari.cobre
		info_cobre.text = "%s %d para a malha de aterramento" % [_verbo_faltar(faltam), faltam]


func _verbo_faltar(quantidade: int) -> String:
	return "Falta" if quantidade == 1 else "Faltam"
