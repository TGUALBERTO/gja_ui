import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../formularios/check_box/rebic_check_box.dart';
import '../../fundacao_layout/title/rebic_title.dart';

/// Modo de seleção de uma [RebicTable], como o `mode` (`sap.m.ListMode`) do
/// SAPUI5.
enum RebicListMode {
  /// Sem seleção.
  none,

  /// Acionar uma linha a escolhe, e só ela fica escolhida.
  singleSelectMaster,

  /// Cada linha tem uma caixa de seleção, e o cabeçalho escolhe todas.
  multiSelect,
}

/// Tipo de uma linha, como o `type` (`sap.m.ListType`) do SAPUI5.
enum RebicListType {
  /// Não reage ao ponteiro nem ao teclado.
  inactive,

  /// Acionável: chama `onItemPress`.
  active,

  /// Acionável, com uma seta no fim, para abrir um detalhe.
  navigation,
}

/// Alinhamento horizontal de uma [RebicColumn], como o `hAlign` do SAPUI5.
enum RebicColumnHAlign {
  /// No início da linha (à esquerda em LTR).
  begin,

  /// No centro.
  center,

  /// No fim da linha (à direita em LTR), como números e valores.
  end,
}

/// Coluna de uma [RebicTable], como o `sap.m.Column` do SAPUI5.
///
/// É uma configuração, não um widget: use em [RebicTable.columns].
@immutable
class RebicColumn {
  /// Cria a coluna [header].
  const RebicColumn({
    required this.header,
    this.hAlign = RebicColumnHAlign.begin,
    this.flex = 1,
    this.minScreenWidth,
    this.demandPopin = false,
  });

  /// Título da coluna.
  final String header;

  /// Alinhamento do título e das células.
  final RebicColumnHAlign hAlign;

  /// Proporção da largura da tabela, no lugar do `width` em CSS do UI5.
  final int flex;

  /// Menor classe de tamanho, da largura da tabela, em que a coluna
  /// aparece; nula, aparece sempre.
  final RebicSizeClass? minScreenWidth;

  /// Se, escondida por [minScreenWidth], a célula desce para baixo da linha
  /// com o título da coluna.
  final bool demandPopin;
}

/// Linha de uma [RebicTable], como o `sap.m.ColumnListItem` do SAPUI5.
///
/// É uma configuração, não um widget: use em [RebicTable.items].
@immutable
class RebicColumnListItem<T> {
  /// Cria a linha [key] com [cells].
  const RebicColumnListItem({
    required this.key,
    required this.cells,
    this.type = RebicListType.inactive,
  });

  /// Chave da linha, devolvida por `onItemPress` e `onSelectionChange`.
  final T key;

  /// Células, uma por coluna, na ordem de `columns`.
  final List<Widget> cells;

  /// Tipo da linha.
  final RebicListType type;
}

/// Tabela responsiva, como o `sap.m.Table` do SAPUI5.
///
/// Mostra os títulos de [columns] e, abaixo, as linhas de [items]. Linhas
/// `active` e `navigation` chamam [onItemPress]; com [mode], as linhas
/// podem ser escolhidas. É controlada: a seleção é [selectedKeys], e
/// mudá-la chama [onSelectionChange] com o novo conjunto, sem mudar
/// sozinha. Sem itens, mostra [noDataText].
///
/// A tabela olha a própria largura: uma coluna com `minScreenWidth` maior
/// que a classe de tamanho dela some e, com `demandPopin`, desce para baixo
/// das outras células, com o título. Pelo teclado, as setas para cima e
/// para baixo movem o foco entre as linhas acionáveis.
///
/// ```dart
/// RebicTable<String>(
///   columns: const [
///     RebicColumn(header: 'Produto'),
///     RebicColumn(header: 'Preço', hAlign: RebicColumnHAlign.end),
///   ],
///   items: [
///     for (final p in produtos)
///       RebicColumnListItem(
///         key: p.id,
///         type: RebicListType.navigation,
///         cells: [RebicText(p.nome), RebicText(p.preco)],
///       ),
///   ],
///   onItemPress: abrir,
/// )
/// ```
class RebicTable<T> extends StatefulWidget {
  /// Cria a tabela de [columns] e [items].
  const RebicTable({
    required this.columns,
    required this.items,
    this.headerText,
    this.noDataText,
    this.mode = RebicListMode.none,
    this.selectedKeys = const {},
    this.onSelectionChange,
    this.onItemPress,
    super.key,
  });

  /// Colunas, da primeira à última.
  final List<RebicColumn> columns;

  /// Linhas, de cima para baixo.
  final List<RebicColumnListItem<T>> items;

  /// Título acima da tabela, e nome dela para o leitor de tela.
  final String? headerText;

  /// Texto mostrado sem itens; nulo usa o `noData` da localização.
  final String? noDataText;

  /// Modo de seleção.
  final RebicListMode mode;

  /// Chaves das linhas escolhidas.
  final Set<T> selectedKeys;

