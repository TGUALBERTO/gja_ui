import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../spacing/rebic_spacing.dart';

/// Fundo de um [RebicContainer], por papel de cor do tema.
enum RebicSurface {
  /// Sem fundo (transparente).
  none,

  /// Fundo da página (`colors.background`).
  background,

  /// Superfície de conteúdo, como cartões e painéis (`colors.base`).
  base,

  /// Cabeçalhos e barras de grupo (`colors.headerBackground`).
  header,

  /// Barra da aplicação (`colors.shell`).
  shell,
}

/// Raio dos cantos de um [RebicContainer], com os nomes de
/// `RebicRadiusTokens`.
enum RebicRadius {
  /// Cantos retos.
  none,

  /// Passo muito pequeno.
  xs,

  /// Passo pequeno.
  s,

  /// Passo médio.
  m,

  /// Passo grande.
  l,

  /// Passo muito grande.
  xl,

  /// Pílula: cantos máximos.
  full,

  /// Papel de botões, campos e caixas de seleção.
  control,

  /// Papel de cartões, diálogos e menus.
  container,
}

/// Sombra de um [RebicContainer], por papel de `RebicElevationTokens`.
enum RebicElevation {
  /// Sem sombra.
  none,

  /// Cartões e blocos.
  card,

  /// Menus, listas suspensas e popovers.
  popover,

  /// Diálogos e painéis modais.
  dialog,

  /// Item arrastado.
  dragged,

  /// Cabeçalhos e barras fixas.
  header,
}

/// Superfície do Rebic que agrupa conteúdo, como o `backgroundDesign` e os
/// parâmetros de superfície do SAPUI5.
///
/// Cada aspecto é um papel do tema ativo: fundo ([surface]), borda
/// `separator` de 1 px ([border]), cantos ([radius], com recorte do
/// conteúdo), sombra ([elevation], com a cor `shadow`) e espaço interno
/// ([padding], pela densidade). Não há valores literais nem tamanho próprio.
///
/// ```dart
/// const RebicContainer(
///   surface: RebicSurface.base,
///   border: true,
///   radius: RebicRadius.container,
///   elevation: RebicElevation.card,
///   padding: RebicSpace.l,
///   child: RebicText('Pedido 4711'),
/// )
/// ```
///
/// Para espaço diferente por lado, use `RebicSpacing.padding` dentro do
/// contêiner.
class RebicContainer extends StatelessWidget {
  /// Cria a superfície.
  const RebicContainer({
    this.child,
    this.surface = RebicSurface.none,
    this.border = false,
    this.radius = RebicRadius.none,
    this.elevation = RebicElevation.none,
    this.padding,
    super.key,
  });

  /// Conteúdo.
  final Widget? child;

  /// Fundo.
  final RebicSurface surface;

  /// Se a borda `separator` é desenhada.
  final bool border;

  /// Raio dos cantos; diferente de `none`, recorta o conteúdo.
  final RebicRadius radius;

  /// Papel de sombra.
  final RebicElevation elevation;

  /// Espaço interno em todos os lados; nulo não acrescenta espaço.
  final RebicSpace? padding;

  static Color? _surface(RebicColorTokens c, RebicSurface surface) =>
      switch (surface) {
        RebicSurface.none => null,
        RebicSurface.background => c.background,
        RebicSurface.base => c.base,
        RebicSurface.header => c.headerBackground,
        RebicSurface.shell => c.shell,
      };

  static double _radius(RebicRadiusTokens r, RebicRadius radius) =>
      switch (radius) {
        RebicRadius.none => r.none,
        RebicRadius.xs => r.xs,
        RebicRadius.s => r.s,
        RebicRadius.m => r.m,
        RebicRadius.l => r.l,
        RebicRadius.xl => r.xl,
        RebicRadius.full => r.full,
        RebicRadius.control => r.control,
        RebicRadius.container => r.container,
      };

  static List<RebicShadowLayer> _shadow(
    RebicElevationTokens e,
    RebicElevation elevation,
  ) => switch (elevation) {
    RebicElevation.none => e.none,
    RebicElevation.card => e.card,
    RebicElevation.popover => e.popover,
    RebicElevation.dialog => e.dialog,
    RebicElevation.dragged => e.dragged,
    RebicElevation.header => e.header,
  };

  @override
  Widget build(BuildContext context) {
    final t = RebicThemeData.of(context);
    final rounded = radius != RebicRadius.none;
    final corners = BorderRadius.circular(_radius(t.radius, radius));

    Widget? content = child;
    final space = padding;
    if (space != null) {
      content = Padding(
        padding: EdgeInsets.all(RebicSpacing.resolve(t.spacing, space)),
        child: content,
      );
    }
    if (rounded && content != null) {
      content = ClipRRect(borderRadius: corners, child: content);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _surface(t.colors, surface),
        border: border ? Border.all(color: t.colors.separator) : null,
        borderRadius: rounded ? corners : null,
        boxShadow: t.elevation.shadowsFor(
          _shadow(t.elevation, elevation),
          t.colors.shadow,
        ),
      ),
      child: content,
    );
  }
}
