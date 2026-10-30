import 'package:flutter/painting.dart' show Color, ColorProperty;

import 'package:flutter/foundation.dart';

import '../tokens/token_set.dart';
import 'primitives/color_primitives.dart';
import 'value_state.dart';

/// Cores de um estado semântico de valor.
///
/// Nível: semântico.
@immutable
class RebicValueStateColors extends RebicTokenSet<RebicValueStateColors> {
  /// Cria as cores de um estado.
  const RebicValueStateColors({
    required this.foreground,
    required this.background,
    required this.hoverBackground,
    required this.border,
  });

  /// Texto e ícones do estado (≥ 4,5:1 sobre as superfícies e sobre [background]).
  final Color foreground;

  /// Fundo suave do estado (mensagens, faixas).
  final Color background;

  /// Fundo suave do estado em hover (como `sapButton_Accept_Hover_Background`).
  ///
  /// Texto em [foreground] sobre ele mantém ≥ 4,5:1.
  final Color hoverBackground;

  /// Borda do estado (≥ 3:1 sobre as superfícies).
  final Color border;

  @override
  RebicValueStateColors copyWith({
    Color? foreground,
    Color? background,
    Color? hoverBackground,
    Color? border,
  }) {
    return RebicValueStateColors(
      foreground: foreground ?? this.foreground,
      background: background ?? this.background,
      hoverBackground: hoverBackground ?? this.hoverBackground,
      border: border ?? this.border,
    );
  }

  @override
  RebicValueStateColors lerp(RebicValueStateColors? other, double t) {
    if (other == null) return this;
    return RebicValueStateColors(
      foreground: Color.lerp(foreground, other.foreground, t)!,
      background: Color.lerp(background, other.background, t)!,
      hoverBackground: Color.lerp(hoverBackground, other.hoverBackground, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RebicValueStateColors &&
        other.foreground == foreground &&
        other.background == background &&
        other.hoverBackground == hoverBackground &&
        other.border == border;
  }

  @override
  int get hashCode =>
      Object.hash(foreground, background, hoverBackground, border);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('foreground', foreground))
      ..add(ColorProperty('background', background))
      ..add(ColorProperty('hoverBackground', hoverBackground))
      ..add(ColorProperty('border', border));
  }
}

/// Papéis semânticos de cor e cores dos estados de valor.
///
/// Nível: semântico.
///
/// Papéis no modelo de parâmetros de tema do Fiori, sem o prefixo `sap`.
/// Widgets leem cores somente daqui, ou das famílias de controle derivadas
/// destes papéis, nunca de `RebicColorPrimitives`. [RebicColorTokens.light] e
/// [RebicColorTokens.dark] são os mapeamentos de referência; ambos atendem ao
/// contraste mínimo verificado por `rebicCheckContrast`.
@immutable
class RebicColorTokens extends RebicTokenSet<RebicColorTokens> {
  /// Cria um mapeamento de cores.
  const RebicColorTokens({
    required this.background,
    required this.base,
    required this.headerBackground,
    required this.shell,
    required this.text,
    required this.label,
    required this.link,
    required this.separator,
    required this.fieldBorder,
    required this.brand,
    required this.brandHover,
    required this.highlight,
    required this.contrastText,
    required this.hoverBackground,
    required this.selectionBackground,
    required this.selectionHoverBackground,
    required this.focus,
    required this.required,
    required this.shadow,
    required this.blockLayer,
    required this.none,
    required this.success,
    required this.warning,
    required this.error,
    required this.information,
  });

