import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicSelect": campos interativos, um com ícones nos itens, um com
/// espaço reservado e campos com estado de valor, somente leitura e
/// desabilitado.
class RebicSelectPage extends StatefulWidget {
  /// Cria a página.
  const RebicSelectPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicSelect';

  /// Rota nomeada.
  static const route = '/rebic-select';

  /// Rótulo do campo de status.
  static const statusLabel = 'Status';

  /// Itens de status.
  static const statuses = [
    RebicDropdownItem(key: 'aberto', text: 'Em aberto'),
    RebicDropdownItem(key: 'aprovado', text: 'Aprovado'),
    RebicDropdownItem(key: 'recusado', text: 'Recusado'),
  ];

  @override
  State<RebicSelectPage> createState() => _RebicSelectPageState();
}

class _RebicSelectPageState extends State<RebicSelectPage> {
  String _status = 'aberto';
  String? _sort;
  String? _priority;

  @override
  Widget build(BuildContext context) {
    Widget field(String label, Widget select) => RebicVBox(
      gap: RebicSpace.xxs,
      alignItems: RebicFlexAlignItems.stretch,
      items: [RebicLabel(label), select],
    );
    return RebicPage(
      title: RebicSelectPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Campos de seleção no modelo do sap.m.Select'),
        const RebicSpacing.vertical(RebicSpace.l),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: RebicVBox(
              gap: RebicSpace.m,
              alignItems: RebicFlexAlignItems.stretch,
              items: [
                field(
                  RebicSelectPage.statusLabel,
                  RebicSelect<String>(
                    semanticLabel: RebicSelectPage.statusLabel,
                    items: RebicSelectPage.statuses,
                    selectedKey: _status,
                    onChange: (value) => setState(() => _status = value),
                  ),
                ),
                field(
                  'Ordenar por',
                  RebicSelect<String>(
                    semanticLabel: 'Ordenar por',
                    placeholder: 'Escolha a ordem',
                    selectedKey: _sort,
                    onChange: (value) => setState(() => _sort = value),
                    items: const [
                      RebicDropdownItem(
                        key: 'data',
                        text: 'Data',
                        icon: RebicIcons.calendar,
                      ),
                      RebicDropdownItem(
                        key: 'valor',
                        text: 'Valor',
                        icon: RebicIcons.sort,
                      ),
                    ],
                  ),
                ),
                field(
                  'Prioridade',
                  RebicSelect<String>(
                    semanticLabel: 'Prioridade',
                    selectedKey: _priority,
                    valueState: _priority == null
                        ? RebicValueState.error
                        : RebicValueState.none,
                    valueStateText: 'Escolha uma prioridade',
                    onChange: (value) => setState(() => _priority = value),
                    items: const [
                      RebicDropdownItem(key: 'alta', text: 'Alta'),
                      RebicDropdownItem(key: 'baixa', text: 'Baixa'),
                    ],
                  ),
                ),
                field(
                  'Somente leitura',
                  RebicSelect<String>(
                    semanticLabel: 'Somente leitura',
                    items: RebicSelectPage.statuses,
                    selectedKey: 'aprovado',
                    editable: false,
                  ),
                ),
                field(
                  'Desabilitado',
                  RebicSelect<String>(
                    semanticLabel: 'Desabilitado',
                    items: RebicSelectPage.statuses,
                    selectedKey: 'recusado',
                    enabled: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
