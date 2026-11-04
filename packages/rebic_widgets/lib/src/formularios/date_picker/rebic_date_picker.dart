import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../acoes_navegacao/button/rebic_button.dart';
import '../../feedback_sobreposicoes/popover/rebic_popover.dart';
import '../input/rebic_input.dart';

/// Seletor de data, como o `sap.m.DatePicker` do SAPUI5.
///
/// O campo mostra [dateValue] no formato curto do idioma e aceita uma data
/// digitada nesse formato; o ícone de calendário (ou F4, ou Alt+seta para
/// baixo) abre um calendário mensal. É controlado: escolher um dia, ou
/// confirmar (Enter ou perda de foco) uma data válida, chama [onChange] com
/// ela, e esvaziar o campo chama `onChange(null)`; o seletor não muda
/// sozinho.
///
/// Um texto que não é data, ou que está fora de [minDate]–[maxDate], não
/// chama [onChange]: o campo fica no estado de erro até a próxima edição. No
/// calendário, os dias fora dos limites ficam desabilitados. As horas das
/// datas são ignoradas.
///
/// ```dart
/// RebicDatePicker(
///   semanticLabel: 'Data de entrega',
///   dateValue: entrega,
///   minDate: hoje,
///   onChange: (date) => setState(() => entrega = date),
/// )
/// ```
class RebicDatePicker extends StatefulWidget {
  /// Cria o seletor.
  const RebicDatePicker({
    this.dateValue,
    this.onChange,
    this.minDate,
    this.maxDate,
    this.placeholder,
    this.semanticLabel,
    this.enabled = true,
    this.editable = true,
    this.valueState = RebicValueState.none,
    this.valueStateText,
    super.key,
  });

  /// Data mostrada.
  final DateTime? dateValue;

  /// Chamado com a nova data, ou nulo quando o campo é esvaziado, como o
  /// evento `change` do UI5.
  final ValueChanged<DateTime?>? onChange;

  /// Primeira data aceita.
  final DateTime? minDate;

  /// Última data aceita.
  final DateTime? maxDate;

  /// Texto do campo vazio; nulo usa o padrão da data no idioma.
  final String? placeholder;

  /// Nome anunciado pelo leitor de tela; sem ele, vale o [placeholder].
  final String? semanticLabel;

  /// Se o seletor pode receber foco e edição.
  final bool enabled;

  /// Se a data pode ser mudada; `false` deixa o campo somente leitura.
  final bool editable;

  /// Estado de valor do campo; diferente de `none`, prevalece sobre o erro
  /// de uma data inválida.
  final RebicValueState valueState;

  /// Mensagem do estado de valor.
  final String? valueStateText;

  @override
  State<RebicDatePicker> createState() => _RebicDatePickerState();
}

DateTime _day(DateTime date) => DateTime(date.year, date.month, date.day);

bool _sameDay(DateTime? a, DateTime? b) =>
    a != null && b != null && _day(a) == _day(b);

class _RebicDatePickerState extends State<RebicDatePicker> {
  final _popover = RebicPopoverController();

  /// Texto em edição; nulo mostra [RebicDatePicker.dateValue] formatada.
  String? _text;

  /// Se o último texto confirmado não foi uma data aceita.
  bool _invalid = false;

  @override
  void didUpdateWidget(RebicDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameDay(oldWidget.dateValue, widget.dateValue) ||
        (oldWidget.dateValue == null) != (widget.dateValue == null)) {
      _text = null;
      _invalid = false;
    }
  }

  @override
  void dispose() {
    _popover.dispose();
    super.dispose();
  }

  bool _inRange(DateTime date) {
    final min = widget.minDate;
    final max = widget.maxDate;
    return (min == null || !date.isBefore(_day(min))) &&
        (max == null || !date.isAfter(_day(max)));
  }

  void _select(DateTime? date) {
    setState(() {
      _text = null;
      _invalid = false;
    });
    final current = widget.dateValue;
    final changed = date == null ? current != null : !_sameDay(date, current);
    if (changed) widget.onChange?.call(date);
  }

  void _confirm(String text) {
    if (text.trim().isEmpty) return _select(null);
    final date = RebicLocalizations.of(context).parseDate(text);
    if (date == null || !_inRange(date)) {
      setState(() => _invalid = true);
    } else {
      _select(date);
    }
  }

  void _open() {
    if (widget.enabled && widget.editable) _popover.open();
  }

  @override
  Widget build(BuildContext context) {
    final min = widget.minDate;
    final max = widget.maxDate;
    assert(
      min == null || max == null || !_day(min).isAfter(_day(max)),
      'minDate não pode ser depois de maxDate',
    );
    final l10n = RebicLocalizations.of(context);
    final date = widget.dateValue;
    final placeholder = widget.placeholder ?? l10n.datePattern;
    final parentState = widget.valueState != RebicValueState.none;
    return RebicPopover(
      controller: _popover,
      semanticLabel: widget.semanticLabel ?? placeholder,
      padded: false,
      content: _Calendar(
        selected: date == null ? null : _day(date),
        minDate: min == null ? null : _day(min),
        maxDate: max == null ? null : _day(max),
        onSelect: (day) {
          _popover.close();
          _select(day);
        },
      ),
      child: RebicInput(
        value: _text ?? (date == null ? '' : l10n.formatDate(date)),
        placeholder: placeholder,
        semanticLabel: widget.semanticLabel,
        enabled: widget.enabled,
        editable: widget.editable,
        valueState: parentState
            ? widget.valueState
            : (_invalid ? RebicValueState.error : RebicValueState.none),
        valueStateText: parentState
            ? widget.valueStateText
            : (_invalid ? l10n.valueState(RebicValueState.error) : null),
        showValueHelp: true,
        valueHelpIconSrc: RebicIcons.calendar,
        onValueHelpRequest: _open,
        onLiveChange: (text) => setState(() {
          _text = text;
          _invalid = false;
        }),
        onChange: _confirm,
      ),
    );
  }
}

