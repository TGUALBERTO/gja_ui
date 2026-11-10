# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs alteradas. Os goldens são gerados com `density:` no
`GjaApp`.

## 1. Fundação de cor

- [x] 1.1 Papel `required` em `GjaColorTokens`: campo, `copyWith`, `lerp`, `==`, `hashCode`, diagnóstico e
  mapeamentos claro (`red600`) e escuro (`red300`) (D5). Verificação: "Papéis semânticos de cor — Papéis do modelo
  Fiori", "— Contrato do conjunto" e "— Interpolação de cor" com `required`; `flutter test` em
  `packages/gja_foundation`.
- [x] 1.2 Par de contraste de `required` sobre `background`, `base` e `headerBackground` na verificação do
  fundamento. Verificação: "Contraste mínimo dos papéis — Pares de texto" passa nos dois mapeamentos.
- [x] 1.3 ADR 0009 com a linha de `required` (vermelho no lugar do magenta de `sapField_RequiredColor`) e a do
  tamanho do asterisco (D4, D5), e CHANGELOG de `gja_foundation`. Verificação: a linha cita a change.

## 2. Texto, título e rótulo

- [x] 2.1 Reescrever `GjaText` (D2): `text`, `maxLines`, `wrapping`, `textAlign`; sem `variant`, `tone` e
  `heading`, e sem os enums. Verificação: um teste por cenário da spec `gja-text`, incluindo "Texto sem quebra",
  "Leitor de tela", "Escala de texto 2,0" e "Contraste do texto"; goldens livre/truncado/sem quebra em claro e
  escuro, cozy e compacto, regerados.
- [x] 2.2 `GjaTitle` e `GjaTitleLevel` em `fundacao_layout/title/` (D1, D3), com dartdoc e exportação.
  Verificação: um teste por cenário da spec `gja-title`, com o `headingLevel` do `SemanticsNode` em "Leitor de
  tela no título" e "Nível sem efeito no estilo"; goldens dos sete estilos e de um título truncado em claro e
  escuro, cozy e compacto.
- [x] 2.3 `GjaLabel` e `GjaLabelDesign` em `fundacao_layout/label/` (D1, D4), com dartdoc e exportação.
  Verificação: um teste por cenário da spec `gja-label`, incluindo "Sinais com texto truncado" e "Leitor de tela
  no rótulo" ("Fornecedor:, Obrigatório"); goldens dos desenhos com e sem sinais em claro e escuro, cozy e
  compacto.
- [x] 2.4 `docs/catalog.yaml`: entradas `gja/widgets/gja-title` e `gja/widgets/gja-label` (`implemented`), com as
  dependências das specs. Verificação: `dart run tool/gja_checks all`
  sem erros de catálogo.

## 3. Migração dos widgets

- [x] 3.1 `GjaPopover` (`GjaTitle`, estilo H4) e `GjaScaffold` (`GjaTitle`, estilo H3), com as dependências
  no catálogo. Verificação: "Popover sem Material", "Scaffold sem Material" e os testes existentes passam; goldens
  sem mudança.
- [x] 3.2 `GjaTooltip` (`GjaText`) e `GjaStatusIndicator` (`GjaLabel` com `showColon`), com as dependências
  no catálogo. Verificação: "Aparência da dica", "Status com título e ícone" e "Status sem Material"; goldens sem
  mudança.
- [x] 3.3 `GjaCard`, `GjaPage` e `GjaBadge` com `Text` e tokens do tema (D6). Verificação: "Cores da página"
  e os testes existentes de cartão, página e selo, incluindo os de cabeçalho; goldens sem mudança.
- [x] 3.4 Exemplos de dartdoc de `GjaRow`, `GjaColumn`, `GjaContainer`, `GjaDivider` e `GjaSpacing`, e os
  testes de widgets que montam `GjaText` com variantes (dropdown, grid, column etc.). Verificação: `dart analyze`
  sem usos de `variant`, `tone` ou `heading`; `flutter test` em `packages/gja_widgets`, com e sem a tag `golden`,
  com mudança só nos goldens de 2.1–2.3.
- [x] 3.5 CHANGELOG de `gja_widgets`: `GjaTitle`, `GjaLabel` e o de/para de `GjaText` (**BREAKING**).

## 4. Galeria

- [x] 4.1 Páginas "GjaTitle", "GjaText" e "GjaLabel" registradas em `main.dart`, com os testes.
  Verificação: "Página GjaTitle na galeria", "Página GjaText na galeria" e "Página GjaLabel na galeria".
- [x] 4.2 Migrar as demais páginas pela tabela de D7. Verificação: `dart analyze` e `flutter test` em
  `apps/gja_gallery` sem falhas.

## 5. Verificação final

- [x] 5.1 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-text-fiori-title-text-label`) após a revisão.
- Próximas changes do bloco de layout: ToolPage + ShellBar, Page, Card, Separator, FlexBox, Grid.
