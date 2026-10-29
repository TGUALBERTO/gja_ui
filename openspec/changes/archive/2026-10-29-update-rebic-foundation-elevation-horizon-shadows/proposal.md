# Proposal: Sombras no modelo Horizon (`update-rebic-foundation-elevation-horizon-shadows`)

## Why

A auditoria de fidelidade ao SAPUI5 de 2026-10-28 deixou três heranças do Material no fundamento de elevação:
- **Nome.** "Elevação" é o vocabulário do Material. O SAPUI5 não tem elevação, só os parâmetros de sombra
  `sapContent_Shadow0`…`sapContent_Shadow3` e `sapContent_HeaderShadow`.
- **Geometria.** Cada sombra é um par "contato + ambiente", o modelo de luz do Material. No Horizon, `Shadow1` a
  `Shadow3` têm um contorno de 1 px e uma sombra difusa que cresce com a profundidade.
- **Papéis.** O popover usa `Shadow1` e o diálogo usa `Shadow2`. No Horizon, `sap.m.Popover` usa `Shadow2` e
  `sap.m.Dialog` usa `Shadow3`.

Esta é a terceira change da série de realinhamento da fundação, depois da tipografia e dos estados de interação.

## What Changes

- **BREAKING** O fundamento passa de `rebic/foundation/elevation` para `rebic/foundation/shadows`:
  - `RebicElevationTokens` → `RebicShadowTokens`;
  - `RebicElevationPrimitives` → `RebicShadowPrimitives`;
  - `RebicThemeData.elevation` → `RebicThemeData.shadows`;
  - `shadowsFor` → `boxShadows`;
  - pasta `src/elevation` → `src/shadows`.

  `RebicShadowLayer` mantém o nome.
- **BREAKING** Geometria Horizon:
  - `shadow0` tem duas camadas difusas curtas;
  - `shadow1` a `shadow3` têm um contorno de 1 px e uma camada difusa, com deslocamento e desfoque de 2/8, 10/30 e
    20/80;
  - `header` não muda.

  O deslocamento passa a crescer de forma não estrita, porque `shadow0` e `shadow1` têm o mesmo deslocamento no
  Horizon.
- **BREAKING** Papéis da referência:
  - `popover` passa a `shadow2` e `dialog` a `shadow3`;
  - `card` continua `shadow0` e `header` continua o primitivo `header`;
  - `dragged` passa a `shadow3`, igual a `dialog`. O SAPUI5 não define a sombra do item arrastado, e o valor é
    provisório.
- **BREAKING** `RebicContainer`: a propriedade `elevation` (`RebicElevation`) passa a `shadow` (`RebicShadow`), com os
  mesmos valores.
- A página "Elevação" da galeria passa a "Sombras" (`ShadowsPage`, rota `/shadows`).
- `docs/catalog.yaml`: o item `rebic/foundation/elevation` passa a `rebic/foundation/shadows`, com nome "Sombras", e
  as dependências dos widgets são atualizadas.
- ADR 0009: entram como provisórios a geometria das sombras (a opacidade vem de `colors.shadow`) e o papel
  `dragged`.

Fora do escopo:
- A cor `colors.shadow`, que continua `blackAlpha16` no claro e `blackAlpha40` no escuro. O Horizon usa uma cor de
  sombra azulada com opacidades diferentes por camada, mas trocá-la mexe na spec de cor e fica para quando os valores
  forem confirmados.
- Sombras de hover de cartões (`sap.f.Card` em hover usa `Shadow2`), que ficam para a change de realinhamento de
  `RebicCard`.

## Capabilities

### New Capabilities

- `rebic/foundation/shadows`: sombras `none`, `shadow0`…`shadow3` e `header` no modelo dos parâmetros
  `sapContent_Shadow*`, papéis `card`, `popover`, `dialog`, `dragged` e `header`, composição com a cor `shadow` do
  tema, contrato do conjunto e página "Sombras". Substitui `rebic/foundation/elevation`.

### Modified Capabilities

- `rebic/foundation/elevation`: todos os requisitos são removidos e a capability é retirada
  (`retire_capabilities: true`). Eles migram para `rebic/foundation/shadows`.
- `rebic/foundation/theming`: o tema reúne `rebic/foundation/shadows` e expõe "sombras" no lugar de "elevação".
- `rebic/spec-governance`: a lista de fundamentos obrigatórios troca `elevation` por `shadows`.
- `rebic/widgets/rebic-container`: propriedade `shadow` e enum `RebicShadow`, tokens `shadows.boxShadows`,
  dependência e página da galeria.
- `rebic/widgets/rebic-card`, `rebic/widgets/rebic-popover`, `rebic/widgets/rebic-scaffold` e
  `rebic/widgets/rebic-tooltip`: os requisitos de aparência citam `shadows.<papel>`, e os de integração citam
  `rebic/foundation/shadows`.

Esta change toca nove specs, cinco delas de widget, acima do limite de `rebic/spec-governance`. A exceção se justifica
como na change de tipografia: renomear um fundamento quebra todas as referências a ele. Sem atualizar as specs na
mesma change, elas citariam uma spec e tokens inexistentes. Só `RebicContainer` muda de API, porque a propriedade
leva o nome do fundamento.

## Impact

- `packages/rebic_foundation`:
  - pasta `src/elevation` → `src/shadows`, primitivos, tokens, tema, exports e teste de nível de token;
  - testes e CHANGELOG.
- `packages/rebic_widgets`:
  - código: `RebicContainer` (propriedade e enum), `RebicCard`, `RebicPopover`, `RebicTooltip` e `RebicScaffold`;
  - testes e goldens com sombra: cartão, popover, menu, dropdown, tooltip, scaffold, página e contêiner. Esses
    goldens são regerados;
  - CHANGELOG.
- `apps/rebic_gallery`: página "Sombras" (renomeada) e as páginas que usam `elevation`, com seus testes.
- `tool/rebic_checks`: o teste da verificação de tokens que cita `elevation.shadowsFor`. A regra de literais continua
  rejeitando `elevation:`, que é o parâmetro do Material.
- `docs/catalog.yaml` e ADR 0009.
- Sem efeito em `rebic_core` e no portal.
