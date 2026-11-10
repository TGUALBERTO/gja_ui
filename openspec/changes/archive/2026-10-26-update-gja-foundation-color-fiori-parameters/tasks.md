# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs modificadas. Os testes que citavam cenários removidos
são substituídos pelos novos.

## 1. Cores

- [x] 1.1 Renomear e ampliar os papéis de `GjaColorTokens` (D1), adicionar a primitiva `transparent` e atualizar `gjaCheckContrast` e os testes de cor (cenários "Papéis do modelo Fiori", "Contrato do conjunto", "Interpolação de cor", "Papéis vêm dos primitivos", "Polaridade do modo escuro", os quatro de contraste e o teste que altera cada campo). Verificação: `flutter test` em `gja_foundation` passa nos testes de cor.

## 2. Estados de interação

- [x] 2.1 Substituir a camada de opacidade pelas famílias (D2): `GjaControlFamily`, `GjaStateColors`, `GjaControlColors.of`/`resolve`, `GjaInteractionStateTokens` com `disabledOpacity`, `focusWidth` e `focusOffset`, e `gjaCheckStateContrast` (D4). Remover as opacidades de camada, o teto e a elevação em interação. Verificação: testes "Famílias de controle" (4 cenários), "Resolução de cores por estado" (3), "Aparência desabilitada", "Contraste de texto nos estados", "Contrato do conjunto de estados" (2) e "Anel de foco" (2).

## 3. Tema e núcleo

- [x] 3.1 Atualizar `GjaThemeData.accessibilityIssues()` (D4) e os testes de tema (cenários "Tema de marca válido" e "inválido" com `brand`/`contrastText`, e "Troca animada" com `base`), e `GjaInteractable`/`GjaFocusRing` para os nomes novos (D3). Verificação: `flutter test` em `gja_foundation` e `gja_core` passa.

## 4. Galeria, catálogo e documentação

- [x] 4.1 Atualizar as páginas da galeria ("Cores", "Estados" com as famílias, "Tema", "Interação", "Densidade", "Elevação", "Acessibilidade" e demais usos) e os testes delas para os papéis e famílias novos. Verificação: `flutter test` em `apps/gja_gallery` passa, e nenhum arquivo do repositório usa os nomes antigos (`onSurface`, `primaryContainer`, `scrim`, `overlayOpacity`).
- [x] 4.2 Remover `gja/foundation/elevation` das dependências de `gja/foundation/interaction-states` em `docs/catalog.yaml` e reescrever o Purpose da spec principal `interaction-states` (D5). Atualizar o `CHANGELOG.md` de `gja_foundation` e de `gja_core` com a tabela de/para. Verificação: `dart run gja_checks catalog` e `specs` passam.
- [x] 4.3 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change. O sync aplica os MODIFIED, ADDED e REMOVED nas specs `color`, `interaction-states` e `theming`.
- Em seguida: `update-gja-foundation-elevation-fiori-shadows`.
