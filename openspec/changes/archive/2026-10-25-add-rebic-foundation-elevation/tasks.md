# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/foundation/elevation`. Esta change não entrega
widget público, então não há goldens nem testes de acessibilidade.

## 1. Geometria e primitivos

- [x] 1.1 Criar `RebicShadowLayer` (D1) e `RebicElevationPrimitives` (D2) em `lib/src/elevation/`, com dartdoc `Nível: primitivo.`, exportando a camada em `rebic_foundation.dart` e os níveis em `rebic_primitives.dart`. O teste de nível documentado passa a varrer `lib/src/elevation`. Verificação: testes "Escala primitiva de sombras — Profundidade crescente" e "— Fatores de opacidade válidos", e um teste de `RebicShadowLayer.lerp`.

## 2. Conjunto semântico

- [x] 2.1 Implementar `RebicElevationTokens` (D3) com `fallback()` constante, `shadowsFor`, `copyWith` com `assert`, `lerp`, `==`/`hashCode` e `debugFillProperties`, e exportá-lo. Verificação: testes "Níveis e papéis de elevação — Papéis do mapeamento de referência"; "Sombras com a cor do tema — Sombra com a cor do modo" e "— Nível sem sombra"; "Contrato do conjunto de elevação — Contrato verificado" e "— Interpolação a partir de nível sem sombra"; e um teste que altera cada campo isoladamente.

## 3. Verificação de tokens

- [x] 3.1 Adicionar a `tool/rebic_checks/test/tokens_test.dart` os testes "Uso de elevação sem literais nos widgets — Widget usa sombra dos tokens" e "— Widget com sombra literal". Verificação: `dart test` em `tool/rebic_checks` passa.

## 4. Galeria

- [x] 4.1 Adicionar a página "Elevação" (`pages/elevation_page.dart`) ao índice (D5). Verificação: teste "Testes e documentação da elevação — Página na galeria", que encontra os oito nomes nos dois modos e confere o número de sombras de cada cartão.

## 5. Catálogo, changelog e verificação final

- [x] 5.1 Atualizar `docs/catalog.yaml` (`rebic/foundation/elevation` → `implemented`) e a seção "Não lançado" do `CHANGELOG.md` de `rebic_foundation`. Verificação: `dart run rebic_checks catalog` passa.
- [x] 5.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-foundation-elevation`) após a revisão.
- Próximo fundamento: `add-rebic-foundation-interaction-states`, que depende de `color` e `elevation`.
