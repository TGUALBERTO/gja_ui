import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicBadge": contadores por estado, sobre botões de ícone e um
/// contador de notificações que aumenta ao tocar "Nova notificação".
class RebicBadgePage extends StatefulWidget {
  /// Cria a página.
  const RebicBadgePage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicBadge';

  /// Rota nomeada.
  static const route = '/rebic-badge';

  /// Chave do contador sobre o sino.
  static const bellKey = Key('badge-bell');

  @override
  State<RebicBadgePage> createState() => _RebicBadgePageState();
}

class _RebicBadgePageState extends State<RebicBadgePage> {
  int _notifications = 0;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicBadgePage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Contadores avulsos e sobre elementos'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            const RebicTitle(
              'Por estado',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicHBox(
              wrap: RebicFlexWrap.wrap,
              alignItems: RebicFlexAlignItems.start,
              items: [
                for (final state in RebicValueState.values)
                  RebicBadge(count: 12, state: state),
                const RebicBadge(count: 1500),
              ],
            ),
            const RebicTitle(
              'Sobre botões de ícone',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicHBox(
              gap: RebicSpace.xxl,
              items: [
                RebicBadge(
                  key: RebicBadgePage.bellKey,
                  count: _notifications,
                  semanticLabel: '$_notifications notificações',
                  child: RebicButton(
                    icon: RebicIcons.bell,
                    tooltip: 'Notificações',
                    onPress: () {},
                    type: RebicButtonType.transparent,
                  ),
                ),
                RebicBadge(
                  count: 42,
                  state: RebicValueState.information,
                  semanticLabel: '42 pedidos',
                  child: RebicButton(
                    icon: RebicIcons.document,
                    tooltip: 'Pedidos',
                    onPress: () {},
                    type: RebicButtonType.transparent,
                  ),
                ),
              ],
            ),
            RebicButton(
              text: 'Nova notificação',
              onPress: () => setState(() => _notifications++),
            ),
          ],
        ),
      ],
    );
  }
}
