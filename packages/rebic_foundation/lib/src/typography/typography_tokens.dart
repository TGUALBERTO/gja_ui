import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show TextLeadingDistribution, TextStyle;

import '../tokens/token_set.dart';
import 'primitives/typography_primitives.dart';

typedef _P = RebicTypographyPrimitives;

const _display = TextStyle(
  fontFamily: _P.fontFamily,
  fontFamilyFallback: _P.fontFamilyFallback,
  leadingDistribution: TextLeadingDistribution.even,
  fontSize: _P.size40,
  height: _P.lineHeight48 / _P.size40,
  fontWeight: _P.semibold,
);

const _headline = TextStyle(
  fontFamily: _P.fontFamily,
  fontFamilyFallback: _P.fontFamilyFallback,
  leadingDistribution: TextLeadingDistribution.even,
  fontSize: _P.size32,
  height: _P.lineHeight40 / _P.size32,
  fontWeight: _P.semibold,
);

const _title = TextStyle(
  fontFamily: _P.fontFamily,
  fontFamilyFallback: _P.fontFamilyFallback,
  leadingDistribution: TextLeadingDistribution.even,
  fontSize: _P.size24,
  height: _P.lineHeight32 / _P.size24,
  fontWeight: _P.semibold,
);

const _subtitle = TextStyle(
  fontFamily: _P.fontFamily,
  fontFamilyFallback: _P.fontFamilyFallback,
  leadingDistribution: TextLeadingDistribution.even,
  fontSize: _P.size18,
  height: _P.lineHeight24 / _P.size18,
  fontWeight: _P.semibold,
);

const _body = TextStyle(
  fontFamily: _P.fontFamily,
  fontFamilyFallback: _P.fontFamilyFallback,
  leadingDistribution: TextLeadingDistribution.even,
  fontSize: _P.size14,
  height: _P.lineHeight20 / _P.size14,
  fontWeight: _P.regular,
);

const _bodyStrong = TextStyle(
  fontFamily: _P.fontFamily,
  fontFamilyFallback: _P.fontFamilyFallback,
  leadingDistribution: TextLeadingDistribution.even,
  fontSize: _P.size14,
  height: _P.lineHeight20 / _P.size14,
  fontWeight: _P.semibold,
);

const _label = TextStyle(
  fontFamily: _P.fontFamily,
  fontFamilyFallback: _P.fontFamilyFallback,
  leadingDistribution: TextLeadingDistribution.even,
  fontSize: _P.size14,
  height: _P.lineHeight20 / _P.size14,
  fontWeight: _P.medium,
);

const _caption = TextStyle(
  fontFamily: _P.fontFamily,
  fontFamilyFallback: _P.fontFamilyFallback,
  leadingDistribution: TextLeadingDistribution.even,
  fontSize: _P.size12,
  height: _P.lineHeight16 / _P.size12,
  fontWeight: _P.regular,
);

/// Estilos semânticos de texto.
///
/// Nível: semântico.
///
/// Widgets usam somente estes estilos (ou tokens de componente derivados),
/// combinados com uma cor dos papéis de cor (ex.:
/// `typography.body.copyWith(color: colors.text)`). Nenhum estilo define
/// cor ou fundo. Tamanhos e alturas são pixels lógicos antes da escala de
/// texto do sistema.
@immutable
class RebicTypographyTokens extends RebicTokenSet<RebicTypographyTokens> {
  /// Cria um mapeamento tipográfico.
  const RebicTypographyTokens({
    required this.display,
    required this.headline,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.bodyStrong,
    required this.label,
    required this.caption,
  });

  /// Mapeamento de referência, com a Inter empacotada.
  const RebicTypographyTokens.fallback()
    : this(
        display: _display,
        headline: _headline,
        title: _title,
        subtitle: _subtitle,
        body: _body,
        bodyStrong: _bodyStrong,
        label: _label,
        caption: _caption,
      );

  /// Destaque de página (números de painel, telas vazias).
  final TextStyle display;

  /// Título de página.
  final TextStyle headline;

  /// Título de seção ou de cartão.
  final TextStyle title;

  /// Subtítulo e cabeçalho de grupo.
  final TextStyle subtitle;

  /// Texto corrido.
  final TextStyle body;

  /// Texto corrido com ênfase.
  final TextStyle bodyStrong;

  /// Rótulos de controles (botões, campos, abas).
  final TextStyle label;

  /// Texto auxiliar (legendas, mensagens de campo).
  final TextStyle caption;

  /// Estilos por nome, na ordem de declaração.
  Map<String, TextStyle> get styles => {
    'display': display,
    'headline': headline,
    'title': title,
    'subtitle': subtitle,
    'body': body,
    'bodyStrong': bodyStrong,
    'label': label,
    'caption': caption,
  };

  @override
  RebicTypographyTokens copyWith({
    TextStyle? display,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? subtitle,
    TextStyle? body,
    TextStyle? bodyStrong,
    TextStyle? label,
    TextStyle? caption,
  }) {
    return RebicTypographyTokens(
      display: display ?? this.display,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      body: body ?? this.body,
      bodyStrong: bodyStrong ?? this.bodyStrong,
      label: label ?? this.label,
      caption: caption ?? this.caption,
    );
  }

  @override
  RebicTypographyTokens lerp(RebicTypographyTokens? other, double t) {
    if (other == null) return this;
    TextStyle mix(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return RebicTypographyTokens(
      display: mix(display, other.display),
      headline: mix(headline, other.headline),
      title: mix(title, other.title),
      subtitle: mix(subtitle, other.subtitle),
      body: mix(body, other.body),
      bodyStrong: mix(bodyStrong, other.bodyStrong),
      label: mix(label, other.label),
      caption: mix(caption, other.caption),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RebicTypographyTokens &&
        other.display == display &&
        other.headline == headline &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.body == body &&
        other.bodyStrong == bodyStrong &&
        other.label == label &&
        other.caption == caption;
  }

  @override
  int get hashCode => Object.hash(
    display,
    headline,
    title,
    subtitle,
    body,
    bodyStrong,
    label,
    caption,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    for (final MapEntry(key: name, value: style) in styles.entries) {
      properties.add(DiagnosticsProperty<TextStyle>(name, style));
    }
  }
}
