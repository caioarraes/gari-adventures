extends SceneTree
## Gera a arte e o áudio provisórios da fatia vertical em res://arte e res://som.

const ARTE := "res://arte/"
const SOM := "res://som/"
const TAXA := 22050

var rng := RandomNumberGenerator.new()

func _init() -> void:
	rng.seed = 7
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(ARTE))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(SOM))
	_personagens()
	_itens()
	_cenario()
	_sons()
	_musica()
	print("assets gerados")
	quit()

func _nova(w: int, h: int) -> Image:
	return Image.create_empty(w, h, false, Image.FORMAT_RGBA8)

func _r(i: Image, x: int, y: int, w: int, h: int, cor: String) -> void:
	i.fill_rect(Rect2i(x, y, w, h), Color(cor))

func _salvar(i: Image, nome: String) -> void:
	i.save_png(ProjectSettings.globalize_path(ARTE + nome + ".png"))

func _personagens() -> void:
	var gari := _nova(144, 64)
	for quadro in 6:
		_gari(gari, quadro * 24, quadro)
	gari.blit_rect(gari, Rect2i(0, 0, 144, 32), Vector2i(0, 32))
	_colocar_malha(gari)
	_salvar(gari, "gari")

	var fio := _nova(80, 22)
	for quadro in 2:
		_fio(fio, quadro * 40, quadro)
	_salvar(fio, "fio")

	var notebook := _nova(52, 20)
	for quadro in 2:
		var x := quadro * 26
		var tela := "#5aa0e0" if quadro == 0 else "#e0f4ff"
		_r(notebook, x + 3, 0, 20, 13, "#3a3d45")
		_r(notebook, x + 5, 2, 16, 9, tela)
		_r(notebook, x + 8, 4, 3, 2, "#10202e")
		_r(notebook, x + 15, 4, 3, 2, "#10202e")
		_r(notebook, x + 7, 3, 4, 1, "#10202e")
		_r(notebook, x + 15, 3, 4, 1, "#10202e")
		_r(notebook, x + 10, 8, 6, 1, "#10202e")
		_r(notebook, x + 0, 13, 26, 4, "#8a8e98")
		for k in [3, 7, 11, 15, 19]:
			_r(notebook, x + k, 14, 2, 1, "#5a5d66")
		_r(notebook, x + 1, 17, 24, 2, "#5a5d66")
		_r(notebook, x + 18, 17, 7, 3, "#2a9d6a")
		_r(notebook, x + 18, 17, 1, 3, "#c9ccd2")
	notebook.fill_rect(Rect2i(26, 0, 26, 20), Color(0, 0, 0, 0))
	notebook.blit_rect(notebook, Rect2i(0, 0, 26, 19), Vector2i(26, 1))
	_salvar(notebook, "notebook")

	var microondas := _nova(56, 20)
	for quadro in 2:
		var x := quadro * 28
		var vidro := "#3a4a3a" if quadro == 0 else "#fff3b0"
		_r(microondas, x + 0, 0, 28, 18, "#d8d8d0")
		_r(microondas, x + 0, 0, 28, 1, "#f0f0ea")
		_r(microondas, x + 2, 2, 17, 13, "#30343c")
		_r(microondas, x + 3, 3, 15, 11, vidro)
		_r(microondas, x + 5, 5, 3, 2, "#e04030")
		_r(microondas, x + 12, 5, 3, 2, "#e04030")
		_r(microondas, x + 4, 4, 4, 1, "#17202b")
		_r(microondas, x + 12, 4, 4, 1, "#17202b")
		_r(microondas, x + 7, 10, 7, 1, "#17202b")
		_r(microondas, x + 21, 3, 5, 3, "#2fd070")
		for y in [8, 11, 14]:
			_r(microondas, x + 22, y, 3, 2, "#8a8e98")
		_r(microondas, x + 2, 18, 4, 2, "#5a5d66")
		_r(microondas, x + 22, 18, 4, 2, "#5a5d66")
	_salvar(microondas, "microondas")

func _colocar_malha(i: Image) -> void:
	var bota := Color("#20242c")
	for y in range(62, 32, -1):
		for x in 144:
			if i.get_pixel(x, y).is_equal_approx(bota) and i.get_pixel(x, y + 1).a == 0.0:
				i.set_pixel(x, y + 1, Color("#f2b066") if x % 2 == 0 else Color("#b8651f"))

