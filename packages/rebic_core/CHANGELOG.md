# Changelog

## Não lançado

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
