import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicDatePicker": data de entrega a partir de hoje.
class RebicDatePickerPage extends StatefulWidget {
  /// Cria a página.
  const RebicDatePickerPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicDatePicker';

  /// Rota nomeada.
  static const route = '/rebic-date-picker';

  @override
  State<RebicDatePickerPage> createState() => _RebicDatePickerPageState();
}

class _RebicDatePickerPageState extends State<RebicDatePickerPage> {
  DateTime? _delivery;

  @override
  Widget build(BuildContext context) {
    final l10n = RebicLocalizations.of(context);
    final now = DateTime.now();
    final delivery = _delivery;
    return RebicPage(
      title: RebicDatePickerPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText(
          'Seletor no modelo do sap.m.DatePicker: digite a data ou abra o '
          'calendário pelo ícone, F4 ou Alt+seta para baixo.',
        ),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicForm(
          editable: true,
          formContainers: [
            RebicFormContainer(
              formElements: [
                RebicFormElement(
                  label: 'Entrega',
                  required: true,
                  fields: [
                    RebicDatePicker(
                      semanticLabel: 'Data de entrega',
                      dateValue: delivery,
                      minDate: DateTime(now.year, now.month, now.day),
                      showCurrentDateButton: true,
                      onChange: (date) => setState(() => _delivery = date),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicText(
          delivery == null
              ? 'Entrega: não definida'
              : 'Entrega: ${l10n.formatDate(delivery)}',
        ),
      ],
    );
  }
}
