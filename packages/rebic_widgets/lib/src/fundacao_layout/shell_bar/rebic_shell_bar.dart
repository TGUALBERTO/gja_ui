import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../acoes_navegacao/button/rebic_button.dart';
import '../../exibicao_dados/avatar/rebic_avatar.dart';
import '../../exibicao_dados/badge/rebic_badge.dart';
import '../../exibicao_dados/tooltip/rebic_tooltip.dart';
import '../container/rebic_container.dart';
import '../title/rebic_title.dart';

/// Barra superior da aplicação, como o `sap.f.ShellBar` do SAPUI5.
///
/// No início ficam os botões de voltar ([showNavButton]) e de menu
/// ([showMenuButton]), o ícone inicial ([homeIcon]), o [title] e o
/// [secondTitle]; no fim, a pesquisa ([showSearch]), as notificações
/// ([showNotifications]), o [additionalContent], o [profile] e o seletor de
/// produtos ([showProductSwitcher]). Cada elemento avisa a aplicação pelo seu
/// callback; um botão visível sem callback fica desabilitado. Quando falta
/// espaço, o segundo título e depois o título terminam com reticências.
///
/// Em geral é o `header` de um `RebicToolPage`, com o botão de menu ligado ao
/// conteúdo lateral:
///
/// ```dart
/// RebicShellBar(
///   title: 'Compras',
///   showMenuButton: true,
///   onMenuButtonPressed: () => RebicToolPage.toggleSideContentMode(context),
///   showNotifications: true,
///   notificationsNumber: 4,
///   onNotificationsPressed: openNotifications,
///   profile: const RebicAvatar(initials: 'TA'),
///   onAvatarPressed: openProfile,
/// )
/// ```
class RebicShellBar extends StatelessWidget {
  /// Cria a barra.
  const RebicShellBar({
    this.title,
    this.secondTitle,
    this.homeIcon,
    this.homeIconTooltip,
    this.showNavButton = false,
    this.showMenuButton = false,
    this.showSearch = false,
    this.showNotifications = false,
    this.notificationsNumber = 0,
    this.showProductSwitcher = false,
    this.profile,
    this.additionalContent = const [],
    this.onHomeIconPressed,
    this.onNavButtonPressed,
    this.onMenuButtonPressed,
    this.onSearchButtonPressed,
    this.onNotificationsPressed,
    this.onProductSwitcherPressed,
    this.onAvatarPressed,
    super.key,
  }) : assert(
         notificationsNumber >= 0,
         '"notificationsNumber" não pode ser negativo',
       );

  /// Título principal, anunciado como cabeçalho de nível 1.
  final String? title;

  /// Segundo título, depois do principal.
  final String? secondTitle;

  /// Ícone inicial, como o logotipo da aplicação.
  final Widget? homeIcon;

  /// Dica do ícone inicial; nula usa o texto `logo` do núcleo.
  final String? homeIconTooltip;

  /// Se mostra o botão de voltar.
  final bool showNavButton;

  /// Se mostra o botão de menu.
  final bool showMenuButton;

  /// Se mostra o botão de pesquisa.
  final bool showSearch;

  /// Se mostra o botão de notificações.
  final bool showNotifications;

  /// Número no contador do botão de notificações; zero oculta o contador.
  final int notificationsNumber;

  /// Se mostra o botão do seletor de produtos.
  final bool showProductSwitcher;

  /// Perfil do usuário, exibido no tamanho `xs` e com [onAvatarPressed]; o
  /// `onPressed` e o tamanho do próprio avatar são ignorados.
  final RebicAvatar? profile;

  /// Conteúdo adicional, entre as notificações e o perfil.
  final List<Widget> additionalContent;

  /// Toque no ícone inicial; nulo o deixa não interativo.
  final VoidCallback? onHomeIconPressed;

  /// Toque no botão de voltar; nulo o desabilita.
  final VoidCallback? onNavButtonPressed;

  /// Toque no botão de menu; nulo o desabilita.
  final VoidCallback? onMenuButtonPressed;

  /// Toque no botão de pesquisa; nulo o desabilita.
  final VoidCallback? onSearchButtonPressed;

  /// Toque no botão de notificações; nulo o desabilita.
  final VoidCallback? onNotificationsPressed;

  /// Toque no botão do seletor de produtos; nulo o desabilita.
  final VoidCallback? onProductSwitcherPressed;

  /// Toque no perfil; nulo o deixa não interativo.
  final VoidCallback? onAvatarPressed;

  /// Margem horizontal pela classe da largura da barra, como os paddings
  /// Phone, Tablet e Desktop do `sap.f.ShellBar`.
  static double _margin(RebicSpacingTokens spacing, RebicSizeClass size) =>
      switch (size) {
        RebicSizeClass.small => spacing.pageMargin,
        RebicSizeClass.medium => spacing.xxl,
        RebicSizeClass.large || RebicSizeClass.extraLarge => spacing.xxxl,
      };

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final texts = RebicLocalizations.of(context);
    final homeIcon = this.homeIcon;
    final profile = this.profile;
    final title = this.title;
    final secondTitle = this.secondTitle;

