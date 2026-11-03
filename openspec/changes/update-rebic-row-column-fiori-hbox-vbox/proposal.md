# Proposal: HBox e VBox no modelo do SAPUI5 (`update-rebic-row-column-fiori-hbox-vbox`)

## Why

`RebicRow` e `RebicColumn` já fazem o papel do `sap.m.HBox` e do `sap.m.VBox`, mas com os nomes do Flutter: os
widgets se chamam `Row`/`Column`, a lista é `children`, os alinhamentos são `mainAlignment`/`crossAlignment`, ocupar só
o necessário é `shrinkWrap`, e a quebra é um construtor `.wrap`. O projeto segue os nomes do SAPUI5.

O `sap.m.FlexBox` (conferido em `SAP/openui5`, `sap.m/FlexBox.js` e os enums de `sap.m/library.js`) tem:
- `items`, `justifyContent` (`FlexJustifyContent`: Start, End, Center, SpaceBetween, SpaceAround), `alignItems`
  (`FlexAlignItems`: Start, End, Center, Baseline, Stretch), `wrap` (`FlexWrap`: NoWrap, Wrap, WrapReverse),
  `displayInline`, `gap`, `rowGap`, `columnGap`, `direction`, `alignContent`, `fitContainer`, `backgroundDesign`;
- `HBox` e `VBox` são o FlexBox com `direction` fixa em Row e Column.

Faltam ao Rebic `spaceAround` e `baseline`. É o passo FlexBox do bloco de layout do realinhamento ao SAPUI5.

## What Changes

- **BREAKING** `RebicRow` dá lugar a `RebicHBox`, e `RebicColumn` a `RebicVBox`:
  - `children` → `items`; `mainAlignment` → `justifyContent`; `crossAlignment` → `alignItems`; `shrinkWrap` →
    `displayInline`;
  - `RebicRow.wrap(...)` → `RebicHBox(wrap: RebicFlexWrap.wrap, ...)`;
  - os enums passam a `RebicFlexJustifyContent` (com o novo `spaceAround`), `RebicFlexAlignItems` (com o novo
    `baseline`) e `RebicFlexWrap` (`noWrap`, `wrap`), no lugar de `RebicMainAlignment` e `RebicCrossAlignment`.
- Padrões que continuam diferentes do UI5, de propósito:
  - `gap` padrão `inlineGap` (HBox) e `stackGap` (VBox), em vez de nenhum: no Rebic o espaço vem do tema, não de
    classes de margem;
  - `alignItems` padrão `center` (HBox) e `start` (VBox), em vez de `Stretch`: no Flutter, esticar num eixo sem
    limite falha.
- `baseline` alinha os itens do HBox pela linha de base do texto; no VBox, vale como `start`, como no CSS.
- Com `wrap`, `alignItems` aceita `start`, `center` e `end`; `stretch` e `baseline` não se aplicam.
- A spec do separador troca `RebicRow` por `RebicHBox` num cenário.
- A galeria troca a página "RebicRow e RebicColumn" por "RebicHBox e RebicVBox"; todos os usos na galeria e nos
  testes passam aos novos nomes.

Fora do escopo, cada um com change própria quando houver uso:
- `RebicFlexBox` genérico, `direction` (inclusive reversa), `WrapReverse`, `alignContent`, `rowGap`/`columnGap`
  separados, `fitContainer`, `backgroundDesign` e `renderType`;
- `FlexItemData` (`growFactor`, `alignSelf`, `order`…); `Expanded` e `Flexible` continuam fazendo esse papel;
- quebra no VBox.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-hbox`: `RebicHBox`, o `sap.m.HBox` do Rebic.
- `rebic/widgets/rebic-vbox`: `RebicVBox`, o `sap.m.VBox` do Rebic.

### Modified Capabilities

- `rebic/widgets/rebic-row` e `rebic/widgets/rebic-column`: retiradas (`retire_capabilities`). Os requisitos passam
  a `rebic-hbox` e `rebic-vbox`.
- `rebic/widgets/rebic-separator`: cenário "Separador vertical numa linha esticada" com `RebicHBox`.

O HBox e o VBox são inseparáveis, como na change que criou `RebicRow` e `RebicColumn` (ADR 0007): dividem os enums
e a montagem interna, e renomear um sem o outro deixaria dois vocabulários de alinhamento no framework.

## Impact

- `packages/rebic_widgets`:
  - `fundacao_layout/row/` e `fundacao_layout/column/` dão lugar a `fundacao_layout/hbox/` e `fundacao_layout/vbox/`;
    `fundacao_layout/flex/` mantém a montagem comum e os enums novos; exportações trocadas;
  - dartdoc que cita `RebicRow`/`RebicColumn` (layout responsivo, separador);
  - todos os testes que usam os dois widgets (cerca de 55 usos) e os testes próprios deles;
  - CHANGELOG com o de/para.
- `apps/rebic_gallery`: cerca de 70 usos e a página "RebicHBox e RebicVBox" no lugar de "RebicRow e RebicColumn".
- `docs/catalog.yaml`: saem `rebic/widgets/rebic-row` e `rebic/widgets/rebic-column`; entram
  `rebic/widgets/rebic-hbox` e `rebic/widgets/rebic-vbox` (P0, fase 1).
- Goldens: nenhum deve mudar, porque a troca mantém o layout.
- Portal existente: nenhum impacto. A change é do framework e não altera o portal.
