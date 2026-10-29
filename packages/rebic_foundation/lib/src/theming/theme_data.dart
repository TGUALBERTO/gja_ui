import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show BuildContext, MediaQuery;

import '../accessibility/accessibility.dart';
import '../accessibility/animation_mode.dart';
import '../breakpoints/breakpoint_tokens.dart';
import '../color/color_tokens.dart';
import '../color/contrast_check.dart';
import '../density/density_tokens.dart';
import '../shadows/shadow_tokens.dart';
import '../iconography/icon_tokens.dart';
import '../interaction_states/interaction_state_tokens.dart';
import '../interaction_states/state_contrast_check.dart';
import '../radius/radius_tokens.dart';
import '../spacing/spacing_tokens.dart';
import '../tokens/lerp.dart';
import '../tokens/motion_tokens.dart';
import '../tokens/token_extensions.dart';
import '../tokens/token_set.dart';
import '../typography/typography_tokens.dart';
import 'theme_scope.dart';

/// Tema centralizado do Rebic: todos os fundamentos em um único objeto.
///
/// Nível: semântico.
///
/// Use [RebicThemeData.light] ou [RebicThemeData.dark] e personalize com
/// [copyWith]; confira a personalização com [accessibilityIssues]. Os tokens
/// de componente dos widgets ficam em [components] (o widget usa os padrões
/// derivados dos semânticos quando o tipo não está registrado) e os tokens da
/// aplicação, em [extensions]. O espaçamento vem sempre da [density].
@immutable
class RebicThemeData extends RebicTokenSet<RebicThemeData> {
  /// Cria um tema com todos os conjuntos.
  const RebicThemeData({
    required this.brightness,
    required this.colors,
    required this.typography,
    required this.density,
    required this.radius,
    required this.shadows,
    required this.motion,
    required this.icons,
    required this.interaction,
    required this.breakpoints,
    this.animationMode = RebicAnimationMode.full,
    this.components = const RebicTokenExtensions.empty(),
    this.extensions = const RebicTokenExtensions.empty(),
  });

  /// Tema claro de referência, na densidade [density].
  factory RebicThemeData.light({
    RebicDensity density = RebicDensity.cozy,
  }) => RebicThemeData._reference(
    Brightness.light,
    const RebicColorTokens.light(),
    density,
  );

  /// Tema escuro de referência, na densidade [density].
  factory RebicThemeData.dark({
    RebicDensity density = RebicDensity.cozy,
  }) => RebicThemeData._reference(
    Brightness.dark,
    const RebicColorTokens.dark(),
    density,
  );

  factory RebicThemeData._reference(
    Brightness brightness,
    RebicColorTokens colors,
    RebicDensity density,
  ) => RebicThemeData(
    brightness: brightness,
    colors: colors,
    typography: const RebicTypographyTokens.fallback(),
    density: RebicDensityTokens.of(density),
    radius: const RebicRadiusTokens.fallback(),
    shadows: const RebicShadowTokens.fallback(),
    motion: const RebicMotionTokens.fallback(),
    icons: const RebicIconTokens.fallback(),
    interaction: const RebicInteractionStateTokens.fallback(),
    breakpoints: const RebicBreakpointTokens.fallback(),
  );

  /// Claro ou escuro; deve corresponder às [colors].
  final Brightness brightness;

  /// Papéis de cor.
  final RebicColorTokens colors;

  /// Estilos de texto.
  final RebicTypographyTokens typography;

  /// Densidade, com dimensões de controle e espaçamento.
  final RebicDensityTokens density;

  /// Raios de borda.
  final RebicRadiusTokens radius;

  /// Sombras e papéis de sombra.
  final RebicShadowTokens shadows;

  /// Durações e curvas de animação.
  final RebicMotionTokens motion;

  /// Tamanhos de ícone.
  final RebicIconTokens icons;

  /// Estados visuais de interação.
  final RebicInteractionStateTokens interaction;

  /// Limiares de largura.
  final RebicBreakpointTokens breakpoints;

  /// Modo de animação pedido pela aplicação (`sap-ui-animation-mode`).
  ///
  /// No tema resolvido ([resolve], [of]), é o modo efetivo, que também
  /// considera o pedido da plataforma.
  final RebicAnimationMode animationMode;

  /// Tokens de componente dos widgets do framework, por tipo.
  final RebicTokenExtensions components;

  /// Tokens próprios da aplicação, por tipo.
  final RebicTokenExtensions extensions;

  /// Espaçamento da densidade ativa.
  RebicSpacingTokens get spacing => density.spacing;

  /// Este tema com a densidade de referência de [mode].
  RebicThemeData withDensity(RebicDensity mode) =>
      copyWith(density: RebicDensityTokens.of(mode));

  /// Este tema resolvido para a plataforma.
  ///
  /// O modo efetivo é [animationMode] ou, com [disableAnimations], `none`
  /// ([RebicAnimationMode.effective]). O resultado tem esse modo e o
  /// movimento resolvido para ele; com o mesmo modo e sem redução, é este
  /// tema.
  RebicThemeData resolve({required bool disableAnimations}) {
    final mode = animationMode.effective(disableAnimations: disableAnimations);
    if (mode == animationMode && !mode.reducesMotion) return this;
    return copyWith(
      animationMode: mode,
      motion: RebicAccessibility.resolveMotion(motion, mode: mode),
    );
  }

