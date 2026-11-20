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
- **Inimigos:** `jogo/notebook.*`, `jogo/microondas.*` e `jogo/fio.*`.
- **Materiais:** `jogo/celula.*`, `jogo/motor.*` e `jogo/cobre.*`. Chão eletrificado em `jogo/chao_eletrico.*`, gerador em `jogo/gerador.*` e portão em `jogo/portao.gd`. Apresentações dos itens em `jogo/cutscene.*`, que pausa o jogo e roda com `process_mode` sempre ativo.
- **Faíscas:** `jogo/faisca.gd`, `jogo/faisca_inimiga.tscn` e `jogo/faisca_gari.tscn`.
- **Tela:** `jogo/hud.gd`.
- **Câmera:** `jogo/camera.gd`.
- **Camadas de colisão:** 1 cenário, 2 gari, 3 (valor 4) inimigos.
- A interpolação de física está ligada para suavizar o movimento em monitores acima de 60 Hz.
- `derrotar()` é adiada quando chamada por sinal de colisão, porque criar áreas durante esse sinal não é permitido.
- A cerca é removida pelo sinal `derrotado` de `MicroondasFinal`, ligado em `main.tscn`.

- **Telas:** `jogo/tela.gd` controla início, vitória e reinício. O jogo fica pausado nessas telas.
- **Sons:** nó `Sons` em `main.tscn`, com um `AudioStreamPlayer` por efeito. Ele continua ativo durante a pausa.
- **Arte e áudio:** `arte/` e `som/`, gerados por `ferramentas/gerar_assets.gd`. Depois de gerar, rode a importação com `--headless --import`.
- **Sprites:** usam `pixel_size = 0.053`. Com isso, 32 pixels equivalem à altura do gari.

## Controles

A/D ou setas: andar. Espaço, W ou seta para cima: pular. J ou X: vassourada. R: pistola-dínamo. F: malha de aterramento. K ou C: atirar. Q: powerbank.

## Último teste automático (2026-11-19)

- Antes da bolsa cabem 3 componentes. O quarto é recusado.
- As duas bolsas consumiram 6 PET e levaram a capacidade a 6 e depois a 9.
- O gari chegou à cerca com 4 componentes. A pistola consumiu 3 e sobrou 1 bala.
- A vassourada não alcançou o monitor atrás da cerca. O tiro o derrotou, a cerca sumiu e o gari chegou ao fim.
- Sem balas, atirar não cria faísca. Uma bala voltou após a espera.
- Sem proteção após o empurrão, faíscas de vários monitores prendiam o gari no lugar. A proteção de 1 segundo resolveu.

## Teste da fatia vertical (2026-11-19)

Um jogador automático foi do título à vitória e reiniciou a fase, que voltou ao estado inicial. A imagem foi conferida em capturas de tela. O áudio foi gerado e a música iniciou, mas ninguém o ouviu ainda.

## Teste do solado (2026-11-19)

Sem solado, o pulo chegou a 2,35 e não passou do muro. Com solado, chegou a 3,64, passou do muro e alcançou o caminhão. O sprite do gari tem uma segunda linha com o solado.

## Teste de vida (2026-11-19)

O ecoponto marcou o retorno e recuperou a vida. O dano tirou 1 ponto e foi ignorado durante a proteção. Na terceira perda, o gari voltou ao ecoponto com vida cheia e manteve o PET. A queda no vão tirou 1 ponto e o levou ao ecoponto. A fase completa continuou vencível.

A sensação de jogo só pode ser avaliada jogando.

## Teste do notebook (2026-11-20)

O powerbank foi recusado antes da pistola. A pistola consumiu 3 células e começou com 3 de energia. O powerbank consumiu outras 3 e levou a energia a 6 de 6. O tiro na cerca gastou 1 de energia e abriu o caminho. Com a energia em zero, uma célula recarregou a pistola por completo. Sem células, 1 tiro voltou após a espera. A fase completa continuou vencível. No teste, o jogador automático chegou à cerca com 1 de vida, porque seis notebooks atiram faíscas em sequência.

## Teste do micro-ondas (2026-11-20)

Os 6 notebooks deram 6 células, e os 2 powerbanks levaram a carga máxima a 9 antes da pistola. Os 3 micro-ondas deram 3 motores, e a pistola-dínamo começou com 9 de 9. Com a carga zerada, o dínamo gerou 1 em cerca de 1,3 segundo. O tiro atravessou a cerca e abriu o caminho, e a fase completa continuou vencível. Parado em frente à cerca, o jogador automático perdeu toda a vida para o micro-ondas do outro lado e voltou ao ecoponto.

## Teste dos fios e do chão eletrificado (2026-11-20)

Os 3 fios deram 3 cobres. Sem a malha, o chão eletrificado empurrou o gari de volta a cada contato e tirou a vida até devolvê-lo ao ecoponto, sem que ele atravessasse. Com a malha, ele atravessou com as faíscas de aterramento ativas e chegou ao caminhão. A textura de brilho do chão com mapeamento `triplanar` deixava a placa toda branca, e o brilho foi trocado pela grade azul da própria textura, partículas e luz piscando.

Com a malha, o gari ficou carregado ao sair do chão, ligou o gerador e o portão subiu antes de ele chegar ao caminhão. Sem carga, o gerador não liga.

Os raios do chão são desenhados a cada quadro com `ImmediateMesh` em `jogo/chao_eletrico.gd`. A mistura aditiva sumia contra o céu claro, então o material usa transparência comum.

## Teste das apresentações (2026-11-20)

A primeira montagem do powerbank pausou o jogo e mostrou a apresentação. O primeiro Espaço completou a animação, e o segundo fechou e despausou. O segundo powerbank não repetiu a apresentação. Pistola e malha mostraram as suas, e a fase completa continuou vencível.
