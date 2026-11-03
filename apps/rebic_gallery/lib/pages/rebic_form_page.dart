import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicForm": formulário de fornecedor com dois contêineres e um
/// resumo dos valores.
class RebicFormPage extends StatefulWidget {
  /// Cria a página.
  const RebicFormPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicForm';

  /// Rota nomeada.
  static const route = '/rebic-form';

  @override
  State<RebicFormPage> createState() => _RebicFormPageState();
}

class _RebicFormPageState extends State<RebicFormPage> {
  String _name = '';
  String _city = '';
  String? _status = 'ativo';
  bool _preferred = false;

  @override
  Widget build(BuildContext context) {
    final summary = [
      if (_name.isNotEmpty) _name,
      if (_city.isNotEmpty) _city,
      if (_preferred) 'preferencial',
    ].join(', ');
    return RebicPage(
      title: RebicFormPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText(
          'Formulário no modelo do sap.ui.layout.form.Form com ColumnLayout: '
          'os rótulos sobem para cima dos campos em larguras pequenas.',
        ),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicForm(
          title: 'Fornecedor',
          formContainers: [
            RebicFormContainer(
              title: 'Dados',
              formElements: [
                RebicFormElement(
                  label: 'Nome',
                  required: true,
                  fields: [
                    RebicInput(
                      value: _name,
                      placeholder: 'Razão social',
                      onLiveChange: (value) => setState(() => _name = value),
                    ),
                  ],
                ),
                RebicFormElement(
                  label: 'Cidade',
                  fields: [
                    RebicInput(
                      value: _city,
                      placeholder: 'Cidade da sede',
                      onLiveChange: (value) => setState(() => _city = value),
                    ),
                  ],
                ),
                RebicFormElement(
                  label: 'Status',
                  fields: [
                    RebicSelect<String>(
                      semanticLabel: 'Status',
                      selectedKey: _status,
                      onChange: (value) => setState(() => _status = value),
                      items: const [
                        RebicDropdownItem(value: 'ativo', label: 'Ativo'),
                        RebicDropdownItem(value: 'inativo', label: 'Inativo'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            RebicFormContainer(
              title: 'Contato',
              formElements: [
                RebicFormElement(
                  label: 'E-mail',
                  fields: [
                    RebicInput(
                      placeholder: 'nome@empresa.com',
                      type: RebicInputType.email,
                      onLiveChange: (_) {},
                    ),
                  ],
                ),
                RebicFormElement(
                  label: 'Telefone',
                  fields: [
                    RebicInput(
                      placeholder: 'DDD',
                      type: RebicInputType.tel,
                      onLiveChange: (_) {},
                    ),
                    RebicInput(
                      placeholder: 'Número',
                      type: RebicInputType.tel,
                      onLiveChange: (_) {},
                    ),
                  ],
                ),
                RebicFormElement(
                  label: 'Preferencial',
                  fields: [
                    RebicCheckBox(
                      semanticLabel: 'Preferencial',
                      selected: _preferred,
                      onSelect: (value) => setState(() => _preferred = value),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicText('Resumo: $summary'),
      ],
    );
  }
}
