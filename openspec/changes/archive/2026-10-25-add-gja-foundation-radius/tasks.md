# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/foundation/radius`. Esta change não entrega
widget público, então não há goldens nem testes de acessibilidade.

## 1. Primitivos

- [x] 1.1 Criar `lib/src/radius/primitives/radius_primitives.dart` (D1), com dartdoc `Nível: primitivo.`, e reexportá-lo em `gja_primitives.dart`. O teste de nível documentado passa a varrer `lib/src/radius`. Verificação: testes "Escala primitiva de raios — Escala em ordem" e "Formato de pílula — Valor finito".

## 2. Conjunto semântico

- [x] 2.1 Implementar `GjaRadiusTokens` (D2, D3) com `fallback()` constante, `copyWith` com `assert`, `lerp`, `==`/`hashCode` e `debugFillProperties`, e exportá-lo em `gja_foundation.dart`. Verificação: testes "Formato de pílula — Pílula em um controle" (D4); "Passos e papéis semânticos de raio — Ordem dos passos", "— Papéis apontam para passos" e "— Valor negativo rejeitado"; "Contrato do conjunto de raios — Contrato verificado", "— Interpolação de um papel" e "— Valores vêm dos primitivos"; e um teste que altera cada campo isoladamente.

## 3. Verificação de tokens

- [x] 3.1 Adicionar a `tool/gja_checks/test/tokens_test.dart` os testes "Uso de raios sem literais nos widgets — Widget usa raio sem literal" e "— Widget com raio literal". Verificação: `dart test` em `tool/gja_checks` passa.

## 4. Galeria

- [x] 4.1 Adicionar a página "Raios" (`pages/radius_page.dart`) ao índice (D5). Verificação: teste "Testes e documentação dos raios — Página na galeria", que encontra os nove nomes com seus valores.

## 5. Catálogo, changelog e verificação final

- [x] 5.1 Atualizar `docs/catalog.yaml` (`gja/foundation/radius` → `implemented`) e a seção "Não lançado" do `CHANGELOG.md` de `gja_foundation`. Verificação: `dart run gja_checks catalog` passa.
- [x] 5.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-foundation-radius`) após a revisão.
- Próximas changes, na ordem combinada: `add-gja-foundation-breakpoints`, `-iconography` (Lucide) e depois `-density`.
