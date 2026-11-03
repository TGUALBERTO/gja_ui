import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../acoes_navegacao/button/rebic_button.dart';
import '../../acoes_navegacao/link/rebic_link.dart';

/// Faixa de mensagem dentro da página, como o `sap.m.MessageStrip` do SAPUI5.
///
/// Mostra [text] com as cores do [type] (o `MessageType` do UI5), o ícone do
/// tipo antes dele com [showIcon] e o [link] depois. Com [showCloseButton],
/// mostra um botão de fechar que chama [onClose]; o pai remove a faixa. O
/// texto quebra em várias linhas, e a faixa é anunciada pelo leitor de tela
/// quando aparece.
///
/// ```dart
/// RebicMessageStrip(
///   text: 'Pedido 4711 salvo.',
///   type: RebicValueState.success,
///   showIcon: true,
/// )
/// ```
class RebicMessageStrip extends StatelessWidget {
  /// Cria a faixa com [text].
  const RebicMessageStrip({
    required this.text,
    this.type = RebicValueState.information,
    this.showIcon = false,
    this.showCloseButton = false,
    this.onClose,
    this.link,
    super.key,
  }) : assert(text != '', 'text não pode ser vazio');

  /// Texto da mensagem.
  final String text;

  /// Tipo da mensagem, que define as cores e o ícone.
  final RebicValueState type;

  /// Se mostra o ícone do tipo antes do texto.
  final bool showIcon;

  /// Se mostra o botão de fechar.
  final bool showCloseButton;

  /// Chamado pelo botão de fechar, como o evento `close` do UI5.
  final VoidCallback? onClose;

  /// Link depois do texto.
  final RebicLink? link;

  IconData get _icon => switch (type) {
    RebicValueState.none ||
    RebicValueState.information => RebicIcons.information,
    RebicValueState.success => RebicIcons.sysEnter2,
    RebicValueState.warning => RebicIcons.warning,
    RebicValueState.error => RebicIcons.error,
  };

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final state = theme.colors.stateColors(type);
    final spacing = theme.spacing;
    final link = this.link;
    return Semantics(
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: state.background,
          border: Border.all(
            color: state.border,
            width: const BorderSide().width,
          ),
          borderRadius: BorderRadius.circular(theme.radius.popover),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: spacing.l,
            end: showCloseButton ? spacing.xs : spacing.l,
            top: spacing.s,
            bottom: spacing.s,
          ),
          child: Row(
            spacing: spacing.xs,
            children: [
              if (showIcon)
                ExcludeSemantics(
                  child: Icon(
                    _icon,
                    size: theme.icons.control,
                    color: state.foreground,
                  ),
                ),
              Expanded(
                child: Wrap(
                  spacing: spacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      text,
                      style: theme.typography.base.copyWith(
                        color: theme.colors.text,
                      ),
                    ),
                    ?link,
                  ],
                ),
              ),
              if (showCloseButton)
                RebicButton(
                  icon: RebicIcons.decline,
                  tooltip: RebicLocalizations.of(context).close,
                  type: RebicButtonType.transparent,
                  onPress: onClose,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
