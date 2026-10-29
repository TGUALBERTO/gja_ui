# Changelog

## Não lançado

- **BREAKING** Breakpoints no modelo SAPUI5 (`update-rebic-foundation-breakpoints-fiori-ranges`, spec
  `rebic/foundation/breakpoints`): `RebicBreakpointPrimitives` passa a ter só `width600`, `width1024` e `width1440`, os
  limites das faixas do `sap.ui.Device.media` (`SAP_STANDARD_EXTENDED`). Saem `width360`, `width840`, `width1280` e
  `width1920`. O dartdoc de `RebicSizeClass` cita as faixas S, M, L e XL (Phone, Tablet, Desktop e LargeDesktop).
- **BREAKING** Ícones no modelo do IconPool (`update-rebic-foundation-iconography-fiori-iconpool`, spec
  `rebic/foundation/iconography`): `RebicIcons` passa aos nomes do IconPool do SAPUI5 em camelCase. Os desenhos
  continuam os da Lucide.

    | Antes | Agora | Antes | Agora |
    |---|---|---|---|
    | `close` | `decline` | `clock` | `pending` |
    | `check` | `accept` | `user` | `personPlaceholder` |
    | `chevronUp`/`Down`/`Left`/`Right` | `slimArrowUp`/`Down`/`Left`/`Right` | `settings` | `actionSettings` |
    | `arrowLeft` | `navBack` | `externalLink` | `popupWindow` |
    | `arrowRight` | `navigationRightArrow` | `visibility` | `show` |
    | `menu` | `menu2` | `visibilityOff` | `hide` |
    | `moreHorizontal` | `overflow` | `logout` | `log` |
    | `info` | `information` | `notification` | `bell` |
    | `success` | `sysEnter2` | `file` | `document` |
    | `help` | `sysHelp` | `folder` | `folderBlank` |

  - Os nomes `add`, `search`, `edit`, `delete`, `warning`, `error`, `calendar`, `filter`, `sort`, `upload`,
    `download`, `refresh`, `home` e `copy` não mudam.
  - `moreVertical` foi removido: o IconPool não tem reticências verticais.
  - Novo `RebicIcons.iconPoolNames`, com o nome `sap-icon://` de cada ícone.
  - `RebicIconTokens.control` passa de 20 a 16 (`sapContent_IconHeight`).

  Valores provisórios na ADR 0009.
- **BREAKING** Raios no modelo Fiori (`update-rebic-foundation-radius-fiori-roles`, spec `rebic/foundation/radius`):
  os papéis `control` e `container` de `RebicRadiusTokens` dão lugar aos raios por tipo de controle do Horizon.

    | Papel | Parâmetro Fiori | Referência |
    |---|---|---|
    | `button` | `sapButton_BorderCornerRadius` | 8 |
    | `field` | `sapField_BorderCornerRadius` | 4 |
    | `popover` | `sapPopover_BorderCornerRadius` | 8 |
    | `element` | `sapElement_BorderCornerRadius` | 12 |
    | `tile` | `sapTile_BorderCornerRadius` | 16 |

  Antes, `control` valia 4 e `container` valia 8. Valores provisórios na ADR 0009.
- Espaçamento no modelo Fiori (`update-rebic-foundation-spacing-fiori-margins`, specs `rebic/foundation/spacing` e
  `rebic/foundation/density`):
  - `RebicSpacingTokens` ganha `pageMarginMedium`, `pageMarginLarge`, `pageMarginExtraLarge` e
    `pageMarginFor(RebicSizeClass)`, com 16, 32, 32 e 48 na referência (`sapUiResponsivePadding`). `pageMargin`
    continua sendo a margem da classe S.
  - O dartdoc dos passos `s`, `l`, `xxl` e `xxxl` cita as classes de margem `sapUiTinyMargin`…`sapUiLargeMargin`.
  - **BREAKING (visual)** A densidade compacta passa a usar o espaçamento de referência. A densidade muda só as alturas
    de elemento, como no Fiori.

  Valores provisórios na ADR 0009.
- **BREAKING** Densidade no modelo Fiori (`update-rebic-foundation-density-fiori-cozy`, spec `rebic/foundation/density`):
  `RebicDensity.comfortable` passa a `RebicDensity.cozy` (`sapUiSizeCozy`), e `RebicDensityTokens.comfortable()` a
  `RebicDensityTokens.cozy()`. Medidas dos parâmetros `sapElement_*`:

    | | Cozy (antes → agora) | Compact (antes → agora) |
    |---|---|---|
    | `controlHeight` | 40 → 36 | 32 → 26 |
    | `listItemHeight` | 48 → 44 | 32 |
    | `minTargetSize` | 48 → 44 | 24 → 32 |

  - Novos primitivos `RebicDensityPrimitives` (`size26`, `size32`, `size36`, `size44`).
  - `RebicAccessibility.defaultMinTargetSize` passa a 44.
  - A regra "o rótulo cabe no controle" passa a usar a linha de `base` mais 2 × `xxs`.

  Valores provisórios na ADR 0009.
