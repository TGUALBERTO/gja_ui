# Design: Sombras no modelo Fiori

## Context

`GjaElevationTokens` tem os níveis `level0`…`level4` e os papéis `card`, `popover` e `dialog`. Os primitivos
`elevation0`…`elevation4` têm duas camadas (contato e ambiente). A cor vem do papel `shadow`. Só a galeria e o
tema usam o conjunto; nenhum widget o lê ainda.

## Goals / Non-Goals

**Goals:** nomes de sombra no estilo dos parâmetros Fiori; papéis para item arrastado e cabeçalho; manter a
geometria já validada.

**Non-Goals:** mudar a cor ou a forma de compor as sombras (`shadowsFor`); reproduzir os valores do tema Horizon.

## Decisions

### D1. Nomes e mapeamento

| Antes (primitivo / semântico) | Agora | Uso no Fiori |
|---|---|---|
| `elevation0` / `level0` | `none` | sem sombra |
| `elevation1` / `level1` | `shadow0` | `sapContent_Shadow0`: cartões, blocos |
| `elevation2` / `level2` | `shadow1` | `sapContent_Shadow1`: popovers, menus |
| `elevation3` / `level3` | `shadow2` | `sapContent_Shadow2`: diálogos |
| `elevation4` / `level4` | `shadow3` | `sapContent_Shadow3`: item arrastado |
| — | `header` | `sapContent_HeaderShadow`: cabeçalhos |

O Fiori não tem uma sombra "zero"; `none` existe para interpolar e para desligar a sombra de um papel.

### D2. Primitivo `header`

Uma camada `offsetY: 2, blurRadius: 4, opacity: 0.5`, curta e só para baixo. Ela fica fora da ordem crescente de
`shadow0`…`shadow3`, porque é usada lado a lado com o conteúdo, não empilhada.

### D3. API

`GjaElevationTokens(none, shadow0, shadow1, shadow2, shadow3, card, popover, dialog, dragged, header)`.
`values` lista as sombras e depois os papéis. `GjaElevationPrimitives.levels` vira `shadows`, com `none`,
`shadow0`…`shadow3` e `header`.

## Risks / Trade-offs

- [Renomeação quebra a API 0.x] → Não há consumidores externos. O CHANGELOG registra a tabela de/para.
- [`dragged` como papel pode sugerir uma regra de estado] → A regra é do widget: ao arrastar, ele usa o papel
  `dragged`. O fundamento de estados não volta a aumentar elevação.
