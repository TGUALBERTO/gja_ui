import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../fundacao_layout/container/rebic_container.dart';
import '../../fundacao_layout/separator/rebic_separator.dart';
import '../../fundacao_layout/spacing/rebic_spacing.dart';
import '../../fundacao_layout/title/rebic_title.dart';

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

/// Largura de um [RebicPopover], igual entre popovers do mesmo tipo.
enum RebicPopoverWidth {
  /// Largura da âncora, para listas como a do `sap.m.Select`: no mínimo 6
  /// passos `spacing.xxxl` (288 nos tokens de referência, 192 no compacto),
  /// para que âncoras estreitas, como botões de ícone, ainda deem uma lista
  /// com ícone, rótulo e atalho legíveis.
  anchor(6),

  /// Largura padrão: 8 passos `spacing.xxxl` (384 nos tokens de referência),
  /// perto do `contentWidth` usual de um popover Fiori.
  standard(8),

  /// Largura maior, para conteúdos largos como tabelas: 12 passos
  /// `spacing.xxxl` (576 nos tokens de referência).
  wide(12);

  const RebicPopoverWidth(this._steps);

  /// Passos `spacing.xxxl` da largura.
  final int _steps;
}

/// Painel leve junto de uma âncora, como o `sap.m.Popover` do SAPUI5.
///
/// O [controller] abre o popover junto de [child], na posição [placement] e alinhado
/// por [alignment], com a inversão e o limite de tela de
/// `RebicAnchoredOverlay`. A superfície é `base`, sem borda, com raio
/// `container` e sombra `popover`. Com [title], há um cabeçalho; com
/// [actions], um rodapé com as ações no fim. O [content] tem a margem
/// `spacing.l`, ou nenhuma com [padded] `false` (listas), e rola quando
/// passa da altura disponível, com cabeçalho e rodapé fixos.
///
/// A largura é a de [width] (padrão `standard`, igual entre popovers), ou a
/// da âncora, quando ela é mais larga, como a lista do `sap.m.Select`; é
/// reduzida à área da sobreposição em telas estreitas. Textos longos quebram
/// em linhas.
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
class RebicPopover extends StatefulWidget {
  /// Cria o popover de [content], ancorado em [child].
  const RebicPopover({
    required this.controller,
    required this.content,
    required this.child,
    this.title,
    this.actions = const [],
    this.placement = RebicPlacement.bottom,
    this.alignment = RebicOverlayAlignment.start,
    this.width = RebicPopoverWidth.standard,
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

  /// Posição preferida em relação à âncora.
  final RebicPlacement placement;

  /// Alinhamento ao longo da âncora.
  final RebicOverlayAlignment alignment;

  /// Largura do popover; a da âncora prevalece quando é maior.
  final RebicPopoverWidth width;

  /// Se o conteúdo tem a margem `spacing.l`.
  final bool padded;

  /// Nome do popover para leitores de tela quando não há [title].
  final String? semanticLabel;

  /// Chamado quando o popover fecha por toque fora ou Esc.
  final VoidCallback? onDismiss;

  @override
  State<RebicPopover> createState() => _RebicPopoverState();
}

class _RebicPopoverState extends State<RebicPopover> {
  final _anchorKey = GlobalKey();

  /// Largura da âncora, ou zero antes do primeiro layout.
  double get _anchorWidth {
    final anchor = _anchorKey.currentContext?.findRenderObject();
    return anchor is RenderBox && anchor.hasSize ? anchor.size.width : 0;
  }

  Widget _panel(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final RebicPopover(:title, :actions, :padded, :content) = widget;
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: title ?? widget.semanticLabel,
      child: SizedBox(
        width: math.max(theme.spacing.xxxl * widget.width._steps, _anchorWidth),
        child: RebicContainer(
          surface: RebicSurface.base,
          radius: RebicRadius.popover,
          shadow: RebicShadow.popover,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                RebicSpacing.padding(
                  all: RebicSpace.l,
                  child: RebicTitle(title, titleStyle: RebicTitleLevel.h4),
                ),
                const RebicSeparator(),
              ],
              Flexible(
                child: SingleChildScrollView(
                  child: padded
                      ? RebicSpacing.padding(all: RebicSpace.l, child: content)
                      : content,
                ),
              ),
              if (actions.isNotEmpty) ...[
                const RebicSeparator(),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return RebicAnchoredOverlay(
      controller: widget.controller,
      placement: widget.placement,
      alignment: widget.alignment,
      onDismiss: widget.onDismiss,
      overlayBuilder: _panel,
      child: KeyedSubtree(key: _anchorKey, child: widget.child),
    );
  }
}
