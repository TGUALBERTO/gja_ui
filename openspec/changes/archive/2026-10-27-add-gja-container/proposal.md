# Proposal: GjaContainer (`gja/widgets/gja-container`)

## Why

Toda área que agrupa conteúdo precisa de uma superfície do tema: cartões, painéis, cabeçalhos, popovers, barras e
seções de formulário. Essa superfície combina fundo, borda, cantos, sombra e espaço interno. Hoje a galeria monta isso
com `Container` e `BoxDecoration`, escolhendo cor, raio e sombra à mão em cada página. `GjaCard` e `GjaPopover`
dependem de uma base comum, conforme o design da Fase 0.

No SAPUI5, o papel é das superfícies padronizadas:
- o `backgroundDesign` de `sap.m.Page`, `sap.m.Panel` e `sap.m.FlexBox` (`Solid`, `Transparent`, `List`);
- os parâmetros de tema (`sapBaseColor`, `sapBackgroundColor`, `sapShellColor`,
  `sapContent_Shadow0…3`, `sapElement_BorderCornerRadius`);
- a classe `sapUiContentPadding`.

`GjaContainer` é o equivalente: cada aspecto é um papel nomeado do tema.

## What Changes

- Widget `GjaContainer` em `gja_widgets`, com papéis em vez de valores:
  - `surface` (`GjaSurface`): `none` (transparente, padrão), `background`, `base`, `header` ou `shell`, mapeados para
    `background`, `base`, `headerBackground` e `shell` do tema;
  - `border`: `true` desenha a borda `separator` de 1 px;
  - `radius` (`GjaRadius`): passo ou papel de raio (`none` a `full`, `control`, `container`). O conteúdo é recortado
    nos cantos arredondados;
  - `elevation` (`GjaElevation`): papel de sombra (`none`, `card`, `popover`, `dialog`, `dragged`, `header`), com a
    cor `shadow` do tema;
  - `padding` (`GjaSpace?`): espaço interno em todos os lados, pelo `spacing` do tema e da densidade.
- Goldens das combinações de superfície, borda, raio e sombra, em claro e escuro e nas duas densidades.
- Página "GjaContainer" na galeria.

Fora do escopo:
- Tamanho, largura e altura (vêm do layout pai ou de `SizedBox`).
- Interação (`GjaCard` clicável, spec própria).
- Cabeçalho e rodapé (`GjaCard`).
- Cores livres e gradientes.

## Capabilities

### New Capabilities

- `gja/widgets/gja-container`: superfície do tema com fundo, borda, raio com recorte, sombra e espaço interno
  nomeados por papéis.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/gja_widgets/lib/src/fundacao_layout/container/`, testes e goldens.
- **Galeria:** nova página "GjaContainer".
- **Catálogo:** `gja/widgets/gja-container` → `implemented`. As dependências (`color`, `radius`, `elevation` e
  `spacing`) ganham `theming`, `density` e `gja/widgets/gja-spacing` (reuso de `GjaSpace`).
- **Portal existente:** sem impacto.