func _fio(i: Image, x: int, quadro: int) -> void:
	var capas := ["#c0392b", "#2b6cc0", "#2a2d35"]
	for py in 22:
		for px in 40:
			var e := sqrt(pow((px - 20.0) / 9.5, 2.0) + pow((py - 13.0) / 8.5, 2.0))
			if e > 1.0:
				continue
			var cor: String = capas[int(e * 6.0) % 3]
			if e < 0.3:
				cor = "#d9822b"
			i.set_pixel(x + px, py, Color(cor))
	_r(i, x + 15, 8, 3, 3, "#f4f4ee")
	_r(i, x + 23, 8, 3, 3, "#f4f4ee")
	_r(i, x + 16, 9, 2, 2, "#17202b")
	_r(i, x + 24, 9, 2, 2, "#17202b")
	_r(i, x + 14, 7, 4, 1, "#17202b")
	_r(i, x + 23, 7, 4, 1, "#17202b")
	if quadro == 0:
		_r(i, x + 29, 15, 4, 2, "#2a2d35")
		_r(i, x + 32, 13, 2, 3, "#2a2d35")
		_r(i, x + 32, 12, 2, 1, "#d9822b")
	else:
		_r(i, x + 28, 12, 9, 2, "#c0392b")
		_r(i, x + 36, 11, 2, 4, "#f2b066")
		_r(i, x + 38, 9, 2, 2, "#fff0a0")
		_r(i, x + 38, 14, 2, 2, "#fff0a0")
		_r(i, x + 39, 11, 1, 3, "#ffffff")

func _gari(i: Image, x: int, quadro: int) -> void:
	var y := 1 if quadro == 2 else 0
	_r(i, x + 8, y + 1, 8, 3, "#f26a12")
	_r(i, x + 8, y + 3, 11, 1, "#c94f08")
	_r(i, x + 9, y + 4, 7, 6, "#d9a07a")
	_r(i, x + 14, y + 6, 1, 1, "#17202b")
	_r(i, x + 8, y + 10, 9, 10, "#f26a12")
	_r(i, x + 8, y + 14, 9, 2, "#f6e96a")
	_r(i, x + 8, y + 17, 9, 1, "#f6e96a")

	match quadro:
		0:
			_perna(i, x + 9, 20, 8)
			_perna(i, x + 13, 20, 8)
		1:
			_perna(i, x + 6, 20, 8)
			_perna(i, x + 15, 20, 8)
		2:
			_perna(i, x + 10, 21, 7)
			_perna(i, x + 12, 21, 7)
		3:
			_perna(i, x + 8, 20, 5)
			_perna(i, x + 14, 20, 6)
		4:
			_perna(i, x + 6, 20, 7)
			_perna(i, x + 15, 20, 7)
		5:
			_perna(i, x + 7, 20, 8)
			_perna(i, x + 14, 20, 8)

	if quadro == 5:
		_r(i, x + 14, y + 11, 9, 3, "#c94f08")
		_r(i, x + 21, y + 11, 3, 3, "#d9a07a")
	elif quadro == 3:
		_r(i, x + 12, y + 8, 3, 6, "#c94f08")
	else:
		_r(i, x + 11, y + 11, 3, 7, "#c94f08")
		_r(i, x + 11, y + 18, 3, 2, "#d9a07a")

func _perna(i: Image, x: int, y: int, altura: int) -> void:
	_r(i, x, y, 3, altura - 2, "#d65a0c")
	_r(i, x, y + altura - 2, 4, 2, "#20242c")
	_r(i, x, y + altura - 4, 3, 1, "#f6e96a")

