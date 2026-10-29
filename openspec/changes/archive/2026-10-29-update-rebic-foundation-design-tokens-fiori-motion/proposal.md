# Proposal: Movimento no modelo SAPUI5 (`update-rebic-foundation-design-tokens-fiori-motion`)

## Why

A auditoria de fidelidade ao SAPUI5 de 2026-10-28 achou duas heranças do Material no movimento:
- **Curvas.** As curvas de referência `Cubic(0.4, 0, 0.2, 1)`, `Cubic(0, 0, 0.2, 1)` e `Cubic(0.4, 0, 1, 1)` são o
  "standard", o "decelerate" e o "accelerate" do Material. Os controles do SAPUI5 animam com as curvas CSS
  `ease-in-out`, `ease-out` e `ease-in`.
- **Redução de animações.** Ela é só um booleano vindo da plataforma. O SAPUI5 tem o modo de animação
  `sap.ui.core.AnimationMode` (`full`, `basic`, `minimal` e `none`), que a aplicação configura
  (`sap-ui-animation-mode`) e os controles consultam.

Esta é a quarta change da série de realinhamento da fundação, depois de tipografia, estados de interação e sombras.

## What Changes

- **BREAKING** Curvas primitivas com os nomes e os valores das curvas CSS:

  | Antes | Agora |
  |---|---|
  | `curveStandard` `(0.4, 0, 0.2, 1)` | `curveEaseInOut` `(0.42, 0, 0.58, 1)` |
  | `curveDecelerate` `(0, 0, 0.2, 1)` | `curveEaseOut` `(0, 0, 0.58, 1)` |
  | `curveAccelerate` `(0.4, 0, 1, 1)` | `curveEaseIn` `(0.42, 0, 1, 1)` |

  Os papéis `standard`, `enter` e `exit` mantêm os nomes e passam a apontar para `ease-in-out`, `ease-out` e
  `ease-in`. As durações não mudam.
- Novo enum `RebicAnimationMode` com `full`, `basic`, `minimal` e `none`, como `sap.ui.core.AnimationMode`, e o
  conceito de **movimento reduzido**: modo efetivo `minimal` ou `none`.
- `RebicThemeData` ganha `animationMode`, `full` por padrão. O modo efetivo é o mais restritivo entre o do tema e o
  da plataforma: com animações desligadas no sistema, ele é `none`.
- **BREAKING** `RebicAccessibility.resolveMotion(motion, disableAnimations:)` passa a
  `resolveMotion(motion, mode:)`. Com `full` ou `basic`, os tokens ficam iguais. Com `minimal` ou `none`, as durações
  valem zero e as curvas são mantidas.
- `RebicThemeData.resolve(disableAnimations:)` mantém a assinatura e passa a combinar o modo do tema com o da
  plataforma. O tema resolvido expõe o modo efetivo.
- `RebicApp` e `RebicTheme` passam a decidir a transição imediata pelo modo efetivo, e não só pelo
  `MediaQuery.disableAnimations`. Assim, um tema com `animationMode: none` também desliga as transições.
- Galeria:
  - a página "Design tokens" mostra as curvas pelos nomes CSS;
  - a página "Acessibilidade" mostra as durações em cada modo de animação.
- ADR 0009 ganha estas linhas provisórias:
  - as durações, sem mudança;
  - `basic` igual a `full`, porque o Rebic ainda não tem animações "caras";
  - `minimal` igual a `none` nas durações, porque o indicador de progresso fica parado com movimento reduzido.

Fora do escopo:
- O atraso da dica, que hoje usa `motion.long` e por isso vai a zero com movimento reduzido. Atraso não é animação. A
  correção fica para a change de realinhamento de `RebicTooltip`.
- Uma propriedade `animationMode` em `RebicApp`. O modo vem do tema (`theme`/`darkTheme`), como os demais aspectos
  visuais.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/foundation/design-tokens`: o requisito "Tokens de movimento" passa às curvas CSS e proíbe as curvas do
  Material.
- `rebic/foundation/accessibility`: "Movimento reduzido" passa ao modo de animação, com o efeito de cada modo, e a
  página "Acessibilidade" mostra os quatro modos.
- `rebic/foundation/theming`:
  - o tema expõe o modo de animação;
  - a resolução combina o modo do tema com o da plataforma;
  - a leitura do tema ativo aplica o modo efetivo.

As specs de widget não mudam: elas falam em "movimento reduzido", que passa a ser definido pelo modo efetivo em
`rebic/foundation/accessibility`.

## Impact

- `packages/rebic_foundation`: primitivos e tokens de movimento, `RebicAnimationMode` (pasta `accessibility`),
  `RebicAccessibility.resolveMotion`, `RebicThemeData` (`animationMode`, `resolve`, `of`), testes e CHANGELOG.
- `packages/rebic_widgets`:
  - `RebicApp` (rota) e `RebicTheme` (troca animada) passam a usar o modo efetivo, com testes do modo vindo do tema;
  - CHANGELOG.

  Goldens só mudam se capturarem um quadro intermediário de animação, por exemplo o indeterminado do indicador de
  progresso. Nesse caso são regerados.
- `apps/rebic_gallery`: páginas "Design tokens" e "Acessibilidade" e seus testes.
- `docs/adr/0009-provisional-horizon-values.md`.
- Sem efeito em `rebic_core`, no catálogo e no portal.
