import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Linha fina que separa itens e grupos de conteúdo, como o
/// `sap.m.ToolbarSeparator` do SAPUI5.
///
/// [RebicSeparator.new] é horizontal e ocupa a largura disponível.
/// [RebicSeparator.vertical] tem a altura `density.separatorHeight` e fica
/// centrado na altura de quem o contém, sem esticar, como o separador de uma
/// barra. A cor é `colors.separator`, e a espessura é a linha fina padrão, a
/// mesma da borda do `RebicContainer`.
///
/// Como no UI5, não há espaço próprio em volta da linha: ele vem do
/// contêiner, por exemplo o `gap` de um `RebicVBox` ou o espaço entre os
/// itens de um `RebicBar`. É decorativo e fica fora da semântica.
///
/// ```dart
/// const RebicVBox(items: [
///   RebicText('Itens'),
///   RebicSeparator(),
///   RebicText('Total'),
/// ])
/// ```
class RebicSeparator extends StatelessWidget {
  /// Linha horizontal.
  const RebicSeparator({super.key}) : _axis = Axis.horizontal;

  /// Linha vertical, com a altura de separador da densidade.
  const RebicSeparator.vertical({super.key}) : _axis = Axis.vertical;

  final Axis _axis;

  @override
  Widget build(BuildContext context) {
    final t = RebicThemeData.of(context);
    // Linha fina padrão do Flutter (`sapElement_BorderWidth`), a mesma de
    // `Border.all` no `RebicContainer`; não há token semântico de espessura.
    final line = const BorderSide().width;
    final stroke = ColoredBox(color: t.colors.separator);

    final Widget separator = switch (_axis) {
      Axis.horizontal => SizedBox(
        height: line,
        width: double.infinity,
        child: stroke,
      ),
      // O `Center` mantém a altura da densidade mesmo sob altura imposta pelo
      // pai, e encolhe à linha na largura.
      Axis.vertical => Center(
        child: SizedBox(
          width: line,
          height: t.density.separatorHeight,
          child: stroke,
        ),
      ),
    };
    return ExcludeSemantics(child: separator);
  }
}