  /// Tema ativo de [context]: o do `RebicThemeScope` mais próximo ou, sem
  /// escopo, o tema claro de referência.
  ///
  /// O tema vem resolvido para a plataforma ([resolve]) com
  /// `MediaQuery.disableAnimations`: com movimento reduzido, pelo tema ou pelo
  /// sistema, as durações valem zero. Quem chama é reconstruído quando o tema
  /// do escopo muda.
  static RebicThemeData of(BuildContext context) {
    final data = maybeOf(context) ?? _fallback;
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return data.resolve(disableAnimations: reduce);
  }

  /// Tema do `RebicThemeScope` mais próximo, sem resolução de movimento, ou
  /// nulo sem escopo.
  static RebicThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RebicThemeScope>()?.data;

  // Uma única instância, para que leituras sem escopo sejam idênticas.
  static final _fallback = RebicThemeData.light();

  /// Problemas de acessibilidade deste tema: pares de contraste abaixo do
  /// mínimo (papéis de cor e estados das famílias de controle) e alvo de interação abaixo de
  /// [RebicAccessibility.minTargetSizeFloor]. Lista vazia significa conforme.
  List<String> accessibilityIssues() {
    return [
      for (final issue in [
        ...rebicCheckContrast(colors),
        ...rebicCheckStateContrast(colors),
      ])
        '${issue.foreground}/${issue.background}: '
            '${issue.ratio.toStringAsFixed(2)} < ${issue.minimum}',
      if (density.minTargetSize < RebicAccessibility.minTargetSizeFloor)
        'minTargetSize: ${density.minTargetSize} < '
            '${RebicAccessibility.minTargetSizeFloor}',
    ];
  }

  @override
  RebicThemeData copyWith({
    Brightness? brightness,
    RebicColorTokens? colors,
    RebicTypographyTokens? typography,
    RebicDensityTokens? density,
    RebicRadiusTokens? radius,
    RebicShadowTokens? shadows,
    RebicMotionTokens? motion,
    RebicIconTokens? icons,
    RebicInteractionStateTokens? interaction,
    RebicBreakpointTokens? breakpoints,
    RebicAnimationMode? animationMode,
    RebicTokenExtensions? components,
    RebicTokenExtensions? extensions,
  }) {
    return RebicThemeData(
      brightness: brightness ?? this.brightness,
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      density: density ?? this.density,
      radius: radius ?? this.radius,
      shadows: shadows ?? this.shadows,
      motion: motion ?? this.motion,
      icons: icons ?? this.icons,
      interaction: interaction ?? this.interaction,
      breakpoints: breakpoints ?? this.breakpoints,
      animationMode: animationMode ?? this.animationMode,
      components: components ?? this.components,
      extensions: extensions ?? this.extensions,
    );
  }

  @override
  RebicThemeData lerp(RebicThemeData? other, double t) {
    if (other == null || t == 0) return this;
    // Nos extremos o resultado é exatamente o destino: as coleções mantêm
    // extensões presentes em só um dos lados, o que quebraria lerp(b, 1) == b.
    if (t == 1) return other;
    return RebicThemeData(
      brightness: lerpDiscrete(brightness, other.brightness, t),
      colors: colors.lerp(other.colors, t),
      typography: typography.lerp(other.typography, t),
      density: density.lerp(other.density, t),
      radius: radius.lerp(other.radius, t),
      shadows: shadows.lerp(other.shadows, t),
      motion: motion.lerp(other.motion, t),
      icons: icons.lerp(other.icons, t),
      interaction: interaction.lerp(other.interaction, t),
      breakpoints: breakpoints.lerp(other.breakpoints, t),
      animationMode: lerpDiscrete(animationMode, other.animationMode, t),
      components: components.lerp(other.components, t),
      extensions: extensions.lerp(other.extensions, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RebicThemeData &&
        other.brightness == brightness &&
        other.colors == colors &&
        other.typography == typography &&
        other.density == density &&
        other.radius == radius &&
        other.shadows == shadows &&
        other.motion == motion &&
        other.icons == icons &&
        other.interaction == interaction &&
        other.breakpoints == breakpoints &&
        other.animationMode == animationMode &&
        other.components == components &&
        other.extensions == extensions;
  }

  @override
  int get hashCode => Object.hash(
    brightness,
    colors,
    typography,
    density,
    radius,
    shadows,
    motion,
    icons,
    interaction,
    breakpoints,
    animationMode,
    components,
    extensions,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Brightness>('brightness', brightness))
      ..add(DiagnosticsProperty<RebicColorTokens>('colors', colors))
      ..add(
        DiagnosticsProperty<RebicTypographyTokens>('typography', typography),
      )
      ..add(DiagnosticsProperty<RebicDensityTokens>('density', density))
      ..add(DiagnosticsProperty<RebicRadiusTokens>('radius', radius))
      ..add(DiagnosticsProperty<RebicShadowTokens>('shadows', shadows))
      ..add(DiagnosticsProperty<RebicMotionTokens>('motion', motion))
      ..add(DiagnosticsProperty<RebicIconTokens>('icons', icons))
      ..add(
        DiagnosticsProperty<RebicInteractionStateTokens>(
          'interaction',
          interaction,
        ),
      )
      ..add(
        DiagnosticsProperty<RebicBreakpointTokens>('breakpoints', breakpoints),
      )
      ..add(EnumProperty<RebicAnimationMode>('animationMode', animationMode))
      ..add(DiagnosticsProperty<RebicTokenExtensions>('components', components))
      ..add(
        DiagnosticsProperty<RebicTokenExtensions>('extensions', extensions),
      );
  }
}
