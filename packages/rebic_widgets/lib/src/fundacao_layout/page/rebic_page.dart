import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../acoes_navegacao/button/rebic_button.dart';
import '../bar/rebic_bar.dart';
import '../container/rebic_container.dart';
import '../title/rebic_title.dart';

/// Fundo de uma [RebicPage], como o `sap.m.PageBackgroundDesign` do SAPUI5.
enum RebicPageBackgroundDesign {
  /// Fundo da aplicação (`colors.background`).
  standard,

  /// Fundo sólido da aplicação (`colors.background`).
  solid,

  /// Fundo de lista (`colors.base`).
  list,

  /// Sem fundo.
  transparent,
}

/// Espaçamento do conteúdo de uma [RebicPage], como as classes de padding do
/// SAPUI5.
enum RebicContentPadding {
  /// Sem espaçamento (`sapUiNoContentPadding`, o padrão da página).
  none,

  /// `spacing.l` nos quatro lados (`sapUiContentPadding`).
  standard,

  /// Pela classe da tela: nenhum em `small`, `spacing.l` em `medium` e
  /// `spacing.l` por `spacing.xxl` a partir de `large`
  /// (`sapUiResponsiveContentPadding`).
  responsive,
}

/// Página de conteúdo, como o `sap.m.Page` do SAPUI5.
///
/// O cabeçalho é uma `RebicBar` com o botão de voltar ([showNavButton]), o
/// [title] e o [headerContent], ou o [customHeader]. Abaixo vêm o
/// [subHeader], o [content], que rola com [enableScrolling] ou divide a altura
/// disponível sem ela, e o [footer], fixo ou flutuante ([floatingFooter]). O
/// fundo segue [backgroundDesign], e o espaçamento do conteúdo,
/// [contentPadding]. Barras com desenho `auto` no subcabeçalho e no rodapé
/// recebem o desenho da área.
///
/// Precisa de altura limitada: use-a como conteúdo principal do
/// `RebicToolPage` ou como página de uma rota.
///
/// ```dart
/// RebicPage(
///   title: 'Pedido 4711',
///   showNavButton: true,
///   onNavButtonPress: () => Navigator.of(context).maybePop(),
///   headerContent: [EditarAction()],
///   contentPadding: RebicContentPadding.responsive,
///   content: const [DetalhesDoPedido()],
///   footer: RebicBar(contentRight: [CancelarAction(), SalvarAction()]),
/// )
/// ```
class RebicPage extends StatelessWidget {
  /// Cria a página.
  const RebicPage({
    this.title,
    this.titleLevel = RebicTitleLevel.auto,
    this.titleAlignment = RebicTitleAlignment.auto,
    this.showNavButton = false,
    this.navButtonTooltip,
    this.onNavButtonPress,
    this.headerContent = const [],
    this.customHeader,
    this.showHeader = true,
    this.subHeader,
    this.showSubHeader = true,
    this.content = const [],
    this.enableScrolling = true,
    this.backgroundDesign = RebicPageBackgroundDesign.standard,
    this.contentPadding = RebicContentPadding.none,
    this.footer,
    this.showFooter = true,
    this.floatingFooter = false,
    super.key,
  });

  /// Título no cabeçalho, anunciado como cabeçalho com [titleLevel].
  final String? title;

  /// Nível semântico do título.
  final RebicTitleLevel titleLevel;

  /// Alinhamento do título no cabeçalho.
  final RebicTitleAlignment titleAlignment;

  /// Se mostra o botão de voltar.
  final bool showNavButton;

  /// Dica do botão de voltar; nula usa o texto `back` do núcleo.
  final String? navButtonTooltip;

  /// Toque no botão de voltar; nulo o desabilita.
  final VoidCallback? onNavButtonPress;

  /// Conteúdo no fim do cabeçalho.
  final List<Widget> headerContent;

  /// Cabeçalho próprio, no lugar do interno.
  final Widget? customHeader;

  /// Se mostra o cabeçalho.
  final bool showHeader;

  /// Subcabeçalho, logo abaixo do cabeçalho.
  final Widget? subHeader;

  /// Se mostra o [subHeader].
  final bool showSubHeader;

