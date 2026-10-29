# Design: Tipografia no modelo Fiori

## Context

`RebicTypographyTokens` tem oito estilos com os nomes da escala do Material 3 (`display` 40/48 semibold, `headline`
32/40, `title` 24/32, `subtitle` 18/24, `body` 14/20, `bodyStrong` 14/20 semibold, `label` 14/20 medium e
`caption` 12/16). Leem esses estilos pelo nome:
- `RebicText`, por um `switch` na variante;
- `RebicButton` (`bodyStrong`), `RebicLink` (`body`, `bodyStrong`), `RebicStatusIndicator` (`body`),
  `RebicAvatar` (iniciais), `RebicTheme` (`body`, estilo padrão) e as opções da lista do dropdown (`body`);
- cerca de 15 páginas da galeria.

`RebicBadge`, `RebicTooltip`, `RebicCard`, `RebicPopover`, `RebicPage` e `RebicScaffold` usam estilos só através
das variantes de `RebicText`.

## Goals / Non-Goals

**Goals:**
- Nomes dos estilos iguais aos parâmetros Fiori de tamanho de fonte.
- Títulos em negrito e rótulos em peso regular, como no Horizon.
- Nenhuma mudança de API em widgets nesta change.

**Non-Goals:**
- Trocar `RebicTextVariant` por `RebicTitle`/`RebicText`/`RebicLabel`. Isso fica para a change de realinhamento de
  `RebicText`.
- Reproduzir as famílias "72", "72-Bold" e duplex.
- Mudar o comportamento de escala de texto.

## Decisions

### D1. Estilos e valores

| Estilo | Parâmetro Fiori | Tamanho / altura | Peso | Substitui |
|---|---|---|---|---|
| `header1` | `sapFontHeader1Size` (3rem) | 48 / 60 | bold | `display` (40) |
| `header2` | `sapFontHeader2Size` (2rem) | 32 / 40 | bold | `headline` |
| `header3` | `sapFontHeader3Size` (1.5rem) | 24 / 32 | bold | `title` |
| `header4` | `sapFontHeader4Size` (1.25rem) | 20 / 24 | bold | `subtitle` (18) |
| `header5` | `sapFontHeader5Size` (1rem) | 16 / 20 | bold | — |
| `header6` | `sapFontHeader6Size` (0.875rem) | 14 / 20 | bold | — |
| `large` | `sapFontLargeSize` (1rem) | 16 / 24 | regular | — |
| `base` | `sapFontSize` (0.875rem) | 14 / 20 | regular | `body`, `label` |
| `baseSemibold` | `sapFontSize` + família semibold | 14 / 20 | semibold | `bodyStrong` |
| `baseBold` | `sapFontSize` + `sapFontBoldFamily` | 14 / 20 | bold | — |
| `small` | `sapFontSmallSize` (0.75rem) | 12 / 16 | regular | `caption` |

As alturas de linha seguem a regra já vigente da spec (múltiplo de 4 e ≥ 1,2 × tamanho). Por isso `header1` fica com
60, e não com 56.

Entram os primitivos `size48` e `lineHeight60`. Os primitivos que ficam sem uso no mapeamento de referência
(`size18`, `size28`, `size40`, `lineHeight28`, `lineHeight36`, `lineHeight48`) permanecem na escala para temas
personalizados.

`styles` lista os estilos na ordem da tabela, e a galeria usa essa ordem.

Alternativa considerada: manter `bodyStrong` e `label` com nomes neutros. Foi rejeitada porque o SAPUI5 não tem
estilo de rótulo próprio: `sap.m.Label` usa `sapFontSize` com `sapContent_LabelColor`.

### D2. `RebicText` na transição

`RebicTextVariant` continua igual. O `switch` passa a mapear:
- `display` → `header1`, `headline` → `header2`, `title` → `header3`, `subtitle` → `header4`;
- `body` → `base`, `bodyStrong` → `baseSemibold`, `label` → `base`, `caption` → `small`.

As variantes de cabeçalho continuam anunciadas como cabeçalho. A troca do enum fica para a change de `RebicText`,
para não juntar quatro widgets públicos (`RebicTitle`, `RebicText`, `RebicLabel` e seus usuários) nesta change.

### D3. Widgets

- `RebicButton`: rótulo em `baseSemibold`. O visual não muda, porque `bodyStrong` já era semibold. O Horizon usa
  semibold nos botões.
- `RebicLink`: `base`, e com `emphasized`, `baseBold`. O `sap.m.Link` enfatizado usa a família bold.
- `RebicStatusIndicator`, `RebicTheme` (estilo padrão) e as opções da lista: `base`.
- `RebicBadge`: `small`, pela variante `caption` de `RebicText`. Hoje usa `label`, de 14. O lado mínimo
  `icons.small` continua garantindo o círculo.
- `RebicAvatar`: iniciais em `small`, `header4`, `header3`, `header2` e `header1`, próximas das iniciais do
  `sap.m.Avatar` (0.75, 1.125, 1.625, 2 e 2.75rem). O `FittedBox` existente encolhe as iniciais que não couberem.

### D4. ADR 0009: valores provisórios do Horizon

A nova ADR 0009 registra:
- a política: quando um valor exato do tema Horizon não puder ser confirmado sem material da SAP, o Rebic adota o
  valor mais próximo coerente com as regras das specs, marca-o como provisório e o lista na ADR;
- os valores provisórios desta change: os pesos dos títulos (bold) e as alturas de linha (regra do múltiplo de 4).

As próximas changes de realinhamento acrescentam suas linhas à mesma ADR, em vez de criar uma ADR por fundamento.

### D5. Goldens

Todo golden com texto muda. São regerados no Windows (ADR 0008), com a tag `golden`. A revisão confere as
diferenças por amostragem: títulos em negrito, card e popover com título de 20, badge menor.

## Risks / Trade-offs

- **Títulos maiores e em negrito podem quebrar palavras em cartões estreitos.** A change de `RebicCard` trocou 24 por
  18 por esse motivo. Com 20 em negrito, o teste de cartão estreito existente precisa continuar sem estouro. Se
  falhar, o título do cartão passa a `header5` (16), registrado no CHANGELOG.
- **`label` → `base` muda o peso de rótulos de tooltip, badge e status de cartão de 500 para 400.** É intencional; o
  contraste continua vindo da cor.
- **A renomeação quebra a API 0.x.** Não há consumidores externos. O CHANGELOG traz a tabela de/para.
- **Estado transitório.** `RebicTextVariant` mantém nomes do Material até a change de `RebicText`. O dartdoc de cada
  variante passa a citar o estilo Fiori correspondente.