  /// Mapeamento claro de referência.
  const RebicColorTokens.light()
    : this(
        background: RebicColorPrimitives.neutral50,
        base: RebicColorPrimitives.white,
        headerBackground: RebicColorPrimitives.neutral100,
        shell: RebicColorPrimitives.white,
        text: RebicColorPrimitives.neutral900,
        label: RebicColorPrimitives.neutral600,
        link: RebicColorPrimitives.blue600,
        separator: RebicColorPrimitives.neutral200,
        fieldBorder: RebicColorPrimitives.neutral500,
        brand: RebicColorPrimitives.blue600,
        brandHover: RebicColorPrimitives.blue700,
        highlight: RebicColorPrimitives.blue800,
        contrastText: RebicColorPrimitives.white,
        hoverBackground: RebicColorPrimitives.neutral100,
        selectionBackground: RebicColorPrimitives.blue50,
        selectionHoverBackground: RebicColorPrimitives.blue100,
        focus: RebicColorPrimitives.blue600,
        required: RebicColorPrimitives.magenta600,
        shadow: RebicColorPrimitives.blackAlpha16,
        blockLayer: RebicColorPrimitives.blackAlpha40,
        none: const RebicValueStateColors(
          foreground: RebicColorPrimitives.neutral700,
          background: RebicColorPrimitives.neutral100,
          hoverBackground: RebicColorPrimitives.neutral200,
          border: RebicColorPrimitives.neutral500,
        ),
        success: const RebicValueStateColors(
          foreground: RebicColorPrimitives.green700,
          background: RebicColorPrimitives.green50,
          hoverBackground: RebicColorPrimitives.green100,
          border: RebicColorPrimitives.green600,
        ),
        warning: const RebicValueStateColors(
          foreground: RebicColorPrimitives.amber700,
          background: RebicColorPrimitives.amber50,
          hoverBackground: RebicColorPrimitives.amber100,
          border: RebicColorPrimitives.amber600,
        ),
        error: const RebicValueStateColors(
          foreground: RebicColorPrimitives.red600,
          background: RebicColorPrimitives.red50,
          hoverBackground: RebicColorPrimitives.red100,
          border: RebicColorPrimitives.red600,
        ),
        information: const RebicValueStateColors(
          foreground: RebicColorPrimitives.cyan700,
          background: RebicColorPrimitives.cyan50,
          hoverBackground: RebicColorPrimitives.cyan100,
          border: RebicColorPrimitives.cyan600,
        ),
      );

  /// Mapeamento escuro de referência.
  const RebicColorTokens.dark()
    : this(
        background: RebicColorPrimitives.neutral950,
        base: RebicColorPrimitives.neutral900,
        headerBackground: RebicColorPrimitives.neutral800,
        shell: RebicColorPrimitives.neutral900,
        text: RebicColorPrimitives.neutral50,
        label: RebicColorPrimitives.neutral300,
        link: RebicColorPrimitives.blue300,
        separator: RebicColorPrimitives.neutral700,
        fieldBorder: RebicColorPrimitives.neutral400,
        brand: RebicColorPrimitives.blue300,
        brandHover: RebicColorPrimitives.blue200,
        highlight: RebicColorPrimitives.blue100,
        contrastText: RebicColorPrimitives.blue900,
        hoverBackground: RebicColorPrimitives.neutral800,
        selectionBackground: RebicColorPrimitives.blue800,
        selectionHoverBackground: RebicColorPrimitives.blue900,
        focus: RebicColorPrimitives.blue300,
        required: RebicColorPrimitives.magenta300,
        shadow: RebicColorPrimitives.blackAlpha40,
        blockLayer: RebicColorPrimitives.blackAlpha60,
        none: const RebicValueStateColors(
          foreground: RebicColorPrimitives.neutral300,
          background: RebicColorPrimitives.neutral800,
          hoverBackground: RebicColorPrimitives.neutral700,
          border: RebicColorPrimitives.neutral400,
        ),
        success: const RebicValueStateColors(
          foreground: RebicColorPrimitives.green300,
          background: RebicColorPrimitives.green900,
          hoverBackground: RebicColorPrimitives.green800,
          border: RebicColorPrimitives.green400,
        ),
        warning: const RebicValueStateColors(
          foreground: RebicColorPrimitives.amber300,
          background: RebicColorPrimitives.amber900,
          hoverBackground: RebicColorPrimitives.amber800,
          border: RebicColorPrimitives.amber400,
        ),
        error: const RebicValueStateColors(
          foreground: RebicColorPrimitives.red300,
          background: RebicColorPrimitives.red900,
          hoverBackground: RebicColorPrimitives.red800,
          border: RebicColorPrimitives.red400,
        ),
        information: const RebicValueStateColors(
          foreground: RebicColorPrimitives.cyan300,
          background: RebicColorPrimitives.cyan900,
          hoverBackground: RebicColorPrimitives.cyan800,
          border: RebicColorPrimitives.cyan400,
        ),
      );

  /// Fundo da aplicação, atrás dos contêineres (sapBackgroundColor).
  final Color background;

  /// Fundo base de contêineres, campos e controles (sapBaseColor).
  final Color base;

  /// Fundo de cabeçalhos de lista e tabela e de áreas agrupadas.
  final Color headerBackground;

  /// Fundo da barra superior da aplicação (sapShellColor).
  final Color shell;

  /// Texto e ícones principais (sapTextColor).
  final Color text;

