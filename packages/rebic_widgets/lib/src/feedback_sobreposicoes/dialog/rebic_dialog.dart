import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../acoes_navegacao/button/rebic_button.dart';
import '../../fundacao_layout/container/rebic_container.dart';
import '../../fundacao_layout/separator/rebic_separator.dart';
import '../../fundacao_layout/spacing/rebic_spacing.dart';
import '../../fundacao_layout/title/rebic_title.dart';

/// Largura de um [RebicDialog], igual entre diálogos do mesmo tipo.
enum RebicDialogWidth {
  /// 8 passos `spacing.xxxl` (384 nos tokens de referência).
  standard(8),

  /// 12 passos `spacing.xxxl` (576 nos tokens de referência), para
  /// conteúdos largos.
  wide(12);

  const RebicDialogWidth(this._steps);

  final int _steps;
}

/// Diálogo modal, como o `sap.m.Dialog` do SAPUI5.
///
/// É o painel: [title] (com o ícone do [state] nas mensagens), [content]
/// rolável e, no rodapé, [buttons], [beginButton] e [endButton]. Abra com
/// [RebicDialog.open], que usa o modal do núcleo: a camada de bloqueio cobre
/// a tela, o foco fica preso no diálogo e volta a quem o abriu, e Esc fecha
/// quando `dismissible`. Os botões fecham com
/// `Navigator.of(context).pop(resultado)`.
///
/// ```dart
/// final excluir = await RebicDialog.open<bool>(
///   context,
///   builder: (context) => RebicDialog(
///     title: 'Excluir pedido',
///     state: RebicValueState.warning,
///     content: const RebicText('O pedido 4711 será excluído.'),
///     beginButton: RebicButton(
///       text: 'Excluir',
///       type: RebicButtonType.emphasized,
///       onPress: () => Navigator.of(context).pop(true),
///     ),
///     endButton: RebicButton(
///       text: 'Cancelar',
///       onPress: () => Navigator.of(context).pop(false),
///     ),
///   ),
/// );
/// ```
class RebicDialog extends StatelessWidget {
  /// Cria o painel do diálogo com [content].
  const RebicDialog({
    required this.content,
    this.title,
    this.semanticLabel,
    this.state = RebicValueState.none,
    this.beginButton,
    this.endButton,
    this.buttons = const [],
    this.width = RebicDialogWidth.standard,
    super.key,
  }) : assert(
         (title != null && title != '') ||
             (semanticLabel != null && semanticLabel != ''),
         'RebicDialog precisa de title ou semanticLabel não vazio',
       );

  /// Abre o diálogo de [builder] como modal e espera o resultado.
  ///
  /// Com [dismissible], Esc fecha com resultado nulo; a camada de bloqueio
  /// nunca fecha o diálogo.
  static Future<T?> open<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool dismissible = true,
  }) => RebicModal.show<T>(context, builder: builder, dismissible: dismissible);

  /// Conteúdo do diálogo, que rola quando não cabe.
  final Widget content;

  /// Título, também o nome do diálogo para o leitor de tela.
  final String? title;

  /// Nome do diálogo quando não há [title].
  final String? semanticLabel;

  /// Estado da mensagem, que põe o ícone dele antes do título.
  final RebicValueState state;

  /// Botão antes do [endButton] no rodapé.
  final RebicButton? beginButton;

  /// Último botão do rodapé.
  final RebicButton? endButton;

  /// Botões do rodapé antes de [beginButton] e [endButton].
  final List<RebicButton> buttons;

  /// Largura do painel.
  final RebicDialogWidth width;

  IconData? get _stateIcon => switch (state) {
    RebicValueState.none => null,
    RebicValueState.success => RebicIcons.sysEnter2,
    RebicValueState.warning => RebicIcons.warning,
    RebicValueState.error => RebicIcons.error,
    RebicValueState.information => RebicIcons.information,
  };

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final title = this.title;
    final icon = _stateIcon;
    final footer = [...buttons, ?beginButton, ?endButton];
    final screen = MediaQuery.sizeOf(context).width - 2 * theme.spacing.l;
    final panelWidth = math.min(
      theme.spacing.xxxl * width._steps,
      math.max(screen, theme.spacing.none),
    );

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: title ?? semanticLabel,
      child: SizedBox(
        width: panelWidth,
        child: RebicContainer(
          surface: RebicSurface.base,
          radius: RebicRadius.element,
          shadow: RebicShadow.dialog,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                RebicSpacing.padding(
                  all: RebicSpace.l,
                  child: Row(
                    spacing: theme.spacing.xs,
                    children: [
                      if (icon != null)
                        ExcludeSemantics(
                          child: Icon(
                            icon,
                            size: theme.icons.control,
                            color: theme.colors.stateColors(state).foreground,
                          ),
                        ),
                      Expanded(
                        child: RebicTitle(
                          title,
                          titleStyle: RebicTitleLevel.h4,
                          wrapping: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const RebicSeparator(),
              ],
              Flexible(
                child: SingleChildScrollView(
                  child: RebicSpacing.padding(
                    all: RebicSpace.l,
                    child: content,
                  ),
                ),
              ),
              if (footer.isNotEmpty) ...[
                const RebicSeparator(),
                RebicSpacing.padding(
                  all: RebicSpace.s,
                  child: OverflowBar(
                    alignment: MainAxisAlignment.end,
                    overflowAlignment: OverflowBarAlignment.end,
                    spacing: theme.spacing.xs,
                    overflowSpacing: theme.spacing.xs,
                    children: footer,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