  /// Chamado com a nova seleção, como o evento `selectionChange` do UI5.
  final ValueChanged<Set<T>>? onSelectionChange;

  /// Chamado com a chave da linha acionada, como o evento `itemPress` do
  /// UI5.
  final ValueChanged<T>? onItemPress;

  @override
  State<RebicTable<T>> createState() => _RebicTableState<T>();
}

class _RebicTableState<T> extends State<RebicTable<T>> {
  final _nodes = <T, FocusNode>{};

  /// Chaves das linhas acionáveis, na ordem, para as setas.
  List<T> _order = [];

  @override
  void dispose() {
    for (final node in _nodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  bool _actionable(RebicColumnListItem<T> item) =>
      item.type != RebicListType.inactive ||
      widget.mode == RebicListMode.singleSelectMaster;

  void _validate() {
    final columns = widget.columns;
    final items = widget.items;
    assert(columns.isNotEmpty, 'columns não pode ser vazia');
    assert(
      items.every((item) => item.cells.length == columns.length),
      'cada linha precisa de uma célula por coluna',
    );
    assert(
      items.map((item) => item.key).toSet().length == items.length,
      'as chaves das linhas devem ser distintas',
    );
  }

  void _toggle(T key, bool selected) {
    final keys = {...widget.selectedKeys};
    selected ? keys.add(key) : keys.remove(key);
    widget.onSelectionChange?.call(keys);
  }

  void _press(RebicColumnListItem<T> item) {
    if (widget.mode == RebicListMode.singleSelectMaster &&
        !(widget.selectedKeys.length == 1 &&
            widget.selectedKeys.contains(item.key))) {
      widget.onSelectionChange?.call({item.key});
    }
    if (item.type != RebicListType.inactive) {
      widget.onItemPress?.call(item.key);
    }
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final int step;
    if (key == LogicalKeyboardKey.arrowDown) {
      step = 1;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      step = -1;
    } else {
      return KeyEventResult.ignored;
    }
    final current = _order.indexWhere((k) => _nodes[k]?.hasFocus ?? false);
    if (current < 0) return KeyEventResult.ignored;
    final next = current + step;
    if (next >= 0 && next < _order.length) _nodes[_order[next]]!.requestFocus();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    _validate();
    final theme = RebicThemeData.of(context);
    final l10n = RebicLocalizations.of(context);
    final items = widget.items;
    final multi = widget.mode == RebicListMode.multiSelect;
    final hasNavigation = items.any(
      (item) => item.type == RebicListType.navigation,
    );
    final keys = items.map((item) => item.key).toSet();
    _nodes.removeWhere((key, node) {
      final gone = !keys.contains(key);
      if (gone) node.dispose();
      return gone;
    });
    _order = [
      for (final item in items)
        if (_actionable(item)) item.key,
    ];
    final header = widget.headerText;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: header,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final sizeClass = theme.breakpoints.classify(constraints.maxWidth);
          bool shown(RebicColumn column) {
            final min = column.minScreenWidth;
            return min == null || sizeClass.isAtLeast(min);
          }

          final visible = [
            for (final (i, column) in widget.columns.indexed)
              if (shown(column)) i,
          ];
          final popin = [
            for (final (i, column) in widget.columns.indexed)
              if (!shown(column) && column.demandPopin) i,
          ];
          final selectedCount = items
              .where((item) => widget.selectedKeys.contains(item.key))
              .length;

          final headerRow = _Frame(
            selected: false,
            leading: multi
                ? RebicCheckBox(
                    semanticLabel: l10n.selectAll,
                    selected: items.isNotEmpty && selectedCount == items.length,
                    partiallySelected:
                        selectedCount > 0 && selectedCount < items.length,
                    enabled: items.isNotEmpty,
                    onSelect: (_) => widget.onSelectionChange?.call(
                      selectedCount == items.length ? <T>{} : keys,
                    ),
                  )
                : null,
            trailing: hasNavigation,
            child: _Cells(
              columns: widget.columns,
              visible: visible,
              cells: [
                for (final column in widget.columns)
                  Text(
                    column.header,
                    textAlign: _textAlign(column.hAlign),
                    style: theme.typography.base.copyWith(
                      color: theme.colors.label,
                    ),
                  ),
              ],
            ),
          );

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (header != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.s,
                    vertical: theme.spacing.s,
                  ),
                  child: RebicTitle(header, titleStyle: RebicTitleLevel.h5),
                ),
              headerRow,
              if (items.isEmpty)
                _Frame(
                  selected: false,
                  child: Center(
                    child: Text(
                      widget.noDataText ?? l10n.noData,
                      style: theme.typography.base.copyWith(
                        color: theme.colors.label,
                      ),
                    ),
                  ),
                ),
              Focus(
                canRequestFocus: false,
                skipTraversal: true,
                onKeyEvent: _onKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final item in items)
                      _row(
                        item,
                        visible: visible,
                        popin: popin,
                        multi: multi,
                        trailing: hasNavigation,
                        selectItem: l10n.selectItem,
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _row(
    RebicColumnListItem<T> item, {
    required List<int> visible,
    required List<int> popin,
    required bool multi,
    required bool trailing,
    required String selectItem,
  }) {
    final selected = widget.selectedKeys.contains(item.key);
    final theme = RebicThemeData.of(context);
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Cells(columns: widget.columns, visible: visible, cells: item.cells),
        for (final i in popin)
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: theme.spacing.s,
              end: theme.spacing.s,
              bottom: theme.spacing.xs,
            ),
            child: Row(
              spacing: theme.spacing.xs,
              children: [
                Text(
                  '${widget.columns[i].header}:',
                  style: theme.typography.base.copyWith(
                    color: theme.colors.label,
                  ),
                ),
                Flexible(child: item.cells[i]),
              ],
            ),
          ),
      ],
    );
    final arrow = item.type == RebicListType.navigation;
    final Widget body;
    if (_actionable(item)) {
      body = MergeSemantics(
        child: RebicInteractable(
          focusNode: _nodes.putIfAbsent(item.key, FocusNode.new),
          selected: widget.mode == RebicListMode.singleSelectMaster && selected,
          onPressed: () => _press(item),
          focusRingBorderRadius: BorderRadius.zero,
          builder: (context, states) {
            final active =
                states.contains(RebicInteractionState.hovered) ||
                states.contains(RebicInteractionState.pressed);
            return DecoratedBox(
              decoration: BoxDecoration(
                color: active && !selected
                    ? theme.colors.hoverBackground
                    : null,
              ),
              child: _WithArrow(
                arrow: arrow,
                trailing: trailing,
                child: content,
              ),
            );
          },
        ),
      );
    } else {
      body = Semantics(
        container: true,
        child: _WithArrow(arrow: false, trailing: trailing, child: content),
      );
    }
    return _Frame(
      selected: selected,
      leading: multi
          ? RebicCheckBox(
              semanticLabel: selectItem,
              selected: selected,
              onSelect: (value) => _toggle(item.key, value),
            )
          : null,
      child: body,
    );
  }
}

