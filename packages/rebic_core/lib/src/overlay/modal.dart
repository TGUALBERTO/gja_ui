import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../localization/localizations.dart';
import 'initial_focus.dart';

/// Abre conteúdos modais sobre a tela, com camada de bloqueio.
///
/// Equivale ao modal do `sap.ui.core.Popup` do SAPUI5: a camada (*block
/// layer*) cobre a tela, o conteúdo abaixo não recebe toques nem semântica, o
/// foco fica preso no modal e volta a quem o abriu ao fechar.
abstract final class RebicModal {
  /// Abre o conteúdo de [builder] como modal e espera o resultado.
  ///
  /// Feche com `Navigator.of(context).pop(resultado)` de dentro do conteúdo.
  /// Quando [dismissible] é verdadeiro, Esc e um toque na camada fecham o
  /// modal com resultado nulo, e a camada tem o rótulo `close` do idioma
  /// ativo. A camada usa [barrierColor] ou, sem ele, o `blockLayer` do tema
  /// ativo (`RebicThemeData.of`).
  ///
  /// O foco inicial é o do elemento com `autofocus`; sem nenhum, o primeiro
  /// elemento focável do modal recebe o foco.
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool dismissible = true,
    Color? barrierColor,
    bool useRootNavigator = true,
  }) {
    final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    return navigator.push<T>(
      RawDialogRoute<T>(
        barrierDismissible: dismissible,
        barrierColor:
            barrierColor ?? RebicThemeData.of(context).colors.blockLayer,
        barrierLabel: RebicLocalizations.of(context).close,
        transitionDuration: Duration.zero,
        pageBuilder: (context, _, _) => SafeArea(
          child: Center(child: RebicInitialFocus(child: builder(context))),
        ),
      ),
    );
  }
}
