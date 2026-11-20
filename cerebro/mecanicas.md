# Mecânicas

## Ciclo central

Enfrentar inimigo → obter material → transformar material → ficar mais capaz → enfrentar novos inimigos.

## Definido

| Inimigo | Ataque | Material | Uso |
|---|---|---|---|
| Notebook | Só contato | Célula 18650 | Powerbanks, que aumentam a carga máxima da pistola |
| Micro-ondas | Atira ondas | Motor | Pistola-dínamo |
| Fios usados | Contato e chicotada elétrica | Cobre | Malha de aterramento, imune ao chão eletrificado |

A garrafa PET, a bolsa, o pneu e o solado saíram do jogo em 2026-11-20. O uso real de cada material está em [reciclagem.md](reciclagem.md).

**Clareza é requisito:** o jogador precisa ver quanto tem, quanto falta e para que serve cada material. Veio do teste do usuário em 2026-11-19.

## Provisório no protótipo

Valores e detalhes para teste. Não são decisões finais.

- A vassourada derrota inimigos, que deixam o material no chão. Encostar o recolhe.
- **Apresentação do item:** na primeira vez que o jogador monta o powerbank, a pistola-dínamo ou a malha, o jogo pausa e mostra uma tela animada com a cadeia inimigo → material → item, o uso real, um cuidado real e o efeito no jogo. Espaço completa a animação e depois fecha.
- **Notebook:** inimigo básico. Anda de um lado para o outro e machuca no contato. Deixa uma célula.
- **Powerbank:** cada 3 células montam um powerbank com a tecla Q, até 2. Cada um soma 3 à carga máxima: 3, depois 6, depois 9. Pode ser montado antes da pistola.
- **Micro-ondas:** atira ondas na direção do gari quando ele está perto. Deixa um motor.
- **Pistola-dínamo:** 3 motores montam a pistola com a tecla R. Ela começa com a carga cheia, cada tiro gasta 1, e o dínamo gera 1 de carga a cada 1,2 segundo. Depois de montada, a linha de motores some da tela e as linhas de baixo sobem.
- Os materiais não têm limite de quantidade. O limite que importa é a carga da pistola.
- As faíscas atravessam a cerca, o gari não. Derrotar o micro-ondas atrás dela abre o caminho.
- A fase tem 6 notebooks e 3 micro-ondas antes da cerca, o suficiente para 2 powerbanks e a pistola.
- Não há lanterna, por decisão do usuário.
- **Vida:** o gari tem 3 pontos. Ser atingido tira 1, empurra e dá 1 segundo de proteção.
- **Queda:** tira 1 ponto e leva ao último ecoponto.
- **Derrota:** com a vida em zero, o gari volta ao último ecoponto com a vida cheia. Materiais, melhorias e inimigos derrotados são mantidos.
- **Ecopontos:** encostar ativa o ponto de retorno e recupera a vida. Há 3 na fase.
- **Fios usados:** andam e, quando o gari chega perto, dão uma chicotada elétrica a cada 2 segundos. Deixam cobre.
- **Malha de aterramento:** 3 cobres fazem a malha com a tecla F. Ela aparece como solas de cobre nas botas.
- **Chão eletrificado:** fica antes do caminhão e é visível desde o começo do trecho. Sem a malha, cada choque tira 1 de vida e joga o gari de volta. Com a malha, ele atravessa e solta faíscas de aterramento pelos pés.
- O chão dispara raios em zigue-zague entre pontos da placa, às vezes dois de uma vez, com clarão na luz e estalo de raio em tom variado. Quando o gari está em cima, metade dos raios vai até ele. Há também faíscas, brilhos azuis subindo e zumbido que aumenta com a proximidade.
- **Corrente redirecionada:** com a malha, pisar no chão eletrificado deixa o gari carregado por 4 segundos, com faíscas cor de cobre nos pés. Encostar carregado no gerador o liga, e o gerador abre o portão que bloqueia o caminhão.

## Observado no teste

- O micro-ondas atrás da cerca acerta quem fica parado em frente a ela.
- O motor deixado por esse último micro-ondas não tem uso depois que a pistola já existe.

## Hipóteses

Nada aqui foi aprovado. A lógica real de cada item ainda precisa ser conferida.

| Inimigo | Possível resultado | Ideia |
|---|---|---|
| Lata de alumínio | Proteção | Metal reaproveitado em placas |
| Papelão | Item leve ou plataforma | Material moldável |

## Ainda não definido

As perguntas abertas estão em [duvidas.md](duvidas.md).
