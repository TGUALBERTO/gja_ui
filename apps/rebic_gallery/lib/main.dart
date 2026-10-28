import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'pages/accessibility_page.dart';
import 'pages/breakpoints_page.dart';
import 'pages/color_page.dart';
import 'pages/density_page.dart';
import 'pages/design_tokens_page.dart';
import 'pages/elevation_page.dart';
import 'pages/icons_page.dart';
import 'pages/interaction_page.dart';
import 'pages/localization_page.dart';
import 'pages/overlay_page.dart';
import 'pages/radius_page.dart';
import 'pages/rebic_avatar_page.dart';
import 'pages/rebic_badge_page.dart';
import 'pages/rebic_button_page.dart';
import 'pages/rebic_container_page.dart';
import 'pages/rebic_divider_page.dart';
import 'pages/rebic_grid_page.dart';
import 'pages/rebic_icon_button_page.dart';
import 'pages/rebic_icon_page.dart';
import 'pages/rebic_link_page.dart';
import 'pages/rebic_responsive_layout_page.dart';
import 'pages/rebic_page_page.dart';
import 'pages/rebic_progress_indicator_page.dart';
import 'pages/rebic_row_column_page.dart';
import 'pages/rebic_scaffold_page.dart';
import 'pages/rebic_status_indicator_page.dart';
import 'pages/rebic_tooltip_page.dart';
import 'pages/rebic_spacing_page.dart';
import 'pages/rebic_text_page.dart';
import 'pages/rebic_theme_page.dart';
import 'pages/responsive_page.dart';
import 'pages/spacing_page.dart';
import 'pages/states_page.dart';
import 'pages/theme_page.dart';
import 'pages/typography_page.dart';

/// Inicia a galeria de componentes Rebic.
void main() {
  runApp(const RebicGalleryApp());
}

/// Página da galeria: título exibido no índice e construtor da rota.
class GalleryPage {
  /// Cria a página [title], publicada em [route].
  const GalleryPage({
    required this.title,
    required this.route,
    required this.builder,
  });

  /// Título no índice.
  final String title;

  /// Rota nomeada.
  final String route;

  /// Constrói o conteúdo da página.
  final WidgetBuilder builder;
}

