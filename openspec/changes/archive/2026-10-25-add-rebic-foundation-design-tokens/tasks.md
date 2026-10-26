# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/foundation/design-tokens`.
Não há goldens nem testes de acessibilidade: esta change não entrega widget público, e a página da galeria é
de demonstração. A acessibilidade dos widgets começa em `add-rebic-foundation-accessibility`.

## 1. Contrato e helpers

- [x] 1.1 Criar `lib/src/tokens/lerp.dart` com `lerpDurationValue` e `lerpDiscrete` (D5), sem exportação. Verificação: testes unitários de extremos, ponto médio (100 ms → 300 ms em 0,5 = 200 ms) e troca discreta em 0,49/0,5.
- [x] 1.2 Criar `RebicTokenSet<T>` em `lib/src/tokens/token_set.dart` (D1), com dartdoc que contenha a linha `Nível:` e um exemplo completo de conjunto, e exportá-lo em `rebic_foundation.dart`. Verificação: `dart analyze` sem issues.
- [x] 1.3 Criar o helper de teste `test/support/token_set_contract.dart` (`expectTokenSetContract`: `copyWith()` igual ao original, extremos de `lerp`, `lerp(null)`, igualdade e `hashCode`). Verificação: o helper é exercitado por um conjunto de teste mínimo, e os testes passam.

## 2. Primitivos e movimento

- [x] 2.1 Criar `lib/src/tokens/primitives/motion_primitives.dart` (durações 0–500 ms e curvas `curveStandard`, `curveDecelerate` e `curveAccelerate`) e a biblioteca `lib/rebic_primitives.dart`, sem reexportá-la em `rebic_foundation.dart`. Verificação: teste "Nomenclatura dos tokens — Primitivo identificado pela escala" (nomes `durationN` em ordem crescente de valor).
- [x] 2.2 Implementar `RebicMotionTokens` (D3) com `fallback()`, `copyWith`, `lerp`, `==`/`hashCode`, `debugFillProperties` e asserts de ordem. Verificação: testes de "Três níveis de tokens — Token semântico derivado de primitivo", "Conjuntos de tokens imutáveis" (2 cenários), "Igualdade por valor" (2), "Interpolação entre conjuntos" (4), "Tokens de movimento — Ordem das durações" e "Inspeção dos tokens — Propriedades no diagnóstico", além de `expectTokenSetContract` e de um teste que altera cada campo isoladamente.
- [x] 2.3 Escrever o teste "Primitivos isolados da camada de widgets — Aplicação personaliza a marca": monta um `RebicMotionTokens` com primitivos importando só `rebic_primitives.dart` e `rebic_foundation.dart`. Verificação: o teste passa e não importa `src/`.

## 3. Extensões tipadas

- [x] 3.1 Implementar `RebicTokenExtension<T>` e `RebicTokenExtensions` (D4) em `lib/src/tokens/token_extensions.dart`, com dartdoc e exemplo de extensão da aplicação, e exportá-los. Verificação: testes "Extensões tipadas da aplicação" — "Extensão registrada", "Extensão ausente", "Interpolação das extensões" e "Registro duplicado" (asserção com o nome do tipo), além de `expectTokenSetContract` em uma extensão de teste.

## 4. Isolamento verificado (`tool/rebic_checks`)

- [x] 4.1 Adicionar a regra de D6 em `architecture_check.dart`: em pacotes diferentes de `rebic_foundation`, `import`/`export` de `package:rebic_foundation/rebic_primitives.dart` ou de `package:rebic_foundation/src/` é violação, com arquivo e linha. Verificação: testes em `architecture_test.dart` com fixtures (widget importa primitivos → falha com linha, que é o cenário "Widget importa primitivos"; `core` importa `src/` → falha; `rebic_ui` exporta primitivos → falha, que é o cenário "Agregador não expõe primitivos"; `rebic_foundation` importa a própria biblioteca → aceito).
- [x] 4.2 Documentar a regra nova em `tool/rebic_checks/README.md`. Verificação: `dart run rebic_checks architecture` na raiz retorna 0.

## 5. Nível documentado

- [x] 5.1 Escrever o teste "Três níveis de tokens — Nível documentado" (D7): varre `lib/src/tokens/**` e exige `Nível: primitivo|semântico|componente.` no dartdoc de toda classe pública. Verificação: o teste passa, e falha ao remover a linha de uma classe (verificado manualmente uma vez).

## 6. Galeria

- [x] 6.1 Transformar a página inicial da galeria em índice com rotas nomeadas e adicionar a página "Design tokens" (D8): tabela de papéis de movimento e animação de `lerp` entre `fallback()` e o conjunto lento. Verificação: teste de widget "Testes e documentação — Página na galeria", que navega até a página e encontra os papéis `instant`, `short`, `medium` e `long`. O teste de fumaça continua garantindo que não há ancestrais Material.

## 7. Catálogo, changelog e verificação final

- [x] 7.1 Atualizar `docs/catalog.yaml` (`rebic/foundation/design-tokens` → `implemented`) e o `CHANGELOG.md` de `rebic_foundation` (seção "Não lançado": contrato de tokens, movimento e extensões; a versão sobe no release, sincronizada entre os pacotes). Verificação: `dart run rebic_checks catalog` passa.
- [x] 7.2 Executar `tool/ci` (`dart analyze`, testes, `openspec validate --all --strict` e `rebic_checks all`). Verificação: código de saída 0. Os cenários "Nomenclatura dos tokens — Revisão de nome semântico" e "Tokens de movimento — Widget anima sem literal" são verificados na revisão da change e por `rebic_checks tokens`, respectivamente, e registrados no resumo do PR.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-foundation-design-tokens`) após a revisão. O status `implemented` só passa a ser coerente com a spec principal depois do archive.
- Próxima change da ordem sugerida: `add-rebic-foundation-color`.
