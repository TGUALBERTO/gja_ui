# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change. Os goldens são gerados nos temas claro e
escuro e nas duas densidades (`goldenThemes`).

## 1. Fundação e núcleo

- [x] 1.1 `GjaIcons.grid` (Lucide `grip`), com as entradas em `iconPoolNames` e no mapa por nome (D6), e o
  CHANGELOG de `gja_foundation`. Verificação: os testes de catálogo de ícones passam com o ícone novo; `flutter
  test` em `packages/gja_foundation`.
- [x] 1.2 Textos `menu`, `logo`, `notifications`, `profile`, `products` e `shellBar` em `GjaLocalizations`
  (pt-BR e en) (D8), com o CHANGELOG de `gja_core`. Verificação: "Textos do framework — Textos da barra" e os
  demais cenários de "Textos do framework"; `flutter test` em `packages/gja_core`.

## 2. GjaShellBar

- [x] 2.1 `GjaShellBar` em `fundacao_layout/shell_bar/`: propriedades, botões, callbacks, contador,
  ícone inicial e perfil `xs` (D4, D6), com dartdoc e exportação. Verificação: os cenários de "[API]
  Propriedades", "[API] Botões da barra", "[API] Callbacks e controlador" e "[Comportamento] Contador de
  notificações".
- [x] 2.2 Títulos com `CustomMultiChildLayout`, margem pela classe da largura e tokens (D4, D5). Verificação:
  "[Comportamento] Espaço insuficiente — Títulos truncados", os cenários de "[Aparência] Superfície e margem" e de
  "[Aparência] Títulos e botões", e "[Responsividade] Largura, densidade e direção".
- [x] 2.3 Estados, teclado, semântica (D7), contraste e alvo da barra. Verificação: os cenários de "[Estados]",
  "[Acessibilidade] Teclado e foco", "[Acessibilidade] Semântica" e "[Acessibilidade] Contraste e alvo" (contraste
  num arquivo sem a fonte Inter, como nos demais widgets); os cenários de "[Integração]" e "[Restrições]"; goldens
  da barra completa e da barra só com título; teste de rastreabilidade com a contagem de cenários da spec.

## 3. GjaToolPage

- [x] 3.1 `GjaToolPage` em `fundacao_layout/tool_page/`: propriedades, escopo, `sideExpandedOf`,
  `toggleSideContentMode` e estado automático mantido (D2), com dartdoc (exemplo com `GjaShellBar`) e
  exportação. Verificação: os cenários de "[API] Propriedades", "[API] Callbacks e controlador" e
  "[Comportamento] Estado automático".
- [x] 3.2 Layout ao lado, na tela `small` e com vários conteúdos principais, com a animação e as exclusões de foco e
  semântica (D3). Verificação: os cenários de "[Comportamento] Conteúdo lateral ao lado", "[Comportamento] Conteúdo
  lateral na tela pequena", "[Comportamento] Vários conteúdos principais", "[Aparência]", "[Estados]",
  "[Acessibilidade]", "[Responsividade]", "[Integração]" e "[Restrições]"; goldens com `GjaShellBar`, conteúdo
  lateral expandido e conteúdo principal; teste de rastreabilidade.
- [x] 3.3 Remover `fundacao_layout/scaffold/` e os testes e goldens do scaffold. Atualizar a mensagem do `assert` da
  `GjaPage` e os testes de página ("[Integração] Dependências de widgets e hospedeiro — Página na página de
  ferramentas") e de botão de ícone ("[Integração] Dependências e uso — Barra e página usam o botão de ícone").
  Verificação: `dart analyze` sem referências a `GjaScaffold`; `flutter test` em `packages/gja_widgets`, com e
  sem a tag `golden`, com mudança só nos goldens novos.
- [x] 3.4 `docs/catalog.yaml` (sai `gja-scaffold`; entram `gja-tool-page` P0/fase 1 e `gja-shell-bar`
  P1/fase 2, ambos `implemented`), ADR 0009 (D9) e CHANGELOG de `gja_widgets` com o de/para (**BREAKING**).
  Verificação: `dart run gja_checks all` sem erros.

## 4. Galeria

- [x] 4.1 Páginas "GjaToolPage" (demonstração com barra, navegação de demonstração e conteúdo) e
  "GjaShellBar" (barra completa, só com título e estreita), registradas em `main.dart` no lugar de
  "GjaScaffold", com os testes. Verificação: "[Documentação] Exemplos mínimos — Página GjaToolPage na galeria" e
  "— Página GjaShellBar na galeria".
- [x] 4.2 Página "GjaPage", que hospedava a página no scaffold, passa ao `GjaToolPage`. Verificação: `flutter
  test` em `apps/gja_gallery` sem falhas, incluindo `gallery_dark_theme_test.dart`.

## 5. Verificação final

- [x] 5.1 Executar `tool/ci` e `flutter test --tags golden` em `packages/gja_widgets`. Verificação: código de
  saída 0 nos dois.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-scaffold-fiori-tool-page`) após a revisão, sincronizando as specs e
  retirando `gja/widgets/gja-scaffold`.
- Próximas changes do bloco de layout: Page, Card, Separator, FlexBox, Grid L3.
