extends CharacterBody3D

const VELOCIDADE := 7.0
const ACELERACAO := 60.0
const FREIO := 80.0
const CONTROLE_NO_AR := 0.7
const FORCA_PULO := 12.0
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

const MOTORES_PARA_PISTOLA := 3
const CELULAS_POR_POWERBANK := 3
const MAXIMO_POWERBANKS := 2
const ENERGIA_INICIAL := 3
const ENERGIA_POR_POWERBANK := 3
const ENERGIA_MAXIMA_TOTAL := 9
const COBRE_PARA_MALHA := 3
const CHOQUE := Vector2(-9.0, 6.0)
const DURACAO_CHOQUE := 0.3
const DURACAO_CARGA := 4.0

const FAISCA := preload("res://jogo/faisca_gari.tscn")
const VELOCIDADE_FAISCA := 14.0
const RECARGA_TIRO := 0.35
const ALTURA_TIRO := 0.85
const TEMPO_DINAMO := 1.2

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
var tempo_dinamo := TEMPO_DINAMO
var tempo_empurrao := 0.0
var tempo_protecao := 0.0
var tempo_passos := 0.0
var olhando := 1.0

var vida := VIDA_MAXIMA
var precisa_voltar := false

var celulas := 0
var powerbanks := 0
var motores := 0
var tem_arma := false
var energia := 0
var energia_maxima := ENERGIA_INICIAL
var cobre := 0
var tem_malha := false
var tempo_aterrado := 0.0
var carga_eletrica := 0.0

@onready var ponto_retorno := global_position
@onready var sprite: Sprite3D = $Sprite
@onready var arma: Sprite3D = $Faiscador
@onready var golpe: Area3D = $Golpe
@onready var vassoura: Sprite3D = $Golpe/Vassoura
@onready var powerbank: Sprite3D = $Powerbank
@onready var aterramento: GPUParticles3D = $Aterramento
@onready var sons: Node = $"../Sons"
@onready var cutscene: CanvasLayer = $"../Cutscene"


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
		velocity.y = FORCA_PULO
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
	tempo_aterrado = maxf(tempo_aterrado - delta, 0.0)
	carga_eletrica = maxf(carga_eletrica - delta, 0.0)
	aterramento.emitting = tempo_aterrado > 0.0 or carga_eletrica > 0.0
	_atualizar_golpe(delta)
	_atualizar_tiro(delta)
	_atualizar_visual(delta)
	if Input.is_action_just_pressed("montar"):
		_montar_pistola()
	if Input.is_action_just_pressed("powerbank"):
		_montar_powerbank()
	if Input.is_action_just_pressed("aterramento"):
		_fazer_malha()

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

	if energia < energia_maxima:
		tempo_dinamo -= delta
		if tempo_dinamo <= 0.0:
			energia += 1
			tempo_dinamo = TEMPO_DINAMO
	else:
		tempo_dinamo = TEMPO_DINAMO

	if tempo_tiro > 0.0 or energia == 0 or not Input.is_action_just_pressed("atirar"):
		return
	tempo_tiro = RECARGA_TIRO
	energia -= 1
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
	powerbank.flip_h = virado
	arma.position.x = olhando * 0.45
	powerbank.position.x = -olhando * 0.32
	sprite.visible = tempo_protecao == 0.0 or int(tempo_protecao * 12.0) % 2 == 0

	var quadro := QUADRO_PARADO
	if vassoura.visible:
		quadro = QUADRO_GOLPE
	elif not is_on_floor():
		quadro = QUADRO_SUBINDO if velocity.y > 0.0 else QUADRO_CAINDO
	elif absf(velocity.x) > 0.5:
		tempo_passos += delta
		quadro = QUADRO_ANDANDO + int(tempo_passos * 10.0) % 2
	sprite.frame = quadro + (QUADROS_POR_LINHA if tem_malha else 0)


func _montar_pistola() -> void:
	if tem_arma or motores < MOTORES_PARA_PISTOLA:
		return
	motores -= MOTORES_PARA_PISTOLA
	tem_arma = true
	energia = energia_maxima
	arma.visible = true
	sons.get_node("Fabricar").play()
	cutscene.mostrar("pistola")


func _montar_powerbank() -> void:
	if powerbanks >= MAXIMO_POWERBANKS or celulas < CELULAS_POR_POWERBANK:
		return
	celulas -= CELULAS_POR_POWERBANK
	powerbanks += 1
	energia_maxima += ENERGIA_POR_POWERBANK
	if tem_arma:
		energia = energia_maxima
	powerbank.visible = true
	powerbank.scale = Vector3.ONE * (1.0 + 0.3 * (powerbanks - 1))
	sons.get_node("Fabricar").play()
	cutscene.mostrar("powerbank")


func _fazer_malha() -> void:
	if tem_malha or cobre < COBRE_PARA_MALHA:
		return
	cobre -= COBRE_PARA_MALHA
	tem_malha = true
	sons.get_node("Fabricar").play()
	cutscene.mostrar("malha")


func pisar_chao_eletrico(inicio_x: float) -> void:
	if tem_malha:
		if tempo_aterrado == 0.0:
			sons.get_node("Aterrado").play()
		tempo_aterrado = 0.15
		carga_eletrica = DURACAO_CARGA
		return
	if tempo_protecao == 0.0:
		tempo_protecao = DURACAO_PROTECAO
		sons.get_node("Choque").play()
		_perder_vida()
	var lado := signf(inicio_x - global_position.x)
	velocity = Vector3(lado * absf(CHOQUE.x), CHOQUE.y, 0.0)
	tempo_empurrao = DURACAO_CHOQUE


func entregar_carga() -> bool:
	if carga_eletrica == 0.0:
		return false
	carga_eletrica = 0.0
	return true


func guardar_cobre() -> void:
	cobre += 1
	sons.get_node("Coleta").play()


func guardar_celula() -> bool:
	celulas += 1
	sons.get_node("Coleta").play()
	return true


func guardar_motor() -> bool:
	if tem_arma:
		energia = energia_maxima
		sons.get_node("Coleta").play()
		return true
	motores += 1
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