func _itens() -> void:
	var vassoura := _nova(30, 9)
	_r(vassoura, 0, 3, 20, 2, "#b9894f")
	_r(vassoura, 18, 1, 3, 6, "#7a4e22")
	_r(vassoura, 21, 0, 8, 9, "#e8c75a")
	for y in [1, 3, 5, 7]:
		_r(vassoura, 24, y, 6, 1, "#b8952f")
	_salvar(vassoura, "vassoura")

	var pistola := _nova(16, 10)
	_r(pistola, 1, 1, 12, 4, "#5a5d66")
	_r(pistola, 13, 2, 3, 2, "#3fe07f")
	_r(pistola, 3, 2, 5, 2, "#2fd070")
	_r(pistola, 2, 5, 4, 5, "#3a3d45")
	_r(pistola, 9, 0, 1, 1, "#ffd84a")
	_salvar(pistola, "pistola")

	var celula := _nova(14, 8)
	_r(celula, 1, 1, 12, 6, "#2a9d6a")
	_r(celula, 1, 1, 12, 1, "#5fd49a")
	_r(celula, 1, 5, 12, 1, "#1d7a48")
	_r(celula, 0, 2, 1, 4, "#c9ccd2")
	_r(celula, 13, 3, 1, 2, "#e8eaee")
	_salvar(celula, "celula")

	var powerbank := _nova(10, 14)
	_r(powerbank, 0, 0, 10, 14, "#30343c")
	_r(powerbank, 1, 1, 8, 12, "#3a3d45")
	for y in [2, 6, 10]:
		_r(powerbank, 2, y, 6, 2, "#2a9d6a")
	_r(powerbank, 7, 1, 1, 1, "#ffd84a")
	_salvar(powerbank, "powerbank")

	var cobre := _nova(14, 10)
	for n in 4:
		_r(cobre, 1 + n * 3, 1, 2, 8, "#d9822b")
		_r(cobre, 1 + n * 3, 1, 1, 8, "#f2b066")
	_r(cobre, 0, 4, 14, 2, "#b8651f")
	_salvar(cobre, "cobre")

	var malha := _nova(16, 14)
	for k in range(0, 16, 3):
		_r(malha, k, 0, 1, 10, "#d9822b")
	for k in range(0, 10, 3):
		_r(malha, 0, k, 16, 1, "#f2b066")
	_r(malha, 6, 10, 2, 4, "#2fd070")
	_r(malha, 6, 12, 2, 1, "#f2e230")
	_r(malha, 4, 13, 6, 1, "#5a5d66")
	_salvar(malha, "malha")

	var particula := _nova(4, 4)
	_r(particula, 1, 0, 2, 4, "#ffffff")
	_r(particula, 0, 1, 4, 2, "#ffffff")
	_salvar(particula, "particula")

	var motor := _nova(14, 10)
	_r(motor, 2, 1, 9, 8, "#b86a2c")
	for y in [2, 4, 6]:
		_r(motor, 2, y, 9, 1, "#e08a40")
	_r(motor, 0, 3, 2, 4, "#5a5d66")
	_r(motor, 11, 4, 3, 2, "#c9ccd2")
	_salvar(motor, "motor")

	_salvar(_faisca("#ffffff", "#3fe07f"), "faisca_gari")

	var onda := _nova(10, 12)
	for n in 3:
		var x := n * 3
		_r(onda, x + 1, 1, 1, 2, "#ffd84a")
		_r(onda, x + 2, 3, 1, 6, "#f0442c")
		_r(onda, x + 1, 9, 1, 2, "#ffd84a")
	_salvar(onda, "faisca_inimiga")

func _faisca(centro: String, borda: String) -> Image:
	var i := _nova(9, 9)
	_r(i, 3, 0, 3, 9, borda)
	_r(i, 0, 3, 9, 3, borda)
	_r(i, 1, 1, 7, 7, borda)
	_r(i, 3, 3, 3, 3, centro)
	return i

func _ruido(i: Image, cores: Array, quantidade: int) -> void:
	for n in quantidade:
		_r(i, rng.randi_range(0, i.get_width() - 1), rng.randi_range(0, i.get_height() - 1), 1, 1, cores[rng.randi_range(0, cores.size() - 1)])

