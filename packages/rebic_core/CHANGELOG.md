# Changelog

## Não lançado

- Semântica de marcação e alternância (`add-rebic-check-box`, spec `rebic/core/interaction`): `RebicInteractable`
  ganha `checked`, `mixed`, `toggled` e `inMutuallyExclusiveGroup`; com eles, o elemento é exposto como caixa, chave
  ou opção de rádio, e não como botão.
- Textos `menu`, `logo`, `notifications`, `profile`, `products` e `shellBar` (`update-rebic-scaffold-fiori-tool-page`,
  spec `rebic/core/localization`), como os textos do `sap.f.ShellBar`. Quem estende `RebicLocalizations` passa a
  implementá-los.
- **BREAKING** Sobreposições no modelo do Popup do SAPUI5 (`update-rebic-core-overlay-fiori-popup`, spec
  `rebic/core/overlay`):
  - `RebicModal.show` fecha só com Esc (com `dismissible`), como o `sap.m.Dialog`. A camada de bloqueio nunca é
    interativa: o toque nela é ignorado, e ela não tem rótulo nem ação na semântica. `barrierColor` passa a
    `blockLayerColor`.
  - `RebicOverlaySide` (`below`, `above`, `start`, `end`) passa a `RebicPlacement` (`bottom`, `top`, `start`,
    `end`), e `RebicAnchoredOverlay.side` passa a `placement`, como o `placement` do Popover.
  - `RebicAnchoredOverlay` acompanha a âncora quando ela se move ou muda de tamanho, e não só na rolagem.
  - Novo `RebicAnchoredOverlay.placementOf(context)`, com a posição efetiva depois da inversão.
- Raios no modelo Fiori (`update-rebic-foundation-radius-fiori-roles`, spec `rebic/core/interaction`): o anel de foco
  de `RebicInteractable` usa por padrão o raio `button` do tema (`sapButton_BorderCornerRadius`), no lugar de
  `control`.
- **BREAKING** Densidade no modelo Fiori (`update-rebic-foundation-density-fiori-cozy`, spec `rebic/core/responsive`):
  `RebicResponsive.recommendedDensity` recomenda `RebicDensity.cozy` (antes `comfortable`) em Android, iOS e
  Fuchsia. A área mínima de `RebicInteractable` passa a 44 no cozy e a 32 no compacto, pelos tokens de densidade.
- Interação (`add-rebic-link`): `RebicInteractable.link` expõe o papel de link em vez do de botão ao leitor de tela,
  com o padrão `false` inalterado.
- Localização (`add-rebic-page`): novo texto `back` ("Voltar" / "Back"), rótulo do botão de voltar da `RebicPage`.
  Subclasses próprias de `RebicLocalizations` precisam implementá-lo.
- Localização (`add-rebic-scaffold`): novo texto `navigation` ("Navegação" / "Navigation"), rótulo do botão de
  navegação do `RebicScaffold`. Subclasses próprias de `RebicLocalizations` precisam implementá-lo.
- Valores do tema ativo (`add-rebic-theme`): os parâmetros visuais de `RebicInteractable` (`minTargetSize`,
  `interactionTokens`, `focusColor`, `focusRingBorderRadius`), `RebicModal.show` (`barrierColor`),
  `RebicAnchoredOverlay` (`gap`, `margin`) e da responsividade (`breakpoints`) passam a ser opcionais e, sem valor,
  vêm de `RebicThemeData.of`. O anel de foco sem raio informado passa a usar o raio `control` do tema (antes, zero).

- Sobreposições (`add-rebic-core-overlay`, spec `rebic/core/overlay`):
  - `RebicModal.show`: modal com camada de bloqueio (`blockLayer`), foco preso e devolvido, dispensa por Esc e pela
    camada quando dispensável, e resultado ao fechar;
  - `RebicAnchoredOverlay` e `RebicAnchoredOverlayController`: conteúdo junto de uma âncora, com lado preferido
    (`RebicOverlaySide`), alinhamento (`RebicOverlayAlignment`), inversão sem espaço, limite de bordas, rolagem
    acompanhada, fechamento automático por toque fora e Esc, e foco devolvido à âncora;
  - empilhamento nativo: a sobreposição aberta dentro de um modal fica acima dele, e Esc fecha só a do topo.

- Responsividade (`add-rebic-core-responsive`, spec `rebic/core/responsive`):
  - `RebicResponsive.screenSizeClassOf`: classe de tamanho da largura da janela;
  - `RebicScreenSizeScope`: publica a classe da tela e só reconstrói quem a lê quando a classe muda;
  - `RebicResponsiveBuilder`: classe de tamanho do espaço disponível para o próprio widget;
  - `RebicResponsiveValue<T>`: valor por classe, com herança da classe menor (como os spans `XL/L/M/S` do UI5);
  - `RebicResponsive.recommendedDensity`: compacta em desktop, confortável em dispositivos de toque.

- Localização (`add-rebic-core-localization`, spec `rebic/core/localization`):
  - `RebicLocalizations` com os textos do framework (ações comuns, vazio, carregando, obrigatório, estados de valor e
    contagem de selecionados) e as implementações `RebicLocalizationsPtBr` (padrão) e `RebicLocalizationsEn`;
  - `RebicLocalizations.delegate`, `supportedLocales` e `of(context)`, que recorre ao pt-BR sem o delegate;
  - formatação por idioma: `formatDecimal`, `formatInteger`, `formatDate`, `formatTime` e `formatDateTime`;
  - nova dependência `intl` 0.20.2, a versão fixada pelo Flutter SDK.

- **BREAKING** `RebicInteractable` lê `focusWidth` e `focusOffset` de `RebicInteractionStateTokens` (antes
  `focusRingWidth` e `focusRingOffset`), conforme o realinhamento ao Fiori do `rebic_foundation`.

- Interação e foco (`add-rebic-core-interaction`, spec `rebic/core/interaction`):
  - `RebicInteractable`: estados (hover, pressionado, foco, selecionado, desabilitado), ativação por toque e por
    Enter/Espaço, área mínima de interação, semântica de botão e cursor de clique;
  - `RebicFocusRing`: anel de foco desenhado fora do conteúdo, só com foco por teclado.

## 0.0.1

- Estrutura inicial do pacote (Fase 0). Sem API pública.
