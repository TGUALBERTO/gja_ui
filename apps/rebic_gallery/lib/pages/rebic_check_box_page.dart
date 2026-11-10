import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicCheckBox": caixas interativas, uma parcial que reflete o
/// grupo, os estados de valor, somente leitura e desabilitada.
class RebicCheckBoxPage extends StatefulWidget {
  /// Cria a página.
  const RebicCheckBoxPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicCheckBox';

  /// Rota nomeada.
  static const route = '/rebic-check-box';

  /// Texto da caixa de exemplo.
  static const terms = 'Aceito os termos';

  @override
  State<RebicCheckBoxPage> createState() => _RebicCheckBoxPageState();
}

class _RebicCheckBoxPageState extends State<RebicCheckBoxPage> {
  bool _terms = false;
  final _channels = <String, bool>{'E-mail': true, 'SMS': false, 'Push': false};

  @override
  Widget build(BuildContext context) {
    final marked = _channels.values.where((v) => v).length;
    return RebicPage(
      title: RebicCheckBoxPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Caixas de seleção no modelo do sap.m.CheckBox'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            RebicCheckBox(
              text: RebicCheckBoxPage.terms,
              selected: _terms,
              onSelect: (value) => setState(() => _terms = value),
            ),
            const RebicTitle(
              'Grupo com caixa parcial',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicVBox(
              gap: RebicSpace.none,
              items: [
                RebicCheckBox(
                  text: 'Todos os canais',
                  selected: marked == _channels.length,
                  partiallySelected: marked > 0 && marked < _channels.length,
                  onSelect: (value) =>
                      setState(() => _channels.updateAll((_, _) => value)),
                ),
                for (final entry in _channels.entries)
                  RebicCheckBox(
                    text: entry.key,
                    selected: entry.value,
                    onSelect: (value) =>
                        setState(() => _channels[entry.key] = value),
                  ),
              ],
            ),
            const RebicTitle(
              'Estados de valor, somente leitura e desabilitada',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicHBox(
              wrap: RebicFlexWrap.wrap,
              alignItems: RebicFlexAlignItems.start,
              items: [
                for (final state in RebicValueState.values)
                  RebicCheckBox(
                    text: state.name,
                    valueState: state,
                    selected: true,
                    onSelect: (_) {},
                  ),
                const RebicCheckBox(
                  text: 'Somente leitura',
                  selected: true,
                  editable: false,
                ),
                const RebicCheckBox(text: 'Desabilitada', enabled: false),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
