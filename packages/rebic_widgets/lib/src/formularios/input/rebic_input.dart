import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../exibicao_dados/tooltip/rebic_tooltip.dart';

/// Tipo de um [RebicInput], como o `sap.m.InputType`: define o teclado e,
/// em [password], esconde os caracteres.
enum RebicInputType {
  /// Texto livre.
  text,

  /// Endereço de e-mail.
  email,

  /// Número.
  number,

  /// Senha, com os caracteres escondidos.
  password,

  /// Telefone.
  tel,

  /// Endereço web.
  url,
}

/// Campo de texto de uma linha, como o `sap.m.Input` do SAPUI5.
///
/// É controlado: mostra [value] e avisa cada edição por [onLiveChange]; o
/// pai devolve o novo valor. [onSubmit] é chamado com Enter, e [onChange]
/// com Enter ou ao perder o foco, quando o texto mudou desde o último aviso,
/// como os eventos `submit` e `change` do UI5.
///
/// Com [valueState] e [valueStateText], mostra a mensagem do estado abaixo do
/// campo enquanto ele tem o foco. Com [showClearIcon], mostra um botão que
/// esvazia o texto. Com [enabled] `false`, não recebe foco nem edição; com
/// [editable] `false`, recebe o foco e permite selecionar, sem editar.
///
/// Sem rótulo visível, [semanticLabel] (ou, sem ele, [placeholder]) é o nome
/// lido pelo leitor de tela.
///
/// ```dart
/// RebicInput(
///   semanticLabel: 'Nome',
///   placeholder: 'Nome completo',
///   value: nome,
///   onLiveChange: (value) => setState(() => nome = value),
/// )
/// ```
class RebicInput extends StatefulWidget {
  /// Cria o campo.
  const RebicInput({
    this.value = '',
    this.onLiveChange,
    this.onChange,
    this.onSubmit,
    this.placeholder,
    this.semanticLabel,
    this.type = RebicInputType.text,
    this.enabled = true,
    this.editable = true,
    this.valueState = RebicValueState.none,
    this.valueStateText,
    this.maxLength = 0,
    this.showClearIcon = false,
    this.focusNode,
    super.key,
  }) : assert(
         (semanticLabel != null && semanticLabel != '') ||
             (placeholder != null && placeholder != ''),
         'RebicInput precisa de semanticLabel ou placeholder não vazio',
       ),
       assert(maxLength >= 0, 'maxLength não pode ser negativo');

  /// Texto do campo.
  final String value;

  /// Chamado a cada edição, como o evento `liveChange` do UI5.
  final ValueChanged<String>? onLiveChange;

  /// Chamado com Enter ou ao perder o foco, quando o texto mudou, como o
  /// evento `change` do UI5.
  final ValueChanged<String>? onChange;

  /// Chamado com Enter, como o evento `submit` do UI5.
  final ValueChanged<String>? onSubmit;

  /// Texto mostrado enquanto o campo está vazio.
  final String? placeholder;

  /// Nome anunciado pelo leitor de tela; sem ele, vale [placeholder].
  final String? semanticLabel;

  /// Tipo, que define o teclado.
  final RebicInputType type;

  /// Se o campo pode receber foco e edição.
  final bool enabled;

  /// Se o texto pode ser editado; `false` deixa o campo somente leitura.
  final bool editable;

  /// Estado de valor, que colore a borda e o fundo.
  final RebicValueState valueState;

  /// Mensagem do estado de valor, mostrada abaixo do campo com o foco.
  final String? valueStateText;

  /// Número máximo de caracteres; `0` não limita.
  final int maxLength;

  /// Se mostra o botão de limpar quando há texto.
  final bool showClearIcon;

  /// Nó de foco do campo; um interno é criado quando nulo.
  final FocusNode? focusNode;

  @override
  State<RebicInput> createState() => _RebicInputState();
}

