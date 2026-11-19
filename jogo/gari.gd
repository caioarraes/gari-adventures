extends CharacterBody3D

const VELOCIDADE := 7.0
const ACELERACAO := 60.0
const FREIO := 80.0
const CONTROLE_NO_AR := 0.7
const FORCA_PULO := 12.0
const FORCA_PULO_SOLADO := 15.0
const GRAVIDADE := 32.0
const GRAVIDADE_QUEDA := 48.0
const QUEDA_MAXIMA := 20.0
const CORTE_PULO := 0.45
const TEMPO_APOS_BORDA := 0.1
const TEMPO_PULO_ANTECIPADO := 0.12
const ALTURA_DE_RETORNO := -12.0

const ALCANCE_GOLPE := 0.95
const RECARGA_GOLPE := 0.3
const DURACAO_GOLPE := 0.12
const EMPURRAO := Vector2(9.0, 5.0)
const DURACAO_EMPURRAO := 0.25
const DURACAO_PROTECAO := 1.0
const VIDA_MAXIMA := 3

const PET_POR_BOLSA := 3
const NIVEL_MAXIMO_BOLSA := 2
const ESPACOS_INICIAIS := 3
const ESPACOS_POR_BOLSA := 3
const CAPACIDADE_MAXIMA := 9
const COMPONENTES_PARA_PISTOLA := 3
const BORRACHA_PARA_SOLADO := 3

const FAISCA := preload("res://jogo/faisca_gari.tscn")
const VELOCIDADE_FAISCA := 14.0
const RECARGA_TIRO := 0.35
const ALTURA_TIRO := 0.85
const RECARGA_EMERGENCIA := 4.0

const QUADRO_PARADO := 0
const QUADRO_ANDANDO := 1
const QUADRO_SUBINDO := 3
const QUADRO_CAINDO := 4
const QUADRO_GOLPE := 5
const QUADROS_POR_LINHA := 6

var tempo_borda := 0.0
var tempo_pulo := 0.0
var tempo_golpe := 0.0
var tempo_tiro := 0.0
var tempo_emergencia := RECARGA_EMERGENCIA
var tempo_empurrao := 0.0
var tempo_protecao := 0.0
var tempo_passos := 0.0
var olhando := 1.0

var vida := VIDA_MAXIMA
var precisa_voltar := false

var pet := 0
var nivel_bolsa := 0
var capacidade := ESPACOS_INICIAIS
var componentes := 0
var tem_arma := false
var borracha := 0
var tem_solado := false

@onready var ponto_retorno := global_position
@onready var sprite: Sprite3D = $Sprite
@onready var arma: Sprite3D = $Faiscador
@onready var golpe: Area3D = $Golpe
@onready var vassoura: Sprite3D = $Golpe/Vassoura
@onready var bolsa: Sprite3D = $Bolsa
@onready var sons: Node = $"../Sons"


func _physics_process(delta: float) -> void:
	var no_chao := is_on_floor()
	tempo_borda = TEMPO_APOS_BORDA if no_chao else maxf(tempo_borda - delta, 0.0)
	if Input.is_action_just_pressed("pular"):
		tempo_pulo = TEMPO_PULO_ANTECIPADO
	else:
		tempo_pulo = maxf(tempo_pulo - delta, 0.0)

	if not no_chao:
		var gravidade := GRAVIDADE_QUEDA if velocity.y < 0.0 else GRAVIDADE
		velocity.y = maxf(velocity.y - gravidade * delta, -QUEDA_MAXIMA)

	if tempo_pulo > 0.0 and tempo_borda > 0.0:
		velocity.y = FORCA_PULO_SOLADO if tem_solado else FORCA_PULO
		tempo_pulo = 0.0
		tempo_borda = 0.0
		sons.get_node("Pulo").play()
	if Input.is_action_just_released("pular") and velocity.y > 0.0:
		velocity.y *= CORTE_PULO

	if tempo_empurrao > 0.0:
		tempo_empurrao -= delta
	else:
		var direcao := Input.get_axis("esquerda", "direita")
		if direcao != 0.0:
			olhando = signf(direcao)
		var taxa := ACELERACAO if direcao != 0.0 else FREIO
		if not no_chao:
			taxa *= CONTROLE_NO_AR
		velocity.x = move_toward(velocity.x, direcao * VELOCIDADE, taxa * delta)

	move_and_slide()

	tempo_protecao = maxf(tempo_protecao - delta, 0.0)
	_atualizar_golpe(delta)
	_atualizar_tiro(delta)
	_atualizar_visual(delta)
	if Input.is_action_just_pressed("fabricar"):
		_fazer_bolsa()
	if Input.is_action_just_pressed("montar"):
		_montar_pistola()
	if Input.is_action_just_pressed("solado"):
		_fazer_solado()

	if global_position.y < ALTURA_DE_RETORNO:
		_perder_vida()
		precisa_voltar = true
	if precisa_voltar:
		_voltar()


