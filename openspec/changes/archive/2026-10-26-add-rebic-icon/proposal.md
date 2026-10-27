# Proposal: RebicIcon (`rebic/widgets/rebic-icon`)

## Why

O fundamento de iconografia já entrega a fonte Lucide empacotada, o catálogo semântico `RebicIcons` (40 ícones) com
espelhamento dos direcionais e os tamanhos `small` a `xLarge`, `inline` e `control`. Falta o widget que os usa. Hoje,
um ícone pede `Icon(...)` com tamanho e cor escolhidos à mão. Também não há regra para separar ícones decorativos
(fora da semântica) de ícones que carregam significado (com rótulo).

No SAPUI5, `sap.ui.core.Icon` cobre esse papel:
- `size` vem dos parâmetros de tema;
- `color` usa as cores semânticas (`Default`, `Positive`, `Negative`, `Critical`, `Neutral`);
- `decorative` decide se o ícone fica fora da acessibilidade;
- `alt` é o texto alternativo.

`RebicIcon` foi acrescentado no design da Fase 0 (★). `RebicIconButton`, `RebicButton`, `RebicTextField` e os
widgets de mensagem dependem dele.

## What Changes

- Widget `RebicIcon` em `rebic_widgets`:
  - recebe um `IconData` (do catálogo `RebicIcons` ou um ícone da aplicação, conforme o fundamento);
  - `size` escolhe um papel de tamanho dos tokens: `small`, `medium`, `large`, `xLarge`, `inline` ou `control`
    (padrão);
  - `tone` escolhe uma cor de papel: `standard`, `muted`, `brand` ou um estado de valor;
  - sem `semanticLabel`, o ícone é decorativo e fica fora da árvore de semântica. Com `semanticLabel`, é anunciado
    como imagem com esse rótulo;
  - os direcionais são espelhados em RTL, como define o fundamento;
  - o tamanho `inline` acompanha a escala de texto do sistema, para ficar alinhado ao texto. Os demais papéis
    mantêm o tamanho dos tokens.
- Goldens (tamanhos e tons, claro e escuro, nas duas densidades) com a infraestrutura da change anterior. O suporte de
  fontes dos testes passa a carregar também a Lucide.
- Página "RebicIcon" na galeria.

Fora do escopo:
- Ícone clicável (`RebicIconButton`, spec própria).
- Ícones fora da fonte, como imagens e SVG.
- Dica ao passar o ponteiro (`RebicTooltip`, spec própria).

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-icon`: ícone com papel de tamanho e cor do tema, decorativo ou com rótulo, espelhamento em
  RTL e alinhamento à escala de texto no papel `inline`.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:**
  - `packages/rebic_widgets/lib/src/fundacao_layout/icon/`, com testes e goldens;
  - `test/support/fonts.dart` carrega a Lucide.
- **Galeria:** nova página "RebicIcon".
- **Catálogo:** `rebic/widgets/rebic-icon` → `implemented`, com as dependências do `[Integração]` e o
  `proposed: true` mantido.
- **Portal existente:** sem impacto.
