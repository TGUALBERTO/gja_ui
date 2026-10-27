# Proposal: RebicContainer (`rebic/widgets/rebic-container`)

## Why

Toda área que agrupa conteúdo precisa de uma superfície do tema: cartões, painéis, cabeçalhos, popovers, barras e
seções de formulário. Essa superfície combina fundo, borda, cantos, sombra e espaço interno. Hoje a galeria monta isso
com `Container` e `BoxDecoration`, escolhendo cor, raio e sombra à mão em cada página. `RebicCard` e `RebicPopover`
dependem de uma base comum, conforme o design da Fase 0.

No SAPUI5, o papel é das superfícies padronizadas:
- o `backgroundDesign` de `sap.m.Page`, `sap.m.Panel` e `sap.m.FlexBox` (`Solid`, `Transparent`, `List`);
- os parâmetros de tema (`sapBaseColor`, `sapBackgroundColor`, `sapShellColor`,
  `sapContent_Shadow0…3`, `sapElement_BorderCornerRadius`);
- a classe `sapUiContentPadding`.

`RebicContainer` é o equivalente: cada aspecto é um papel nomeado do tema.

## What Changes

- Widget `RebicContainer` em `rebic_widgets`, com papéis em vez de valores:
  - `surface` (`RebicSurface`): `none` (transparente, padrão), `background`, `base`, `header` ou `shell`, mapeados para
    `background`, `base`, `headerBackground` e `shell` do tema;
  - `border`: `true` desenha a borda `separator` de 1 px;
  - `radius` (`RebicRadius`): passo ou papel de raio (`none` a `full`, `control`, `container`). O conteúdo é recortado
    nos cantos arredondados;
  - `elevation` (`RebicElevation`): papel de sombra (`none`, `card`, `popover`, `dialog`, `dragged`, `header`), com a
    cor `shadow` do tema;
  - `padding` (`RebicSpace?`): espaço interno em todos os lados, pelo `spacing` do tema e da densidade.
- Goldens das combinações de superfície, borda, raio e sombra, em claro e escuro e nas duas densidades.
- Página "RebicContainer" na galeria.

Fora do escopo:
- Tamanho, largura e altura (vêm do layout pai ou de `SizedBox`).
- Interação (`RebicCard` clicável, spec própria).
- Cabeçalho e rodapé (`RebicCard`).
- Cores livres e gradientes.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-container`: superfície do tema com fundo, borda, raio com recorte, sombra e espaço interno
  nomeados por papéis.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_widgets/lib/src/fundacao_layout/container/`, testes e goldens.
- **Galeria:** nova página "RebicContainer".
- **Catálogo:** `rebic/widgets/rebic-container` → `implemented`. As dependências (`color`, `radius`, `elevation` e
  `spacing`) ganham `theming`, `density` e `rebic/widgets/rebic-spacing` (reuso de `RebicSpace`).
- **Portal existente:** sem impacto.
