import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Aplica um tema do Rebic a uma subárvore.
///
/// Publica [data] para os widgets e para o núcleo (lido com
/// [RebicTheme.of]), anima a troca de tema e define o estilo de texto padrão
/// (`base` com a cor `text`) e o ícone padrão (cor `text`, tamanho `control`).
/// Não pinta nada e não é interativo.
///
/// Use [RebicTheme.density] para trocar só a densidade de uma subárvore, como
/// o `sapUiSizeCompact` do SAPUI5:
///
/// ```dart
/// RebicTheme(
///   data: RebicThemeData.light(),
///   child: Row(children: [
///     const Expanded(child: Formulario()),
///     const Expanded(
///       child: RebicTheme.density(density: RebicDensity.compact, child: Tabela()),
///     ),
///   ]),
/// )
/// ```
class RebicTheme extends StatelessWidget {
  /// Aplica [data] à subárvore [child].
  ///
  /// Uma troca de [data] é animada durante [duration] (por padrão, a duração
  /// `medium` do movimento de [data]), com a curva `standard`. Com movimento
  /// reduzido, pelo `animationMode` de [data] ou pelo sistema, a troca é
  /// imediata.
  const RebicTheme({
    required RebicThemeData this.data,
    required this.child,
    this.duration,
    super.key,
  }) : density = null;

  /// Aplica à subárvore [child] o tema do ancestral com a densidade
  /// [density], preservando os demais valores.
  const RebicTheme.density({
    required RebicDensity this.density,
    required this.child,
    super.key,
  }) : data = null,
       duration = null;

  /// Tema aplicado, ou nulo em [RebicTheme.density].
  final RebicThemeData? data;

  /// Densidade aplicada em [RebicTheme.density], ou nula.
  final RebicDensity? density;

  /// Duração da troca de tema, ou nula para a duração `medium` do tema.
  final Duration? duration;

  /// Subárvore que recebe o tema.
  final Widget child;

  /// Tema ativo de [context]; equivale a `RebicThemeData.of`.
  static RebicThemeData of(BuildContext context) => RebicThemeData.of(context);

  @override
  Widget build(BuildContext context) {
    final target = data ?? RebicThemeData.of(context).withDensity(density!);
    // Modo efetivo: o do tema novo ou, com o pedido do sistema, `none`.
    final reduce = target.animationMode
        .effective(
          disableAnimations:
              MediaQuery.maybeDisableAnimationsOf(context) ?? false,
        )
        .reducesMotion;
    return _AnimatedRebicTheme(
      data: target,
      duration: reduce ? Duration.zero : duration ?? target.motion.medium,
      curve: target.motion.standard,
      child: child,
    );
  }
}

class _AnimatedRebicTheme extends ImplicitlyAnimatedWidget {
  const _AnimatedRebicTheme({
    required this.data,
    required this.child,
    required super.duration,
    super.curve,
  });

  final RebicThemeData data;
  final Widget child;

  @override
  AnimatedWidgetBaseState<_AnimatedRebicTheme> createState() =>
      _AnimatedRebicThemeState();
}

class _AnimatedRebicThemeState
    extends AnimatedWidgetBaseState<_AnimatedRebicTheme> {
  _RebicThemeDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data =
        visitor(
              _data,
              widget.data,
              (value) => _RebicThemeDataTween(begin: value as RebicThemeData),
            )
            as _RebicThemeDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    final theme = _data!.evaluate(animation);
    return RebicThemeScope(
      data: theme,
      child: DefaultTextStyle.merge(
        style: theme.typography.base.copyWith(color: theme.colors.text),
        child: IconTheme.merge(
          data: IconThemeData(
            color: theme.colors.text,
            size: theme.icons.control,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _RebicThemeDataTween extends Tween<RebicThemeData> {
  _RebicThemeDataTween({super.begin});

  @override
  RebicThemeData lerp(double t) => begin!.lerp(end, t);
}
