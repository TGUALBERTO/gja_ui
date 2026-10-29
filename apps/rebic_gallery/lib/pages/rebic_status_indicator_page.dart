import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicStatusIndicator": status por estado, invertidos, com título e
/// um ativo que mostra uma mensagem.
class RebicStatusIndicatorPage extends StatefulWidget {
  /// Cria a página.
  const RebicStatusIndicatorPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicStatusIndicator';

  /// Rota nomeada.
  static const route = '/rebic-status-indicator';

  /// Texto do status ativo de exemplo.
  static const pending = '3 pendências';

  /// Mensagem mostrada ao acionar o status ativo.
  static const opened = 'Abrindo pendências';

  @override
  State<RebicStatusIndicatorPage> createState() =>
      _RebicStatusIndicatorPageState();
}

class _RebicStatusIndicatorPageState extends State<RebicStatusIndicatorPage> {
  bool _opened = false;

  static const _examples = [
    (RebicValueState.success, RebicIcons.sysEnter2, 'Aprovado'),
    (RebicValueState.warning, RebicIcons.warning, 'Atrasado'),
    (RebicValueState.error, RebicIcons.error, 'Rejeitado'),
    (RebicValueState.information, RebicIcons.pending, 'Em análise'),
    (RebicValueState.none, RebicIcons.document, 'Rascunho'),
  ];

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicStatusIndicatorPage.title,
      subtitle: 'Situação de registros, no modelo do ObjectStatus',
      onBack: () => Navigator.of(context).maybePop(),
      body: RebicColumn(
        gap: RebicSpace.l,
        children: [
          const RebicText('Por estado', variant: RebicTextVariant.title),
          for (final (state, icon, text) in _examples)
            RebicRow(
              gap: RebicSpace.l,
              children: [
                RebicStatusIndicator(icon: icon, text: text, state: state),
                RebicStatusIndicator(text: text, state: state, inverted: true),
              ],
            ),
          const RebicText('Com título', variant: RebicTextVariant.title),
          const RebicStatusIndicator(
            title: 'Situação',
            icon: RebicIcons.sysEnter2,
            text: 'Aprovado',
            state: RebicValueState.success,
          ),
          const RebicText('Ativo', variant: RebicTextVariant.title),
          RebicStatusIndicator(
            icon: RebicIcons.warning,
            text: RebicStatusIndicatorPage.pending,
            state: RebicValueState.warning,
            onPressed: () => setState(() => _opened = true),
          ),
          if (_opened) const RebicText(RebicStatusIndicatorPage.opened),
        ],
      ),
    );
  }
}
