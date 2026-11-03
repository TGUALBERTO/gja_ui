import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../exibicao_dados/tooltip/rebic_tooltip.dart';
import '../../fundacao_layout/separator/rebic_separator.dart';

/// Item de uma [RebicSideNavigation], como o `sap.tnt.NavigationListItem`
/// do SAPUI5.
///
/// É uma configuração, não um widget: use em [RebicSideNavigation.items] e
/// [RebicSideNavigation.fixedItems].
@immutable
class RebicNavigationListItem<T> {
  /// Cria o item [text] com a chave [key].
  const RebicNavigationListItem({
    required this.key,
    required this.text,
    this.icon,
    this.enabled = true,
    this.selectable = true,
    this.items = const [],
  });

  /// Chave devolvida por `onItemSelect` quando o item é escolhido.
  final T key;

  /// Texto do item.
  final String text;

  /// Ícone antes do texto; é o que aparece na navegação recolhida.
  final IconData? icon;

  /// Se o item pode ser acionado e focado.
  final bool enabled;

  /// Se acionar o item o escolhe; itens com subitens abrem e fecham
  /// independentemente disso.
  final bool selectable;

  /// Subitens, mostrados recuados quando o item está aberto.
  final List<RebicNavigationListItem<T>> items;
}

/// Navegação lateral, como o `sap.tnt.SideNavigation` do SAPUI5.
///
/// Mostra [items] empilhados (com subitens que abrem e fecham) e, no pé,
/// [fixedItems]. O item de [selectedKey] fica destacado. É controlada:
/// acionar outro item selecionável chama [onItemSelect] com a chave dele,
/// sem mudar sozinha. Com [expanded] `false`, mostra só os ícones dos itens
/// de primeiro nível, com o texto como dica.
///
/// Pelo teclado, as setas para cima e para baixo movem o foco entre os
/// itens visíveis, e as para a direita e para a esquerda abrem e fecham os
/// subitens. É o conteúdo lateral típico de um `RebicToolPage`.
///
/// ```dart
/// RebicSideNavigation<String>(
///   selectedKey: pagina,
///   onItemSelect: (key) => setState(() => pagina = key),
///   items: const [
///     RebicNavigationListItem(key: 'inicio', text: 'Início', icon: RebicIcons.home),
///     RebicNavigationListItem(key: 'pedidos', text: 'Pedidos', icon: RebicIcons.document),
///   ],
/// )
/// ```
class RebicSideNavigation<T> extends StatefulWidget {
  /// Cria a navegação com [items].
  const RebicSideNavigation({
    required this.items,
    this.fixedItems = const [],
    this.selectedKey,
    this.onItemSelect,
    this.expanded = true,
    this.semanticLabel,
    super.key,
  });

  /// Itens principais, na ordem da lista.
  final List<RebicNavigationListItem<T>> items;

  /// Itens fixos no pé da navegação.
  final List<RebicNavigationListItem<T>> fixedItems;

  /// Chave do item escolhido.
  final T? selectedKey;

  /// Chamado com a chave do item escolhido, como o evento `itemSelect` do
  /// UI5.
  final ValueChanged<T>? onItemSelect;

  /// Se mostra os textos; `false` mostra só os ícones.
  final bool expanded;

  /// Nome da navegação para o leitor de tela.
  final String? semanticLabel;

  @override
  State<RebicSideNavigation<T>> createState() => _RebicSideNavigationState<T>();
}

class _RebicSideNavigationState<T> extends State<RebicSideNavigation<T>> {
  final _open = <T>{};
  final _nodes = <T, FocusNode>{};

  /// Ordem dos itens visíveis, para as setas.
  List<T> _visible = [];

  @override
  void initState() {
    super.initState();
    _openTowards(widget.selectedKey);
  }

