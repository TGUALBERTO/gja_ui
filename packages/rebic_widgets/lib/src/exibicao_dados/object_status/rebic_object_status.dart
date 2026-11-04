import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../fundacao_layout/icon/rebic_icon.dart';
import '../../fundacao_layout/label/rebic_label.dart';

/// Situação de um registro, como o `sap.m.ObjectStatus` do SAPUI5.
///
/// Mostra o [title] opcional ("Situação:", no tom `muted`), o [icon] e o
/// [text] na cor de frente do [state] (`colors.text` em `none`). Com
/// [inverted], vira uma etiqueta com o fundo, a borda e a frente do estado.
/// Com [onPress], fica ativo: sublinhado no hover, foco pelo teclado,
/// Enter e Espaço, e anunciado como botão. O texto quebra em várias linhas,
/// com o título e o ícone na primeira.
///
/// ```dart
/// RebicObjectStatus(
///   title: 'Situação',
///   text: 'Aprovado',
///   icon: RebicIcons.sysEnter2,
///   state: RebicValueState.success,
/// )
/// ```
class RebicObjectStatus extends StatelessWidget {
  /// Cria o status; informe [text] ou [icon].
  const RebicObjectStatus({
    this.text,
    this.icon,
    this.title,
    this.state = RebicValueState.none,
    this.inverted = false,
    this.onPress,
    super.key,
  }) : assert(
         (text != null && text != '') || icon != null,
         'informe text ou icon',
       );

  /// Valor da situação (ex.: "Aprovado").
  final String? text;

  /// Ícone antes do texto, do catálogo `RebicIcons` ou da aplicação.
  final IconData? icon;

  /// Rótulo antes do valor (ex.: "Situação"), seguido de dois-pontos.
  final String? title;

  /// Estado de valor, que define as cores.
  final RebicValueState state;

  /// Se o status é uma etiqueta preenchida com as cores do estado.
  final bool inverted;

  /// Ação do status ativo; nula torna o status apenas informativo.
  final VoidCallback? onPress;

  static RebicIconTone _iconTone(RebicValueState state) => switch (state) {
    RebicValueState.none => RebicIconTone.standard,
    RebicValueState.success => RebicIconTone.success,
    RebicValueState.warning => RebicIconTone.warning,
    RebicValueState.error => RebicIconTone.error,
    RebicValueState.information => RebicIconTone.information,
  };

  /// Rótulo do leitor de tela: "título: texto", só o texto ou só o título.
  String get _label {
    final text = this.text;
    final title = this.title;
    if (text != null && text != '') {
      return title == null ? text : '$title: $text';
    }
    return title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final colors = theme.colors.stateColors(state);
    final foreground = state == RebicValueState.none
        ? theme.colors.text
        : colors.foreground;
    final body = theme.typography.base;
    final lineHeight =
        MediaQuery.textScalerOf(context).scale(body.fontSize!) *
        (body.height ?? 1);
    final iconSide = MediaQuery.textScalerOf(context).scale(theme.icons.inline);

    Widget content(bool underline) {
      final text = this.text;
      final icon = this.icon;
      final title = this.title;
      Widget row = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: theme.spacing.xs,
        children: [
          if (title != null) RebicLabel(title, showColon: true, wrapping: true),
          if (icon != null)
            // Recuo para centrar o ícone na primeira linha do texto.
            Padding(
              padding: EdgeInsets.only(
                top: lineHeight > iconSide ? (lineHeight - iconSide) / 2 : 0,
              ),
              child: RebicIcon(
                icon,
                size: RebicIconSize.inline,
                tone: _iconTone(state),
              ),
            ),
          if (text != null && text != '')
            Flexible(
              child: Text(
                text,
                style: body.copyWith(
                  color: foreground,
                  decoration: underline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: foreground,
                ),
                softWrap: true,
              ),
            ),
        ],
      );
      if (inverted) {
        row = DecoratedBox(
          decoration: BoxDecoration(
            color: colors.background,
            // Linha fina padrão do framework, como no RebicContainer.
            border: Border.all(
              color: colors.border,
              width: const BorderSide().width,
            ),
            borderRadius: BorderRadius.circular(theme.radius.s),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
            child: row,
          ),
        );
      }
      // O rótulo é anunciado pelo nó do status; o conteúdo é visual.
      return ExcludeSemantics(child: row);
    }

    final onPress = this.onPress;
    if (onPress == null) {
      return Semantics(container: true, label: _label, child: content(false));
    }
    // Um só nó: o foco e o toque do detector se juntam ao status rotulado.
    return MergeSemantics(
      child: RebicInteractable(
        semanticLabel: _label,
        onPressed: onPress,
        focusRingBorderRadius: BorderRadius.circular(theme.radius.s),
        builder: (context, states) => content(
          states.contains(RebicInteractionState.hovered) ||
              states.contains(RebicInteractionState.pressed),
        ),
      ),
    );
  }
}
