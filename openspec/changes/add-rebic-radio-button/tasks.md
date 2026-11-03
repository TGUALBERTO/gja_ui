# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Opção e grupo

- [ ] 1.1 `RebicRadioButton` em `formularios/radio_button/` (D1), com dartdoc e exportação. Verificação: um teste
  por cenário de `rebic-radio-button`, a bateria de acessibilidade, goldens e rastreabilidade.
- [ ] 1.2 `RebicRadioButtonGroup` (D2), com dartdoc e exportação. Verificação: um teste por cenário de
  `rebic-radio-button-group` e rastreabilidade.
- [ ] 1.3 CHANGELOG de `rebic_widgets`.

## 2. Galeria e documentação

- [ ] 2.1 Página "RebicRadioButton" na galeria, com os testes da página.
- [ ] 2.2 Catálogo e ADR 0009. Verificação: `dart run rebic_checks all`.

## 3. Verificação final

- [ ] 3.1 Etapas de `tool/ci` (com `flutter test -j 2`) e `--tags golden`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change após a revisão.
