# Proposal: Cores e estados no modelo Fiori (`update-gja-foundation-color-fiori-parameters`)

## Why

O GJA tem o SAPUI5/Fiori como modelo, mas os fundamentos de cor e de estados de interação foram escritos com
vocabulário e mecanismos do Material Design:

- papéis `surface`, `onSurface`, `primaryContainer`, `onPrimaryContainer` e `scrim`;
- "camada de estado" de opacidade (8%/12%/16%) pintada sobre a superfície;
- aumento de elevação no hover.

O Fiori trabalha com **parâmetros de tema** (`sapBrandColor`, `sapBaseColor`, `sapTextColor`,
`sapContent_LabelColor`, `sapList_Hover_Background`, `sapButton_Active_Background`, `sapContent_FocusColor`,
`sapBlockLayer_Background`…). Cada família de controle tem cores explícitas para normal, hover, ativo (pressionado)
e selecionado. O desabilitado é uma opacidade (`sapContent_DisabledOpacity`). Nenhum widget existe ainda, então este
é o momento de realinhar, antes que os widgets herdem o vocabulário errado.

## What Changes

- **BREAKING** `GjaColorTokens` passa a usar papéis no estilo dos parâmetros Fiori (sem o prefixo `sap`):
  - `surface` → `base`, `surfaceVariant` → `headerBackground`, `onSurface` → `text`, `onSurfaceMuted` → `label`;
  - `border` → `separator`, `borderStrong` → `fieldBorder`, `primary` → `brand`, `onPrimary` → `contrastText`;
  - `primaryContainer` → `selectionBackground`, `scrim` → `blockLayer`;
  - novos: `shell`, `link`, `brandHover`, `highlight` (fundo ativo), `hoverBackground` e `selectionHoverBackground`;
  - removidos: `onSurfaceDisabled`, `surfaceDisabled` e `onPrimaryContainer` (o texto sobre a seleção é `text`).
- **BREAKING** `GjaInteractionStateTokens` deixa a camada de opacidade e passa ao modelo Fiori:
  - famílias de controle `standard`, `emphasized`, `transparent` e `list` (equivalentes aos tipos de botão Default,
    Emphasized e Transparent e aos itens de lista do UI5);
  - cada família tem cores explícitas de fundo, borda e texto para normal, hover, ativo, selecionado e selecionado + hover,
    **derivadas dos papéis de cor**, para que uma troca de marca flua para todos os controles;
  - desabilitado vira opacidade do controle inteiro (0,4, como `sapContent_DisabledOpacity`);
  - o aumento de elevação no hover sai.
- A verificação de contraste passa a cobrir o texto de cada estado de cada família, nos dois modos.
- A paleta primitiva não muda.
- As páginas da galeria "Cores", "Estados", "Tema" e "Interação" passam a usar os papéis e as famílias novas.
- O catálogo deixa de listar `elevation` como dependência de `interaction-states`.

Fora do escopo:
- Nomes de elevação no padrão Fiori (`sapContent_Shadow0…3`): change `update-gja-foundation-elevation-fiori-shadows`.
- Famílias de campo (`sapField_*`), que entram com o primeiro widget de campo.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/foundation/color`: papéis semânticos renomeados e ampliados no modelo Fiori, mapeamentos de referência e pares de contraste.
- `gja/foundation/interaction-states`: famílias de controle com cores por estado, desabilitado por opacidade, foco, contraste por estado e contrato. Sem camada de opacidade e sem elevação em interação.
- `gja/foundation/theming`: cenários que citavam `primary`, `onPrimary` e `surface`.

## Impact

- **Código:** `gja_foundation` (`color/`, `interaction_states/`, `theming/` e testes) e `gja_core` (`GjaInteractable`
  usa os novos nomes do anel de foco). Também as páginas da galeria afetadas e os testes delas.
- **API:** quebra intencional na série `0.x`, sem consumidores fora do repositório. Fica registrada no CHANGELOG.
- **Catálogo:** a dependência `interaction-states` → `elevation` sai.
- **Portal existente:** sem impacto.