func _perder_vida() -> void:
	vida -= 1
	sons.get_node("Dano").play()
	if vida <= 0:
		precisa_voltar = true


func _voltar() -> void:
	precisa_voltar = false
	if vida <= 0:
		vida = VIDA_MAXIMA
	global_position = ponto_retorno
	velocity = Vector3.ZERO
	tempo_empurrao = 0.0
	tempo_protecao = DURACAO_PROTECAO
	reset_physics_interpolation()


func marcar_retorno(posicao: Vector3) -> void:
	ponto_retorno = posicao + Vector3(0.0, 0.05, 0.0)
	vida = VIDA_MAXIMA
	sons.get_node("Coleta").play()


func _atualizar_golpe(delta: float) -> void:
	golpe.position.x = olhando * ALCANCE_GOLPE
	tempo_golpe = maxf(tempo_golpe - delta, 0.0)
	if Input.is_action_just_pressed("golpe") and tempo_golpe == 0.0:
		tempo_golpe = RECARGA_GOLPE
		sons.get_node("Golpe").play()
		for inimigo in golpe.get_overlapping_areas():
			inimigo.derrotar()
	vassoura.visible = tempo_golpe > RECARGA_GOLPE - DURACAO_GOLPE


func _atualizar_tiro(delta: float) -> void:
	tempo_tiro = maxf(tempo_tiro - delta, 0.0)
	if not tem_arma:
		return

	if componentes == 0:
		tempo_emergencia -= delta
		if tempo_emergencia <= 0.0:
			componentes = 1
			tempo_emergencia = RECARGA_EMERGENCIA
	else:
		tempo_emergencia = RECARGA_EMERGENCIA

	if tempo_tiro > 0.0 or componentes == 0 or not Input.is_action_just_pressed("atirar"):
		return
	tempo_tiro = RECARGA_TIRO
	componentes -= 1
	sons.get_node("Tiro").play()
	var faisca := FAISCA.instantiate()
	faisca.position = global_position + Vector3(olhando * 0.7, ALTURA_TIRO, 0.0)
	faisca.velocidade = Vector3(olhando * VELOCIDADE_FAISCA, 0.0, 0.0)
	get_parent().add_child(faisca)


func _atualizar_visual(delta: float) -> void:
	var virado := olhando < 0.0
	sprite.flip_h = virado
	vassoura.flip_h = virado
	arma.flip_h = virado
	bolsa.flip_h = virado
	arma.position.x = olhando * 0.45
	bolsa.position.x = -olhando * 0.3
	sprite.visible = tempo_protecao == 0.0 or int(tempo_protecao * 12.0) % 2 == 0

	var quadro := QUADRO_PARADO
	if vassoura.visible:
		quadro = QUADRO_GOLPE
	elif not is_on_floor():
		quadro = QUADRO_SUBINDO if velocity.y > 0.0 else QUADRO_CAINDO
	elif absf(velocity.x) > 0.5:
		tempo_passos += delta
		quadro = QUADRO_ANDANDO + int(tempo_passos * 10.0) % 2
	sprite.frame = quadro + (QUADROS_POR_LINHA if tem_solado else 0)


func _fazer_bolsa() -> void:
	if nivel_bolsa >= NIVEL_MAXIMO_BOLSA or pet < PET_POR_BOLSA:
		return
	pet -= PET_POR_BOLSA
	nivel_bolsa += 1
	capacidade += ESPACOS_POR_BOLSA
	bolsa.visible = true
	bolsa.scale = Vector3.ONE * (1.0 + 0.3 * (nivel_bolsa - 1))
	sons.get_node("Fabricar").play()


func _montar_pistola() -> void:
	if tem_arma or componentes < COMPONENTES_PARA_PISTOLA:
		return
	componentes -= COMPONENTES_PARA_PISTOLA
	tem_arma = true
	arma.visible = true
	sons.get_node("Fabricar").play()


func _fazer_solado() -> void:
	if tem_solado or borracha < BORRACHA_PARA_SOLADO:
		return
	borracha -= BORRACHA_PARA_SOLADO
	tem_solado = true
	sons.get_node("Fabricar").play()


func guardar_borracha() -> void:
	borracha += 1
	sons.get_node("Coleta").play()


func guardar_pet() -> bool:
	pet += 1
	sons.get_node("Coleta").play()
	return true


func guardar_componente() -> bool:
	if componentes >= capacidade:
		return false
	componentes += 1
	sons.get_node("Coleta").play()
	return true


func empurrar(origem_x: float) -> void:
	if tempo_protecao > 0.0:
		return
	tempo_protecao = DURACAO_PROTECAO
	_perder_vida()
	var lado := signf(global_position.x - origem_x)
	if lado == 0.0:
		lado = -olhando
	velocity = Vector3(lado * EMPURRAO.x, EMPURRAO.y, 0.0)
	tempo_empurrao = DURACAO_EMPURRAO