    final start = <Widget>[
      if (showNavButton)
        RebicButton(
          icon: RebicIcons.navBack,
          tooltip: texts.back,
          onPress: onNavButtonPressed,
          enabled: onNavButtonPressed != null,
          type: RebicButtonType.transparent,
        ),
      if (showMenuButton)
        RebicButton(
          icon: RebicIcons.menu2,
          tooltip: texts.menu,
          onPress: onMenuButtonPressed,
          enabled: onMenuButtonPressed != null,
          type: RebicButtonType.transparent,
        ),
      if (homeIcon != null)
        _HomeIcon(
          tooltip: homeIconTooltip ?? texts.logo,
          onPressed: onHomeIconPressed,
          child: homeIcon,
        ),
    ];
    final end = <Widget>[
      if (showSearch)
        RebicButton(
          icon: RebicIcons.search,
          tooltip: texts.search,
          onPress: onSearchButtonPressed,
          enabled: onSearchButtonPressed != null,
          type: RebicButtonType.transparent,
        ),
      if (showNotifications)
        RebicBadge(
          count: notificationsNumber,
          child: RebicButton(
            icon: RebicIcons.bell,
            tooltip: texts.notifications,
            onPress: onNotificationsPressed,
            enabled: onNotificationsPressed != null,
            type: RebicButtonType.transparent,
          ),
        ),
      ...additionalContent,
      if (profile != null)
        RebicAvatar(
          image: profile.image,
          initials: profile.initials,
          icon: profile.icon,
          size: RebicAvatarSize.xs,
          shape: profile.shape,
          semanticLabel: profile.semanticLabel ?? texts.profile,
          onPressed: onAvatarPressed,
        ),
      if (showProductSwitcher)
        RebicButton(
          icon: RebicIcons.grid,
          tooltip: texts.products,
          onPress: onProductSwitcherPressed,
          enabled: onProductSwitcherPressed != null,
          type: RebicButtonType.transparent,
        ),
    ];

    final gap = theme.spacing.xs;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: texts.shellBar,
      child: RebicContainer(
        surface: RebicSurface.shell,
        shadow: RebicShadow.header,
        child: SizedBox(
          height: theme.spacing.xxxl,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final margin = _margin(
                theme.spacing,
                theme.breakpoints.classify(constraints.maxWidth),
              );
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: margin),
                child: Row(
                  spacing: gap,
                  children: [
                    ...start,
                    // Os títulos ocupam o espaço livre e levam o fim da barra
                    // à borda final.
                    Expanded(
                      child: CustomMultiChildLayout(
                        delegate: _TitlesLayout(
                          gap: gap,
                          direction: Directionality.of(context),
                        ),
                        children: [
                          if (title != null)
                            LayoutId(
                              id: _TitleSlot.title,
                              child: RebicTitle(
                                title,
                                level: RebicTitleLevel.h1,
                                titleStyle: RebicTitleLevel.h5,
                              ),
                            ),
                          if (secondTitle != null)
                            LayoutId(
                              id: _TitleSlot.second,
                              child: Text(
                                secondTitle,
                                style: theme.typography.small.copyWith(
                                  color: theme.colors.text,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                    ...end,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

enum _TitleSlot { title, second }

/// Dispõe o título com toda a largura e o segundo título com o que sobrar,
/// para que o segundo encolha primeiro; os dois ficam centrados na altura.
class _TitlesLayout extends MultiChildLayoutDelegate {
  _TitlesLayout({required this.gap, required this.direction});

  final double gap;
  final TextDirection direction;

  @override
  void performLayout(Size size) {
    var used = 0.0;
    Size? titleSize;
    if (hasChild(_TitleSlot.title)) {
      titleSize = layoutChild(_TitleSlot.title, BoxConstraints.loose(size));
      used = titleSize.width;
    }
    Size? secondSize;
    if (hasChild(_TitleSlot.second)) {
      final offset = titleSize == null ? 0.0 : gap;
      final available = (size.width - used - offset).clamp(0.0, size.width);
      secondSize = layoutChild(
        _TitleSlot.second,
        BoxConstraints.loose(Size(available, size.height)),
      );
      used += offset;
    }
    double x(double start, double width) =>
        direction == TextDirection.ltr ? start : size.width - start - width;
    if (titleSize != null) {
      positionChild(
        _TitleSlot.title,
        Offset(x(0, titleSize.width), (size.height - titleSize.height) / 2),
      );
    }
    if (secondSize != null) {
      positionChild(
        _TitleSlot.second,
        Offset(
          x(used, secondSize.width),
          (size.height - secondSize.height) / 2,
        ),
      );
    }
  }

  @override
  bool shouldRelayout(_TitlesLayout oldDelegate) =>
      gap != oldDelegate.gap || direction != oldDelegate.direction;
}

/// Ícone inicial: interativo com [onPressed], como o `homeIcon` do ShellBar.
class _HomeIcon extends StatelessWidget {
  const _HomeIcon({
    required this.tooltip,
    required this.onPressed,
    required this.child,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final onPressed = this.onPressed;
    if (onPressed == null) {
      return Semantics(
        label: tooltip,
        image: true,
        child: ExcludeSemantics(child: child),
      );
    }
    final theme = RebicThemeData.of(context);
    final family = RebicControlColors.of(
      RebicControlFamily.transparent,
      theme.colors,
    );
    final corners = BorderRadius.circular(theme.radius.button);
    return RebicTooltip(
      message: tooltip,
      excludeFromSemantics: true,
      child: MergeSemantics(
        child: RebicInteractable(
          semanticLabel: tooltip,
          onPressed: onPressed,
          focusRingBorderRadius: corners,
          builder: (context, states) => ExcludeSemantics(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: family.resolve(states).background,
                borderRadius: corners,
              ),
              child: Padding(
                padding: EdgeInsets.all(theme.spacing.xxs),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
