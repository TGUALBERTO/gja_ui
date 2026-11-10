import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicDropdown": uma lista de situações sob um campo de status, na
/// largura dele, e uma lista de ações sob um botão de ícone, na largura
/// mínima.
class RebicDropdownPage extends StatefulWidget {
  /// Cria a página.
  const RebicDropdownPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicDropdown';

  /// Rota nomeada.
  static const route = '/rebic-dropdown';

  /// Rótulo do botão de status para a situação [label].
  static String status(String label) => 'Status: $label';

  @override
  State<RebicDropdownPage> createState() => _RebicDropdownPageState();
}

const _statuses = [
  RebicDropdownItem(
    key: 'aberto',
    text: 'Em aberto',
    icon: RebicIcons.pending,
    additionalText: '8',
  ),
  RebicDropdownItem(
    key: 'aprovado',
    text: 'Aprovado',
    icon: RebicIcons.sysEnter2,
    additionalText: '12',
  ),
  RebicDropdownItem(
    key: 'rejeitado',
    text: 'Rejeitado',
    icon: RebicIcons.error,
    additionalText: '3',
  ),
  RebicDropdownItem(
    key: 'arquivado',
    text: 'Arquivado',
    icon: RebicIcons.folderBlank,
    enabled: false,
  ),
];

const _actions = [
  RebicDropdownItem(key: 'editar', text: 'Editar', icon: RebicIcons.edit),
  RebicDropdownItem(key: 'copiar', text: 'Copiar', icon: RebicIcons.copy),
  RebicDropdownItem(key: 'excluir', text: 'Excluir', icon: RebicIcons.delete),
];

class _RebicDropdownPageState extends State<RebicDropdownPage> {
  final _status = RebicPopoverController();
  final _more = RebicPopoverController();
  String _selected = 'aberto';
  String? _action;

  @override
  void dispose() {
    _status.dispose();
    _more.dispose();
    super.dispose();
  }

  String get _label =>
      _statuses.firstWhere((item) => item.key == _selected).text;

  @override
  Widget build(BuildContext context) {
    final action = _action;
    return RebicPage(
      title: RebicDropdownPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Listas ancoradas no modelo do sap.m.Select'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            const RebicText(
              'Setas, Home, End e a primeira letra navegam pelos itens; Enter '
              'escolhe e Esc fecha.',
            ),
            RebicHBox(
              gap: RebicSpace.m,
              items: [
                RebicDropdown<String>(
                  controller: _status,
                  semanticLabel: 'Status',
                  selectedKey: _selected,
                  items: _statuses,
                  onSelectionChange: (value) =>
                      setState(() => _selected = value),
                  child: _StatusField(
                    label: RebicDropdownPage.status(_label),
                    onPressed: _status.toggle,
                  ),
                ),
                RebicDropdown<String>(
                  controller: _more,
                  semanticLabel: 'Mais ações',
                  items: _actions,
                  onSelectionChange: (value) => setState(() => _action = value),
                  child: RebicButton(
                    icon: RebicIcons.overflow,
                    tooltip: 'Mais ações',
                    onPress: _more.toggle,
                    type: RebicButtonType.transparent,
                  ),
                ),
              ],
            ),
            if (action != null)
              RebicText(
                'Ação: ${_actions.firstWhere((item) => item.key == action).text}',
              ),
          ],
        ),
      ],
    );
  }
}

/// Campo de status acionável, no formato de um futuro `RebicSelect`: a lista
/// do dropdown fica na largura dele.
class _StatusField extends StatelessWidget {
  const _StatusField({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    return SizedBox(
      width: theme.spacing.xxxl * 6,
      child: MergeSemantics(
        child: RebicInteractable(
          semanticLabel: label,
          onPressed: onPressed,
          builder: (context, states) => SizedBox(
            width: double.infinity,
            child: RebicContainer(
              surface: RebicSurface.base,
              border: true,
              radius: RebicRadius.field,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: theme.density.controlHeight,
                ),
                child: RebicSpacing.padding(
                  horizontal: RebicSpace.m,
                  child: Row(
                    children: [
                      Expanded(
                        child: ExcludeSemantics(child: RebicText(label)),
                      ),
                      const RebicIcon(RebicIcons.slimArrowDown),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
