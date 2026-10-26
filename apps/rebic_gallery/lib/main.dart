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
];

/// Cores da galeria até existir o tema.
const _colors = RebicColorTokens.light();

/// Aplicação da galeria.
///
/// Provisória até existir `RebicApp`: usa `WidgetsApp` diretamente, sem
/// Material. Cada widget implementado ganha uma página aqui.
class RebicGalleryApp extends StatelessWidget {
  /// Cria a aplicação da galeria.
  const RebicGalleryApp({super.key});

  /// Título exibido na página inicial e na janela.
  static const title = 'Rebic — Galeria';

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: title,
      // Cor obrigatória do WidgetsApp. Vem do mapeamento claro de referência
      // até existir o tema (RebicTheme).
      color: _colors.brand,
      textStyle: TextStyle(fontSize: 16, color: _colors.text),
      localizationsDelegates: const [RebicLocalizations.delegate],
      supportedLocales: RebicLocalizations.supportedLocales,
      builder: (context, child) => RebicScreenSizeScope(child: child!),
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
          PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
      routes: {
        '/': (_) => const _GalleryIndex(),
        for (final page in galleryPages) page.route: page.builder,
      },
    );
  }
}

/// Índice com um link por página.
class _GalleryIndex extends StatelessWidget {
  const _GalleryIndex();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _colors.base,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(RebicGalleryApp.title, style: TextStyle(fontSize: 24)),
          const SizedBox(height: 16),
          for (final page in galleryPages)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pushNamed(page.route),
              child: Semantics(
                button: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(page.title),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