- **BREAKING** Movimento no modelo SAPUI5 (`update-rebic-foundation-design-tokens-fiori-motion`, specs
  `rebic/foundation/design-tokens`, `rebic/foundation/accessibility` e `rebic/foundation/theming`):

    | Antes | Agora |
    |---|---|
    | `RebicMotionPrimitives.curveStandard` `(0.4, 0, 0.2, 1)` | `curveEaseInOut` `(0.42, 0, 0.58, 1)` |
    | `RebicMotionPrimitives.curveDecelerate` `(0, 0, 0.2, 1)` | `curveEaseOut` `(0, 0, 0.58, 1)` |
    | `RebicMotionPrimitives.curveAccelerate` `(0.4, 0, 1, 1)` | `curveEaseIn` `(0.42, 0, 1, 1)` |
    | `RebicAccessibility.resolveMotion(motion, disableAnimations:)` | `resolveMotion(motion, mode:)` |

  - Os papéis `standard`, `enter` e `exit` passam às curvas CSS `ease-in-out`, `ease-out` e `ease-in`; novo mapa
    `RebicMotionPrimitives.curves`.
  - Novo `RebicAnimationMode` (`full`, `basic`, `minimal`, `none`), como `sap.ui.core.AnimationMode`, com
    `reducesMotion` e `effective`.
  - `RebicThemeData.animationMode` (padrão `full`). `resolve` e `of` aplicam o modo efetivo: o do tema ou, com
    animações desligadas na plataforma, `none`.

  Valores provisórios na ADR 0009.
- **BREAKING** Sombras no modelo Horizon (`update-rebic-foundation-elevation-horizon-shadows`, spec
  `rebic/foundation/shadows`, que substitui `rebic/foundation/elevation`):

    | Antes | Agora |
    |---|---|
    | `src/elevation/` | `src/shadows/` |
    | `RebicElevationTokens` | `RebicShadowTokens` |
    | `RebicElevationPrimitives.shadows` | `RebicShadowPrimitives.values` |
    | `RebicThemeData.elevation` | `RebicThemeData.shadows` |
    | `shadowsFor(level, color)` | `boxShadows(shadow, color)` |

  - Geometria dos parâmetros `sapContent_Shadow*`: `shadow0` com duas camadas difusas curtas; `shadow1` a `shadow3`
    com contorno de 1 px e uma camada difusa (2/8, 10/30 e 20/80). Sai o par "contato + ambiente" do Material.
  - Papéis como no Horizon: `popover` passa de `shadow1` a `shadow2`, `dialog` de `shadow2` a `shadow3`, e `dragged`
    fica em `shadow3`.

  Valores provisórios na ADR 0009.
- **BREAKING** Estados de interação no modelo Fiori (`update-rebic-foundation-interaction-states-fiori-alignment`,
  specs `rebic/foundation/interaction-states` e `rebic/foundation/color`):
  - `RebicInteractionState.dragged` removido. O item arrastado usa a sombra `dragged` de elevação e as cores de
    `pressed`.
  - `RebicInteractionPrimitives` fica só com `opacity40` (`sapContent_DisabledOpacity`). Saem `opacity0`, `opacity4`,
    `opacity8`, `opacity12`, `opacity16`, `opacity24`, `opacity50` e `opacity100`.
  - `RebicValueStateColors` ganha o papel obrigatório `hoverBackground`, um tom acima do `background` do estado
    (como `sapButton_Accept_Hover_Background`). `rebicCheckContrast` passa a medir o `foreground` sobre ele.
  - As famílias `accept`, `reject` e `attention` usam só as cores do estado de valor: hover com o `hoverBackground`
    do estado, e ativo, selecionado e selecionado com hover com o normal invertido (`foreground` de fundo e borda,
    `background` de texto). Antes, usavam o `hoverBackground` neutro e o `highlight` da marca.

  Valores provisórios na ADR 0009.
- **BREAKING** Tipografia no modelo Fiori (`update-rebic-foundation-typography-fiori-sizes`, spec
  `rebic/foundation/typography`): os estilos de `RebicTypographyTokens` passam aos nomes dos parâmetros de tamanho de
  fonte do SAPUI5 (`sapFontHeader1Size`…`6Size`, `sapFontLargeSize`, `sapFontSize`, `sapFontSmallSize`), com títulos em
  negrito; novos primitivos `size48` e `lineHeight60`. Valores provisórios na ADR 0009.

    | Antes | Agora |
    |---|---|
    | `display` (40/48, 600) | `header1` (48/60, 700) |
    | `headline` (32/40, 600) | `header2` (32/40, 700) |
    | `title` (24/32, 600) | `header3` (24/32, 700) |
    | `subtitle` (18/24, 600) | `header4` (20/24, 700) |
    | `body` | `base` |
    | `bodyStrong` | `baseSemibold` |
    | `label` (14/20, 500) | `base` (rótulos se distinguem pela cor `label`) |
    | `caption` | `small` |
    | — | novos: `header5` (16/20), `header6` (14/20), `large` (16/24), `baseBold` (14/20, 700) |
