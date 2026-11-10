# Proposal: GjaResponsiveLayout (`gja/widgets/gja-responsive-layout`)

## Why

O núcleo já informa a classe de tamanho, da tela (`GjaResponsive.screenSizeClassOf`) ou do espaço disponível
(`GjaResponsiveBuilder`), e resolve valores por classe (`GjaResponsiveValue`). Mas montar um layout diferente
por classe ainda pede código à mão: ler a classe, escolher um ramo e repetir a herança da classe menor. Exemplos:
- um formulário em uma coluna no celular e em duas no desktop;
- uma lista que vira tabela;
- uma barra lateral que só aparece em telas largas.

`GjaScaffold` depende dessa peça, conforme o design da Fase 0, e `GjaGrid` vem logo depois.

No SAPUI5, os controles responsivos trocam a apresentação pela faixa de largura:
- a `sap.ui.layout.form.ResponsiveGridLayout` e o `sap.m.Table` com `demandPopin`;
- o `sap.f.FlexibleColumnLayout`, que é a versão avançada.

Para `GjaResponsiveLayout`, o design da Fase 0 previu uma versão básica na Fase 1 e a avançada (colunas
flexíveis) na Fase 4. Esta change é a básica: um construtor de conteúdo por classe de tamanho, com herança da classe
menor.

## What Changes

- Enum `GjaLayoutBasis`:
  - `container` (padrão): mede a largura disponível para o próprio widget;
  - `screen`: usa a classe da tela.
- Widget `GjaResponsiveLayout` em `gja_widgets`:
  - `small` obrigatório; `medium`, `large` e `extraLarge` opcionais;
  - uma classe sem construtor usa o da maior classe menor que tenha um, como `GjaResponsiveValue`;
  - a classe é medida conforme `basis`, com os limiares do tema ativo;
  - ao trocar de classe, o conteúdo é reconstruído com o novo construtor. Dentro da mesma classe, o construtor é o
    mesmo.
- Página "GjaResponsiveLayout" na galeria, com um formulário de exemplo que muda de uma para duas colunas.

Fora do escopo:
- Colunas flexíveis e mestre-detalhe (`sap.f.FlexibleColumnLayout`): Fase 4.
- Grade de 12 colunas (`GjaGrid`, próxima change).
- Animação entre layouts.
- Preservar o estado de widgets que mudam de lugar entre layouts.

## Capabilities

### New Capabilities

- `gja/widgets/gja-responsive-layout`: conteúdo diferente por classe de tamanho, com herança da classe menor e
  medida pelo contêiner ou pela tela, com os limiares do tema.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/gja_widgets/lib/src/fundacao_layout/responsive_layout/` e testes.
- **Galeria:** nova página "GjaResponsiveLayout".
- **Catálogo:** `gja/widgets/gja-responsive-layout` → `implemented`. A dependência existente
  (`gja/core/responsive`) ganha `gja/foundation/breakpoints` e `gja/foundation/theming`.
- **Portal existente:** sem impacto.
