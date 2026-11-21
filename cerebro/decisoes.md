# Decisões

Mais recentes no final. Para mudar uma decisão, acrescente outra que a substitua.

## D-001: Godot 4.7.2 padrão com GDScript (2026-11-18)

A versão padrão era a estável atual no winget e dispensa o .NET. O usuário pediu Godot, sem exigir C#.

## D-002: PET aumenta o inventário (2026-11-18)

Definido pelo usuário, inspirado no reaproveitamento de PET em fio para bolsas.

## D-003: Lixo eletrônico fabrica armas (2026-11-18)

Definido pelo usuário.

## D-004: Regras em `AGENTS.md`, agentes em `.claude/agents/` (2026-11-18)

`CLAUDE.md` importa `AGENTS.md`, então as regras carregam automaticamente. `.claude/agents/` é a pasta que o Claude Code reconhece para subagentes.

## D-005: Personagens em sprites sobre cenário 3D (2026-11-18)

Definido pelo usuário. Personagens usam `Sprite3D`, e o cenário usa geometria 3D.

## D-006: Componentes viram pistola e depois balas (2026-11-19)

Definido pelo usuário após jogar. Substitui a sucata usada só para fabricar a arma, porque derrotar monitores precisa continuar útil depois da pistola.

## D-007: Inventário separado e progresso sempre visível (2026-11-19)

O espaço compartilhado entre materiais confundiu o usuário. A tela agora mostra PET e componentes em linhas separadas, com quanto falta e a tecla de cada ação.

## D-008: Arte e áudio da fatia vertical gerados por código (2026-11-19)

`ferramentas/gerar_assets.gd` cria tudo em `arte/` e `som/`. Assim a fatia vertical não depende de material de terceiros. Os arquivos podem ser substituídos por arte final mantendo nome e tamanho.

## D-009: Pneu vira solado de pulo alto (2026-11-19)

Escolhido pelo usuário como início da Fase 5. É o primeiro reaproveitamento que muda o movimento.

## D-010: Nome do jogo é Gari Adventures (2026-11-19)

Definido pelo usuário. Substitui o nome provisório no jogo, no repositório `caioarraes/gari-adventures` e na pasta do projeto.

## D-011: Notebook substitui o monitor (2026-11-20)

Definido pelo usuário para aproximar o jogo da reciclagem real. O notebook deixa células 18650. As células montam e recarregam a pistola e montam um powerbank que aumenta a energia máxima. A bolsa de PET passa a definir quantas células o gari carrega. A lanterna foi descartada pelo usuário. Substitui D-003 e D-006. A reciclagem real está em [reciclagem.md](reciclagem.md).

## D-012: Sai o PET, notebook vira básico e micro-ondas atira (2026-11-20)

Definido pelo usuário. A garrafa PET e a bolsa saem do jogo. O notebook passa a ser o inimigo básico, sem tiro, e suas células só montam powerbanks. O micro-ondas é o inimigo que atira, e seu motor monta uma pistola-dínamo, inspirada no uso real do motor do prato como gerador de manivela. Substitui D-002 e a parte da pistola em D-011.

## D-013: Fios no lugar do pneu e chão eletrificado no lugar do muro (2026-11-20)

Definido pelo usuário. O inimigo de fios usados deixa cobre, que vira a malha de aterramento, inspirada na extração real de cobre de cabos. O muro sai e entra um chão eletrificado, que só pode ser atravessado com a malha. O solado sai junto com o pneu. Substitui D-009.

## D-014: A malha leva a corrente do chão até um gerador (2026-11-20)

Definido pelo usuário. O gari aterrado absorve a corrente do chão eletrificado e a usa para ligar um gerador, que abre o portão antes do caminhão.

## D-015: Apresentação do uso real na primeira montagem de cada item (2026-11-20)

Definido pelo usuário. Os textos seguem só o que está confirmado em [reciclagem.md](reciclagem.md) e incluem um cuidado real, como o risco das células de lítio, do capacitor do micro-ondas e da queima de fios.

## D-016: Primeira fase ampliada sem mecânicas novas (2026-11-21)

Pedido do usuário. A fase passou de cerca de 76 para 118 unidades, seguindo o padrão de apresentar cada mecânica em segurança e depois testá-la. O chão eletrificado ganhou largura ajustável para a faixa curta, e motores extras passaram a recarregar a pistola.

## D-017: Fase 1 em 172 unidades e micro-ondas reposicionados (2026-11-21)

Pedido do usuário, que achou a fase curta e os micro-ondas mal posicionados. O posicionamento segue precedentes de Mega Man 8 e Shovel Knight: um atirador por vez, nenhum perto de ecoponto ou pouso, apresentação em chão plano e cobertura com caixas. Ondas e faíscas passaram a parar em caixas, paredes e plataformas. Substitui o layout de D-016.

## D-018: Chão eletrificado só dá choque ao ser pisado (2026-11-21)

Pedido do usuário para melhorar a experiência. A área de dano virou uma camada fina na superfície e só afeta o gari quando ele está no chão. Os raios só miram no gari nessas condições.

## D-019: Cenário de rua brasileira em camadas, com tema por trecho (2026-11-21)

Pedido do usuário para um cenário mais rico e coeso, com referências. Cada trecho ganhou um tema ligado ao inimigo, e o cenário inteiro segue uma paleta e luz únicas. A direção visual está em [visao.md](visao.md).
