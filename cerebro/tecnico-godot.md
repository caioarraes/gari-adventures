# Técnico: Godot

## Instalação

- **Versão:** Godot 4.7.2 stable, padrão, sem .NET.
- **Abrir:** atalho "Godot Engine" no Menu Iniciar.
- **Pasta:** `%LOCALAPPDATA%\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe`
- **Linha de comando:** use `Godot_v4.7.2-stable_win64_console.exe` dessa pasta. O comando `godot` não ficou disponível.

Execução sem janela:

```powershell
& "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_win64_console.exe" --headless --script caminho\script.gd
```

## Fatos testados nesta instalação

- `CharacterBody3D` aceita `axis_lock_linear_z`, herdado de `PhysicsBody3D`.
- Com a trava e velocidade `(1, 0, 5)` por 60 quadros de física em `move_and_slide()`, o corpo terminou com `z = 0`. Sem a trava, terminou com `z ≈ 4,92`.
- `Sprite3D` e `AnimatedSprite3D` existem nesta versão.

Uma fonte externa dizia que `CharacterBody3D` não tem trava de eixo. O teste acima mostra o contrário.

## Estrutura do protótipo

- **Cena principal:** `jogo/main.tscn`. Pista e fundo usam `CSGBox3D`, editáveis no editor.
- **Gari:** `jogo/gari.gd`, com movimento, golpe, tiro, bolsa e inventário.
- **Inimigos:** `jogo/pet.*` e `jogo/monitor.*`.
- **Materiais:** `jogo/material_pet.*` e `jogo/componente.*`.
- **Faíscas:** `jogo/faisca.gd`, `jogo/faisca_inimiga.tscn` e `jogo/faisca_gari.tscn`.
- **Tela:** `jogo/hud.gd`.
- **Câmera:** `jogo/camera.gd`.
- **Camadas de colisão:** 1 cenário, 2 gari, 3 (valor 4) inimigos.
- A interpolação de física está ligada para suavizar o movimento em monitores acima de 60 Hz.
- `derrotar()` é adiada quando chamada por sinal de colisão, porque criar áreas durante esse sinal não é permitido.
- A cerca é removida pelo sinal `tree_exiting` de `MonitorFinal`, ligado em `main.tscn`.

- **Telas:** `jogo/tela.gd` controla início, vitória e reinício. O jogo fica pausado nessas telas.
- **Sons:** nó `Sons` em `main.tscn`, com um `AudioStreamPlayer` por efeito. Ele continua ativo durante a pausa.
- **Arte e áudio:** `arte/` e `som/`, gerados por `ferramentas/gerar_assets.gd`. Depois de gerar, rode a importação com `--headless --import`.
- **Sprites:** usam `pixel_size = 0.053`. Com isso, 32 pixels equivalem à altura do gari.

## Controles

A/D ou setas: andar. Espaço, W ou seta para cima: pular. J ou X: vassourada. E: bolsa. R: pistola. K ou C: atirar.

## Último teste automático (2026-11-19)

- Antes da bolsa cabem 3 componentes. O quarto é recusado.
- As duas bolsas consumiram 6 PET e levaram a capacidade a 6 e depois a 9.
- O gari chegou à cerca com 4 componentes. A pistola consumiu 3 e sobrou 1 bala.
- A vassourada não alcançou o monitor atrás da cerca. O tiro o derrotou, a cerca sumiu e o gari chegou ao fim.
- Sem balas, atirar não cria faísca. Uma bala voltou após a espera.
- Sem proteção após o empurrão, faíscas de vários monitores prendiam o gari no lugar. A proteção de 1 segundo resolveu.

## Teste da fatia vertical (2026-11-19)

Um jogador automático foi do título à vitória e reiniciou a fase, que voltou ao estado inicial. A imagem foi conferida em capturas de tela. O áudio foi gerado e a música iniciou, mas ninguém o ouviu ainda.

A sensação de jogo só pode ser avaliada jogando.
