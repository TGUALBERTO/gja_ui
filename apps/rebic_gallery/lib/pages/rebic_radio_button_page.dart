import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicRadioButton": uma opção avulsa, um grupo de uma coluna e um
/// de duas.
class RebicRadioButtonPage extends StatefulWidget {
  /// Cria a página.
  const RebicRadioButtonPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicRadioButton';

  /// Rota nomeada.
  static const route = '/rebic-radio-button';

  /// Texto da opção avulsa.
  static const single = 'Receber por e-mail';

  /// Opções do grupo de pagamento.
  static const payment = ['Boleto', 'Pix', 'Cartão'];

  @override
  State<RebicRadioButtonPage> createState() => _RebicRadioButtonPageState();
}

class _RebicRadioButtonPageState extends State<RebicRadioButtonPage> {
  bool _single = false;
  int _payment = 0;
  int _size = 1;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicRadioButtonPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText(
          'Opções no modelo do sap.m.RadioButton e do RadioButtonGroup',
        ),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            RebicRadioButton(
              text: RebicRadioButtonPage.single,
              selected: _single,
              onSelect: (value) => setState(() => _single = value),
            ),
            const RebicTitle(
              'Pagamento',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicRadioButtonGroup(
              selectedIndex: _payment,
              onSelect: (i) => setState(() => _payment = i),
              buttons: [
                for (final text in RebicRadioButtonPage.payment)
                  RebicRadioButton(text: text),
              ],
            ),
            const RebicTitle(
              'Tamanho, em duas colunas',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            SizedBox(
              width: 320,
              child: RebicRadioButtonGroup(
                columns: 2,
                selectedIndex: _size,
                onSelect: (i) => setState(() => _size = i),
                buttons: const [
                  RebicRadioButton(text: 'P'),
                  RebicRadioButton(text: 'M'),
                  RebicRadioButton(text: 'G'),
                  RebicRadioButton(text: 'GG', enabled: false),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