class _RebicInputState extends State<RebicInput> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  FocusNode? _internalNode;
  late String _lastChange;
  bool _hovered = false;

  FocusNode get _node => widget.focusNode ?? (_internalNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _lastChange = widget.value;
    _node.addListener(_onFocus);
  }

  @override
  void didUpdateWidget(RebicInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalNode)?.removeListener(_onFocus);
      _node.addListener(_onFocus);
    }
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _node.removeListener(_onFocus);
    _internalNode?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (!_node.hasFocus) _notifyChange();
    setState(() {});
  }

  void _notifyChange() {
    final text = _controller.text;
    if (text != _lastChange) {
      _lastChange = text;
      widget.onChange?.call(text);
    }
  }

  void _clear() {
    _controller.clear();
    widget.onLiveChange?.call('');
    _notifyChange();
    setState(() {});
  }

  TextInputType get _keyboard => switch (widget.type) {
    RebicInputType.text || RebicInputType.password => TextInputType.text,
    RebicInputType.email => TextInputType.emailAddress,
    RebicInputType.number => TextInputType.number,
    RebicInputType.tel => TextInputType.phone,
    RebicInputType.url => TextInputType.url,
  };

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final colors = theme.colors;
    final focused = _node.hasFocus;
    final state = colors.stateColors(widget.valueState);
    final hasState = widget.valueState != RebicValueState.none;
    final active = widget.enabled && (focused || _hovered);
    final background = !widget.editable
        ? colors.headerBackground
        : (hasState ? state.background : colors.base);
    final border = active
        ? colors.brand
        : (hasState ? state.border : colors.fieldBorder);
    final style = theme.typography.base.copyWith(color: colors.text);
    final corners = BorderRadius.circular(theme.radius.field);
    final message = widget.valueStateText;
    final showMessage = hasState && message != null && message != '' && focused;
    final showClear =
        widget.showClearIcon &&
        widget.enabled &&
        widget.editable &&
        _controller.text.isNotEmpty;

    final field = EditableText(
      controller: _controller,
      focusNode: _node,
      style: style,
      cursorColor: colors.brand,
      backgroundCursorColor: colors.label,
      selectionColor: colors.selectionBackground,
      readOnly: !widget.editable,
      obscureText: widget.type == RebicInputType.password,
      keyboardType: _keyboard,
      maxLines: 1,
      inputFormatters: [
        if (widget.maxLength > 0)
          LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      onChanged: (text) {
        widget.onLiveChange?.call(text);
        setState(() {});
      },
      onSubmitted: (text) {
        widget.onSubmit?.call(text);
        _notifyChange();
      },
    );

    final placeholder = widget.placeholder;
    Widget box = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: corners,
        border: Border.all(color: border, width: const BorderSide().width),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: theme.density.controlHeight),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: theme.spacing.s,
            end: showClear ? theme.spacing.none : theme.spacing.s,
          ),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    if (placeholder != null && _controller.text.isEmpty)
                      ExcludeSemantics(
                        child: Text(
                          placeholder,
                          style: theme.typography.base.copyWith(
                            color: colors.label,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    field,
                  ],
                ),
              ),
              // Como no UI5, o ícone de limpar não é parada de Tab nem nó
              // próprio do leitor de tela.
              if (showClear)
                ExcludeSemantics(
                  child: RebicTooltip(
                    message: RebicLocalizations.of(context).clear,
                    excludeFromSemantics: true,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        key: const ValueKey('rebic-input-clear'),
                        behavior: HitTestBehavior.opaque,
                        onTap: _clear,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: theme.spacing.s,
                          ),
                          child: Icon(
                            RebicIcons.decline,
                            size: theme.icons.control,
                            color: colors.brand,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    box = RebicFocusRing(
      visible: focused && widget.enabled,
      width: theme.interaction.focusWidth,
      offset: theme.interaction.focusOffset,
      color: colors.focus,
      borderRadius: corners,
      child: box,
    );
    box = MouseRegion(
      cursor: widget.enabled && widget.editable
          ? SystemMouseCursors.text
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.enabled ? _node.requestFocus : null,
        child: box,
      ),
    );
    // Um só nó, com o alvo mínimo da densidade em volta da moldura.
    box = MergeSemantics(
      child: Semantics(
        textField: true,
        label: widget.semanticLabel ?? widget.placeholder,
        hint: hasState ? message : null,
        readOnly: !widget.editable,
        enabled: widget.enabled,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: theme.density.minTargetSize),
          child: Center(heightFactor: 1, child: box),
        ),
      ),
    );
    if (!widget.enabled) {
      box = ExcludeFocus(
        child: IgnorePointer(
          child: Opacity(
            opacity: theme.interaction.opacity({
              RebicInteractionState.disabled,
            }),
            child: box,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        box,
        if (showMessage)
          Padding(
            padding: EdgeInsetsDirectional.only(
              top: theme.spacing.xxs,
              start: theme.spacing.s,
            ),
            child: ExcludeSemantics(
              child: Text(
                message,
                style: theme.typography.small.copyWith(color: state.foreground),
              ),
            ),
          ),
      ],
    );
  }
}
