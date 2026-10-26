import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Consultas de responsividade do Rebic: classe de tamanho da tela e
/// densidade recomendada.
///
/// Equivale às faixas de `sap.ui.Device.media` do SAPUI5. Para a classe do
/// espaço disponível de um widget, use [RebicResponsiveBuilder].
abstract final class RebicResponsive {
  /// Classe de tamanho da largura da janela, com [breakpoints].
  ///
  /// Sob um [RebicScreenSizeScope] com os mesmos [breakpoints], quem chama
  /// só é reconstruído quando a classe muda. Sem o escopo, a classe é a
  /// mesma, mas quem chama depende do tamanho da `MediaQuery` e é
  /// reconstruído a cada mudança de largura ou altura.
  static RebicSizeClass screenSizeClassOf(
    BuildContext context, {
    RebicBreakpointTokens breakpoints = const RebicBreakpointTokens.fallback(),
  }) {
    final scope = context
        .getInheritedWidgetOfExactType<_ScreenSizeClassScope>();
    if (scope != null && scope.breakpoints == breakpoints) {
      return context
          .dependOnInheritedWidgetOfExactType<_ScreenSizeClassScope>()!
          .sizeClass;
    }
    return breakpoints.classify(MediaQuery.sizeOf(context).width);
  }

  /// Densidade inicial recomendada para [platform] (por padrão,
  /// `defaultTargetPlatform`): compacta em desktop, de entrada por ponteiro,
  /// e confortável em dispositivos de toque.
  ///
  /// É só um padrão: a aplicação escolhe a densidade do tema.
  static RebicDensity recommendedDensity([TargetPlatform? platform]) {
    return switch (platform ?? defaultTargetPlatform) {
      TargetPlatform.windows ||
      TargetPlatform.macOS ||
      TargetPlatform.linux => RebicDensity.compact,
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.fuchsia => RebicDensity.comfortable,
    };
  }
}

/// Publica a classe de tamanho da tela para a subárvore.
///
/// Os widgets que a leem com [RebicResponsive.screenSizeClassOf] só são
/// reconstruídos quando a classe muda, e não a cada mudança de largura dentro
/// da classe nem de altura. `RebicApp` insere este escopo; aplicações com
/// `WidgetsApp` o colocam no `builder`.
class RebicScreenSizeScope extends StatelessWidget {
  /// Cria o escopo em volta de [child].
  const RebicScreenSizeScope({
    required this.child,
    this.breakpoints = const RebicBreakpointTokens.fallback(),
    super.key,
  });

  /// Limiares usados na classificação.
  final RebicBreakpointTokens breakpoints;

  /// Subárvore que recebe a classe.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _ScreenSizeClassScope(
      breakpoints: breakpoints,
      sizeClass: breakpoints.classify(MediaQuery.sizeOf(context).width),
      child: child,
    );
  }
}

class _ScreenSizeClassScope extends InheritedWidget {
  const _ScreenSizeClassScope({
    required this.breakpoints,
    required this.sizeClass,
    required super.child,
  });

  final RebicBreakpointTokens breakpoints;
  final RebicSizeClass sizeClass;

  @override
  bool updateShouldNotify(_ScreenSizeClassScope old) =>
      old.sizeClass != sizeClass || old.breakpoints != breakpoints;
}

/// Constrói o conteúdo com a classe de tamanho da largura disponível para
/// ele, e não a da janela.
///
/// Equivale aos controles do SAPUI5 que reagem à largura do próprio
/// contêiner. Largura sem limite resulta em `extraLarge`.
class RebicResponsiveBuilder extends StatelessWidget {
  /// Cria o construtor.
  const RebicResponsiveBuilder({
    required this.builder,
    this.breakpoints = const RebicBreakpointTokens.fallback(),
    super.key,
  });

  /// Constrói o conteúdo para a classe do espaço disponível.
  final Widget Function(BuildContext context, RebicSizeClass sizeClass) builder;

  /// Limiares usados na classificação.
  final RebicBreakpointTokens breakpoints;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          builder(context, breakpoints.classify(constraints.maxWidth)),
    );
  }
}

/// Valor por classe de tamanho, com herança da classe menor.
///
/// Equivale aos spans `XL/L/M/S` do SAPUI5: [small] é obrigatório, e uma
/// classe sem valor próprio usa o da maior classe menor que tenha valor.
@immutable
class RebicResponsiveValue<T extends Object> {
  /// Cria o valor responsivo.
  const RebicResponsiveValue({
    required this.small,
    this.medium,
    this.large,
    this.extraLarge,
  });

  /// Valor de `small`, base das demais classes.
  final T small;

  /// Valor próprio de `medium`, ou nulo para herdar.
  final T? medium;

  /// Valor próprio de `large`, ou nulo para herdar.
  final T? large;

  /// Valor próprio de `extraLarge`, ou nulo para herdar.
  final T? extraLarge;

  /// Valor de [sizeClass].
  T resolve(RebicSizeClass sizeClass) {
    final own = <T?>[small, medium, large, extraLarge];
    for (var i = sizeClass.index; i > 0; i--) {
      final value = own[i];
      if (value != null) return value;
    }
    return small;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RebicResponsiveValue<T> &&
        other.small == small &&
        other.medium == medium &&
        other.large == large &&
        other.extraLarge == extraLarge;
  }

  @override
  int get hashCode => Object.hash(small, medium, large, extraLarge);

  @override
  String toString() =>
      'RebicResponsiveValue<$T>(small: $small, medium: $medium, '
      'large: $large, extraLarge: $extraLarge)';
}
