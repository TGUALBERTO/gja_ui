# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Fundação

- [x] 1.1 Escala `magenta` em `RebicColorPrimitives` e `required` em `magenta600`/`magenta300` (D1), com o
  CHANGELOG de `rebic_foundation`. Verificação: "Escalas primitivas de cor — Escala magenta" e "— Ordem de
  luminância", "Contraste mínimo dos papéis — Pares de texto" e "Mapeamentos claro e escuro de referência — Papéis
  vêm dos primitivos"; `flutter test` em `packages/rebic_foundation`.

## 2. Rótulo

- [x] 2.1 Asterisco com `large` em negrito e `spacing.xxs` antes (D2), com os goldens do rótulo regerados e o
  CHANGELOG de `rebic_widgets`. Verificação: "[Aparência] Estilo e cor — Desenhos e sinais" e os demais cenários de
  `rebic-label`; `flutter test` em `packages/rebic_widgets`, com e sem a tag `golden`, com mudança só nos goldens
  do rótulo.
- [x] 2.2 ADR 0009 sem as linhas da cor do `required` e do tamanho do asterisco. Verificação: `dart run
  rebic_checks all` sem erros.

## 3. Verificação final

- [x] 3.1 Executar `tool/ci` e `flutter test --tags golden` em `packages/rebic_widgets`. Verificação: código de
  saída 0 nos dois.

## Workflow follow-up

- Arquivar a change após a revisão.