- Estados de interação (`add-rebic-button`): famílias de controle `accept`, `reject` e `attention`, derivadas das cores
  dos estados de valor `success`, `error` e `warning`, para os tipos de botão Accept, Reject e Attention do Fiori.
- Tema na árvore (`add-rebic-theme`, spec `rebic/foundation/theming`): `RebicThemeScope` publica o tema para a
  subárvore, e `RebicThemeData.of`/`maybeOf` leem o tema ativo, com o claro de referência como reserva e o movimento
  reduzido quando o sistema pede.

- **BREAKING** Realinhamento ao modelo Fiori (`update-rebic-foundation-color-fiori-parameters`, specs
  `rebic/foundation/color`, `rebic/foundation/interaction-states` e `rebic/foundation/theming`):
  - papéis de cor renomeados e ampliados em `RebicColorTokens`, com o mapa `roles`:

    | Antes | Agora |
    |---|---|
    | `surface` | `base` |
    | `surfaceVariant` | `headerBackground` |
    | `onSurface` | `text` |
    | `onSurfaceMuted` | `label` |
    | `border` | `separator` |
    | `borderStrong` | `fieldBorder` |
    | `primary` | `brand` |
    | `onPrimary` | `contrastText` |
    | `primaryContainer` | `selectionBackground` |
    | `scrim` | `blockLayer` |
    | `onSurfaceDisabled`, `surfaceDisabled`, `onPrimaryContainer` | removidos (desabilitado usa `disabledOpacity`) |
    | — | novos: `shell`, `link`, `brandHover`, `highlight`, `hoverBackground`, `selectionHoverBackground` |

  - primitiva `RebicColorPrimitives.transparent`;
  - famílias de controle `RebicControlFamily` (`standard`, `emphasized`, `transparent`, `list`), com
    `RebicStateColors`, `RebicControlColors.of` e `resolve`, no lugar da camada de estado;
  - `RebicInteractionStateTokens` passa a ter só `disabledOpacity` (0,4), `focusWidth` e `focusOffset`; saem
    `hover`, `pressed`, `selected`, `dragged`, `overlayOpacity`, `overlayColor`, `maxOverlayOpacity`,
    `elevationLevel` e `focusRingWidth`/`focusRingOffset`. A primitiva `opacity38` vira `opacity40`;
  - `rebicCheckStateContrast`, somada a `rebicCheckContrast` em `RebicThemeData.accessibilityIssues()`.
- **BREAKING** Sombras no modelo Fiori (`update-rebic-foundation-elevation-fiori-shadows`, spec
  `rebic/foundation/elevation`):

  | Antes (primitivo / semântico) | Agora |
  |---|---|
  | `elevation0` / `level0` | `none` |
  | `elevation1` / `level1` | `shadow0` |
  | `elevation2` / `level2` | `shadow1` |
  | `elevation3` / `level3` | `shadow2` |
  | `elevation4` / `level4` | `shadow3` |
  | `RebicElevationPrimitives.levels` | `RebicElevationPrimitives.shadows` |
  | — | novos: primitivo `header`; papéis `dragged` (= `shadow3`) e `header` |

- Design tokens (`add-rebic-foundation-design-tokens`, spec `rebic/foundation/design-tokens`):
  - contrato `RebicTokenSet<T>` (imutável, `copyWith`, `lerp`, igualdade por valor, diagnóstico);
  - tokens de movimento: primitivos `RebicMotionPrimitives` e papéis semânticos `RebicMotionTokens`;
  - extensões tipadas da aplicação: `RebicTokenExtension<T>` e `RebicTokenExtensions`;
  - nova biblioteca `package:rebic_foundation/rebic_primitives.dart`, não reexportada por `rebic_ui`.
- Cores (`add-rebic-foundation-color`, spec `rebic/foundation/color`):
  - escalas primitivas `RebicColorPrimitives` (paleta provisória própria: neutro, azul, verde, âmbar, vermelho e ciano);
  - papéis semânticos `RebicColorTokens`, com mapeamentos de referência `light()` e `dark()`;
  - estado semântico de valor `RebicValueState` e suas cores (`RebicValueStateColors`);
  - contraste WCAG 2.1: `rebicContrastRatio`, `rebicContrastRatioOver` e `rebicCheckContrast`.
