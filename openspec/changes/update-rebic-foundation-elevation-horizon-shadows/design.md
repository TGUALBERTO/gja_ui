# Design: Sombras no modelo Horizon

## Context

O fundamento `rebic/foundation/elevation` foi realinhado em `update-rebic-foundation-elevation-fiori-shadows` só nos
nomes das sombras (`shadow0`…`shadow3`, `header`). Continuam do Material:
- o nome do fundamento e da API: `RebicElevationTokens`, `RebicElevationPrimitives`, `RebicThemeData.elevation`,
  `shadowsFor`, `RebicElevation` e `RebicContainer.elevation`;
- a geometria: `shadow0`…`shadow3` têm uma camada de contato e uma de ambiente, com deslocamentos de 1 a 6 e
  desfoques de 3 a 10;
- os papéis: `popover` = `shadow1` e `dialog` = `shadow2`.

Usos atuais:
- `rebic_widgets`: `RebicContainer` converte o enum em papel. `RebicCard` (`card`), `RebicPopover` e `RebicTooltip`
  (`popover`) e `RebicScaffold` (`header`) passam o enum ao contêiner. Menu, dropdown e página herdam do popover e do
  scaffold.
- galeria: páginas "Elevação", contêiner, grade, tema e sobreposição.
- `rebic_checks`: o teste da verificação de tokens cita `elevation.shadowsFor`. A regra de literais lista
  `elevation`, que é o parâmetro dos widgets do Material e deve continuar proibido.

`rebic_checks catalog` exige que toda spec principal esteja no catálogo. Durante esta change, a spec principal
`rebic/foundation/elevation` continua existindo até o arquivamento, mas o catálogo já terá trocado o item.

## Goals / Non-Goals

**Goals:**
- Nenhum nome público com `elevation`.
- Geometria e papéis como os parâmetros `sapContent_Shadow*` do Horizon.
- Specs, catálogo e API com o mesmo nome do fundamento.

**Non-Goals:**
- Trocar `colors.shadow` (ver proposal.md).
- Sombra de hover em cartões.
- Aplicar sombras a novos widgets.

## Decisions

### D1. Renomeação

| Antes | Depois |
|---|---|
| `lib/src/elevation/` | `lib/src/shadows/` |
| `RebicElevationTokens` | `RebicShadowTokens` |
| `RebicElevationPrimitives` (`shadows`) | `RebicShadowPrimitives` (`values`) |
| `RebicThemeData.elevation` | `RebicThemeData.shadows` |
| `RebicElevationTokens.shadowsFor(level, color)` | `RebicShadowTokens.boxShadows(shadow, color)` |
| `RebicElevation` (widgets) | `RebicShadow` |
| `RebicContainer.elevation` | `RebicContainer.shadow` |
| `ElevationPage` "Elevação" `/elevation` | `ShadowsPage` "Sombras" `/shadows` |

`RebicShadowLayer` fica igual. O mapa `RebicShadowTokens.values` mantém o nome.

Sem aliases `@Deprecated`: a API é 0.x, não há consumidores externos e a renomeação é a mesma em todo o repositório.

### D2. Geometria

Camadas como (deslocamento vertical, desfoque, expansão, fator de opacidade):

| Sombra | Camadas | Referência Horizon |
|---|---|---|
| `shadow0` | (0, 2, 0, 1) e (2, 4, 0, 1) | `0 0 0.125rem`, `0 0.125rem 0.25rem` |
| `shadow1` | contorno (0, 0, 1, 1) e (2, 8, 0, 0,5) | `0 0 0 0.0625rem`, `0 0.125rem 0.5rem` |
| `shadow2` | contorno (0, 0, 1, 1) e (10, 30, 0, 0,5) | `0 0 0 0.0625rem`, `0 0.625rem 1.875rem` |
| `shadow3` | contorno (0, 0, 1, 1) e (20, 80, 0, 0,5) | `0 0 0 0.0625rem`, `0 1.25rem 5rem` |
| `header` | (2, 4, 0, 0,5), sem mudança | `sapContent_HeaderShadow` |

Maior desfoque: 4, 8, 30 e 80, estritamente crescente. Maior deslocamento: 2, 2, 10 e 20, não decrescente. Por isso a
spec troca "estritamente crescente" por "não decrescente" para o deslocamento.

As opacidades do Horizon (contorno mais forte que a difusa) viram fatores 1 e 0,5 sobre `colors.shadow`. Os valores
exatos são provisórios (ADR 0009).

Alternativa considerada: manter as camadas atuais e só renomear. Rejeitada porque o par contato/ambiente é o modelo
de elevação do Material, e o contorno de 1 px é o traço visual das sobreposições do Horizon.

### D3. Papéis

`card` = `shadow0`, `popover` = `shadow2`, `dialog` = `shadow3`, `dragged` = `shadow3` e `header` = `header`. A ordem
exigida passa a `card` < `popover` < `dialog` ≤ `dragged`. `RebicTooltip` continua usando `popover`, como as dicas
sobrepostas do Horizon.

### D4. Retirada da capability

A change cria `rebic/foundation/shadows` (ADDED, conteúdo completo) e remove todos os requisitos de
`rebic/foundation/elevation`, com `retire_capabilities: true`. No arquivamento, o sync cria a spec nova e apaga a
antiga.

`docs/catalog.yaml`: o item muda de id e nome. Os `depends_on` dos widgets passam a `rebic/foundation/shadows`.

`rebic_checks catalog` passa a dispensar do catálogo a spec principal cujos requisitos são todos removidos por uma
change ativa com `retire_capabilities: true`. É o mesmo tratamento que o helper de rastreabilidade já dá a REMOVED.
Sem isso, a verificação falha entre a aplicação e o arquivamento.

### D5. Galeria

A página renomeada lista as sombras e os papéis por `RebicShadowTokens.values`. As demais páginas passam a
`RebicShadow`/`shadows`.

### D6. ADR 0009

Novas linhas de valores provisórios: a geometria de `shadow0`…`shadow3` (fatores 1 e 0,5 sobre `colors.shadow`) e o
papel `dragged` = `shadow3`.

## Risks / Trade-offs

- **[Sombras maiores podem estourar a área dos goldens]** O desfoque de 30 e 80 ultrapassa a margem das amostras de
  popover, menu e dropdown. → Os goldens são regerados e conferidos por amostragem. Se a sombra for cortada pelo
  limite do golden, a amostra ganha margem no teste, sem mudar o widget.
- **[Contorno somado à borda]** `RebicTooltip` tem borda `separator` e passa a ter também o contorno de `shadow2`. →
  Fica aceito nesta change, porque a dica do Horizon também tem contorno. A revisão da borda fica para a change de
  realinhamento de `RebicTooltip`.
- **[Quebra de API 0.x]** Todos os nomes de D1 mudam. → O CHANGELOG traz a tabela de/para.
- **[Contorno fraco]** Com `colors.shadow` em 16% no claro, o contorno de 1 px fica mais claro que o do Horizon. →
  Registrado na ADR 0009, e a cor fica para uma change de cor.
