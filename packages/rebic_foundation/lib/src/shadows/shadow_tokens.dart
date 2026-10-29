import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show BoxShadow, Color, Offset;

import '../tokens/token_set.dart';
import 'primitives/shadow_primitives.dart';
import 'shadow_layer.dart';

/// Sombras e papéis semânticos, no modelo dos parâmetros `sapContent_Shadow*`
/// do Fiori.
///
/// Nível: semântico.
///
/// Cada sombra ou papel é uma lista de camadas sem cor. Widgets obtêm sombras
/// com [boxShadows], passando a cor `shadow` do tema ativo
/// (ex.: `shadows.boxShadows(shadows.card, colors.shadow)`). A geometria é
/// a mesma nos modos claro e escuro; só a cor muda.
@immutable
class RebicShadowTokens extends RebicTokenSet<RebicShadowTokens> {
  /// Cria um mapeamento de sombras.
  const RebicShadowTokens({
    required this.none,
    required this.shadow0,
    required this.shadow1,
    required this.shadow2,
    required this.shadow3,
    required this.card,
    required this.popover,
    required this.dialog,
    required this.dragged,
    required this.header,
  });

  /// Mapeamento de referência, como no Horizon: `card` = [shadow0],
  /// `popover` = [shadow2], `dialog` = [shadow3], `dragged` = [shadow3]
  /// (provisório, ADR 0009) e `header` = sombra de cabeçalho.
  const RebicShadowTokens.fallback()
    : this(
        none: RebicShadowPrimitives.none,
        shadow0: RebicShadowPrimitives.shadow0,
        shadow1: RebicShadowPrimitives.shadow1,
        shadow2: RebicShadowPrimitives.shadow2,
        shadow3: RebicShadowPrimitives.shadow3,
        card: RebicShadowPrimitives.shadow0,
        popover: RebicShadowPrimitives.shadow2,
        dialog: RebicShadowPrimitives.shadow3,
        dragged: RebicShadowPrimitives.shadow3,
        header: RebicShadowPrimitives.header,
      );

  /// Sem sombra; para interpolar ou desligar a sombra de um papel.
  final List<RebicShadowLayer> none;

  /// Sombra de cartões (`sapContent_Shadow0`).
  final List<RebicShadowLayer> shadow0;

  /// Sombra baixa (`sapContent_Shadow1`).
  final List<RebicShadowLayer> shadow1;

  /// Sombra de popovers (`sapContent_Shadow2`).
  final List<RebicShadowLayer> shadow2;

  /// Sombra de diálogos (`sapContent_Shadow3`).
  final List<RebicShadowLayer> shadow3;

  /// Cartões e blocos.
  final List<RebicShadowLayer> card;

  /// Popovers, menus, listas suspensas e dicas.
  final List<RebicShadowLayer> popover;

  /// Diálogos e painéis modais.
  final List<RebicShadowLayer> dialog;

  /// Item arrastado.
  final List<RebicShadowLayer> dragged;

  /// Cabeçalhos e barras fixas (`sapContent_HeaderShadow`).
  final List<RebicShadowLayer> header;

  /// Sombras e papéis por nome, na ordem de declaração.
  Map<String, List<RebicShadowLayer>> get values => {
    'none': none,
    'shadow0': shadow0,
    'shadow1': shadow1,
    'shadow2': shadow2,
    'shadow3': shadow3,
    'card': card,
    'popover': popover,
    'dialog': dialog,
    'dragged': dragged,
    'header': header,
  };

  /// Sombras de caixa de [shadow] com a cor [shadowColor].
  ///
  /// Cada camada vira um [BoxShadow] com sua geometria e a cor recebida, com
  /// a opacidade multiplicada pelo fator da camada.
  List<BoxShadow> boxShadows(List<RebicShadowLayer> shadow, Color shadowColor) {
    return [
      for (final layer in shadow)
        BoxShadow(
          color: shadowColor.withValues(alpha: shadowColor.a * layer.opacity),
          offset: Offset(0, layer.offsetY),
          blurRadius: layer.blurRadius,
          spreadRadius: layer.spreadRadius,
        ),
    ];
  }

  @override
  RebicShadowTokens copyWith({
    List<RebicShadowLayer>? none,
    List<RebicShadowLayer>? shadow0,
    List<RebicShadowLayer>? shadow1,
    List<RebicShadowLayer>? shadow2,
    List<RebicShadowLayer>? shadow3,
    List<RebicShadowLayer>? card,
    List<RebicShadowLayer>? popover,
    List<RebicShadowLayer>? dialog,
    List<RebicShadowLayer>? dragged,
    List<RebicShadowLayer>? header,
  }) {
    final result = RebicShadowTokens(
      none: none ?? this.none,
      shadow0: shadow0 ?? this.shadow0,
      shadow1: shadow1 ?? this.shadow1,
      shadow2: shadow2 ?? this.shadow2,
      shadow3: shadow3 ?? this.shadow3,
      card: card ?? this.card,
      popover: popover ?? this.popover,
      dialog: dialog ?? this.dialog,
      dragged: dragged ?? this.dragged,
      header: header ?? this.header,
    );
    assert(() {
      for (final MapEntry(key: name, value: level) in result.values.entries) {
        if (level.any((layer) => !layer.isValid)) {
          throw AssertionError(
            'sombra "$name" tem camada inválida (valores finitos, desfoque e '
            'expansão ≥ 0, opacidade entre 0 e 1): $level',
          );
        }
      }
      return true;
    }());
    return result;
  }

  @override
  RebicShadowTokens lerp(RebicShadowTokens? other, double t) {
    if (other == null) return this;
    List<RebicShadowLayer> mix(
      List<RebicShadowLayer> a,
      List<RebicShadowLayer> b,
    ) => RebicShadowLayer.lerpList(a, b, t);
    return RebicShadowTokens(
      none: mix(none, other.none),
      shadow0: mix(shadow0, other.shadow0),
      shadow1: mix(shadow1, other.shadow1),
      shadow2: mix(shadow2, other.shadow2),
      shadow3: mix(shadow3, other.shadow3),
      card: mix(card, other.card),
      popover: mix(popover, other.popover),
      dialog: mix(dialog, other.dialog),
      dragged: mix(dragged, other.dragged),
      header: mix(header, other.header),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RebicShadowTokens &&
        listEquals(other.none, none) &&
        listEquals(other.shadow0, shadow0) &&
        listEquals(other.shadow1, shadow1) &&
        listEquals(other.shadow2, shadow2) &&
        listEquals(other.shadow3, shadow3) &&
        listEquals(other.card, card) &&
        listEquals(other.popover, popover) &&
        listEquals(other.dialog, dialog) &&
        listEquals(other.dragged, dragged) &&
        listEquals(other.header, header);
  }

  @override
  int get hashCode => Object.hashAll([
    for (final level in values.values) Object.hashAll(level),
  ]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    for (final MapEntry(key: name, value: level) in values.entries) {
      properties.add(IterableProperty<RebicShadowLayer>(name, level));
    }
  }
}