/// Calendário mensal do seletor, como o `sap.ui.unified.Calendar`.
class _Calendar extends StatefulWidget {
  const _Calendar({
    required this.selected,
    required this.minDate,
    required this.maxDate,
    required this.onSelect,
  });

  final DateTime? selected;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime> onSelect;

  @override
  State<_Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
  final _node = FocusNode();
  late DateTime _focused = widget.selected ?? _day(DateTime.now());
  late DateTime _month = DateTime(_focused.year, _focused.month);

  @override
  void initState() {
    super.initState();
    // Ao abrir, o foco vai ao dia escolhido (ou a hoje), e não ao primeiro
    // botão do cabeçalho.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _node.requestFocus();
    });
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  bool _enabled(DateTime day) {
    final min = widget.minDate;
    final max = widget.maxDate;
    return (min == null || !day.isBefore(min)) &&
        (max == null || !day.isAfter(max));
  }

  void _showMonth(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  void _moveFocus(DateTime day) {
    if (!_enabled(day)) return;
    setState(() {
      _focused = day;
      _month = DateTime(day.year, day.month);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _node.requestFocus();
    });
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final f = _focused;
    final DateTime? target = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowRight => DateTime(
        f.year,
        f.month,
        f.day + (rtl ? -1 : 1),
      ),
      LogicalKeyboardKey.arrowLeft => DateTime(
        f.year,
        f.month,
        f.day + (rtl ? 1 : -1),
      ),
      LogicalKeyboardKey.arrowDown => DateTime(f.year, f.month, f.day + 7),
      LogicalKeyboardKey.arrowUp => DateTime(f.year, f.month, f.day - 7),
      LogicalKeyboardKey.pageDown => _addMonths(f, 1),
      LogicalKeyboardKey.pageUp => _addMonths(f, -1),
      _ => null,
    };
    if (target == null) return KeyEventResult.ignored;
    _moveFocus(target);
    return KeyEventResult.handled;
  }

  /// [date] [months] meses depois, no último dia do mês quando ele é curto.
  static DateTime _addMonths(DateTime date, int months) {
    final last = DateTime(date.year, date.month + months + 1, 0).day;
    return DateTime(
      date.year,
      date.month + months,
      date.day > last ? last : date.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final l10n = RebicLocalizations.of(context);
    final colors = theme.colors;
    final today = _day(DateTime.now());
    final offset = (_month.weekday - l10n.firstDayOfWeek) % 7;
    final first = DateTime(_month.year, _month.month, 1 - offset);
    final weekdayStyle = theme.typography.small.copyWith(color: colors.label);

    return Padding(
      padding: EdgeInsets.all(theme.spacing.s),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: theme.spacing.xs,
        children: [
          Row(
            children: [
              RebicButton(
                icon: RebicIcons.slimArrowLeft,
                tooltip: l10n.previous,
                type: RebicButtonType.transparent,
                onPress: () => _showMonth(-1),
              ),
              Expanded(
                child: Text(
                  l10n.formatMonthYear(_month),
                  textAlign: TextAlign.center,
                  style: theme.typography.baseBold.copyWith(color: colors.text),
                ),
              ),
              RebicButton(
                icon: RebicIcons.slimArrowRight,
                tooltip: l10n.next,
                type: RebicButtonType.transparent,
                onPress: () => _showMonth(1),
              ),
            ],
          ),
          ExcludeSemantics(
            child: Row(
              children: [
                for (final name in l10n.shortWeekdays)
                  Expanded(
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: weekdayStyle,
                    ),
                  ),
              ],
            ),
          ),
          Focus(
            canRequestFocus: false,
            skipTraversal: true,
            onKeyEvent: _onKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var week = 0; week < 6; week++)
                  Row(
                    children: [
                      for (var i = 0; i < 7; i++)
                        Expanded(
                          child: _dayCell(
                            DateTime(
                              first.year,
                              first.month,
                              first.day + week * 7 + i,
                            ),
                            today: today,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayCell(DateTime day, {required DateTime today}) {
    final theme = RebicThemeData.of(context);
    final colors = theme.colors;
    final l10n = RebicLocalizations.of(context);
    final selected = day == widget.selected;
    final focused = day == _focused;
    final inMonth = day.month == _month.month;
    final cell = RebicInteractable(
      semanticLabel: l10n.formatLongDate(day),
      selected: selected,
      focusNode: focused ? _node : null,
      autofocus: focused,
      onPressed: _enabled(day) ? () => widget.onSelect(day) : null,
      focusRingBorderRadius: BorderRadius.circular(theme.radius.field),
      builder: (context, states) {
        final active =
            states.contains(RebicInteractionState.hovered) ||
            states.contains(RebicInteractionState.pressed);
        final Color? background = selected
            ? colors.brand
            : (active ? colors.hoverBackground : null);
        final color = selected
            ? colors.contrastText
            : (inMonth ? colors.text : colors.label);
        return ExcludeSemantics(
          child: Opacity(
            opacity: theme.interaction.opacity(states),
            child: SizedBox(
              height: theme.density.minTargetSize,
              child: Center(
                child: SizedBox.square(
                  dimension: theme.density.minTargetSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(theme.radius.field),
                      border: day == today && !selected
                          ? Border.all(
                              color: colors.brand,
                              width: const BorderSide().width,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        l10n.formatInteger(day.day),
                        style: theme.typography.base.copyWith(color: color),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    // Foco itinerante: só o dia focado é parada de Tab.
    return MergeSemantics(child: focused ? cell : ExcludeFocus(child: cell));
  }
}
