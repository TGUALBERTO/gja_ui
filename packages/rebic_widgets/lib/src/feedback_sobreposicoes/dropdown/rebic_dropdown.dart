import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../popover/rebic_popover.dart';

/// Item de um [RebicDropdown], como o `sap.ui.core.Item` do SAPUI5.
class RebicDropdownItem<T> {
  /// Cria o item [label] com o valor [value].
  const RebicDropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.additionalText,
    this.enabled = true,
  });

  /// Valor devolvido por `onSelected` quando o item é escolhido.
  final T value;

  /// Rótulo do item, em uma linha.
  final String label;

  /// Ícone antes do rótulo, do catálogo `RebicIcons` ou da aplicação.
  final IconData? icon;

  /// Texto no fim do item, no tom `muted` (ex.: uma contagem).
  final String? additionalText;

  /// Se o item pode ser escolhido e receber o foco.
  final bool enabled;
}

/// Lista de itens selecionáveis num popover ancorado, como a lista do
/// `sap.m.Select` do SAPUI5.
///
/// O [controller] abre a lista junto de [child], na largura da âncora
/// (`RebicPopoverWidth.anchor`). O item cujo valor é [selected] aparece
/// selecionado e recebe o foco ao abrir; sem ele, o foco vai ao primeiro item
/// habilitado. Escolher um item, por toque, Enter ou Espaço, fecha a lista e
/// chama [onSelected]; toque fora e Esc fecham chamando [onDismiss].
///
/// Pelo teclado, as setas movem entre os itens habilitados, Home e End vão ao
/// primeiro e ao último, e uma letra leva ao próximo item que começa com ela.
/// A lista é anunciada como uma rota com o nome [semanticLabel], e cada item
/// como um botão com o estado de selecionado.
///
/// É a base de campos de seleção e menus; não é um campo.
///
/// ```dart
/// RebicDropdown<String>(
///   controller: status,
///   semanticLabel: 'Status',
///   selected: atual,
///   items: const [
///     RebicDropdownItem(value: 'aberto', label: 'Em aberto'),
///     RebicDropdownItem(value: 'aprovado', label: 'Aprovado'),
///   ],
///   onSelected: escolher,
///   child: RebicButton(label: 'Status', onPressed: status.toggle),
/// )
/// ```
class RebicDropdown<T> extends StatefulWidget {
  /// Cria o dropdown de [items], ancorado em [child].
  RebicDropdown({
    required this.controller,
    required this.items,
    required this.onSelected,
    required this.semanticLabel,
    required this.child,
    this.selected,
    this.side = RebicOverlaySide.below,
    this.onDismiss,
    super.key,
  }) : assert(items.isNotEmpty, 'items não pode ser vazia'),
       assert(
         items.map((item) => item.value).toSet().length == items.length,
         'os valores dos itens devem ser distintos',
       ),
       assert(
         items.every((item) => item.label != ''),
         'os rótulos não podem ser vazios',
       ),
       assert(semanticLabel != '', 'semanticLabel não pode ser vazio');

  /// Abre e fecha a lista.
  final RebicPopoverController controller;

  /// Itens, na ordem da lista.
  final List<RebicDropdownItem<T>> items;

  /// Chamado com o valor do item escolhido.
  final ValueChanged<T> onSelected;

  /// Nome da lista para leitores de tela.
  final String semanticLabel;

  /// A âncora.
  final Widget child;

  /// Valor do item selecionado, ou nulo.
  final T? selected;

  /// Lado preferido em relação à âncora.
  final RebicOverlaySide side;

  /// Chamado quando a lista fecha por toque fora ou Esc.
  final VoidCallback? onDismiss;

  @override
  State<RebicDropdown<T>> createState() => _RebicDropdownState<T>();
}

class _RebicDropdownState<T> extends State<RebicDropdown<T>> {
  final List<FocusNode> _nodes = [];

  @override
  void initState() {
    super.initState();
    _syncNodes();
  }

  @override
  void didUpdateWidget(RebicDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncNodes();
  }