func _cenario() -> void:
	var asfalto := _nova(32, 32)
	_r(asfalto, 0, 0, 32, 32, "#555a62")
	_ruido(asfalto, ["#4b5058", "#60656e", "#444951"], 150)
	_salvar(asfalto, "asfalto")

	var papelao := _nova(32, 32)
	_r(papelao, 0, 0, 32, 32, "#b88d58")
	_r(papelao, 0, 14, 32, 4, "#d8bd8c")
	_r(papelao, 0, 0, 32, 1, "#8f6a3e")
	_r(papelao, 0, 0, 1, 32, "#8f6a3e")
	_ruido(papelao, ["#a97f4d", "#c29a66"], 60)
	_salvar(papelao, "papelao")

	var tijolo := _nova(32, 32)
	_r(tijolo, 0, 0, 32, 32, "#8d8378")
	for linha in 4:
		var y := linha * 8
		var desvio := 0 if linha % 2 == 0 else 8
		for coluna in 3:
			_r(tijolo, (coluna * 16 + desvio) % 32, y + 1, 15, 6, "#a4563f")
	_salvar(tijolo, "tijolo")

	_salvar(_predio("#7f93a3", "#5f7384"), "predio_a")
	_salvar(_predio("#a39383", "#837363"), "predio_b")

	var cerca := _nova(24, 151)
	for y in range(-24, 151, 12):
		for n in 20:
			_r(cerca, 2 + n, y + n, 1, 1, "#e6e04a")
			_r(cerca, 21 - n, y + n, 1, 1, "#e6e04a")
	_r(cerca, 0, 0, 3, 151, "#5a5d66")
	_r(cerca, 21, 0, 3, 151, "#5a5d66")
	for y in range(6, 151, 24):
		_r(cerca, 0, y, 3, 3, "#fff58a")
		_r(cerca, 21, y, 3, 3, "#fff58a")
	_salvar(cerca, "cerca")

	var caminhao := _nova(64, 36)
	_r(caminhao, 2, 6, 42, 22, "#f26a12")
	_r(caminhao, 2, 6, 42, 3, "#c94f08")
	_r(caminhao, 2, 16, 42, 3, "#f6e96a")
	for x in [8, 18, 28, 38]:
		_r(caminhao, x, 9, 2, 7, "#c94f08")
	_r(caminhao, 45, 12, 16, 16, "#f4f4ee")
	_r(caminhao, 50, 14, 10, 7, "#86c9e0")
	_r(caminhao, 0, 26, 64, 3, "#30343c")
	for x in [8, 34, 50]:
		_r(caminhao, x, 27, 9, 9, "#17191f")
		_r(caminhao, x + 3, 30, 3, 3, "#a9adb5")
	_salvar(caminhao, "caminhao")

	var lixeira := _nova(14, 20)
	_r(lixeira, 1, 0, 12, 3, "#1c7a45")
	_r(lixeira, 2, 3, 10, 17, "#27a35d")
	for x in [4, 7, 10]:
		_r(lixeira, x, 5, 1, 13, "#1c7a45")
	_salvar(lixeira, "lixeira")

	var saco := _nova(16, 12)
	_r(saco, 2, 3, 12, 9, "#2a2d35")
	_r(saco, 5, 1, 6, 3, "#2a2d35")
	_r(saco, 7, 0, 2, 2, "#d8b84a")
	_r(saco, 4, 5, 2, 3, "#454955")
	_salvar(saco, "saco")

	var ecoponto := _nova(36, 30)
	for quadro in 2:
		var x := quadro * 18
		var cor := "#6b6e78" if quadro == 0 else "#27a35d"
		var escura := "#4a4d56" if quadro == 0 else "#1c7a45"
		_r(ecoponto, x + 2, 10, 14, 20, cor)
		_r(ecoponto, x + 1, 8, 16, 3, escura)
		_r(ecoponto, x + 6, 15, 6, 2, "#f4f4ee")
		_r(ecoponto, x + 6, 19, 6, 2, "#f4f4ee")
		_r(ecoponto, x + 6, 23, 6, 2, "#f4f4ee")
		_r(ecoponto, x + 8, 0, 1, 8, "#30343c")
		if quadro == 1:
			_r(ecoponto, x + 9, 0, 7, 4, "#f6e96a")
	_salvar(ecoponto, "ecoponto")

	var chao_eletrico := _nova(32, 32)
	_r(chao_eletrico, 0, 0, 32, 32, "#3a3f48")
	for k in [0, 16]:
		_r(chao_eletrico, 0, k, 32, 1, "#5a606b")
		_r(chao_eletrico, k, 0, 1, 32, "#5a606b")
	for k in [7, 23]:
		_r(chao_eletrico, 0, k, 32, 2, "#3fa9ff")
		_r(chao_eletrico, k, 0, 2, 32, "#3fa9ff")
	for k in [3, 12, 19, 28]:
		_r(chao_eletrico, k, k, 1, 1, "#8a909b")
	_salvar(chao_eletrico, "chao_eletrico")

	var gerador := _nova(40, 25)
	for quadro in 2:
		var x := quadro * 20
		var raio := "#5a5d66" if quadro == 0 else "#ffd84a"
		var lampada := "#3a3d45" if quadro == 0 else "#5fff8a"
		_r(gerador, x + 1, 4, 18, 21, "#4a5058")
		_r(gerador, x + 2, 5, 16, 1, "#6a707a")
		_r(gerador, x + 4, 0, 3, 4, "#30343c")
		_r(gerador, x + 13, 0, 3, 4, "#30343c")
		_r(gerador, x + 13, 0, 3, 1, lampada)
		_r(gerador, x + 6, 8, 8, 12, "#30343c")
		_r(gerador, x + 10, 9, 3, 5, raio)
		_r(gerador, x + 8, 13, 4, 2, raio)
		_r(gerador, x + 7, 15, 3, 4, raio)
		for y in [21, 23]:
			_r(gerador, x + 3, y, 14, 1, "#30343c")
	_salvar(gerador, "gerador")

	var portao := _nova(32, 32)
	_r(portao, 0, 0, 32, 32, "#6a707a")
	for y in range(0, 32, 4):
		_r(portao, 0, y, 32, 1, "#4a5058")
		_r(portao, 0, y + 1, 32, 1, "#8a909b")
	for x in range(0, 32, 8):
		_r(portao, x, 28, 4, 4, "#f2c230")
		_r(portao, x + 4, 28, 4, 4, "#2a2d35")
	_salvar(portao, "portao")

	var poste := _nova(14, 70)
	_r(poste, 5, 4, 3, 66, "#4a4e58")
	_r(poste, 5, 3, 9, 2, "#4a4e58")
	_r(poste, 10, 5, 4, 2, "#ffe9a0")
	_salvar(poste, "poste")

