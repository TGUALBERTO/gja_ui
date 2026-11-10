# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/foundation/color`. Esta change não entrega
widget público, então não há goldens. O contraste dos papéis é testado aqui. A acessibilidade dos widgets começa
em `add-gja-foundation-accessibility`.

## 1. Primitivos e estado de valor

- [x] 1.1 Criar `lib/src/color/primitives/color_primitives.dart` com as escalas de D1, `white`, `black`, `blackAlpha16/40/60` e os mapas ordenados por escala, com dartdoc `Nível: primitivo.`, e reexportá-lo em `gja_primitives.dart`. Verificação: testes "Escalas primitivas de cor — Ordem de luminância" e "Escalas primitivas de cor — Escalas fora da API dos widgets", e o teste de nível documentado passa.
- [x] 1.2 Criar `GjaValueState` (D3) e exportá-lo em `gja_foundation.dart`. Verificação: `dart analyze` sem issues. O enum tem exatamente os 5 valores (teste).

## 2. Contraste

- [x] 2.1 Implementar `gjaContrastRatio` e `gjaContrastRatioOver` (D4), com dartdoc. Verificação: testes "Cálculo de contraste — Extremos", "— Simetria" e "— Cor translúcida" (`ArgumentError` com mensagem que pede o fundo), além de um valor de referência conhecido (ex.: `#767676` sobre branco ≈ 4,54).

## 3. Papéis semânticos e mapeamentos

- [x] 3.1 Implementar `GjaValueStateColors` e `GjaColorTokens` (D2) com `copyWith`, `lerp`, `==`/`hashCode`, `debugFillProperties`, `stateColors` e os mapeamentos `const light()`/`dark()`, e exportá-los. Verificação: testes "Papéis semânticos de cor — Contrato do conjunto" (via `expectTokenSetContract`), "— Interpolação de cor", "Mapeamentos claro e escuro de referência — Papéis vêm dos primitivos", "— Polaridade do modo escuro", "Estado semântico de valor — Cores de erro" e "— Estado sem destaque", além de um teste que altera cada campo isoladamente.
- [x] 3.2 Implementar `gjaCheckContrast` e `GjaContrastIssue` (D4) com a lista de pares da spec. Verificação: testes "Contraste mínimo dos papéis — Pares de texto", "— Pares não textuais" (claro e escuro), "— Personalização que viola o contraste" e "— Papéis isentos".

## 4. Galeria

- [x] 4.1 Trocar o literal de cor do `WidgetsApp` e do `textStyle` pelos papéis de `GjaColorTokens.light()` (D5). Verificação: teste "Testes e documentação das cores — Galeria sem cor fixa", que lê `lib/main.dart` e não encontra `Color(0x`, e o teste de fumaça continua passando.
- [x] 4.2 Adicionar a página "Cores" (`pages/color_page.dart`) ao índice, com amostras dos papéis e dos estados nos dois modos e a razão de contraste dos pares de texto. Verificação: teste "Testes e documentação das cores — Página na galeria", que navega até a página e encontra `onSurface`, `primary` e `error` nos dois modos, com razões formatadas.

## 5. Catálogo, changelog e verificação final

- [x] 5.1 Atualizar `docs/catalog.yaml` (`gja/foundation/color` → `implemented`) e a seção "Não lançado" do `CHANGELOG.md` de `gja_foundation`. Verificação: `dart run gja_checks catalog` passa.
- [x] 5.2 Executar `tool/ci` (`dart analyze`, testes, `openspec validate --all --strict` e `gja_checks all`). Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-foundation-color`) após a revisão.
- Próximas changes da ordem sugerida, que dependem só de `design-tokens`: `add-gja-foundation-typography`, `-spacing`, `-radius`, `-breakpoints` e `-iconography`. Depois vem `-elevation`, que usará `shadow`/`scrim`.
