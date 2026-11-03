# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Fundação

- [ ] 1.1 Primitivo `size24` em `RebicDensityPrimitives` e dimensão `separatorHeight` em `RebicDensityTokens`
  (32 cozy, 24 compacto), em `dimensions`, `copyWith`, `lerp`, `==` e `hashCode`, com dartdoc e o CHANGELOG de
  `rebic_foundation` (D3). Verificação: "Dimensões de controle por densidade — Valores de referência", "—
  Compacto não maior que confortável" e "— Escala primitiva de densidade"; `flutter test -j 2` em
  `packages/rebic_foundation`.

## 2. Separador

- [ ] 2.1 `RebicSeparator` em `fundacao_layout/separator/rebic_separator.dart` (D1, D3, D4), com dartdoc e a
  exportação no lugar da do divisor; `fundacao_layout/divider/` sai, com testes e goldens. Verificação: um teste por
  cenário de `rebic-separator` em `test/fundacao_layout/separator/`, incluindo a semântica, e os goldens das duas
  orientações nos temas claro e escuro e nas duas densidades (com `density:` no `RebicApp`).
- [ ] 2.2 Card, lista de opções (dropdown e menu) e popover passam a usar `RebicSeparator()`, e os testes deles
  procuram `RebicSeparator` em vez de `RebicDivider`/`RebicDividerTone`. Verificação: "[Aparência] Itens e seções —
  Itens do menu", "[Aparência] Superfície, cabeçalho e rodapé — Superfície do popover" e os cenários de integração
  de card, dropdown, menu e popover; os goldens deles sem diferença.
- [ ] 2.3 CHANGELOG de `rebic_widgets` com o de/para: `RebicDivider` → `RebicSeparator`, saída de `tone`,
  `spacing`, `indent` e `endIndent`, e a altura do vertical.

## 3. Galeria e documentação

- [ ] 3.1 Página "RebicSeparator" no lugar de "RebicDivider" (D5), com o teste "[Documentação] Exemplos mínimos —
  Página RebicSeparator na galeria"; a página do card usa `RebicSeparator`. Verificação: `flutter test -j 2` em
  `apps/rebic_gallery`, incluindo `gallery_dark_theme_test.dart`.
- [ ] 3.2 `docs/catalog.yaml`: sai `rebic/widgets/rebic-divider`; entra `rebic/widgets/rebic-separator` (P0, fase 1,
  `fundacao-layout`, `implemented`, dependências da spec); card, dropdown, menu e popover dependem dele.
  Verificação: `dart run rebic_checks all` sem erros.

## 4. Verificação final

- [ ] 4.1 Executar `tool/ci` e `flutter test -j 2 --tags golden` em `packages/rebic_widgets`. Verificação: código
  de saída 0 nos dois, e nenhum golden muda além dos do separador.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-rebic-divider-fiori-separator`) após a revisão, com o merge dos deltas
  nas specs principais e a retirada de `rebic/widgets/rebic-divider`.
- Próximas changes do bloco de layout: FlexBox, Grid L3.
