import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../fundacao_layout/container/rebic_container.dart';
import '../../fundacao_layout/divider/rebic_divider.dart';
import '../../fundacao_layout/spacing/rebic_spacing.dart';
import '../../fundacao_layout/text/rebic_text.dart';

/// Abre e fecha um [RebicPopover], como o `openBy`/`close` do SAPUI5.
///
/// Avisa os ouvintes a cada mudança. Quem cria o controlador o descarta.
class RebicPopoverController extends RebicAnchoredOverlayController {
  /// Cria o controlador, fechado.
  RebicPopoverController({super.debugLabel});

  /// Se o popover está aberto.
  bool get isOpen => isShowing;

  /// Abre o popover.
  void open() => show();

  /// Fecha o popover, sem chamar `onDismiss`.
  void close() => hide();

  /// Abre o popover fechado, ou fecha o aberto.
  @override
  void toggle() => isOpen ? close() : open();
}

/// Largura mínima do popover em passos `spacing.xxxl`: 192 nos tokens de
/// referência, para que cabeçalho e rodapé não fiquem apertados.
const _minWidthSteps = 4;

/// Largura máxima do popover em passos `spacing.xxxl`: 384 nos tokens de
/// referência, perto da largura usual de um popover Fiori.
const _maxWidthSteps = 8;

/// Painel leve junto de uma âncora, como o `sap.m.Popover` do SAPUI5.
///
/// O [controller] abre o popover junto de [child], no lado [side] e alinhado
/// por [alignment], com a inversão e o limite de tela de
/// `RebicAnchoredOverlay`. A superfície é `base`, sem borda, com raio
/// `container` e sombra `popover`. Com [title], há um cabeçalho; com
/// [actions], um rodapé com as ações no fim. O [content] tem a margem
/// `spacing.l`, ou nenhuma com [padded] `false` (listas), e rola quando
/// passa da altura disponível, com cabeçalho e rodapé fixos.
///
/// Fecha com um toque fora ou com Esc, chamando [onDismiss]. Ao abrir, o
/// foco vai ao primeiro elemento focável e circula dentro do popover; ao
/// fechar, volta à âncora. O popover é anunciado como um diálogo com o nome
/// [title] ou [semanticLabel].
///
/// ```dart
/// RebicPopover(
///   controller: filtros,
///   title: 'Filtros',
///   content: const OpcoesDeFiltro(),
///   actions: [
///     RebicButton(label: 'Aplicar', type: RebicButtonType.emphasized, onPressed: aplicar),
///     RebicButton(label: 'Cancelar', type: RebicButtonType.transparent, onPressed: filtros.close),
///   ],
///   child: RebicButton(label: 'Filtrar', onPressed: filtros.toggle),
/// )
/// ```
class RebicPopover extends StatelessWidget {
  /// Cria o popover de [content], ancorado em [child].
  const RebicPopover({
    required this.controller,
    required this.content,
    required this.child,
    this.title,
    this.actions = const [],
    this.side = RebicOverlaySide.below,
    this.alignment = RebicOverlayAlignment.start,
    this.padded = true,
    this.semanticLabel,
    this.onDismiss,
    super.key,
  }) : assert(
         (title ?? semanticLabel ?? '') != '',
         'informe title ou semanticLabel',
       );

  /// Abre e fecha o popover.
  final RebicPopoverController controller;

  /// Conteúdo do popover.
  final Widget content;

  /// A âncora.
  final Widget child;

  /// Título do cabeçalho; nulo omite o cabeçalho.
  final String? title;

  /// Ações do rodapé, alinhadas ao fim; vazia omite o rodapé.
  final List<Widget> actions;

  /// Lado preferido em relação à âncora.
  final RebicOverlaySide side;

  /// Alinhamento ao longo da âncora.
  final RebicOverlayAlignment alignment;

  /// Se o conteúdo tem a margem `spacing.l`.
  final bool padded;

  /// Nome do popover para leitores de tela quando não há [title].
  final String? semanticLabel;

  /// Chamado quando o popover fecha por toque fora ou Esc.
  final VoidCallback? onDismiss;

  Widget _panel(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final title = this.title;
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: title ?? semanticLabel,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: theme.spacing.xxxl * _minWidthSteps,
          maxWidth: theme.spacing.xxxl * _maxWidthSteps,
        ),
        child: IntrinsicWidth(
          child: RebicContainer(
            surface: RebicSurface.base,
            radius: RebicRadius.container,
            elevation: RebicElevation.popover,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) ...[
                  RebicSpacing.padding(
                    all: RebicSpace.l,
                    child: RebicText(
                      title,
                      variant: RebicTextVariant.subtitle,
                      heading: true,
                      maxLines: 1,
                    ),
                  ),
                  const RebicDivider(),
                ],
                Flexible(
                  child: SingleChildScrollView(
                    child: padded
                        ? RebicSpacing.padding(
                            all: RebicSpace.l,
                            child: content,
                          )
                        : content,
                  ),
                ),
                if (actions.isNotEmpty) ...[
                  const RebicDivider(),
                  RebicSpacing.padding(
                    all: RebicSpace.s,
                    child: OverflowBar(
                      alignment: MainAxisAlignment.end,
                      overflowAlignment: OverflowBarAlignment.end,
                      spacing: theme.spacing.xs,
                      overflowSpacing: theme.spacing.xs,
                      children: actions,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RebicAnchoredOverlay(
      controller: controller,
      side: side,
      alignment: alignment,
      onDismiss: onDismiss,
      overlayBuilder: _panel,
      child: child,
    );
  }
}
