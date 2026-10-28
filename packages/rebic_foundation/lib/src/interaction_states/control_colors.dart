import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show Color, ColorProperty;

import '../color/color_tokens.dart';
import '../color/primitives/color_primitives.dart';
import '../color/value_state.dart';
import '../tokens/token_set.dart';
import 'interaction_state.dart';

/// Família de controle, no modelo dos tipos de botão e itens de lista do Fiori.
///
/// Nível: semântico.
enum RebicControlFamily {
  /// Controle padrão (botão Default): fundo base, borda e texto da marca.
  standard,

  /// Ação enfatizada (botão Emphasized): fundo da marca, texto de contraste.
  emphasized,

  /// Controle sem fundo (botão Transparent): só o texto da marca.
  transparent,

  /// Ação positiva (botão Accept): cores do estado de valor `success`.
  accept,

  /// Ação negativa (botão Reject): cores do estado de valor `error`.
  reject,

  /// Ação que pede atenção (botão Attention): cores do estado de valor
  /// `warning`.
  attention,

  /// Item de lista ou linha de tabela.
  list,
}

/// Fundo, borda e texto de um controle em um estado.
///
/// Nível: semântico.
@immutable
class RebicStateColors extends RebicTokenSet<RebicStateColors> {
  /// Cria as cores de um estado.
  const RebicStateColors({
    required this.background,
    required this.border,
    required this.text,
  });

  /// Fundo do controle.
  final Color background;

  /// Borda do controle (transparente quando a família não tem borda).
  final Color border;

  /// Texto e ícones do controle.
  final Color text;

  @override
  RebicStateColors copyWith({Color? background, Color? border, Color? text}) {
    return RebicStateColors(
      background: background ?? this.background,
      border: border ?? this.border,
      text: text ?? this.text,
    );
  }

  @override
  RebicStateColors lerp(RebicStateColors? other, double t) {
    if (other == null) return this;
    return RebicStateColors(
      background: Color.lerp(background, other.background, t)!,
      border: Color.lerp(border, other.border, t)!,
      text: Color.lerp(text, other.text, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RebicStateColors &&
        other.background == background &&
        other.border == border &&
        other.text == text;
  }

  @override
  int get hashCode => Object.hash(background, border, text);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('background', background))
      ..add(ColorProperty('border', border))
      ..add(ColorProperty('text', text));
  }
}

/// Cores de uma família de controle em cada estado.
///
/// Nível: semântico.
///
/// Derivadas dos papéis de cor por [RebicControlColors.of], como os
/// parâmetros derivados do Fiori: trocar `brand` no tema alcança todas as
/// famílias. Use [resolve] para obter as cores de um conjunto de estados.
@immutable
class RebicControlColors extends RebicTokenSet<RebicControlColors> {
  /// Cria as cores de uma família.
  const RebicControlColors({
    required this.normal,
    required this.hover,
    required this.active,
    required this.selected,
    required this.selectedHover,
  });

  /// Cores de [family] derivadas de [colors].
  factory RebicControlColors.of(
    RebicControlFamily family,
    RebicColorTokens colors,
  ) {
    const none = RebicColorPrimitives.transparent;
    final c = colors;
    RebicStateColors s(Color background, Color border, Color text) =>
        RebicStateColors(background: background, border: border, text: text);
    final active = s(c.highlight, c.highlight, c.contrastText);
    return switch (family) {
      RebicControlFamily.standard => RebicControlColors(
        normal: s(c.base, c.fieldBorder, c.brand),
        hover: s(c.hoverBackground, c.fieldBorder, c.brand),
        active: active,
        selected: s(c.selectionBackground, c.brand, c.brand),
        selectedHover: s(c.selectionHoverBackground, c.brand, c.brand),
      ),
      RebicControlFamily.emphasized => RebicControlColors(
        normal: s(c.brand, c.brand, c.contrastText),
        hover: s(c.brandHover, c.brandHover, c.contrastText),
        active: active,
        selected: active,
        selectedHover: active,
      ),
      RebicControlFamily.transparent => RebicControlColors(
        normal: s(none, none, c.brand),
        hover: s(c.hoverBackground, none, c.brand),
        active: s(c.highlight, none, c.contrastText),
        selected: s(c.selectionBackground, none, c.brand),
        selectedHover: s(c.selectionHoverBackground, none, c.brand),
      ),
      RebicControlFamily.accept => _semantic(
        c,
        RebicValueState.success,
        active,
      ),
      RebicControlFamily.reject => _semantic(c, RebicValueState.error, active),
      RebicControlFamily.attention => _semantic(
        c,
        RebicValueState.warning,
        active,
      ),
      RebicControlFamily.list => RebicControlColors(
        normal: s(c.base, none, c.text),
        hover: s(c.hoverBackground, none, c.text),
        active: s(c.highlight, none, c.contrastText),
        selected: s(c.selectionBackground, none, c.text),
        selectedHover: s(c.selectionHoverBackground, none, c.text),
      ),
    };
  }