func _predio(parede: String, sombra: String) -> Image:
	var i := _nova(32, 32)
	_r(i, 0, 0, 32, 32, parede)
	_r(i, 0, 30, 32, 2, sombra)
	for x in [4, 19]:
		var acesa := rng.randf() < 0.4
		_r(i, x - 1, 6, 11, 16, sombra)
		_r(i, x, 7, 9, 14, "#f3d98a" if acesa else "#3a4a5a")
		_r(i, x + 4, 7, 1, 14, sombra)
	return i

func _vazio(segundos: float) -> PackedFloat32Array:
	var buffer := PackedFloat32Array()
	buffer.resize(int(segundos * TAXA))
	return buffer

func _nota(b: PackedFloat32Array, inicio: float, duracao: float, f0: float, f1: float, tipo: String, volume: float) -> void:
	var primeira := int(inicio * TAXA)
	var total := int(duracao * TAXA)
	var fase := 0.0
	for n in total:
		var i := primeira + n
		if i >= b.size():
			break
		var t := float(n) / total
		fase += lerpf(f0, f1, t) / TAXA
		var valor := 0.0
		match tipo:
			"quadrada":
				valor = 1.0 if fmod(fase, 1.0) < 0.5 else -1.0
			"seno":
				valor = sin(fase * TAU)
			"triangulo":
				valor = absf(fmod(fase, 1.0) * 4.0 - 2.0) - 1.0
			"ruido":
				valor = rng.randf_range(-1.0, 1.0)
		b[i] += valor * volume * pow(1.0 - t, 1.5)

