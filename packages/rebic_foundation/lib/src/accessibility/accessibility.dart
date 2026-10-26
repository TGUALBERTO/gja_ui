import '../color/contrast_check.dart';
import '../density/density_tokens.dart';
import '../spacing/primitives/spacing_primitives.dart';
import '../tokens/motion_tokens.dart';

/// Convenções de acessibilidade do Rebic (meta WCAG 2.2 AA).
///
/// Nível: semântico.
///
/// Reúne os limites que todo widget público deve cumprir, sem duplicar
/// valores: os mínimos de contraste vêm do fundamento de cor e o alvo de
/// interação, do de densidade. Os limites não são personalizáveis por tema.
///
/// Bateria mínima de testes de um widget interativo:
///
/// ```dart
/// await expectLater(tester, meetsGuideline(textContrastGuideline));
/// await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
/// for (final density in RebicDensity.values) {
///   final size = RebicAccessibility.minTargetSize(RebicDensityTokens.of(density));
///   await expectLater(
///     tester,
///     meetsGuideline(MinimumTapTargetGuideline(
///       size: Size.square(size),
///       link: RebicAccessibility.targetSizeLink,
///     )),
///   );
/// }
/// // + render com textScaler 2,0 sem estouro, matchesSemantics e teclado.
/// ```
abstract final class RebicAccessibility {
  /// Meta de conformidade dos widgets públicos.
  static const conformanceTarget = 'WCAG 2.2 AA';

  /// Contraste mínimo de texto (WCAG 1.4.3).
  static const minTextContrast = rebicTextContrastMinimum;

  /// Contraste mínimo de elementos não textuais (WCAG 1.4.11).
  static const minNonTextContrast = rebicNonTextContrastMinimum;

  /// Escala de texto que todo widget deve suportar sem estouro (WCAG 1.4.4).
  static const minSupportedTextScale = 2.0;

  /// Menor alvo de interação permitido em qualquer densidade (WCAG 2.5.8).
  static const minTargetSizeFloor = RebicDensityTokens.minTargetSizeFloor;

  /// Alvo mínimo padrão (densidade confortável de referência), constante
  /// para uso como valor padrão de parâmetros.
  static const defaultMinTargetSize = RebicSpacingPrimitives.space48;

  /// Referência do critério de tamanho de alvo, para diretrizes de teste.
  static const targetSizeLink =
      'https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum';

  /// Alvo mínimo de interação, em largura e altura, na densidade [density].
  static double minTargetSize(RebicDensityTokens density) =>
      density.minTargetSize;

  /// Tokens de movimento efetivos.
  ///
  /// Com [disableAnimations] (ex.: `MediaQuery.disableAnimationsOf`), todas
  /// as durações valem zero e as curvas são mantidas; sem ele, [motion] é
  /// retornado sem alteração.
  static RebicMotionTokens resolveMotion(
    RebicMotionTokens motion, {
    required bool disableAnimations,
  }) {
    if (!disableAnimations) return motion;
    return motion.copyWith(
      short: Duration.zero,
      medium: Duration.zero,
      long: Duration.zero,
    );
  }
}
