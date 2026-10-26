import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show BoxShadow, Color, Offset;

import '../tokens/token_set.dart';
import 'primitives/elevation_primitives.dart';
import 'shadow_layer.dart';

/// Sombras e papéis semânticos de elevação, no modelo Fiori.
///
/// Nível: semântico.
///
/// Cada sombra ou papel é uma lista de camadas sem cor. Widgets obtêm sombras
/// com [shadowsFor], passando a cor `shadow` do tema ativo
/// (ex.: `elevation.shadowsFor(elevation.card, colors.shadow)`). A geometria é
/// a mesma nos modos claro e escuro; só a cor muda.
@immutable
class RebicElevationTokens extends RebicTokenSet<RebicElevationTokens> {
  /// Cria um mapeamento de elevação.
  const RebicElevationTokens({
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

  /// Mapeamento de referência: `card` = [shadow0], `popover` = [shadow1],
  /// `dialog` = [shadow2], `dragged` = [shadow3] e `header` = sombra de
  /// cabeçalho.
  const RebicElevationTokens.fallback()
    : this(
        none: RebicElevationPrimitives.none,
        shadow0: RebicElevationPrimitives.shadow0,
        shadow1: RebicElevationPrimitives.shadow1,
        shadow2: RebicElevationPrimitives.shadow2,
        shadow3: RebicElevationPrimitives.shadow3,
        card: RebicElevationPrimitives.shadow0,
        popover: RebicElevationPrimitives.shadow1,
        dialog: RebicElevationPrimitives.shadow2,
        dragged: RebicElevationPrimitives.shadow3,
        header: RebicElevationPrimitives.header,
      );

  /// Sem sombra; para interpolar ou desligar a sombra de um papel.
  final List<RebicShadowLayer> none;

  /// Sombra sutil (`sapContent_Shadow0`).
  final List<RebicShadowLayer> shadow0;

  /// Sombra baixa (`sapContent_Shadow1`).
  final List<RebicShadowLayer> shadow1;

  /// Sombra média (`sapContent_Shadow2`).
  final List<RebicShadowLayer> shadow2;

  /// Sombra alta (`sapContent_Shadow3`).
  final List<RebicShadowLayer> shadow3;

  /// Cartões e blocos.
  final List<RebicShadowLayer> card;

  /// Menus, listas suspensas e popovers.
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

  /// Sombras de caixa de [level] com a cor [shadowColor].
  ///
  /// Cada camada vira um [BoxShadow] com sua geometria e a cor recebida, com
  /// a opacidade multiplicada pelo fator da camada.
  List<BoxShadow> shadowsFor(List<RebicShadowLayer> level, Color shadowColor) {
    return [
      for (final layer in level)
        BoxShadow(
          color: shadowColor.withValues(alpha: shadowColor.a * layer.opacity),
          offset: Offset(0, layer.offsetY),
          blurRadius: layer.blurRadius,
          spreadRadius: layer.spreadRadius,
        ),
    ];
  }

  @override
  RebicElevationTokens copyWith({
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
    final result = RebicElevationTokens(
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
            'elevação "$name" tem camada inválida (valores finitos, desfoque e '
            'expansão ≥ 0, opacidade entre 0 e 1): $level',
          );
        }
      }
      return true;
    }());
    return result;
  }

  @override
  RebicElevationTokens lerp(RebicElevationTokens? other, double t) {
    if (other == null) return this;
    List<RebicShadowLayer> mix(
      List<RebicShadowLayer> a,
      List<RebicShadowLayer> b,
    ) => RebicShadowLayer.lerpList(a, b, t);
    return RebicElevationTokens(
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
    return other is RebicElevationTokens &&
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