/// Páginas da galeria, na ordem do índice.
final galleryPages = <GalleryPage>[
  GalleryPage(
    title: DesignTokensPage.title,
    route: DesignTokensPage.route,
    builder: (_) => const DesignTokensPage(),
  ),
  GalleryPage(
    title: ColorPage.title,
    route: ColorPage.route,
    builder: (_) => const ColorPage(),
  ),
  GalleryPage(
    title: SpacingPage.title,
    route: SpacingPage.route,
    builder: (_) => const SpacingPage(),
  ),
  GalleryPage(
    title: TypographyPage.title,
    route: TypographyPage.route,
    builder: (_) => const TypographyPage(),
  ),
  GalleryPage(
    title: RadiusPage.title,
    route: RadiusPage.route,
    builder: (_) => const RadiusPage(),
  ),
  GalleryPage(
    title: BreakpointsPage.title,
    route: BreakpointsPage.route,
    builder: (_) => const BreakpointsPage(),
  ),
  GalleryPage(
    title: IconsPage.title,
    route: IconsPage.route,
    builder: (_) => const IconsPage(),
  ),
  GalleryPage(
    title: DensityPage.title,
    route: DensityPage.route,
    builder: (_) => const DensityPage(),
  ),
  GalleryPage(
    title: ElevationPage.title,
    route: ElevationPage.route,
    builder: (_) => const ElevationPage(),
  ),
  GalleryPage(
    title: StatesPage.title,
    route: StatesPage.route,
    builder: (_) => const StatesPage(),
  ),
  GalleryPage(
    title: AccessibilityPage.title,
    route: AccessibilityPage.route,
    builder: (_) => const AccessibilityPage(),
  ),
  GalleryPage(
    title: ThemePage.title,
    route: ThemePage.route,
    builder: (_) => const ThemePage(),
  ),
  GalleryPage(
    title: InteractionPage.title,
    route: InteractionPage.route,
    builder: (_) => const InteractionPage(),
  ),
  GalleryPage(
    title: LocalizationPage.title,
    route: LocalizationPage.route,
    builder: (_) => const LocalizationPage(),
  ),
  GalleryPage(
    title: ResponsivePage.title,
    route: ResponsivePage.route,
    builder: (_) => const ResponsivePage(),
  ),
  GalleryPage(
    title: OverlayPage.title,
    route: OverlayPage.route,
    builder: (_) => const OverlayPage(),
  ),
  GalleryPage(
    title: RebicThemePage.title,
    route: RebicThemePage.route,
    builder: (_) => const RebicThemePage(),
  ),
  GalleryPage(
    title: RebicTextPage.title,
    route: RebicTextPage.route,
    builder: (_) => const RebicTextPage(),
  ),
  GalleryPage(
    title: RebicIconPage.title,
    route: RebicIconPage.route,
    builder: (_) => const RebicIconPage(),
  ),
  GalleryPage(
    title: RebicSpacingPage.title,
    route: RebicSpacingPage.route,
    builder: (_) => const RebicSpacingPage(),
  ),
  GalleryPage(
    title: RebicContainerPage.title,
    route: RebicContainerPage.route,
    builder: (_) => const RebicContainerPage(),
  ),
  GalleryPage(
    title: RebicRowColumnPage.title,
    route: RebicRowColumnPage.route,
    builder: (_) => const RebicRowColumnPage(),
  ),
  GalleryPage(
    title: RebicDividerPage.title,
    route: RebicDividerPage.route,
    builder: (_) => const RebicDividerPage(),
  ),
  GalleryPage(
    title: RebicResponsiveLayoutPage.title,
    route: RebicResponsiveLayoutPage.route,
    builder: (_) => const RebicResponsiveLayoutPage(),
  ),
  GalleryPage(
    title: RebicGridPage.title,
    route: RebicGridPage.route,
    builder: (_) => const RebicGridPage(),
  ),
  GalleryPage(
    title: RebicScaffoldPage.title,
    route: RebicScaffoldPage.route,
    builder: (_) => const RebicScaffoldPage(),
  ),
  GalleryPage(
    title: RebicPagePage.title,
    route: RebicPagePage.route,
    builder: (_) => const RebicPagePage(),
  ),
  GalleryPage(
    title: RebicProgressIndicatorPage.title,
    route: RebicProgressIndicatorPage.route,
    builder: (_) => const RebicProgressIndicatorPage(),
  ),
  GalleryPage(
    title: RebicTooltipPage.title,
    route: RebicTooltipPage.route,
    builder: (_) => const RebicTooltipPage(),
  ),
  GalleryPage(
    title: RebicButtonPage.title,
    route: RebicButtonPage.route,
    builder: (_) => const RebicButtonPage(),
  ),
  GalleryPage(
    title: RebicIconButtonPage.title,
    route: RebicIconButtonPage.route,
    builder: (_) => const RebicIconButtonPage(),
  ),
  GalleryPage(
    title: RebicLinkPage.title,
    route: RebicLinkPage.route,
    builder: (_) => const RebicLinkPage(),
  ),
  GalleryPage(
    title: RebicBadgePage.title,
    route: RebicBadgePage.route,
    builder: (_) => const RebicBadgePage(),
  ),
  GalleryPage(
    title: RebicStatusIndicatorPage.title,
    route: RebicStatusIndicatorPage.route,
    builder: (_) => const RebicStatusIndicatorPage(),
  ),
  GalleryPage(
    title: RebicAvatarPage.title,
    route: RebicAvatarPage.route,
    builder: (_) => const RebicAvatarPage(),
  ),
];

/// Aplicação da galeria.
///
/// Usa `RebicApp` como raiz, sem Material. O índice escolhe o modo de tema e a
/// densidade da galeria inteira. Cada widget implementado ganha uma página.
class RebicGalleryApp extends StatefulWidget {
  /// Cria a aplicação da galeria.
  const RebicGalleryApp({super.key});

