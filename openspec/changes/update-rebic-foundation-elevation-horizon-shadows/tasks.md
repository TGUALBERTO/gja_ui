# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs alteradas.

## 1. Fundamento

- [ ] 1.1 Mover `lib/src/elevation/` para `lib/src/shadows/` e renomear conforme D1 (`RebicShadowTokens`, `RebicShadowPrimitives.values`, `boxShadows`, `RebicThemeData.shadows`), atualizando exports, `theme_data.dart` e `token_level_doc_test.dart`. O dartdoc de cada sombra cita o parâmetro `sapContent_Shadow*`. Verificação: `dart analyze` sem problemas e `grep -ri elevation packages/rebic_foundation/lib` vazio.
- [ ] 1.2 Aplicar a geometria de D2 aos primitivos e os papéis de D3 a `RebicShadowTokens.fallback`. Mover os testes para `test/shadows/` com os nomes novos. Verificação: "Escala primitiva de sombras — Profundidade crescente" e "— Fatores de opacidade válidos"; "Geometria no modelo Horizon — Contorno nas sombras de sobreposição" e "— Cartão sem contorno"; "Sombras e papéis — Papéis do mapeamento de referência" e "— Sem vocabulário do Material"; "Sombras com a cor do tema — Sombra com a cor do modo" e "— Sombra vazia"; "Contrato do conjunto de sombras — Contrato verificado" e "— Interpolação a partir de sombra vazia".
- [ ] 1.3 Atualizar `theme_data_test.dart`. Verificação: "Tema centralizado — Tema completo" e "Temas de referência claro e escuro — Claro e escuro diferem só na cor".

## 2. Widgets

- [ ] 2.1 Renomear `RebicElevation` para `RebicShadow` e `RebicContainer.elevation` para `shadow`, usando `shadows.boxShadows`. Atualizar `RebicCard`, `RebicPopover`, `RebicTooltip` e `RebicScaffold`. Verificação: "[API] Propriedades — Uso mínimo", "[API] Valores dos papéis — Papéis do fundamento" e "[Aparência] Tokens de componente — Raio e sombra" de `rebic-container`; os cenários de aparência de cartão, popover, scaffold e dica; `grep -ri elevation packages/rebic_widgets/lib` vazio, exceto o parâmetro do Material que a verificação de tokens proíbe.
- [ ] 2.2 Regerar no Windows (tag `golden`, ADR 0008) os goldens que mudam com a nova geometria, nos temas claro e escuro e nas duas densidades. Conferir por amostragem o contorno de 1 px e a sombra difusa do popover. Se alguma sombra for cortada pelo limite da amostra, dar margem à amostra no teste (risco de D2). Verificação: `flutter test` em `packages/rebic_widgets`, com e sem a tag `golden`, sem falhas.

## 3. Galeria

- [ ] 3.1 Renomear a página "Elevação" para "Sombras" (`ShadowsPage`, `/shadows`, `shadows_page_test.dart`) e atualizar as páginas de contêiner, grade, tema e sobreposição e seus testes. Verificação: "Testes e documentação das sombras — Página na galeria", "[Documentação] Exemplos mínimos — Página RebicContainer na galeria" e `gallery_dark_theme_test.dart`.

## 4. Ferramentas e catálogo

- [ ] 4.1 `rebic_checks catalog`: dispensar do catálogo a spec principal cujos requisitos são todos removidos por uma change ativa com `retire_capabilities: true` (D4), com teste em `tool/rebic_checks/test`. Atualizar o teste da verificação de tokens para `shadows.boxShadows`. Verificação: "Uso de sombras sem literais nos widgets — Widget usa sombra dos tokens" e "— Widget com sombra literal"; `dart test` em `tool/rebic_checks`.
- [ ] 4.2 `docs/catalog.yaml`: o item `rebic/foundation/elevation` passa a `rebic/foundation/shadows` ("Sombras"), e os `depends_on` passam ao id novo. Verificação: `dart run rebic_checks catalog` e `dart run rebic_checks specs`.

## 5. Documentação, changelog e verificação final

- [ ] 5.1 Acrescentar à ADR 0009 as linhas de D6.
- [ ] 5.2 Atualizar os CHANGELOGs de `rebic_foundation` e `rebic_widgets` com a tabela de/para de D1 (**BREAKING**), a nova geometria e os novos papéis.
- [ ] 5.3 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-rebic-foundation-elevation-horizon-shadows`) após a revisão. O sync deve criar `openspec/specs/rebic/foundation/shadows/spec.md` e apagar `openspec/specs/rebic/foundation/elevation/spec.md`.
- Próxima change de realinhamento da fundação: movimento (curvas e `AnimationMode`).