  /// Família de uma ação semântica, com as cores do estado de valor [state]
  /// no normal e no hover, e [active] nos demais estados.
  static RebicControlColors _semantic(
    RebicColorTokens c,
    RebicValueState state,
    RebicStateColors active,
  ) {
    final s = c.stateColors(state);
    return RebicControlColors(
      normal: RebicStateColors(
        background: s.background,
        border: s.border,
        text: s.foreground,
      ),
      hover: RebicStateColors(
        background: c.hoverBackground,
        border: s.border,
        text: s.foreground,
      ),
      active: active,
      selected: active,
      selectedHover: active,
    );
  }

  /// Estado normal (e desabilitado, com a opacidade de desabilitado).
  final RebicStateColors normal;

  /// Ponteiro sobre o controle.
  final RebicStateColors hover;

  /// Controle pressionado ou arrastado.
  final RebicStateColors active;

  /// Controle selecionado.
  final RebicStateColors selected;

  /// Controle selecionado com o ponteiro sobre ele.
  final RebicStateColors selectedHover;

  /// Estados por nome, na ordem de declaração.
  Map<String, RebicStateColors> get states => {
    'normal': normal,
    'hover': hover,
    'active': active,
    'selected': selected,
    'selectedHover': selectedHover,
  };

  /// Cores para [states], na precedência do Fiori.
  ///
  /// `disabled` → normal (a opacidade vem de
  /// `RebicInteractionStateTokens.opacity`); `pressed` ou `dragged` → ativo;
  /// `selected` com `hovered` → selecionado com hover; `selected` →
  /// selecionado; `hovered` → hover; demais → normal. `focused` não altera
  /// as cores.
  RebicStateColors resolve(Set<RebicInteractionState> states) {
    bool has(RebicInteractionState s) => states.contains(s);
    if (has(RebicInteractionState.disabled)) return normal;
    if (has(RebicInteractionState.pressed) ||
        has(RebicInteractionState.dragged)) {
      return active;
    }
    if (has(RebicInteractionState.selected)) {
      return has(RebicInteractionState.hovered) ? selectedHover : selected;
    }
    if (has(RebicInteractionState.hovered)) return hover;
    return normal;
  }

  @override
  RebicControlColors copyWith({
    RebicStateColors? normal,
    RebicStateColors? hover,
    RebicStateColors? active,
    RebicStateColors? selected,
    RebicStateColors? selectedHover,
  }) {
    return RebicControlColors(
      normal: normal ?? this.normal,
      hover: hover ?? this.hover,
      active: active ?? this.active,
      selected: selected ?? this.selected,
      selectedHover: selectedHover ?? this.selectedHover,
    );
  }

  @override
  RebicControlColors lerp(RebicControlColors? other, double t) {
    if (other == null) return this;
    return RebicControlColors(
      normal: normal.lerp(other.normal, t),
      hover: hover.lerp(other.hover, t),
      active: active.lerp(other.active, t),
      selected: selected.lerp(other.selected, t),
      selectedHover: selectedHover.lerp(other.selectedHover, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RebicControlColors &&
        other.normal == normal &&
        other.hover == hover &&
        other.active == active &&
        other.selected == selected &&
        other.selectedHover == selectedHover;
  }

  @override
  int get hashCode =>
      Object.hash(normal, hover, active, selected, selectedHover);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    for (final MapEntry(key: name, value: colors) in states.entries) {
      properties.add(DiagnosticsProperty<RebicStateColors>(name, colors));
    }
  }
}
