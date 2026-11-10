# Proposal: Sombras no modelo Horizon (`update-gja-foundation-elevation-horizon-shadows`)

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

- **BREAKING** O fundamento passa de `gja/foundation/elevation` para `gja/foundation/shadows`:
  - `GjaElevationTokens` → `GjaShadowTokens`;
  - `GjaElevationPrimitives` → `GjaShadowPrimitives`;
  - `GjaThemeData.elevation` → `GjaThemeData.shadows`;
  - `shadowsFor` → `boxShadows`;
  - pasta `src/elevation` → `src/shadows`.

  `GjaShadowLayer` mantém o nome.
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
- **BREAKING** `GjaContainer`: a propriedade `elevation` (`GjaElevation`) passa a `shadow` (`GjaShadow`), com os
  mesmos valores.
- A página "Elevação" da galeria passa a "Sombras" (`ShadowsPage`, rota `/shadows`).
- `docs/catalog.yaml`: o item `gja/foundation/elevation` passa a `gja/foundation/shadows`, com nome "Sombras", e
  as dependências dos widgets são atualizadas.
- ADR 0009: entram como provisórios a geometria das sombras (a opacidade vem de `colors.shadow`) e o papel
  `dragged`.

Fora do escopo:
- A cor `colors.shadow`, que continua `blackAlpha16` no claro e `blackAlpha40` no escuro. O Horizon usa uma cor de
  sombra azulada com opacidades diferentes por camada, mas trocá-la mexe na spec de cor e fica para quando os valores
  forem confirmados.
- Sombras de hover de cartões (`sap.f.Card` em hover usa `Shadow2`), que ficam para a change de realinhamento de
  `GjaCard`.

## Capabilities

### New Capabilities

- `gja/foundation/shadows`: sombras `none`, `shadow0`…`shadow3` e `header` no modelo dos parâmetros
  `sapContent_Shadow*`, papéis `card`, `popover`, `dialog`, `dragged` e `header`, composição com a cor `shadow` do
  tema, contrato do conjunto e página "Sombras". Substitui `gja/foundation/elevation`.

### Modified Capabilities

- `gja/foundation/elevation`: todos os requisitos são removidos e a capability é retirada
  (`retire_capabilities: true`). Eles migram para `gja/foundation/shadows`.
- `gja/foundation/theming`: o tema reúne `gja/foundation/shadows` e expõe "sombras" no lugar de "elevação".
- `gja/spec-governance`: a lista de fundamentos obrigatórios troca `elevation` por `shadows`.
- `gja/widgets/gja-container`: propriedade `shadow` e enum `GjaShadow`, tokens `shadows.boxShadows`,
  dependência e página da galeria.
- `gja/widgets/gja-card`, `gja/widgets/gja-popover`, `gja/widgets/gja-scaffold` e
  `gja/widgets/gja-tooltip`: os requisitos de aparência citam `shadows.<papel>`, e os de integração citam
  `gja/foundation/shadows`.

Esta change toca nove specs, cinco delas de widget, acima do limite de `gja/spec-governance`. A exceção se justifica
como na change de tipografia: renomear um fundamento quebra todas as referências a ele. Sem atualizar as specs na
mesma change, elas citariam uma spec e tokens inexistentes. Só `GjaContainer` muda de API, porque a propriedade
leva o nome do fundamento.

## Impact

- `packages/gja_foundation`:
  - pasta `src/elevation` → `src/shadows`, primitivos, tokens, tema, exports e teste de nível de token;
  - testes e CHANGELOG.
- `packages/gja_widgets`:
  - código: `GjaContainer` (propriedade e enum), `GjaCard`, `GjaPopover`, `GjaTooltip` e `GjaScaffold`;
  - testes e goldens com sombra: cartão, popover, menu, dropdown, tooltip, scaffold, página e contêiner. Esses
    goldens são regerados;
  - CHANGELOG.
- `apps/gja_gallery`: página "Sombras" (renomeada) e as páginas que usam `elevation`, com seus testes.
- `tool/gja_checks`: o teste da verificação de tokens que cita `elevation.shadowsFor`. A regra de literais continua
  rejeitando `elevation:`, que é o parâmetro do Material.
- `docs/catalog.yaml` e ADR 0009.
- Sem efeito em `gja_core` e no portal.