  /// Título exibido na página inicial e na janela.
  static const title = 'Rebic — Galeria';

  @override
  State<RebicGalleryApp> createState() => _RebicGalleryAppState();
}

class _RebicGalleryAppState extends State<RebicGalleryApp> {
  RebicThemeMode _themeMode = RebicThemeMode.system;
  RebicDensity? _density;

  @override
  Widget build(BuildContext context) {
    return RebicApp(
      title: RebicGalleryApp.title,
      themeMode: _themeMode,
      density: _density,
      builder: (context, child) => _GallerySettings(
        themeMode: _themeMode,
        density: _density,
        onThemeMode: (mode) => setState(() => _themeMode = mode),
        onDensity: (density) => setState(() => _density = density),
        child: child!,
      ),
      routes: {
        '/': (_) => const _GalleryIndex(),
        for (final page in galleryPages) page.route: page.builder,
      },
    );
  }
}

/// Escolhas de tema e densidade da galeria, para o índice.
class _GallerySettings extends InheritedWidget {
  const _GallerySettings({
    required this.themeMode,
    required this.density,
    required this.onThemeMode,
    required this.onDensity,
    required super.child,
  });

  final RebicThemeMode themeMode;
  final RebicDensity? density;
  final ValueChanged<RebicThemeMode> onThemeMode;
  final ValueChanged<RebicDensity?> onDensity;

  static _GallerySettings of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_GallerySettings>()!;

  @override
  bool updateShouldNotify(_GallerySettings old) =>
      old.themeMode != themeMode || old.density != density;
}

/// Índice: escolha de tema e densidade, e um link por página.
class _GalleryIndex extends StatelessWidget {
  const _GalleryIndex();

  @override
  Widget build(BuildContext context) {
    final theme = RebicTheme.of(context);
    final settings = _GallerySettings.of(context);
    final spacing = theme.spacing;
    return ListView(
      padding: EdgeInsets.all(spacing.pageMargin),
      children: [
        Text(RebicGalleryApp.title, style: theme.typography.headline),
        SizedBox(height: spacing.stackGap),
        _Options(
          children: [
            for (final (mode, label) in const [
              (RebicThemeMode.system, 'Tema: sistema'),
              (RebicThemeMode.light, 'Tema: claro'),
              (RebicThemeMode.dark, 'Tema: escuro'),
            ])
              _Option(
                label: label,
                selected: settings.themeMode == mode,
                onPressed: () => settings.onThemeMode(mode),
              ),
          ],
        ),
        SizedBox(height: spacing.s),
        _Options(
          children: [
            for (final (density, label) in const [
              (null, 'Densidade: recomendada'),
              (RebicDensity.comfortable, 'Densidade: confortável'),
              (RebicDensity.compact, 'Densidade: compacta'),
            ])
              _Option(
                label: label,
                selected: settings.density == density,
                onPressed: () => settings.onDensity(density),
              ),
          ],
        ),
        SizedBox(height: spacing.sectionGap),
        for (final page in galleryPages)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pushNamed(page.route),
            child: Semantics(
              button: true,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.m),
                child: Text(page.title),
              ),
            ),
          ),
      ],
    );
  }
}

class _Options extends StatelessWidget {
  const _Options({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spacing = RebicTheme.of(context).spacing;
    return Wrap(spacing: spacing.s, runSpacing: spacing.s, children: children);
  }
}

/// Opção selecionável do índice, com as cores da família `standard`.
class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = RebicTheme.of(context);
    return RebicInteractable(
      onPressed: onPressed,
      selected: selected,
      semanticLabel: label,
      builder: (context, states) {
        final c = RebicControlColors.of(
          RebicControlFamily.standard,
          t.colors,
        ).resolve(states);
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: t.spacing.m,
            vertical: t.spacing.xs,
          ),
          decoration: BoxDecoration(
            color: c.background,
            border: Border.all(color: c.border),
            borderRadius: BorderRadius.circular(t.radius.control),
          ),
          child: Text(label, style: t.typography.label.copyWith(color: c.text)),
        );
      },
    );
  }
}
