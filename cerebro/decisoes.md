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
