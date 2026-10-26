# Proposal: Responsividade (`rebic/core/responsive`)

## Why

Os fundamentos já definem as classes de tamanho (`small` a `extraLarge`) e os limiares de largura, mas nada as
aplica a uma árvore de widgets. `RebicResponsiveLayout`, `RebicGrid`, `RebicScaffold` e todo widget com aparência
responsiva vão precisar saber em que classe estão. Vão precisar também escolher um valor por classe (colunas,
espaçamento, visibilidade) e decidir a densidade inicial pelo tipo de dispositivo.

No SAPUI5, isso vem do `sap.ui.Device.media`, com as faixas de largura da janela. Vem também de controles que
reagem à largura do próprio contêiner, como o `ResponsiveGridLayout` e a Object Page. Os spans por faixa
(`XL3 L4 M6 S12`) seguem a regra do menor para o maior, e a densidade é compacta em dispositivos de mouse e
confortável em dispositivos de toque. Sem esta infraestrutura, cada widget leria `MediaQuery` e compararia larguras
por conta própria.

## What Changes

- Em `rebic_core`, a classe de tamanho da tela, calculada pela largura da janela com os limiares dos fundamentos. Ela
  reconstrói só quem depende dela, quando a largura muda.
- O construtor `RebicResponsiveBuilder`, que entrega a classe de tamanho do espaço disponível para o próprio widget,
  e não a da tela.
- `RebicResponsiveValue<T>`: um valor por classe, com a classe menor como base e herança para as maiores (o
  equivalente aos spans `XL/L/M/S` do UI5).
- A densidade recomendada por plataforma: compacta em desktop e confortável em dispositivos de toque, com troca
  livre pela aplicação.
- Os limiares entram por parâmetro, com o mapeamento de referência como padrão, até `add-rebic-theme` fornecê-los pelo
  tema.
- Página "Responsividade" na galeria.

Fora do escopo:
- Os widgets de layout (`RebicResponsiveLayout` e `RebicGrid`), que são specs de widget próprias.
- A propagação de densidade e de tema por subárvore (`add-rebic-theme`).
- Orientação e altura da tela.

## Capabilities

### New Capabilities

- `rebic/core/responsive`: classe de tamanho da tela e do contêiner, valores por classe com herança e densidade
  recomendada por plataforma.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_core/lib/src/responsive/`, exportação em `rebic_core.dart` e testes em
  `packages/rebic_core/test/responsive/`.
- **Galeria:** nova página "Responsividade".
- **Catálogo:** `rebic/core/responsive` → `implemented`, dependendo de `rebic/foundation/breakpoints` (como no
  catálogo). A spec também referencia `rebic/foundation/density`, então essa dependência é acrescentada ao catálogo.
- **Dependências:** nenhum pacote novo; só `package:flutter/widgets.dart` e `foundation.dart`.
- **Portal existente:** sem impacto.
