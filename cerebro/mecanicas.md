# Mecânicas

## Ciclo central

Enfrentar inimigo → obter material → transformar material → ficar mais capaz → enfrentar novos inimigos.

## Definido

| Inimigo | Material | Uso |
|---|---|---|
| Garrafa PET | PET | Fio → bolsa, que aumenta o inventário |
| Lixo eletrônico | Componente eletrônico | Primeiro monta a pistola. Depois vira balas |

**Clareza é requisito:** o jogador precisa ver quanto tem, quanto falta e para que serve cada material. Veio do teste do usuário em 2026-11-19.

## Provisório no protótipo

Valores e detalhes para teste. Não são decisões finais.

- A vassourada derrota inimigos, que deixam o material no chão. Encostar o recolhe.
- **Bolsa:** cada 3 PET fazem uma bolsa com a tecla E. São 2 níveis, e cada um dá +3 espaços.
- **Inventário:** os espaços valem só para componentes e balas: 3, depois 6, depois 9. O PET tem contador próprio.
- **Pistola:** 3 componentes montam a pistola com a tecla R.
- **Balas:** depois da pistola, cada componente é 1 bala. Sem balas, 1 volta sozinha em 4 segundos, para o jogador nunca ficar travado.
- A pistola atira a faísca do próprio inimigo, seguindo o precedente de Mega Man.
- As faíscas atravessam a cerca, o gari não. Derrotar o monitor atrás dela abre o caminho.
- Ser atingido empurra o gari e dá 1 segundo de proteção. Ainda não existe vida nem derrota.

## Hipóteses

Nada aqui foi aprovado. A lógica real de cada item ainda precisa ser conferida.

| Inimigo | Possível resultado | Ideia |
|---|---|---|
| Pneu | Calçado ou salto | Borracha reaproveitada em solado |
| Lata de alumínio | Proteção | Metal reaproveitado em placas |
| Papelão | Item leve ou plataforma | Material moldável |

## Ainda não definido

As perguntas abertas estão em [duvidas.md](duvidas.md).