func _gravar(b: PackedFloat32Array, nome: String) -> void:
	var dados := PackedByteArray()
	dados.resize(b.size() * 2)
	for i in b.size():
		dados.encode_s16(i * 2, int(clampf(b[i], -1.0, 1.0) * 32000.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = TAXA
	wav.data = dados
	wav.save_to_wav(ProjectSettings.globalize_path(SOM + nome + ".wav"))

func _som(nome: String, segundos: float, notas: Array) -> void:
	var b := _vazio(segundos)
	for n in notas:
		_nota(b, n[0], n[1], n[2], n[3], n[4], n[5])
	_gravar(b, nome)

func _sons() -> void:
	_som("pulo", 0.2, [[0.0, 0.18, 240.0, 560.0, "quadrada", 0.22]])
	_som("golpe", 0.16, [[0.0, 0.15, 900.0, 300.0, "ruido", 0.35]])
	_som("acerto", 0.2, [[0.0, 0.18, 220.0, 70.0, "quadrada", 0.3], [0.0, 0.1, 0.0, 0.0, "ruido", 0.3]])
	_som("coleta", 0.2, [[0.0, 0.08, 880.0, 880.0, "quadrada", 0.18], [0.07, 0.12, 1320.0, 1320.0, "quadrada", 0.18]])
	_som("fabricar", 0.5, [[0.0, 0.14, 523.0, 523.0, "quadrada", 0.2], [0.11, 0.14, 659.0, 659.0, "quadrada", 0.2], [0.22, 0.14, 784.0, 784.0, "quadrada", 0.2], [0.33, 0.17, 1047.0, 1047.0, "quadrada", 0.2]])
	_som("tiro", 0.2, [[0.0, 0.18, 1500.0, 260.0, "quadrada", 0.2]])
	_som("faisca_inimiga", 0.2, [[0.0, 0.18, 500.0, 180.0, "triangulo", 0.3]])
	_som("dano", 0.3, [[0.0, 0.28, 400.0, 90.0, "quadrada", 0.25]])
	_som("cerca", 0.7, [[0.0, 0.65, 180.0, 40.0, "quadrada", 0.25], [0.0, 0.4, 0.0, 0.0, "ruido", 0.2]])
	_som("vitoria", 1.1, [[0.0, 0.18, 523.0, 523.0, "quadrada", 0.22], [0.16, 0.18, 659.0, 659.0, "quadrada", 0.22], [0.32, 0.18, 784.0, 784.0, "quadrada", 0.22], [0.48, 0.6, 1047.0, 1047.0, "quadrada", 0.22]])
	_som("choque", 0.45, [[0.0, 0.4, 0.0, 0.0, "ruido", 0.4], [0.0, 0.35, 1200.0, 90.0, "quadrada", 0.25]])
	_som("chicote", 0.25, [[0.0, 0.08, 0.0, 0.0, "ruido", 0.45], [0.02, 0.2, 1800.0, 600.0, "quadrada", 0.15]])
	_som("aterrado", 0.35, [[0.0, 0.3, 300.0, 900.0, "seno", 0.25], [0.1, 0.2, 900.0, 1400.0, "seno", 0.15]])
	_som("raio", 0.5, [[0.0, 0.05, 0.0, 0.0, "ruido", 0.7], [0.0, 0.45, 0.0, 0.0, "ruido", 0.28], [0.0, 0.3, 2600.0, 140.0, "quadrada", 0.16], [0.0, 0.35, 95.0, 40.0, "seno", 0.45]])
	_som("gerador", 0.9, [[0.0, 0.85, 60.0, 220.0, "quadrada", 0.18], [0.0, 0.85, 120.0, 440.0, "seno", 0.2], [0.55, 0.3, 880.0, 1320.0, "quadrada", 0.12]])
	_som("portao", 0.9, [[0.0, 0.85, 0.0, 0.0, "ruido", 0.18], [0.0, 0.85, 90.0, 140.0, "triangulo", 0.25]])
	_zumbido()


func _zumbido() -> void:
	var b := _vazio(1.0)
	for i in b.size():
		var t := float(i) / TAXA
		var base := (1.0 if fmod(t * 100.0, 1.0) < 0.5 else -1.0) * 0.07
		base += sin(t * TAU * 50.0) * 0.08
		b[i] = base * (0.75 + 0.25 * sin(t * TAU * 3.0))
	for estalo in 9:
		var inicio := rng.randi_range(0, b.size() - 900)
		for n in rng.randi_range(200, 800):
			b[inicio + n] += rng.randf_range(-0.35, 0.35) * (1.0 - n / 800.0)
	_gravar(b, "zumbido")

func _hz(midi: int) -> float:
	return 440.0 * pow(2.0, (midi - 69) / 12.0)

func _musica() -> void:
	var a := [72,0,76,0,79,0,76,74, 72,0,0,69,72,0,74,0, 69,0,72,0,76,0,74,72, 69,0,0,67,69,0,72,0]
	var c := [65,0,69,0,72,0,74,72, 69,0,0,65,69,0,72,0, 67,0,71,0,74,0,76,74, 71,0,67,0,74,0,0,0]
	var melodia: Array = a + c + a + c
	var baixos := [48, 48, 45, 45, 41, 41, 43, 43]
	var passo := 0.125
	var b := _vazio(melodia.size() * passo)
	for i in melodia.size():
		var t := i * passo
		if melodia[i] > 0:
			_nota(b, t, passo * 1.8, _hz(melodia[i]), _hz(melodia[i]), "quadrada", 0.1)
		var baixo: int = baixos[int(i / 8.0) % baixos.size()]
		if i % 8 in [0, 3, 6]:
			_nota(b, t, passo * 1.6, _hz(baixo), _hz(baixo), "triangulo", 0.3)
		if i % 2 == 0:
			_nota(b, t, 0.04, 0.0, 0.0, "ruido", 0.05)
		if i % 8 == 4:
			_nota(b, t, 0.1, 0.0, 0.0, "ruido", 0.16)
	_gravar(b, "musica")
