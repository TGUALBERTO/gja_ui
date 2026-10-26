# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/foundation/interaction-states`. Esta change não
entrega widget público, então não há goldens. Detectar estados e desenhar o anel de foco é tarefa de `core/interaction`.

## 1. Primitivos e estados

- [x] 1.1 Criar `RebicInteractionPrimitives` (D4) e `RebicInteractionState` (D3) em `lib/src/interaction_states/`, com dartdoc `Nível:`, exportando os primitivos em `rebic_primitives.dart` e a enum em `rebic_foundation.dart`. O teste de nível documentado passa a varrer `lib/src/interaction_states`. Verificação: teste "Estados de interação — Conjunto de estados" e um teste de ordem e nome das escalas primitivas.

## 2. Conjunto semântico e regras

- [x] 2.1 Implementar `RebicInteractionStateTokens` (D2, D3) com `fallback()` constante, `overlayOpacity`, `overlayColor`, `showsFocusRing`, `elevationLevel`, `copyWith` com `assert`, `lerp`, `==`/`hashCode` e `debugFillProperties`, e exportá-lo. Verificação: testes "Camada de estado — Cor da camada"; "Combinação de estados — Estados isolados", "— Seleção combinada" e "— Desabilitado anula a camada"; "Anel de foco — Visibilidade do anel" e "— Espessura mínima"; "Aparência desabilitada — Opacidade de desabilitado"; "Elevação em interação — Níveis resultantes" e "— Limite superior e base inválida"; "Contrato do conjunto de estados — Contrato verificado" e "— Mapeamento inválido rejeitado"; e um teste que altera cada campo isoladamente.
- [x] 2.2 Escrever o teste "Contraste preservado nos estados — Pares de texto com a camada máxima" (D5), nos modos claro e escuro. Verificação: o teste passa, e falha com `maxOverlayOpacity` 0,28 (verificado manualmente uma vez).

## 3. Galeria

- [x] 3.1 Adicionar a página "Estados" (`pages/states_page.dart`) ao índice (D6). Verificação: teste "Testes e documentação dos estados — Página na galeria", que encontra os oito rótulos nos dois modos e confere a cor da camada de "selecionado + hover" e a presença do anel só em "foco".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (`rebic/foundation/interaction-states` → `implemented`) e a seção "Não lançado" do `CHANGELOG.md` de `rebic_foundation`. Verificação: `dart run rebic_checks catalog` passa.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-foundation-interaction-states`) após a revisão.
- Próximo fundamento: `add-rebic-foundation-accessibility`, que depende de `color`, `typography` e `density`, todos já prontos.
