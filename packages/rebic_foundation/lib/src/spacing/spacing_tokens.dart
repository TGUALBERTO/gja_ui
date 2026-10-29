import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

import '../breakpoints/size_class.dart';
import '../tokens/token_set.dart';
import 'primitives/spacing_primitives.dart';

/// Passos e papéis semânticos de espaçamento, em pixels lógicos.
///
/// Nível: semântico.
///
/// Widgets expressam padding, margem e distância entre filhos somente com
/// estes valores (ex.: `EdgeInsets.all(spacing.m)`). Os passos (`none` a
/// `xxxl`) são relativos; os papéis de layout ([inlineGap], [stackGap],
/// [sectionGap], [pageMargin]) dão nome à intenção e podem ser ajustados sem
/// mexer na escala. A margem de página varia pela classe de tamanho, como o
/// `sapUiResponsivePadding` do Fiori ([pageMarginFor]); as margens de M a XL
/// ficam fora do diagnóstico, que lista só os passos e papéis de `RebicSpace`. Todos os valores devem ser finitos e não negativos; o
/// construtor `const` não consegue verificar isso, e [copyWith] verifica com
/// `assert` em modo debug.
@immutable
class RebicSpacingTokens extends RebicTokenSet<RebicSpacingTokens> {
  /// Cria um mapeamento de espaçamento.
  const RebicSpacingTokens({
    required this.none,
    required this.xxs,
    required this.xs,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.inlineGap,
    required this.stackGap,
    required this.sectionGap,
    required this.pageMargin,
    required this.pageMarginMedium,
    required this.pageMarginLarge,
    required this.pageMarginExtraLarge,
  });

  /// Mapeamento de referência, igual nas densidades cozy e compacta.
  const RebicSpacingTokens.fallback()
    : this(
        none: RebicSpacingPrimitives.space0,
        xxs: RebicSpacingPrimitives.space2,
        xs: RebicSpacingPrimitives.space4,
        s: RebicSpacingPrimitives.space8,
        m: RebicSpacingPrimitives.space12,
        l: RebicSpacingPrimitives.space16,
        xl: RebicSpacingPrimitives.space24,
        xxl: RebicSpacingPrimitives.space32,
        xxxl: RebicSpacingPrimitives.space48,
        inlineGap: RebicSpacingPrimitives.space8,
        stackGap: RebicSpacingPrimitives.space12,
        sectionGap: RebicSpacingPrimitives.space32,
        pageMargin: RebicSpacingPrimitives.space16,
        pageMarginMedium: RebicSpacingPrimitives.space32,
        pageMarginLarge: RebicSpacingPrimitives.space32,
        pageMarginExtraLarge: RebicSpacingPrimitives.space48,
      );

  /// Sem espaço.
  final double none;

  /// Menor passo (ajustes finos, como entre um texto e seu sublinhado).
  final double xxs;

  /// Passo muito pequeno.
  final double xs;

  /// Passo pequeno (`sapUiTinyMargin`, 0.5rem, na referência).
  final double s;

  /// Passo médio.
  final double m;

  /// Passo grande (`sapUiSmallMargin`, 1rem, na referência).
  final double l;

  /// Passo muito grande.
  final double xl;

  /// Passo extragrande (`sapUiMediumMargin`, 2rem, na referência).
  final double xxl;

  /// Maior passo (`sapUiLargeMargin`, 3rem, na referência).
  final double xxxl;

  /// Entre elementos lado a lado, como ícone e rótulo.
  final double inlineGap;

  /// Entre itens empilhados de um mesmo grupo.
  final double stackGap;

  /// Entre seções de uma página.
  final double sectionGap;

  /// Borda do conteúdo da página na classe de tamanho S.
  final double pageMargin;

  /// Borda do conteúdo da página na classe M.
  final double pageMarginMedium;

  /// Borda do conteúdo da página na classe L.
  final double pageMarginLarge;

  /// Borda do conteúdo da página na classe XL.
  final double pageMarginExtraLarge;

  /// Borda do conteúdo de uma página da classe [sizeClass], como o padding
  /// responsivo da `sap.f.DynamicPage`.
  double pageMarginFor(RebicSizeClass sizeClass) => switch (sizeClass) {
    RebicSizeClass.small => pageMargin,
    RebicSizeClass.medium => pageMarginMedium,
    RebicSizeClass.large => pageMarginLarge,
    RebicSizeClass.extraLarge => pageMarginExtraLarge,
  };

