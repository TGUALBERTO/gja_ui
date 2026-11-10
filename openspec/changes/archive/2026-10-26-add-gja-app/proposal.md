# Proposal: GjaApp (`gja/widgets/gja-app`)

## Why

Hoje, uma aplicação GJA precisa montar à mão um `WidgetsApp` com:
- os delegates e os idiomas de `GjaLocalizations`;
- o `GjaTheme`;
- o `GjaScreenSizeScope`;
- uma rota de página sem Material;
- a cor obrigatória do `WidgetsApp`.

A galeria faz isso em `main.dart`, com um comentário de "provisória até existir `GjaApp`". Cada aplicação
repetiria essa montagem e poderia esquecer uma parte, ficando, por exemplo, sem localização ou sem escopo de tela.

A arquitetura também usa `GjaApp` como a árvore de referência: os widgets MUST funcionar "em uma árvore criada
apenas com `GjaApp`". Duas decisões foram deixadas para ele:
- seguir o brilho do sistema operacional (`GjaTheme` não faz isso);
- aplicar a densidade recomendada pela plataforma.

No SAPUI5, `sap.m.App` e o *bootstrap* fazem esse papel:
- carregam o tema (`sap_horizon` ou `sap_horizon_dark`, que pode seguir o sistema);
- aplicam a densidade (`sapUiSizeCompact` em desktop);
- pintam o fundo da aplicação (`sapBackgroundColor`);
- fazem a navegação entre páginas com transição.

## What Changes

- Widget `GjaApp` em `gja_widgets`, sobre `WidgetsApp`, com dois construtores:
  - `GjaApp`: navegação por rotas (`home`, `routes`, `initialRoute`, `onGenerateRoute`, `navigatorKey`);
  - `GjaApp.router`: com `routerConfig`, para aplicações que usam `Router` (por exemplo, `go_router`).
- Tema:
  - `theme` e `darkTheme`, com `themeMode` (`system`, `light`, `dark`);
  - no modo `system`, segue o brilho do sistema operacional;
  - a troca é animada pelo `GjaTheme`.
- Densidade: `density` define a densidade da aplicação; sem ela, vale a densidade recomendada pela plataforma
  (compacta em desktop, confortável em toque).
- Localização:
  - registra `GjaLocalizations` depois dos delegates da aplicação;
  - os idiomas suportados são, por padrão, os do GJA;
  - `locale` permite fixar um idioma.
- Envolve as rotas no escopo de tela, com os limiares do tema, e pinta o fundo `background` do tema atrás das rotas.
- Transição de página sem Material:
  - deslizamento a partir do lado final, com a duração `medium` e a curva `standard`;
  - imediata com movimento reduzido.
- A galeria passa a usar `GjaApp` e ganha, no índice, a escolha do modo de tema (sistema, claro, escuro) e da
  densidade.

Fora do escopo:
- Barra de navegação, menu lateral e cabeçalho, que são do `GjaScaffold` (spec própria).
- Transições por tipo de navegação (modal, detalhe) e gestos de voltar por arrasto.
- Persistência da escolha de tema ou densidade.

## Capabilities

### New Capabilities

- `gja/widgets/gja-app`: raiz da aplicação GJA sobre `WidgetsApp`, com navegação por rotas ou por `Router`,
  tema claro/escuro com modo do sistema, densidade recomendada, localização, escopo de tela, fundo e transição de
  página sem Material.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:**
  - `packages/gja_widgets/lib/src/fundacao_layout/app/`, com exportação em `gja_widgets.dart` e testes;
  - `apps/gja_gallery/lib/main.dart` migra para `GjaApp`.
- **Catálogo:** `gja/widgets/gja-app` → `implemented`. As dependências passam a incluir `gja/core/responsive`
  (escopo de tela e densidade recomendada), além das já listadas.
- **Dependências:** nenhum pacote novo; só `package:flutter/widgets.dart`.
- **Compatibilidade:** só adições.
- **Portal existente:** sem impacto.