- Espaçamentos (`add-rebic-foundation-spacing`, spec `rebic/foundation/spacing`):
  - escala primitiva `RebicSpacingPrimitives` (grade de 4 px, de 0 a 64);
  - passos e papéis de layout `RebicSpacingTokens`, com o mapeamento confortável `fallback()`.
- Tipografia (`add-rebic-foundation-typography`, spec `rebic/foundation/typography`):
  - fonte Inter 4.1 empacotada (pesos 400–700; SIL Open Font License 1.1 em `fonts/inter/OFL.txt`). Aumenta o
    bundle das aplicações em cerca de 1,6 MB;
  - primitivos `RebicTypographyPrimitives` (família, fallbacks, tamanhos, alturas de linha e pesos);
  - estilos semânticos `RebicTypographyTokens` (`display` a `caption`), sem cor, com o mapeamento `fallback()`.
- Raios de borda (`add-rebic-foundation-radius`, spec `rebic/foundation/radius`):
  - escala primitiva `RebicRadiusPrimitives` (0 a 16 px e `radiusFull` para pílula);
  - passos e papéis `RebicRadiusTokens` (`control`, `container`), com o mapeamento `fallback()`.
- Breakpoints (`add-rebic-foundation-breakpoints`, spec `rebic/foundation/breakpoints`):
  - escala primitiva `RebicBreakpointPrimitives` (360 a 1920 px);
  - classes de tamanho `RebicSizeClass` (`small` a `extraLarge`), com `isAtLeast`/`isAtMost`;
  - limiares `RebicBreakpointTokens` (600, 1024 e 1440 no `fallback()`), com `classify` e `minWidthOf`.
- Ícones (`add-rebic-foundation-iconography`, spec `rebic/foundation/iconography`):
  - fonte de ícones Lucide 1.61.0 empacotada (licença ISC em `fonts/lucide/LICENSE`, com o mapa oficial
    `codepoints.json`); o *tree shaking* de ícones a reduz em builds de release;
  - catálogo semântico `RebicIcons` (38 ícones `const`, direcionais espelhados em RTL), com `all` e `lucideNames`;
  - primitivos `RebicIconPrimitives` (família, pacote e tamanhos 12–48) e tamanhos `RebicIconTokens`
    (`inline` e `control`), com o mapeamento `fallback()`.
- Densidade (`add-rebic-foundation-density`, spec `rebic/foundation/density`):
  - modos `RebicDensity` (`comfortable`, `compact`);
  - `RebicDensityTokens` com altura de controle, altura de item, alvo mínimo (48/24) e espaçamento por densidade,
    com os mapeamentos `comfortable()`, `compact()` e `of(densidade)`.
- Elevação (`add-rebic-foundation-elevation`, spec `rebic/foundation/elevation`):
  - camada de sombra `RebicShadowLayer` (geometria sem cor) e níveis primitivos `RebicElevationPrimitives` (0 a 4);
  - níveis e papéis `RebicElevationTokens` (`card`, `popover`, `dialog`), com `shadowsFor(nível, cor)` usando a
    cor `shadow` do tema.
- Estados de interação (`add-rebic-foundation-interaction-states`, spec `rebic/foundation/interaction-states`):
  - primitivos `RebicInteractionPrimitives` (opacidades e espessuras de traço) e estados `RebicInteractionState`;
  - `RebicInteractionStateTokens`: camada de estado (hover 8%, pressionado 12%, selecionado 12%, arrastado 16%,
    teto de 16%), anel de foco (2 px), opacidade de desabilitado (38%) e elevação em interação, com as regras
    `overlayOpacity`, `overlayColor`, `showsFocusRing` e `elevationLevel`.
- Acessibilidade (`add-rebic-foundation-accessibility`, spec `rebic/foundation/accessibility`):
  - convenções `RebicAccessibility`: meta WCAG 2.2 AA, mínimos de contraste (os de cor), escala de texto suportada
    (200%), alvo mínimo por densidade e `resolveMotion` para movimento reduzido;
  - o template de spec de widget passa a exigir a bateria mínima de testes de acessibilidade.
- Tema (`add-rebic-foundation-theming`, spec `rebic/foundation/theming`):
  - `RebicThemeData` reúne brilho e todos os conjuntos de tokens, com `components` (tokens de componente) e
    `extensions` (tokens da aplicação);
  - temas de referência `light()`/`dark()` com densidade, `withDensity`, `resolve(disableAnimations:)`,
    `accessibilityIssues()` e interpolação entre temas.
- `RebicAccessibility.defaultMinTargetSize` (48), alvo mínimo padrão para parâmetros (`add-rebic-core-interaction`).

## 0.0.1

- Estrutura inicial do pacote (Fase 0). Sem API pública.
