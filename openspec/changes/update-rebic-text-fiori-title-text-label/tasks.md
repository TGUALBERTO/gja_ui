# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs alteradas. Os goldens são gerados com `density:` no
`RebicApp`.

## 1. Fundação de cor

- [ ] 1.1 Papel `required` em `RebicColorTokens`: campo, `copyWith`, `lerp`, `==`, `hashCode`, diagnóstico e
  mapeamentos claro (`red600`) e escuro (`red300`) (D5). Verificação: "Papéis semânticos de cor — Papéis do modelo
  Fiori", "— Contrato do conjunto" e "— Interpolação de cor" com `required`; `flutter test` em
  `packages/rebic_foundation`.
- [ ] 1.2 Par de contraste de `required` sobre `background`, `base` e `headerBackground` na verificação do
  fundamento. Verificação: "Contraste mínimo dos papéis — Pares de texto" passa nos dois mapeamentos.
- [ ] 1.3 ADR 0009 com a linha de `required` (vermelho no lugar do magenta de `sapField_RequiredColor`) e a do
  tamanho do asterisco (D4, D5), e CHANGELOG de `rebic_foundation`. Verificação: a linha cita a change.

## 2. Texto, título e rótulo

- [ ] 2.1 Reescrever `RebicText` (D2): `text`, `maxLines`, `wrapping`, `textAlign`; sem `variant`, `tone` e
  `heading`, e sem os enums. Verificação: um teste por cenário da spec `rebic-text`, incluindo "Texto sem quebra",
  "Leitor de tela", "Escala de texto 2,0" e "Contraste do texto"; goldens livre/truncado/sem quebra em claro e
  escuro, cozy e compacto, regerados.
- [ ] 2.2 `RebicTitle` e `RebicTitleLevel` em `fundacao_layout/title/` (D1, D3), com dartdoc e exportação.
  Verificação: um teste por cenário da spec `rebic-title`, com o `headingLevel` do `SemanticsNode` em "Leitor de
  tela no título" e "Nível sem efeito no estilo"; goldens dos sete estilos e de um título truncado em claro e
  escuro, cozy e compacto.
- [ ] 2.3 `RebicLabel` e `RebicLabelDesign` em `fundacao_layout/label/` (D1, D4), com dartdoc e exportação.
  Verificação: um teste por cenário da spec `rebic-label`, incluindo "Sinais com texto truncado" e "Leitor de tela
  no rótulo" ("Fornecedor:, Obrigatório"); goldens dos desenhos com e sem sinais em claro e escuro, cozy e
  compacto.
- [ ] 2.4 `docs/catalog.yaml`: entradas `rebic/widgets/rebic-title` e `rebic/widgets/rebic-label` (`implemented`), com as
  dependências das specs. Verificação: `dart run tool/rebic_checks all`
  sem erros de catálogo.

## 3. Migração dos widgets

- [ ] 3.1 `RebicPopover` (`RebicTitle`, estilo H4) e `RebicScaffold` (`RebicTitle`, estilo H3), com as dependências
  no catálogo. Verificação: "Popover sem Material", "Scaffold sem Material" e os testes existentes passam; goldens
  sem mudança.
- [ ] 3.2 `RebicTooltip` (`RebicText`) e `RebicStatusIndicator` (`RebicLabel` com `showColon`), com as dependências
  no catálogo. Verificação: "Aparência da dica", "Status com título e ícone" e "Status sem Material"; goldens sem
  mudança.
- [ ] 3.3 `RebicCard`, `RebicPage` e `RebicBadge` com `Text` e tokens do tema (D6). Verificação: "Cores da página"
  e os testes existentes de cartão, página e selo, incluindo os de cabeçalho; goldens sem mudança.
- [ ] 3.4 Exemplos de dartdoc de `RebicRow`, `RebicColumn`, `RebicContainer`, `RebicDivider` e `RebicSpacing`, e os
  testes de widgets que montam `RebicText` com variantes (dropdown, grid, column etc.). Verificação: `dart analyze`
  sem usos de `variant`, `tone` ou `heading`; `flutter test` em `packages/rebic_widgets`, com e sem a tag `golden`,
  com mudança só nos goldens de 2.1–2.3.
- [ ] 3.5 CHANGELOG de `rebic_widgets`: `RebicTitle`, `RebicLabel` e o de/para de `RebicText` (**BREAKING**).

## 4. Galeria

- [ ] 4.1 Páginas "RebicTitle", "RebicText" e "RebicLabel" registradas em `main.dart`, com os testes.
  Verificação: "Página RebicTitle na galeria", "Página RebicText na galeria" e "Página RebicLabel na galeria".
- [ ] 4.2 Migrar as demais páginas pela tabela de D7. Verificação: `dart analyze` e `flutter test` em
  `apps/rebic_gallery` sem falhas.

## 5. Verificação final

- [ ] 5.1 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-rebic-text-fiori-title-text-label`) após a revisão.
- Próximas changes do bloco de layout: ToolPage + ShellBar, Page, Card, Separator, FlexBox, Grid.