  /// Margens de página de M a XL, por nome.
  Map<String, double> get _pageMargins => {
    'pageMarginMedium': pageMarginMedium,
    'pageMarginLarge': pageMarginLarge,
    'pageMarginExtraLarge': pageMarginExtraLarge,
  };

  /// Valores por nome, na ordem de declaração.
  Map<String, double> get _values => {
    'none': none,
    'xxs': xxs,
    'xs': xs,
    's': s,
    'm': m,
    'l': l,
    'xl': xl,
    'xxl': xxl,
    'xxxl': xxxl,
    'inlineGap': inlineGap,
    'stackGap': stackGap,
    'sectionGap': sectionGap,
    'pageMargin': pageMargin,
  };

  @override
  RebicSpacingTokens copyWith({
    double? none,
    double? xxs,
    double? xs,
    double? s,
    double? m,
    double? l,
    double? xl,
    double? xxl,
    double? xxxl,
    double? inlineGap,
    double? stackGap,
    double? sectionGap,
    double? pageMargin,
    double? pageMarginMedium,
    double? pageMarginLarge,
    double? pageMarginExtraLarge,
  }) {
    final result = RebicSpacingTokens(
      none: none ?? this.none,
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      s: s ?? this.s,
      m: m ?? this.m,
      l: l ?? this.l,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      inlineGap: inlineGap ?? this.inlineGap,
      stackGap: stackGap ?? this.stackGap,
      sectionGap: sectionGap ?? this.sectionGap,
      pageMargin: pageMargin ?? this.pageMargin,
      pageMarginMedium: pageMarginMedium ?? this.pageMarginMedium,
      pageMarginLarge: pageMarginLarge ?? this.pageMarginLarge,
      pageMarginExtraLarge: pageMarginExtraLarge ?? this.pageMarginExtraLarge,
    );
    assert(() {
      for (final MapEntry(key: name, value: value) in {
        ...result._values,
        ...result._pageMargins,
      }.entries) {
        if (!value.isFinite || value < 0) {
          throw AssertionError(
            'espaçamento "$name" deve ser finito e não negativo: $value',
          );
        }
      }
      return true;
    }());
    return result;
  }

  @override
  RebicSpacingTokens lerp(RebicSpacingTokens? other, double t) {
    if (other == null) return this;
    double mix(double a, double b) => lerpDouble(a, b, t)!;
    return RebicSpacingTokens(
      none: mix(none, other.none),
      xxs: mix(xxs, other.xxs),
      xs: mix(xs, other.xs),
      s: mix(s, other.s),
      m: mix(m, other.m),
      l: mix(l, other.l),
      xl: mix(xl, other.xl),
      xxl: mix(xxl, other.xxl),
      xxxl: mix(xxxl, other.xxxl),
      inlineGap: mix(inlineGap, other.inlineGap),
      stackGap: mix(stackGap, other.stackGap),
      sectionGap: mix(sectionGap, other.sectionGap),
      pageMargin: mix(pageMargin, other.pageMargin),
      pageMarginMedium: mix(pageMarginMedium, other.pageMarginMedium),
      pageMarginLarge: mix(pageMarginLarge, other.pageMarginLarge),
      pageMarginExtraLarge: mix(
        pageMarginExtraLarge,
        other.pageMarginExtraLarge,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RebicSpacingTokens &&
        other.none == none &&
        other.xxs == xxs &&
        other.xs == xs &&
        other.s == s &&
        other.m == m &&
        other.l == l &&
        other.xl == xl &&
        other.xxl == xxl &&
        other.xxxl == xxxl &&
        other.inlineGap == inlineGap &&
        other.stackGap == stackGap &&
        other.sectionGap == sectionGap &&
        other.pageMargin == pageMargin &&
        other.pageMarginMedium == pageMarginMedium &&
        other.pageMarginLarge == pageMarginLarge &&
        other.pageMarginExtraLarge == pageMarginExtraLarge;
  }

  @override
  int get hashCode => Object.hash(
    none,
    xxs,
    xs,
    s,
    m,
    l,
    xl,
    xxl,
    xxxl,
    inlineGap,
    stackGap,
    sectionGap,
    pageMargin,
    pageMarginMedium,
    pageMarginLarge,
    pageMarginExtraLarge,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    for (final MapEntry(key: name, value: value) in _values.entries) {
      properties.add(DoubleProperty(name, value));
    }
  }
}
