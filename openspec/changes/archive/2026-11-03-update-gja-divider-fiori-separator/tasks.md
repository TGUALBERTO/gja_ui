# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Fundação

- [x] 1.1 Primitivo `size24` em `GjaDensityPrimitives` e dimensão `separatorHeight` em `GjaDensityTokens`
  (32 cozy, 24 compacto), em `dimensions`, `copyWith`, `lerp`, `==` e `hashCode`, com dartdoc e o CHANGELOG de
  `gja_foundation` (D3). Verificação: "Dimensões de controle por densidade — Valores de referência", "—
  Compacto não maior que confortável" e "— Escala primitiva de densidade"; `flutter test -j 2` em
  `packages/gja_foundation`.

## 2. Separador

- [x] 2.1 `GjaSeparator` em `fundacao_layout/separator/gja_separator.dart` (D1, D3, D4), com dartdoc e a
  exportação no lugar da do divisor; `fundacao_layout/divider/` sai, com testes e goldens. Verificação: um teste por
  cenário de `gja-separator` em `test/fundacao_layout/separator/`, incluindo a semântica, e os goldens das duas
  orientações nos temas claro e escuro e nas duas densidades (com `density:` no `GjaApp`).
- [x] 2.2 Card, lista de opções (dropdown e menu) e popover passam a usar `GjaSeparator()`, e os testes deles
  procuram `GjaSeparator` em vez de `GjaDivider`/`GjaDividerTone`. Verificação: "[Aparência] Itens e seções —
  Itens do menu", "[Aparência] Superfície, cabeçalho e rodapé — Superfície do popover" e os cenários de integração
  de card, dropdown, menu e popover; os goldens deles sem diferença.
- [x] 2.3 CHANGELOG de `gja_widgets` com o de/para: `GjaDivider` → `GjaSeparator`, saída de `tone`,
  `spacing`, `indent` e `endIndent`, e a altura do vertical.

## 3. Galeria e documentação

- [x] 3.1 Página "GjaSeparator" no lugar de "GjaDivider" (D5), com o teste "[Documentação] Exemplos mínimos —
  Página GjaSeparator na galeria"; a página do card usa `GjaSeparator`. Verificação: `flutter test -j 2` em
  `apps/gja_gallery`, incluindo `gallery_dark_theme_test.dart`.
- [x] 3.2 `docs/catalog.yaml`: sai `gja/widgets/gja-divider`; entra `gja/widgets/gja-separator` (P0, fase 1,
  `fundacao-layout`, `implemented`, dependências da spec); card, dropdown, menu e popover dependem dele.
  Verificação: `dart run gja_checks all` sem erros.

## 4. Verificação final

- [x] 4.1 Executar `tool/ci` e `flutter test -j 2 --tags golden` em `packages/gja_widgets`. Verificação: código
  de saída 0 nos dois, e nenhum golden muda além dos do separador.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-divider-fiori-separator`) após a revisão, com o merge dos deltas
  nas specs principais e a retirada de `gja/widgets/gja-divider`.
- Próximas changes do bloco de layout: FlexBox, Grid L3.