  /// Rótulos e texto secundário (sapContent_LabelColor).
  final Color label;

  /// Texto de links (sapLinkColor).
  final Color link;

  /// Separadores e divisores decorativos (isento de contraste).
  final Color separator;

  /// Borda de campos e controles, que precisa ser percebida (≥ 3:1).
  final Color fieldBorder;

  /// Cor da marca: ênfase e texto de ações (sapBrandColor).
  final Color brand;

  /// Fundo de ações enfatizadas em hover.
  final Color brandHover;

  /// Fundo do estado ativo (pressionado) e destaques fortes (sapHighlightColor).
  final Color highlight;

  /// Texto sobre [brand], [brandHover] e [highlight].
  final Color contrastText;

  /// Fundo de controles e itens em hover.
  final Color hoverBackground;

  /// Fundo de itens e controles selecionados.
  final Color selectionBackground;

  /// Fundo de itens selecionados em hover.
  final Color selectionHoverBackground;

  /// Contorno de foco do teclado (sapContent_FocusColor).
  final Color focus;

  /// Asterisco de campo obrigatório em rótulos (sapField_RequiredColor).
  final Color required;

  /// Cor das sombras, translúcida (sapContent_ShadowColor).
  final Color shadow;

  /// Camada de bloqueio atrás de diálogos modais, translúcida (sapBlockLayer_Background).
  final Color blockLayer;

  /// Cores do estado sem destaque semântico.
  final RebicValueStateColors none;

  /// Cores do estado de sucesso.
  final RebicValueStateColors success;

  /// Cores do estado de alerta.
  final RebicValueStateColors warning;

  /// Cores do estado de erro.
  final RebicValueStateColors error;

  /// Cores do estado informativo.
  final RebicValueStateColors information;

  /// Cores do estado [state]; todo estado tem cores definidas.
  RebicValueStateColors stateColors(RebicValueState state) {
    return switch (state) {
      RebicValueState.none => none,
      RebicValueState.success => success,
      RebicValueState.warning => warning,
      RebicValueState.error => error,
      RebicValueState.information => information,
    };
  }

  /// Papéis de cor por nome, na ordem de declaração (sem os estados de valor).
  Map<String, Color> get roles => {
    'background': background,
    'base': base,
    'headerBackground': headerBackground,
    'shell': shell,
    'text': text,
    'label': label,
    'link': link,
    'separator': separator,
    'fieldBorder': fieldBorder,
    'brand': brand,
    'brandHover': brandHover,
    'highlight': highlight,
    'contrastText': contrastText,
    'hoverBackground': hoverBackground,
    'selectionBackground': selectionBackground,
    'selectionHoverBackground': selectionHoverBackground,
    'focus': focus,
    'required': required,
    'shadow': shadow,
    'blockLayer': blockLayer,
  };

  @override
  RebicColorTokens copyWith({
    Color? background,
    Color? base,
    Color? headerBackground,
    Color? shell,
    Color? text,
    Color? label,
    Color? link,
    Color? separator,
    Color? fieldBorder,
    Color? brand,
    Color? brandHover,
    Color? highlight,
    Color? contrastText,
    Color? hoverBackground,
    Color? selectionBackground,
    Color? selectionHoverBackground,
    Color? focus,
    Color? required,
    Color? shadow,
    Color? blockLayer,
    RebicValueStateColors? none,
    RebicValueStateColors? success,
    RebicValueStateColors? warning,
    RebicValueStateColors? error,
    RebicValueStateColors? information,
  }) {
    return RebicColorTokens(
      background: background ?? this.background,
      base: base ?? this.base,
      headerBackground: headerBackground ?? this.headerBackground,
      shell: shell ?? this.shell,
      text: text ?? this.text,
      label: label ?? this.label,
      link: link ?? this.link,
      separator: separator ?? this.separator,
      fieldBorder: fieldBorder ?? this.fieldBorder,
      brand: brand ?? this.brand,
      brandHover: brandHover ?? this.brandHover,
      highlight: highlight ?? this.highlight,
      contrastText: contrastText ?? this.contrastText,
      hoverBackground: hoverBackground ?? this.hoverBackground,
      selectionBackground: selectionBackground ?? this.selectionBackground,
      selectionHoverBackground:
          selectionHoverBackground ?? this.selectionHoverBackground,
      focus: focus ?? this.focus,
      required: required ?? this.required,
      shadow: shadow ?? this.shadow,
      blockLayer: blockLayer ?? this.blockLayer,
      none: none ?? this.none,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      information: information ?? this.information,
    );
  }

