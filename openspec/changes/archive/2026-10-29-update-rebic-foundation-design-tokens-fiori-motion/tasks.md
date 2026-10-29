# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs alteradas.

## 1. Curvas

- [x] 1.1 Trocar as curvas de `RebicMotionPrimitives` pelas curvas CSS de D1 (`curveEaseInOut`, `curveEaseOut`, `curveEaseIn`) e apontar os papéis de `RebicMotionTokens.fallback` para elas. Atualizar o dartdoc e os testes `motion_tokens_test.dart` e `brand_customization_test.dart`. Verificação: "Tokens de movimento — Ordem das durações", "— Curvas CSS", "— Sem curvas do Material" e "— Widget anima sem literal".

## 2. Modo de animação

- [x] 2.1 Criar `RebicAnimationMode` com `reducesMotion` e `effective` (D2), exportado pelo fundamento, e mudar `RebicAccessibility.resolveMotion` para receber `mode:`. Verificação: "Movimento reduzido — Animações desativadas", "— Animações ativas" e "— Modo efetivo".
- [x] 2.2 Acrescentar `animationMode` a `RebicThemeData` e reescrever `resolve` conforme D4. Verificação: "Tema centralizado — Tema completo"; "Movimento reduzido no tema — Tema resolvido com redução", "— Modo do tema sem pedido da plataforma" e "— Tema sem redução"; "Tema na árvore de widgets — Animações desligadas pelo sistema" e "— Animações desligadas pelo tema"; os testes de contrato e interpolação do tema continuam passando.

## 3. Widgets

- [x] 3.1 `RebicTheme` passa a usar o modo efetivo para a troca imediata (D5). Adicionar testes de `RebicTheme` e da rota de `RebicApp` com um tema de modo `none` e o sistema com animações ligadas: a troca e a transição são imediatas. Verificação: os testes novos e os cenários "Movimento reduzido" existentes de `rebic-theme`, `rebic-app`, `rebic-scaffold`, `rebic-tooltip` e `rebic-progress-indicator`.
- [x] 3.2 Rodar os goldens de `rebic_widgets` (tag `golden`, Windows, ADR 0008). Regerar só os que mudarem por capturar um quadro intermediário de animação, conferindo a diferença. Verificação: `flutter test` em `packages/rebic_widgets`, com e sem a tag `golden`, sem falhas.

## 4. Galeria

- [x] 4.1 Atualizar as páginas "Design tokens" (nomes CSS das curvas) e "Acessibilidade" (durações nos quatro modos), com seus testes. Verificação: "Testes e documentação — Página na galeria" de `design-tokens` e "Testes e documentação da acessibilidade — Página na galeria".

## 5. Documentação, changelog e verificação final

- [x] 5.1 Acrescentar à ADR 0009 as linhas de D7.
- [x] 5.2 Atualizar os CHANGELOGs de `rebic_foundation` (**BREAKING**: curvas primitivas e `resolveMotion`; `RebicAnimationMode` e `RebicThemeData.animationMode` novos) e de `rebic_widgets` (o modo do tema também desliga as transições de `RebicApp` e `RebicTheme`).
- [x] 5.3 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-rebic-foundation-design-tokens-fiori-motion`) após a revisão.
- Próxima change de realinhamento da fundação: densidade (`cozy`, alturas de elemento 36/26, alvo 44).
