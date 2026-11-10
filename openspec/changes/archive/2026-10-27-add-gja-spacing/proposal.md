# Proposal: GjaSpacing (`gja/widgets/gja-spacing`)

## Why

O fundamento de espaçamento define os passos (`none` a `xxxl`) e os papéis de layout (`inlineGap`, `stackGap`,
`sectionGap` e `pageMargin`). A densidade compacta os reduz. Mas até agora o único jeito de usá-los é ler
`GjaTheme.of(context).spacing` e montar `SizedBox` e `EdgeInsets` à mão, como fazem as páginas da galeria. Isso
repete código e abre espaço para valores literais, que a verificação de tokens só barra dentro de `gja_widgets`. Os
widgets de layout seguintes (`GjaRow`, `GjaColumn` e `GjaGrid`) também precisam de uma forma única de expressar
espaço.

No SAPUI5, o espaço vem das classes padronizadas de margem e de padding (`sapUiTinyMargin`, `sapUiSmallMargin`,
`sapUiMediumMargin`, `sapUiLargeMargin`, `sapUiContentPadding`), e não de números. `GjaSpacing` é o equivalente:
o espaço é nomeado por um passo ou papel, e o valor vem do tema e da densidade ativos.

## What Changes

- Enum `GjaSpace` com os nove passos e os quatro papéis de layout do fundamento.
- Widget `GjaSpacing` em `gja_widgets`:
  - `GjaSpacing.horizontal(space)`: espaço vazio com a largura do passo, para separar itens lado a lado;
  - `GjaSpacing.vertical(space)`: espaço vazio com a altura do passo, para separar itens empilhados;
  - `GjaSpacing.padding(child:, all:, horizontal:, vertical:, start:, end:, top:, bottom:)`: espaço em volta de um
    filho. O valor mais específico vence (`start` > `horizontal` > `all`), e `start`/`end` seguem a direção do texto.
  - os valores vêm do `spacing` do tema ativo e mudam com a densidade.
- Página "GjaSpacing" na galeria, com os passos, os papéis e um exemplo em cada densidade.

Fora do escopo:
- Espaço automático entre filhos (`GjaRow`/`GjaColumn`, specs próprias).
- Margem responsiva por classe de tamanho (`GjaResponsiveLayout`).
- Fundo, borda e raio (`GjaContainer`).
- Espaço negativo ou literal.

## Capabilities

### New Capabilities

- `gja/widgets/gja-spacing`: espaço nomeado por passo ou papel do tema, como separador horizontal ou vertical
  ou como padding direcional em volta de um filho, sensível à densidade.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/gja_widgets/lib/src/fundacao_layout/spacing/` e testes.
- **Galeria:** nova página "GjaSpacing".
- **Catálogo:** `gja/widgets/gja-spacing` → `implemented`. As dependências (`spacing` e `density`) ganham
  `theming`, que a spec referencia.
- **Portal existente:** sem impacto.
