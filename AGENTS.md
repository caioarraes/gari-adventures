# Regras de trabalho

Valem para qualquer agente ou sessão neste projeto. O jogo é um plataforma 2.5D em Godot sobre um gari que reaproveita os inimigos para se aprimorar.

## Antes de começar

1. Leia [cerebro/README.md](cerebro/README.md) e [cerebro/diario.md](cerebro/diario.md).
2. Leia só os outros arquivos do cérebro que a tarefa exigir.
3. Ao terminar, atualize o que mudou. Veja a tabela em [cerebro/README.md](cerebro/README.md).

## Interpretar o pedido

- Interprete o pedido pela **experiência** proposta, não pelo sistema descrito.
- Pergunte-se: o que o jogador deve sentir ou perceber aqui? Atenda a isso.
- Se o sistema descrito for parte explícita da ideia, como as células de notebook virarem powerbank, ele continua valendo. A experiência orienta como realizá-lo.

## Não julgar mecânicas

- Não declare uma mecânica boa ou ruim por si só.
- Não tente convencer o usuário a trocar uma mecânica por gosto ou por "boas práticas".
- Relate fatos: como precedentes implementaram, o que aconteceu neles e o que cada caminho exige.

## Dúvida: pesquisar precedentes

- Quando houver dúvida de design, pesquise precedentes antes de decidir ou perguntar.
- Priorize jogos com mecânica igual ou quase igual, mesmo com tema e visual totalmente diferentes.
- Tema narrativo ou visual parecido, sozinho, não torna um jogo um bom precedente.
- Registre o resultado em [cerebro/precedentes.md](cerebro/precedentes.md), com fontes.
- Se os precedentes não resolverem, registre em [cerebro/duvidas.md](cerebro/duvidas.md) e leve a escolha ao usuário.

## Anti-over-engineering

- Escreva o código mais direto que resolve a tarefa atual.
- Prefira código concreto, repetição pequena e nós simples da Godot.
- Não crie classe base, interface, gerenciador, event bus, registro, plugin, fábrica ou formato de dados "para o futuro".
- Não crie configuração para um valor que só tem um uso.
- Dois casos parecidos não justificam uma abstração.

### Regra de abstração

Um sistema mais abstrato ou complexo só pode ser implementado se estiver **explicitamente mapeado para uma fase futura** na tabela "Sistemas complexos mapeados" de [cerebro/roadmap.md](cerebro/roadmap.md).

- Sem linha na tabela, o sistema não entra.
- A linha precisa dizer qual fase usa o sistema e qual necessidade concreta ele atende.
- Agentes não adicionam linhas para se autorizar. Proponha ao usuário e espere a aprovação.
