extends Node3D

const INTERVALO_MINIMO := 0.12
const INTERVALO_MAXIMO := 0.45
const RECUO_DA_BORDA := 0.2
const PONTOS_POR_RAIO := 14
const COR_NUCLEO := Color(0.94, 0.98, 1.0, 1.0)
const COR_BRILHO := Color(0.3, 0.6, 1.0, 0.6)

var tempo := 0.0
var proximo_raio := 0.0
var clarao := 0.0
var raios: Array[Dictionary] = []
var meia_largura := 3.8
var inicio_x := 0.0
var malha: ImmediateMesh

@export var largura := 8.0

@onready var zona: Area3D = $Zona
@onready var luz: OmniLight3D = $Brilho
@onready var zumbido: AudioStreamPlayer3D = $Zumbido
@onready var som_raio: AudioStreamPlayer3D = $Raio


func _ready() -> void:
	zumbido.finished.connect(zumbido.play)
	$Placa.size.x = largura
	var forma: BoxShape3D = $Zona/Colisao.shape.duplicate()
	forma.size.x = largura
	$Zona/Colisao.shape = forma
	for particulas: GPUParticles3D in [$Faiscas, $Brilhos]:
		var processo: ParticleProcessMaterial = particulas.process_material.duplicate()
		processo.emission_box_extents.x = largura / 2.0 - 0.1
		particulas.process_material = processo
		particulas.amount = maxi(10, int(particulas.amount * largura / 8.0))
	malha = ImmediateMesh.new()
	$Raios.mesh = malha
	meia_largura = largura / 2.0 - RECUO_DA_BORDA
	inicio_x = global_position.x - largura / 2.0


func _physics_process(delta: float) -> void:
	tempo += delta
	for corpo in _pisando():
		corpo.pisar_chao_eletrico(inicio_x)

	proximo_raio -= delta
	if proximo_raio <= 0.0:
		proximo_raio = randf_range(INTERVALO_MINIMO, INTERVALO_MAXIMO)
		_criar_raio()
		if randf() < 0.35:
			_criar_raio()

	clarao = maxf(clarao - delta * 6.0, 0.0)
	luz.light_energy = 0.45 + randf() * 0.3 + clarao * 2.5


func _process(delta: float) -> void:
	for raio in raios:
		raio.vida -= delta
	raios = raios.filter(func(raio): return raio.vida > 0.0)
	_desenhar()


func _criar_raio() -> void:
	var de_x := randf_range(-meia_largura, meia_largura)
	var ate_x := clampf(de_x + randf_range(-2.5, 2.5), -meia_largura, meia_largura)
	var ate_y := 0.02
	var corpos := _pisando()
	if not corpos.is_empty() and randf() < 0.5:
		ate_x = clampf(corpos[0].global_position.x - global_position.x, -meia_largura - 0.4, meia_largura + 0.4)
		ate_y = 0.35
	var z := randf_range(-1.6, 1.6)
	raios.append({
		"de": Vector3(de_x, 0.02, z),
		"ate": Vector3(ate_x, ate_y, z),
		"altura": randf_range(0.7, 2.0),
		"vida": randf_range(0.1, 0.22),
	})
	clarao = 1.0
	som_raio.position = Vector3(de_x, 0.5, 0.0)
	som_raio.pitch_scale = randf_range(0.75, 1.35)
	som_raio.play()


func _pisando() -> Array:
	return zona.get_overlapping_bodies().filter(func(corpo): return corpo.is_on_floor())


func _desenhar() -> void:
	malha.clear_surfaces()
	if raios.is_empty():
		return
	malha.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	for raio in raios:
		var pontos := _pontos(raio.de, raio.ate, raio.altura, PONTOS_POR_RAIO, 0.26)
		_faixa(pontos, 0.3, COR_BRILHO)
		_faixa(pontos, 0.08, COR_NUCLEO)
		var meio: Vector3 = pontos[PONTOS_POR_RAIO / 2]
		var ponta := meio + Vector3(randf_range(-0.8, 0.8), randf_range(-0.6, 0.2), 0.0)
		var galho := _pontos(meio, ponta, 0.0, 5, 0.15)
		_faixa(galho, 0.18, COR_BRILHO)
		_faixa(galho, 0.05, COR_NUCLEO)
	malha.surface_end()


func _pontos(de: Vector3, ate: Vector3, altura: float, quantidade: int, tremor: float) -> Array[Vector3]:
	var pontos: Array[Vector3] = []
	for i in quantidade + 1:
		var t := float(i) / quantidade
		var ponto := de.lerp(ate, t)
		ponto.y += sin(t * PI) * altura
		if i > 0 and i < quantidade:
			ponto.x += randf_range(-tremor, tremor)
			ponto.y += randf_range(-tremor, tremor)
		pontos.append(ponto)
	return pontos


func _faixa(pontos: Array[Vector3], largura: float, cor: Color) -> void:
	for i in pontos.size() - 1:
		var a := pontos[i]
		var b := pontos[i + 1]
		var direcao := b - a
		var lado := Vector3(-direcao.y, direcao.x, 0.0).normalized() * largura * 0.5
		for vertice in [a - lado, a + lado, b + lado, a - lado, b + lado, b - lado]:
			malha.surface_set_color(cor)
			malha.surface_add_vertex(vertice)
