/// Primitivos de design tokens do Rebic: escalas de valores brutos.
///
/// Destinada a temas e aplicações que personalizam a identidade visual. Não
/// é reexportada por `rebic_foundation.dart` nem por `rebic_ui.dart`, e as
/// bibliotecas de `rebic_core` e `rebic_widgets` não podem importá-la
/// (verificado por `rebic_checks architecture`).
library;

export 'src/tokens/primitives/motion_primitives.dart';
export 'src/color/primitives/color_primitives.dart';
export 'src/spacing/primitives/spacing_primitives.dart';
export 'src/typography/primitives/typography_primitives.dart';
export 'src/radius/primitives/radius_primitives.dart';
export 'src/breakpoints/primitives/breakpoint_primitives.dart';
export 'src/iconography/primitives/icon_primitives.dart';
export 'src/elevation/primitives/elevation_primitives.dart';
export 'src/interaction_states/primitives/interaction_primitives.dart';
