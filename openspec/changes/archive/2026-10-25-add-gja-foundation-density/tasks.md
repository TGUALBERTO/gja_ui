# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/foundation/density`. Esta change não entrega
widget público, então não há goldens. A seleção de densidade por subárvore é de `theming`/`GjaTheme`.

## 1. Modos e conjunto de densidade

- [x] 1.1 Criar `GjaDensity` e `GjaDensityTokens` (D1, D2, D3) em `lib/src/density/`, com `comfortable()`/`compact()` constantes, `of`, `copyWith` com `assert`, `lerp`, `==`/`hashCode` e `debugFillProperties`, dartdoc com `Nível:`, e exportá-los. O teste de nível documentado passa a varrer `lib/src/density`. Verificação: testes "Modos de densidade — Mapeamento por modo"; "Dimensões de controle por densidade — Valores de referência" e "— Compacto não maior que confortável"; "Alvo mínimo de interação — Alvos dos mapeamentos de referência" e "— Alvo abaixo do mínimo rejeitado"; "Espaçamento por densidade — Espaçamento confortável" e "— Espaçamento compacto"; "Tipografia preservada — Rótulo cabe no controle" e "— Densidade sem estilos de texto"; "Contrato do conjunto de densidade — Contrato verificado" e "— Interpolação entre densidades"; e um teste que altera cada campo isoladamente.

## 2. Galeria

- [x] 2.1 Adicionar a página "Densidade" (`pages/density_page.dart`) ao índice (D5). Verificação: teste "Testes e documentação da densidade — Página na galeria", que encontra as duas colunas, os controles simulados com as alturas 40 e 32 e as medidas.

## 3. Catálogo, changelog e verificação final

- [x] 3.1 Atualizar `docs/catalog.yaml` (`gja/foundation/density` → `implemented`) e a seção "Não lançado" do `CHANGELOG.md` de `gja_foundation`. Verificação: `dart run gja_checks catalog` passa.
- [x] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-foundation-density`) após a revisão.
- Próximos fundamentos da ordem sugerida no design da Fase 0: `add-gja-foundation-elevation` (cor já pronta), depois `-interaction-states`, `-accessibility` e `-theming`.