TextAlign _textAlign(RebicColumnHAlign align) => switch (align) {
  RebicColumnHAlign.begin => TextAlign.start,
  RebicColumnHAlign.center => TextAlign.center,
  RebicColumnHAlign.end => TextAlign.end,
};

/// Fundo, borda inferior e altura mínima de uma linha, com a caixa de
/// seleção inicial e a reserva da seta final.
class _Frame extends StatelessWidget {
  const _Frame({
    required this.selected,
    required this.child,
    this.leading,
    this.trailing = false,
  });

  final bool selected;
  final Widget child;
  final Widget? leading;

  /// Se reserva, à direita do conteúdo, a largura da seta das linhas
  /// `navigation` (só no cabeçalho; as linhas desenham a própria).
  final bool trailing;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final lead = leading;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? theme.colors.selectionBackground : theme.colors.base,
        border: Border(
          bottom: BorderSide(
            color: theme.colors.separator,
            width: const BorderSide().width,
          ),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: theme.density.listItemHeight),
        child: Row(
          children: [
            if (lead != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
                child: lead,
              ),
            Expanded(
              child: trailing
                  ? _WithArrow(arrow: false, trailing: true, child: child)
                  : child,
            ),
          ],
        ),
      ),
    );
  }
}

/// Conteúdo com a coluna final da seta, mostrada nas linhas `navigation`
/// e reservada nas outras.
class _WithArrow extends StatelessWidget {
  const _WithArrow({
    required this.arrow,
    required this.trailing,
    required this.child,
  });

  final bool arrow;
  final bool trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!trailing) return child;
    final theme = RebicThemeData.of(context);
    return Row(
      children: [
        Expanded(child: child),
        SizedBox(
          width: theme.icons.control + 2 * theme.spacing.s,
          child: arrow
              ? Icon(
                  RebicIcons.slimArrowRight,
                  size: theme.icons.control,
                  color: theme.colors.label,
                )
              : null,
        ),
      ],
    );
  }
}

class _Cells extends StatelessWidget {
  const _Cells({
    required this.columns,
    required this.visible,
    required this.cells,
  });

  final List<RebicColumn> columns;
  final List<int> visible;
  final List<Widget> cells;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    return Row(
      children: [
        for (final i in visible)
          Expanded(
            flex: columns[i].flex,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.s,
                vertical: theme.spacing.xs,
              ),
              child: Align(
                heightFactor: 1,
                alignment: switch (columns[i].hAlign) {
                  RebicColumnHAlign.begin => AlignmentDirectional.centerStart,
                  RebicColumnHAlign.center => AlignmentDirectional.center,
                  RebicColumnHAlign.end => AlignmentDirectional.centerEnd,
                },
                child: cells[i],
              ),
            ),
          ),
      ],
    );
  }
}