  @override
  void didUpdateWidget(RebicSideNavigation<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedKey != widget.selectedKey) {
      _openTowards(widget.selectedKey);
    }
  }

  @override
  void dispose() {
    for (final node in _nodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  /// Abre os itens que contêm [key].
  void _openTowards(T? key) {
    bool visit(RebicNavigationListItem<T> item) {
      if (item.key == key) return true;
      final inside = item.items.any(visit);
      if (inside) _open.add(item.key);
      return inside;
    }

    for (final item in [...widget.items, ...widget.fixedItems]) {
      visit(item);
    }
  }

  /// Se [key] é de um subitem de [item]; na navegação recolhida, o item
  /// de primeiro nível fica destacado no lugar do subitem escolhido.
  bool _contains(RebicNavigationListItem<T> item, T? key) =>
      item.items.any((child) => child.key == key || _contains(child, key));

  FocusNode _node(T key) => _nodes.putIfAbsent(key, FocusNode.new);

  RebicNavigationListItem<T>? _find(T key) {
    RebicNavigationListItem<T>? visit(List<RebicNavigationListItem<T>> list) {
      for (final item in list) {
        if (item.key == key) return item;
        final found = visit(item.items);
        if (found != null) return found;
      }
      return null;
    }

    return visit([...widget.items, ...widget.fixedItems]);
  }

  void _press(RebicNavigationListItem<T> item) {
    if (item.items.isNotEmpty && widget.expanded) {
      setState(() {
        if (!_open.remove(item.key)) _open.add(item.key);
      });
    }
    if (item.selectable && item.key != widget.selectedKey) {
      widget.onItemSelect?.call(item.key);
    }
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final current = _visible.indexWhere(
      (key) => _nodes[key]?.hasFocus ?? false,
    );
    if (current < 0) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowUp) {
      final step = key == LogicalKeyboardKey.arrowDown ? 1 : -1;
      for (var i = current + step; i >= 0 && i < _visible.length; i += step) {
        if (_find(_visible[i])?.enabled ?? false) {
          _nodes[_visible[i]]!.requestFocus();
          break;
        }
      }
      return KeyEventResult.handled;
    }
    final item = _find(_visible[current]);
    if (item == null || item.items.isEmpty || !widget.expanded) {
      return KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      setState(() => _open.add(item.key));
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      setState(() => _open.remove(item.key));
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _validate() {
    assert(widget.items.isNotEmpty, 'items não pode ser vazia');
    assert(() {
      final keys = <T>[];
      void visit(RebicNavigationListItem<T> item) {
        assert(item.text != '', 'os textos dos itens não podem ser vazios');
        keys.add(item.key);
        item.items.forEach(visit);
      }

      [...widget.items, ...widget.fixedItems].forEach(visit);
      return keys.toSet().length == keys.length;
    }(), 'as chaves dos itens devem ser distintas');
  }

  List<Widget> _build(
    List<RebicNavigationListItem<T>> items,
    int level,
    List<T> order,
  ) => [
    for (final item in items) ...[
      _Item<T>(
        item: item,
        level: level,
        selected:
            item.key == widget.selectedKey ||
            (!widget.expanded && _contains(item, widget.selectedKey)),
        open: _open.contains(item.key),
        expanded: widget.expanded,
        focusNode: _node(item.key),
        onPress: () => _press(item),
        order: order,
      ),
      if (widget.expanded && _open.contains(item.key))
        ..._build(item.items, level + 1, order),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    _validate();
    final theme = RebicThemeData.of(context);
    final order = <T>[];
    final main = _build(widget.items, 0, order);
    final fixed = _build(widget.fixedItems, 0, order);
    _visible = order;
    return Semantics(
      container: true,
      label: widget.semanticLabel,
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: _onKey,
        child: DecoratedBox(
          decoration: BoxDecoration(color: theme.colors.base),
          child: SizedBox(
            width: widget.expanded
                ? theme.spacing.xxxl * 5
                : theme.density.barHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: main,
                    ),
                  ),
                ),
                if (fixed.isNotEmpty) ...[const RebicSeparator(), ...fixed],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Item<T> extends StatelessWidget {
  _Item({
    required this.item,
    required this.level,
    required this.selected,
    required this.open,
    required this.expanded,
    required this.focusNode,
    required this.onPress,
    required List<T> order,
  }) {
    order.add(item.key);
  }

  final RebicNavigationListItem<T> item;
  final int level;
  final bool selected;
  final bool open;
  final bool expanded;
  final FocusNode focusNode;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final colors = theme.colors;
    final icon = item.icon;
    final hasChildren = item.items.isNotEmpty;
    final Widget button = RebicInteractable(
      semanticLabel: item.text,
      selected: selected,
      focusNode: focusNode,
      onPressed: item.enabled ? onPress : null,
      focusRingBorderRadius: BorderRadius.zero,
      builder: (context, states) {
        final active =
            states.contains(RebicInteractionState.hovered) ||
            states.contains(RebicInteractionState.pressed);
        final color = selected ? colors.brand : colors.text;
        final background = selected
            ? colors.selectionBackground
            : (active ? colors.hoverBackground : null);
        return ExcludeSemantics(
          child: Opacity(
            opacity: theme.interaction.opacity(states),
            child: DecoratedBox(
              decoration: BoxDecoration(color: background),
              child: SizedBox(
                height: theme.density.listItemHeight,
                child: expanded
                    ? Padding(
                        padding: EdgeInsetsDirectional.only(
                          start:
                              theme.spacing.s +
                              level * (theme.icons.control + theme.spacing.s),
                          end: theme.spacing.s,
                        ),
                        child: Row(
                          spacing: theme.spacing.s,
                          children: [
                            if (icon != null)
                              Icon(
                                icon,
                                size: theme.icons.control,
                                color: color,
                              ),
                            Expanded(
                              child: Text(
                                item.text,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.typography.base.copyWith(
                                  color: color,
                                ),
                              ),
                            ),
                            if (hasChildren)
                              Icon(
                                open
                                    ? RebicIcons.slimArrowDown
                                    : RebicIcons.slimArrowRight,
                                size: theme.icons.control,
                                color: colors.label,
                              ),
                          ],
                        ),
                      )
                    : Center(
                        child: Icon(
                          icon ?? RebicIcons.document,
                          size: theme.icons.control,
                          color: color,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
    final Widget semantic = MergeSemantics(
      child: Semantics(
        expanded: hasChildren && expanded ? open : null,
        child: button,
      ),
    );
    return expanded
        ? semantic
        : RebicTooltip(
            message: item.text,
            excludeFromSemantics: true,
            child: semantic,
          );
  }
}
