import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../spacing/rebic_spacing.dart';

/// Cor de um [RebicDivider].
enum RebicDividerTone {
  /// Linha sutil (`colors.separator`), decorativa: listas e grupos de um
  /// mesmo bloco.
  subtle,

  /// Linha forte (`colors.fieldBorder`), com contraste ≥ 3:1: separa
  /// estruturas, como cabeçalho e conteúdo.
  strong,
}

/// Linha fina que separa grupos de conteúdo, como os separadores de lista e
/// o `sap.m.ToolbarSeparator` do SAPUI5.
///
/// [RebicDivider.new] é horizontal e ocupa a largura disponível;
/// [RebicDivider.vertical] ocupa a altura disponível. A cor vem de [tone], o
/// espaço em volta de [spacing] e o recuo nas pontas de [indent] e
/// [endIndent], todos do tema ativo. A espessura é a linha fina padrão, a
/// mesma da borda do `RebicContainer`. É decorativo e fica fora da semântica.
///
/// ```dart
/// const RebicColumn(children: [
///   RebicText('Itens'),
///   RebicDivider(spacing: RebicSpace.s),
///   RebicText('Total'),
/// ])
/// ```
///
/// O divisor vertical precisa que o pai defina a altura, por exemplo um
/// `RebicRow` com `crossAlignment: RebicCrossAlignment.stretch`.
class RebicDivider extends StatelessWidget {
  /// Linha horizontal.
  const RebicDivider({
    this.tone = RebicDividerTone.subtle,
    this.spacing = RebicSpace.none,
    this.indent,
    this.endIndent,
    super.key,
  }) : _axis = Axis.horizontal;

  /// Linha vertical.
  const RebicDivider.vertical({
    this.tone = RebicDividerTone.subtle,
    this.spacing = RebicSpace.none,
    this.indent,
    this.endIndent,
    super.key,
  }) : _axis = Axis.vertical;

  /// Cor da linha.
  final RebicDividerTone tone;

  /// Espaço antes e depois da linha, no eixo cruzado.
  final RebicSpace spacing;

  /// Recuo do início da linha (início do texto na horizontal, topo na
  /// vertical).
  final RebicSpace? indent;

  /// Recuo do fim da linha (fim do texto na horizontal, base na vertical).
  final RebicSpace? endIndent;

  final Axis _axis;

  @override
  Widget build(BuildContext context) {
    final t = RebicThemeData.of(context);
    // Linha fina padrão do Flutter, a mesma de `Border.all` no
    // `RebicContainer`; não há token semântico de espessura.
    final line = const BorderSide().width;
    final color = switch (tone) {
      RebicDividerTone.subtle => t.colors.separator,
      RebicDividerTone.strong => t.colors.fieldBorder,
    };
    double v(RebicSpace? s) =>
        s == null ? t.spacing.none : RebicSpacing.resolve(t.spacing, s);
    final pad = v(spacing);
    final stroke = ColoredBox(color: color);

    final Widget divider = switch (_axis) {
      Axis.horizontal => Padding(
        padding: EdgeInsetsDirectional.only(
          top: pad,
          bottom: pad,
          start: v(indent),
          end: v(endIndent),
        ),
        child: SizedBox(height: line, width: double.infinity, child: stroke),
      ),
      Axis.vertical => Padding(
        padding: EdgeInsets.only(
          left: pad,
          right: pad,
          top: v(indent),
          bottom: v(endIndent),
        ),
        child: SizedBox(width: line, height: double.infinity, child: stroke),
      ),
    };
    return ExcludeSemantics(child: divider);
  }
}
