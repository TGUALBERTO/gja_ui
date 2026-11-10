# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/foundation/spacing`. Esta change não entrega
widget público, então não há goldens nem testes de acessibilidade.

## 1. Primitivos

- [x] 1.1 Criar `lib/src/spacing/primitives/spacing_primitives.dart` (D1), com dartdoc `Nível: primitivo.`, e reexportá-lo em `gja_primitives.dart`. Verificação: testes "Escala primitiva de espaçamento — Grade de 4 pixels" e "— Nome corresponde ao valor". O teste de nível documentado passa a varrer também `lib/src/spacing`.

## 2. Conjunto semântico

- [x] 2.1 Implementar `GjaSpacingTokens` (D2, D3) com `fallback()` constante, `copyWith` com `assert` de valores finitos e não negativos, `lerp`, `==`/`hashCode` e `debugFillProperties`, e exportá-lo em `gja_foundation.dart`. Verificação: testes "Passos semânticos de espaçamento — Ordem dos passos" e "— Valor negativo rejeitado"; "Papéis de layout — Papéis apontam para passos" e "— Hierarquia dos papéis"; "Contrato do conjunto de espaçamento — Contrato verificado", "— Interpolação de um passo" e "— Valores vêm dos primitivos"; e um teste que altera cada campo isoladamente.

## 3. Verificação de tokens

- [x] 3.1 Adicionar a `tool/gja_checks/test/tokens_test.dart` os testes "Uso sem literais nos widgets — Widget usa espaçamento sem literal" e "— Widget com espaçamento literal" (D4). Verificação: `dart test` em `tool/gja_checks` passa.

## 4. Galeria

- [x] 4.1 Adicionar a página "Espaçamentos" (`pages/spacing_page.dart`) ao índice (D5). Verificação: teste "Testes e documentação dos espaçamentos — Página na galeria", que encontra `xxs` a `xxxl` e os quatro papéis com seus valores.

## 5. Catálogo, changelog e verificação final

- [x] 5.1 Atualizar `docs/catalog.yaml` (`gja/foundation/spacing` → `implemented`) e a seção "Não lançado" do `CHANGELOG.md` de `gja_foundation`. Verificação: `dart run gja_checks catalog` passa.
- [x] 5.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-foundation-spacing`) após a revisão.
- Próximas changes, na ordem combinada: `add-gja-foundation-typography` (Inter), `-radius`, `-breakpoints` e `-iconography` (Lucide). Em seguida, `-density`.
