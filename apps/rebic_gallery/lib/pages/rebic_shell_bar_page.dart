import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicShellBar": a barra completa, a barra só com título e uma
/// barra estreita com os títulos truncados.
class RebicShellBarPage extends StatefulWidget {
  /// Cria a página.
  const RebicShellBarPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicShellBar';

  /// Rota nomeada.
  static const route = '/rebic-shell-bar';

  /// Chave da barra completa.
  static const fullKey = Key('shell-bar-full');

  /// Chave da barra só com título.
  static const titleOnlyKey = Key('shell-bar-title-only');

  /// Chave da barra estreita.
  static const narrowKey = Key('shell-bar-narrow');

  /// Mensagem mostrada pelo botão de menu da barra completa.
  static const menuMessage = 'Botão de menu acionado';

  @override
  State<RebicShellBarPage> createState() => _RebicShellBarPageState();
}

class _RebicShellBarPageState extends State<RebicShellBarPage> {
  String _message = '';

  void _show(String message) => setState(() => _message = message);

  @override
  Widget build(BuildContext context) {
    final spacing = RebicTheme.of(context).spacing;
    Widget heading(String text) => RebicTitle(
      text,
      level: RebicTitleLevel.h2,
      titleStyle: RebicTitleLevel.h3,
    );
    return ListView(
      padding: EdgeInsets.all(spacing.pageMargin),
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Semantics(button: true, child: const RebicText('← Voltar')),
        ),
        SizedBox(height: spacing.stackGap),
        const RebicTitle(
          RebicShellBarPage.title,
          level: RebicTitleLevel.h1,
          titleStyle: RebicTitleLevel.h2,
        ),
        SizedBox(height: spacing.sectionGap),
        heading('Barra completa'),
        SizedBox(height: spacing.s),
        RebicShellBar(
          key: RebicShellBarPage.fullKey,
          title: 'Compras',
          secondTitle: 'Pedidos de compra',
          homeIcon: const RebicIcon(RebicIcons.home, tone: RebicIconTone.brand),
          showNavButton: true,
          showMenuButton: true,
          showSearch: true,
          showNotifications: true,
          notificationsNumber: 4,
          showProductSwitcher: true,
          profile: const RebicAvatar(initials: 'TA'),
          menu: [
            RebicMenuItem(
              text: 'Compras',
              onPress: () => _show('Área: Compras'),
            ),
            RebicMenuItem(
              text: 'Contratos',
              onPress: () => _show('Área: Contratos'),
            ),
          ],
          onHomeIconPressed: () => _show('Ícone inicial acionado'),
          onNavButtonPressed: () => _show('Botão de voltar acionado'),
          onMenuButtonPressed: () => _show(RebicShellBarPage.menuMessage),
          onSearchButtonPressed: () => _show('Pesquisa acionada'),
          onNotificationsPressed: () => _show('Notificações acionadas'),
          onAvatarPressed: () => _show('Perfil acionado'),
          onProductSwitcherPressed: () => _show('Seletor de produtos acionado'),
        ),
        SizedBox(height: spacing.s),
        RebicText(_message),
        SizedBox(height: spacing.sectionGap),
        heading('Só com título'),
        SizedBox(height: spacing.s),
        const RebicShellBar(
          key: RebicShellBarPage.titleOnlyKey,
          title: 'Compras',
        ),
        SizedBox(height: spacing.sectionGap),
        heading('Barra estreita'),
        SizedBox(height: spacing.s),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            width: 360,
            child: RebicShellBar(
              key: RebicShellBarPage.narrowKey,
              title: 'Compras e suprimentos corporativos',
              secondTitle: 'Pedidos de compra em aberto no período',
              showMenuButton: true,
              showNotifications: true,
              notificationsNumber: 4,
              additionalContent: [
                RebicButton(
                  icon: RebicIcons.sysHelp,
                  tooltip: 'Ajuda',
                  type: RebicButtonType.transparent,
                  onPress: () => _show('Ajuda acionada'),
                ),
              ],
              profile: const RebicAvatar(initials: 'TA'),
              onMenuButtonPressed: () => _show(RebicShellBarPage.menuMessage),
              onNotificationsPressed: () => _show('Notificações acionadas'),
              onAvatarPressed: () => _show('Perfil acionado'),
            ),
          ),
        ),
      ],
    );
  }
}