  @override
  void dispose() {
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Um nó de foco por item.
  void _syncNodes() {
    while (_nodes.length < widget.items.length) {
      _nodes.add(FocusNode(debugLabel: 'RebicDropdown item ${_nodes.length}'));
    }
    while (_nodes.length > widget.items.length) {
      _nodes.removeLast().dispose();
    }
  }

  bool _enabled(int index) => widget.items[index].enabled;

  /// Item que recebe o foco ao abrir: o selecionado habilitado ou o primeiro
  /// habilitado.
  int? get _initial {
    final items = widget.items;
    final selected = items.indexWhere(
      (item) => item.enabled && item.value == widget.selected,
    );
    if (selected >= 0) return selected;
    final first = items.indexWhere((item) => item.enabled);
    return first >= 0 ? first : null;
  }

  void _choose(RebicDropdownItem<T> item) {
    widget.controller.close();
    widget.onSelected(item.value);
  }

  void _focus(int index) {
    final node = _nodes[index];
    node.requestFocus();
    final context = node.context;
    if (context != null) Scrollable.ensureVisible(context);
  }

  /// Próximo índice habilitado a partir de [from], no passo [step], sem dar a
  /// volta; nulo quando não há.
  int? _next(int from, int step) {
    for (var i = from + step; i >= 0 && i < _nodes.length; i += step) {
      if (_enabled(i)) return i;
    }
    return null;
  }

  KeyEventResult _handleKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final current = _nodes.indexWhere((node) => node.hasPrimaryFocus);
    final key = event.logicalKey;
    int? target;
    if (key == LogicalKeyboardKey.arrowDown) {
      target = current < 0 ? _initial : _next(current, 1);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      target = current < 0 ? _initial : _next(current, -1);
    } else if (key == LogicalKeyboardKey.home) {
      target = _next(-1, 1);
    } else if (key == LogicalKeyboardKey.end) {
      target = _next(_nodes.length, -1);
    } else {
      final character = event.character;
      if (character == null ||
          character.trim().isEmpty ||
          character.runes.length != 1) {
        return KeyEventResult.ignored;
      }
      target = _byLetter(character.toLowerCase(), current);
      if (target == null) return KeyEventResult.handled;
    }
    if (target != null && target != current) _focus(target);
    return KeyEventResult.handled;
  }

  /// Próximo item habilitado depois de [current] cujo rótulo começa com
  /// [letter], dando a volta.
  int? _byLetter(String letter, int current) {
    final count = widget.items.length;
    for (var offset = 1; offset <= count; offset++) {
      final i = (current + offset) % count;
      if (_enabled(i) &&
          widget.items[i].label.toLowerCase().startsWith(letter)) {
        return i;
      }
    }
    return null;
  }

  Widget _item(BuildContext context, int index) {
    final theme = RebicThemeData.of(context);
    final item = widget.items[index];
    final family = RebicControlColors.of(RebicControlFamily.list, theme.colors);
    final additionalText = item.additionalText;
    // Um só nó por item: botão, rótulo, foco e toque.
    return MergeSemantics(
      child: RebicInteractable(
        focusNode: _nodes[index],
        selected: item.enabled && item.value == widget.selected,
        onPressed: item.enabled ? () => _choose(item) : null,
        semanticLabel: additionalText == null
            ? item.label
            : '${item.label}, $additionalText',
        focusRingBorderRadius: BorderRadius.zero,
        builder: (context, states) {
          final c = family.resolve(states);
          // A cor do texto adicional segue o estado quando o fundo muda muito
          // (ativo); nos demais, fica no tom `muted`.
          final muted = states.contains(RebicInteractionState.pressed)
              ? c.text
              : theme.colors.label;
          // O rótulo já está na semântica do item; o conteúdo é visual.
          return ExcludeSemantics(
            child: Opacity(
              opacity: theme.interaction.opacity(states),
              child: SizedBox(
                width: double.infinity,
                child: ColoredBox(
                  color: c.background,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: theme.density.controlHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.m,
                      ),
                      child: Row(
                        spacing: theme.spacing.s,
                        children: [
                          if (item.icon case final icon?)
                            Icon(
                              icon,
                              size: theme.icons.control,
                              color: c.text,
                            ),
                          Expanded(
                            child: Text(
                              item.label,
                              style: theme.typography.body.copyWith(
                                color: c.text,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (additionalText != null)
                            Text(
                              additionalText,
                              style: theme.typography.body.copyWith(
                                color: muted,
                              ),
                              maxLines: 1,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RebicPopover(
      controller: widget.controller,
      semanticLabel: widget.semanticLabel,
      width: RebicPopoverWidth.anchor,
      padded: false,
      side: widget.side,
      onDismiss: widget.onDismiss,
      content: Builder(
        builder: (context) {
          return _OnMount(
            // Depois do foco inicial do núcleo (primeiro focável), leva o
            // foco ao item selecionado.
            onMount: () {
              final initial = _initial;
              if (initial != null) _focus(initial);
            },
            child: Focus(
              canRequestFocus: false,
              skipTraversal: true,
              onKeyEvent: _handleKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < widget.items.length; i++)
                    _item(context, i),
                ],
              ),
            ),
          );
        },
      ),
      child: widget.child,
    );
  }
}

/// Chama [onMount] depois do primeiro quadro em que [child] aparece.
class _OnMount extends StatefulWidget {
  const _OnMount({required this.onMount, required this.child});

  final VoidCallback onMount;
  final Widget child;

  @override
  State<_OnMount> createState() => _OnMountState();
}

class _OnMountState extends State<_OnMount> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onMount();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