  @override
  RebicColorTokens lerp(RebicColorTokens? other, double t) {
    if (other == null) return this;
    return RebicColorTokens(
      background: Color.lerp(background, other.background, t)!,
      base: Color.lerp(base, other.base, t)!,
      headerBackground: Color.lerp(
        headerBackground,
        other.headerBackground,
        t,
      )!,
      shell: Color.lerp(shell, other.shell, t)!,
      text: Color.lerp(text, other.text, t)!,
      label: Color.lerp(label, other.label, t)!,
      link: Color.lerp(link, other.link, t)!,
      separator: Color.lerp(separator, other.separator, t)!,
      fieldBorder: Color.lerp(fieldBorder, other.fieldBorder, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      brandHover: Color.lerp(brandHover, other.brandHover, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      contrastText: Color.lerp(contrastText, other.contrastText, t)!,
      hoverBackground: Color.lerp(hoverBackground, other.hoverBackground, t)!,
      selectionBackground: Color.lerp(
        selectionBackground,
        other.selectionBackground,
        t,
      )!,
      selectionHoverBackground: Color.lerp(
        selectionHoverBackground,
        other.selectionHoverBackground,
        t,
      )!,
      focus: Color.lerp(focus, other.focus, t)!,
      required: Color.lerp(required, other.required, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      blockLayer: Color.lerp(blockLayer, other.blockLayer, t)!,
      none: none.lerp(other.none, t),
      success: success.lerp(other.success, t),
      warning: warning.lerp(other.warning, t),
      error: error.lerp(other.error, t),
      information: information.lerp(other.information, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RebicColorTokens &&
        other.background == background &&
        other.base == base &&
        other.headerBackground == headerBackground &&
        other.shell == shell &&
        other.text == text &&
        other.label == label &&
        other.link == link &&
        other.separator == separator &&
        other.fieldBorder == fieldBorder &&
        other.brand == brand &&
        other.brandHover == brandHover &&
        other.highlight == highlight &&
        other.contrastText == contrastText &&
        other.hoverBackground == hoverBackground &&
        other.selectionBackground == selectionBackground &&
        other.selectionHoverBackground == selectionHoverBackground &&
        other.focus == focus &&
        other.required == required &&
        other.shadow == shadow &&
        other.blockLayer == blockLayer &&
        other.none == none &&
        other.success == success &&
        other.warning == warning &&
        other.error == error &&
        other.information == information;
  }

  @override
  int get hashCode => Object.hashAll([
    background,
    base,
    headerBackground,
    shell,
    text,
    label,
    link,
    separator,
    fieldBorder,
    brand,
    brandHover,
    highlight,
    contrastText,
    hoverBackground,
    selectionBackground,
    selectionHoverBackground,
    focus,
    required,
    shadow,
    blockLayer,
    none,
    success,
    warning,
    error,
    information,
  ]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('background', background))
      ..add(ColorProperty('base', base))
      ..add(ColorProperty('headerBackground', headerBackground))
      ..add(ColorProperty('shell', shell))
      ..add(ColorProperty('text', text))
      ..add(ColorProperty('label', label))
      ..add(ColorProperty('link', link))
      ..add(ColorProperty('separator', separator))
      ..add(ColorProperty('fieldBorder', fieldBorder))
      ..add(ColorProperty('brand', brand))
      ..add(ColorProperty('brandHover', brandHover))
      ..add(ColorProperty('highlight', highlight))
      ..add(ColorProperty('contrastText', contrastText))
      ..add(ColorProperty('hoverBackground', hoverBackground))
      ..add(ColorProperty('selectionBackground', selectionBackground))
      ..add(ColorProperty('selectionHoverBackground', selectionHoverBackground))
      ..add(ColorProperty('focus', focus))
      ..add(ColorProperty('required', required))
      ..add(ColorProperty('shadow', shadow))
      ..add(ColorProperty('blockLayer', blockLayer))
      ..add(DiagnosticsProperty<RebicValueStateColors>('none', none))
      ..add(DiagnosticsProperty<RebicValueStateColors>('success', success))
      ..add(DiagnosticsProperty<RebicValueStateColors>('warning', warning))
      ..add(DiagnosticsProperty<RebicValueStateColors>('error', error))
      ..add(
        DiagnosticsProperty<RebicValueStateColors>('information', information),
      );
  }
}
