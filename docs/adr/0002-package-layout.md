# ADR 0002 — Workspace com pacotes por camada

- **Status:** Aceita (sujeita à confirmação da ADR 0001)
- **Data:** 2026-10-24

## Contexto

A spec `rebic/framework-architecture` exige camadas publicadas como unidades independentes,
dependência em uma só direção e ausência de ciclos. Pub workspaces exigem **Dart ≥ 3.6**.
A baseline provisória (ADR 0001) é Dart 3.8.1.

## Decisão

Usar um pub workspace na raiz do repositório com os membros:

| Membro | Papel | Depende de |
|---|---|---|
| `packages/rebic_foundation` | tokens, tema, breakpoints, densidade | Flutter SDK |
| `packages/rebic_core` | interação, overlay, localização, validação, dados | `rebic_foundation` |
| `packages/rebic_widgets` | widgets públicos | `rebic_foundation`, `rebic_core` |
| `packages/rebic_ui` | agregador (só reexporta) | as três camadas |
| `apps/rebic_gallery` | galeria de demonstração | `rebic_ui` |
| `tool/rebic_checks` | verificações de conformidade (CLI Dart) | `analyzer`, `path`, `yaml` |

A direção das dependências é garantida pelos `pubspec.yaml`, e `rebic_checks architecture`
verifica os imports dentro de cada pacote.

## Alternativas consideradas

- **Dependências `path:` sem workspace.** Fica como alternativa caso o portal use Dart < 3.6.
  A estrutura de pastas é a mesma, removendo `resolution: workspace` e a seção `workspace:` da raiz.
- **Pacote único com pastas.** Os limites dependeriam apenas de lint.
- **Um pacote por widget.** Custo de versionamento desproporcional para cerca de 60 itens.
- **Melos.** Ferramenta externa desnecessária com pub workspaces.

## Consequências

Um único `pubspec.lock` e uma única resolução de dependências para todo o repositório.
Consumidores dependem de `rebic_ui`, ou só de `rebic_foundation` quando precisarem apenas dos tokens.
