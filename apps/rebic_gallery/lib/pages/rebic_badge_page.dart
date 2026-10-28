import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

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
      subtitle: 'Contadores avulsos e sobre elementos',
      onBack: () => Navigator.of(context).maybePop(),
      body: RebicColumn(
        gap: RebicSpace.l,
        children: [
          const RebicText('Por estado', variant: RebicTextVariant.title),
          RebicRow.wrap(
            children: [
              for (final state in RebicValueState.values)
                RebicBadge(count: 12, state: state),
              const RebicBadge(count: 1500),
            ],
          ),
          const RebicText(
            'Sobre botões de ícone',
            variant: RebicTextVariant.title,
          ),
          RebicRow(
            gap: RebicSpace.xxl,
            children: [
              RebicBadge(
                key: RebicBadgePage.bellKey,
                count: _notifications,
                semanticLabel: '$_notifications notificações',
                child: RebicIconButton(
                  icon: RebicIcons.notification,
                  tooltip: 'Notificações',
                  onPressed: () {},
                ),
              ),
              RebicBadge(
                count: 42,
                state: RebicValueState.information,
                semanticLabel: '42 pedidos',
                child: RebicIconButton(
                  icon: RebicIcons.file,
                  tooltip: 'Pedidos',
                  onPressed: () {},
                ),
              ),
            ],
          ),
          RebicButton(
            label: 'Nova notificação',
            onPressed: () => setState(() => _notifications++),
          ),
        ],
      ),
    );
  }
}
