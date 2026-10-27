import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Passo ou papel de espaçamento, com os nomes de `RebicSpacingTokens`.
enum RebicSpace {
  /// Sem espaço.
  none,

  /// Menor passo.
  xxs,

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

  /// Passo extragrande.
  xxl,

  /// Maior passo.
  xxxl,

  /// Entre elementos lado a lado, como ícone e rótulo.
  inlineGap,

  /// Entre itens empilhados de um mesmo grupo.
  stackGap,

  /// Entre seções de uma página.
  sectionGap,

  /// Borda do conteúdo da página.
  pageMargin,
}

/// Espaço nomeado do Rebic, como as classes de margem e padding do SAPUI5
/// (`sapUiSmallMargin` e afins).
///
/// O valor de cada [RebicSpace] vem do `spacing` do tema ativo e muda com a
/// densidade. Três formas:
///
/// ```dart
/// Row(children: [
///   const RebicIcon(RebicIcons.info),
///   const RebicSpacing.horizontal(RebicSpace.inlineGap),
///   const RebicText('Detalhes'),
/// ])
///
/// const RebicSpacing.vertical(RebicSpace.sectionGap)
///
/// const RebicSpacing.padding(
///   all: RebicSpace.m,
///   start: RebicSpace.xl,
///   child: RebicText('Conteúdo'),
/// )
/// ```
class RebicSpacing extends StatelessWidget {
  /// Espaço vazio com a largura de [space] e altura zero, para separar itens
  /// lado a lado.
  const RebicSpacing.horizontal(RebicSpace this.space, {super.key})
    : _axis = Axis.horizontal,
      child = null,
      all = null,
      horizontal = null,
      vertical = null,
      start = null,
      end = null,
      top = null,
      bottom = null;

  /// Espaço vazio com a altura de [space] e largura zero, para separar itens
  /// empilhados.
  const RebicSpacing.vertical(RebicSpace this.space, {super.key})
    : _axis = Axis.vertical,
      child = null,
      all = null,
      horizontal = null,
      vertical = null,
      start = null,
      end = null,
      top = null,
      bottom = null;

  /// Espaço em volta de [child].
  ///
  /// Cada lado usa o valor mais específico informado: [start], [end], [top]
  /// ou [bottom]; depois [horizontal] (início e fim) ou [vertical] (topo e
  /// base); por fim [all]. Sem valor, o lado fica sem espaço. [start] e [end]
  /// seguem a direção do texto.
  const RebicSpacing.padding({
    required Widget this.child,
    this.all,
    this.horizontal,
    this.vertical,
    this.start,
    this.end,
    this.top,
    this.bottom,
    super.key,
  }) : space = null,
       _axis = null;

  /// Espaço dos separadores; nulo em [RebicSpacing.padding].
  final RebicSpace? space;

  /// Filho envolvido por [RebicSpacing.padding]; nulo nos separadores.
  final Widget? child;

  /// Todos os lados.
  final RebicSpace? all;

  /// Início e fim.
  final RebicSpace? horizontal;

  /// Topo e base.
  final RebicSpace? vertical;

  /// Início, conforme a direção do texto.
  final RebicSpace? start;

  /// Fim, conforme a direção do texto.
  final RebicSpace? end;

  /// Topo.
  final RebicSpace? top;

  /// Base.
  final RebicSpace? bottom;

  final Axis? _axis;

  /// Valor de [space] em [spacing].
  static double resolve(RebicSpacingTokens spacing, RebicSpace space) =>
      switch (space) {
        RebicSpace.none => spacing.none,
        RebicSpace.xxs => spacing.xxs,
        RebicSpace.xs => spacing.xs,
        RebicSpace.s => spacing.s,
        RebicSpace.m => spacing.m,
        RebicSpace.l => spacing.l,
        RebicSpace.xl => spacing.xl,
        RebicSpace.xxl => spacing.xxl,
        RebicSpace.xxxl => spacing.xxxl,
        RebicSpace.inlineGap => spacing.inlineGap,
        RebicSpace.stackGap => spacing.stackGap,
        RebicSpace.sectionGap => spacing.sectionGap,
        RebicSpace.pageMargin => spacing.pageMargin,
      };

  @override
  Widget build(BuildContext context) {
    final spacing = RebicThemeData.of(context).spacing;
    double value(RebicSpace? side) =>
        side == null ? spacing.none : resolve(spacing, side);

    final axis = _axis;
    if (axis != null) {
      final v = value(space);
      return axis == Axis.horizontal ? SizedBox(width: v) : SizedBox(height: v);
    }
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: value(start ?? horizontal ?? all),
        end: value(end ?? horizontal ?? all),
        top: value(top ?? vertical ?? all),
        bottom: value(bottom ?? vertical ?? all),
      ),
      child: child,
    );
  }
}
