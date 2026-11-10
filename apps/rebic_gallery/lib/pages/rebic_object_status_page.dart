import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicObjectStatus": status por estado, invertidos, com título e
/// um ativo que mostra uma mensagem.
class RebicObjectStatusPage extends StatefulWidget {
  /// Cria a página.
  const RebicObjectStatusPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicObjectStatus';

  /// Rota nomeada.
  static const route = '/rebic-object-status';

  /// Texto do status ativo de exemplo.
  static const pending = '3 pendências';

  /// Mensagem mostrada ao acionar o status ativo.
  static const opened = 'Abrindo pendências';

  @override
  State<RebicObjectStatusPage> createState() => _RebicObjectStatusPageState();
}

class _RebicObjectStatusPageState extends State<RebicObjectStatusPage> {
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
      title: RebicObjectStatusPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Situação de registros, no modelo do ObjectStatus'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            const RebicTitle(
              'Por estado',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            for (final (state, icon, text) in _examples)
              RebicHBox(
                gap: RebicSpace.l,
                items: [
                  RebicObjectStatus(icon: icon, text: text, state: state),
                  RebicObjectStatus(text: text, state: state, inverted: true),
                ],
              ),
            const RebicTitle(
              'Com título',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            const RebicObjectStatus(
              title: 'Situação',
              icon: RebicIcons.sysEnter2,
              text: 'Aprovado',
              state: RebicValueState.success,
            ),
            const RebicTitle(
              'Ativo',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicObjectStatus(
              icon: RebicIcons.warning,
              text: RebicObjectStatusPage.pending,
              state: RebicValueState.warning,
              onPress: () => setState(() => _opened = true),
            ),
            if (_opened) const RebicText(RebicObjectStatusPage.opened),
          ],
        ),
      ],
    );
  }
}