  /// Conteúdo da página, empilhado.
  final List<Widget> content;

  /// Se o conteúdo rola; sem rolagem, os itens dividem a altura disponível.
  final bool enableScrolling;

  /// Fundo da página.
  final RebicPageBackgroundDesign backgroundDesign;

  /// Espaçamento do conteúdo.
  final RebicContentPadding contentPadding;

  /// Rodapé, em geral uma `RebicBar` com as ações no fim.
  final Widget? footer;

  /// Se mostra o [footer].
  final bool showFooter;

  /// Se o rodapé flutua sobre o conteúdo.
  final bool floatingFooter;

  EdgeInsets _padding(RebicSpacingTokens spacing, RebicSizeClass size) =>
      switch (contentPadding) {
        RebicContentPadding.none => EdgeInsets.zero,
        RebicContentPadding.standard => EdgeInsets.all(spacing.l),
        RebicContentPadding.responsive => switch (size) {
          RebicSizeClass.small => EdgeInsets.zero,
          RebicSizeClass.medium => EdgeInsets.all(spacing.l),
          RebicSizeClass.large || RebicSizeClass.extraLarge =>
            EdgeInsets.symmetric(horizontal: spacing.xxl, vertical: spacing.l),
        },
      };

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final spacing = theme.spacing;
    final title = this.title;
    final subHeader = this.subHeader;
    final footer = showFooter ? this.footer : null;
    final floating = footer != null && floatingFooter;

    Widget? header;
    if (showHeader) {
      header =
          customHeader ??
          RebicBar(
            design: RebicBarDesign.header,
            titleAlignment: titleAlignment,
            contentLeft: [
              if (showNavButton)
                RebicButton(
                  icon: RebicIcons.navBack,
                  tooltip:
                      navButtonTooltip ?? RebicLocalizations.of(context).back,
                  onPress: onNavButtonPress,
                  enabled: onNavButtonPress != null,
                  type: RebicButtonType.transparent,
                ),
            ],
            contentMiddle: [
              if (title != null) RebicTitle(title, level: titleLevel),
            ],
            contentRight: headerContent,
          );
    }

    var padding = _padding(spacing, RebicResponsive.screenSizeClassOf(context));
    if (floating) {
      // O fim do conteúdo fica acima do rodapé flutuante.
      padding += EdgeInsets.only(
        bottom: theme.density.barHeight + spacing.s * 2,
      );
    }
    final Widget body = enableScrolling
        ? SingleChildScrollView(
            child: Padding(
              padding: padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: content,
              ),
            ),
          )
        : Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [for (final item in content) Expanded(child: item)],
            ),
          );

    final page = LayoutBuilder(
      builder: (context, constraints) {
        assert(
          constraints.hasBoundedHeight,
          'RebicPage precisa de altura limitada: use-a como conteúdo '
          'principal do RebicToolPage ou como página de uma rota, não '
          'dentro de uma rolagem',
        );
        // O cabeçalho vem por último para ser pintado sobre o conteúdo, com a
        // sombra visível; `up` o mantém no topo. Foco e semântica seguem a
        // geometria.
        return Column(
          verticalDirection: VerticalDirection.up,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (footer != null && !floating)
              RebicBarScope(design: RebicBarDesign.footer, child: footer),
            Expanded(child: body),
            if (subHeader != null && showSubHeader)
              RebicBarScope(design: RebicBarDesign.subHeader, child: subHeader),
            ?header,
          ],
        );
      },
    );

    return RebicContainer(
      surface: switch (backgroundDesign) {
        RebicPageBackgroundDesign.standard ||
        RebicPageBackgroundDesign.solid => RebicSurface.background,
        RebicPageBackgroundDesign.list => RebicSurface.base,
        RebicPageBackgroundDesign.transparent => RebicSurface.none,
      },
      child: !floating
          ? page
          : Stack(
              children: [
                Positioned.fill(child: page),
                PositionedDirectional(
                  start: spacing.s,
                  end: spacing.s,
                  bottom: spacing.s,
                  child: RebicBarScope(
                    design: RebicBarDesign.floatingFooter,
                    child: footer,
                  ),
                ),
              ],
            ),
    );
  }
}
