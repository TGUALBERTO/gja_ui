# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs alteradas.

## 1. Cores dos estados de valor

- [ ] 1.1 Adicionar `hoverBackground` a `RebicValueStateColors` (construtor, `copyWith`, `lerp`, `==`, `hashCode`, diagnóstico, dartdoc citando `sapButton_<Tipo>_Hover_Background`) e aos mapeamentos claro e escuro conforme a tabela de D1. Verificação: testes "Estado semântico de valor — Cores de erro", "— Estado sem destaque" e "— Hover distinto do fundo" em `color_tokens_test.dart`, e "Mapeamentos claro e escuro de referência — Papéis vêm dos primitivos" continua passando.
- [ ] 1.2 Incluir em `contrast_check.dart` o par `foreground` sobre `hoverBackground` de cada estado de valor. Verificação: "Contraste mínimo dos papéis — Pares de texto" nos dois mapeamentos, e "— Personalização que viola o contraste" continua passando.

## 2. Estados de interação

- [ ] 2.1 Remover `dragged` de `RebicInteractionState` e de `RebicControlColors.resolve`, atualizando o dartdoc (D3). Verificação: "Estados de interação — Conjunto de estados" e "— Sem estado de arraste" em `interaction_primitives_test.dart`; "Resolução de cores por estado — Estados isolados", "— Seleção combinada" e "— Desabilitado usa o normal".
- [ ] 2.2 Reduzir `RebicInteractionPrimitives.opacities` a `opacity40` (D4) e manter o teste de escala dos primitivos passando. Verificação: `grep` não encontra os primitivos removidos no repositório, e "Aparência desabilitada — Opacidade de desabilitado" continua passando.
- [ ] 2.3 Reescrever `RebicControlColors._semantic` conforme D1 e D2: hover com o `hoverBackground` do estado, e ativo, selecionado e selecionado com hover com (`foreground`, `foreground`, `background`). Verificação: "Famílias de controle — Famílias accept, reject e attention" e "— Ações semânticas sem cores da marca"; "Contraste de texto nos estados — Texto de todos os estados" (`state_contrast_test.dart`) continua passando nos dois modos.

## 3. Widgets

- [ ] 3.1 Rodar os testes de `rebic_widgets` e os goldens de `RebicButton` (tag `golden`, Windows, ADR 0008) nos temas claro e escuro e nas duas densidades. Regerar só os goldens afetados por Accept, Reject ou Attention em hover ou ativo, conferindo a diferença. Verificação: `flutter test` em `packages/rebic_widgets` com e sem a tag `golden` termina sem falhas.

## 4. Galeria

- [ ] 4.1 Mostrar as sete famílias na página "Estados" (D5) e atualizar `states_page_test.dart`. Verificação: "Testes e documentação dos estados — Página na galeria" e `gallery_dark_theme_test.dart`.

## 5. Documentação, changelog e verificação final

- [ ] 5.1 Acrescentar à ADR 0009 as linhas de D6.
- [ ] 5.2 Atualizar os CHANGELOGs de `rebic_foundation` (**BREAKING**: `dragged`, primitivos de opacidade, `hoverBackground` obrigatório) e de `rebic_widgets` (mudança visual de Accept, Reject e Attention). O catálogo não muda: os itens continuam `implemented`. Verificação: `dart run rebic_checks catalog`.
- [ ] 5.3 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-rebic-foundation-interaction-states-fiori-alignment`) após a revisão.
- Próxima change de realinhamento da fundação: sombras (renomear elevação, popover → Shadow2, dialog → Shadow3).
