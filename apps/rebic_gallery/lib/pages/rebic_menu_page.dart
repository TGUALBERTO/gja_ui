import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicMenu": um menu de ações com atalhos e seções sob o botão
/// "Ações", e um menu curto sob um botão de ícone.
class RebicMenuPage extends StatefulWidget {
  /// Cria a página.
  const RebicMenuPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicMenu';

  /// Rota nomeada.
  static const route = '/rebic-menu';

  /// Rótulo do botão que abre o menu de ações.
  static const actions = 'Ações';

  /// Mensagem com a última ação acionada.
  static String lastAction(String label) => 'Última ação: $label';

  @override
  State<RebicMenuPage> createState() => _RebicMenuPageState();
}

class _RebicMenuPageState extends State<RebicMenuPage> {
  final _actions = RebicPopoverController();
  final _more = RebicPopoverController();
  String? _last;

  @override
  void dispose() {
    _actions.dispose();
    _more.dispose();
    super.dispose();
  }

  VoidCallback _record(String label) =>
      () => setState(() => _last = label);

  @override
  Widget build(BuildContext context) {
    final last = _last;
    return RebicPage(
      title: RebicMenuPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Menus de ações no modelo do sap.m.Menu'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            const RebicText(
              'Os atalhos são só exibidos; seções começam com um divisor.',
            ),
            RebicHBox(
              gap: RebicSpace.m,
              items: [
                RebicMenu(
                  controller: _actions,
                  semanticLabel: RebicMenuPage.actions,
                  items: [
                    RebicMenuItem(
                      text: 'Editar',
                      icon: RebicIcons.edit,
                      shortcutText: 'Ctrl+E',
                      onPress: _record('Editar'),
                    ),
                    RebicMenuItem(
                      text: 'Copiar',
                      icon: RebicIcons.copy,
                      shortcutText: 'Ctrl+C',
                      onPress: _record('Copiar'),
                    ),
                    const RebicMenuItem(
                      text: 'Exportar',
                      icon: RebicIcons.download,
                      enabled: false,
                    ),
                    RebicMenuItem(
                      text: 'Excluir',
                      icon: RebicIcons.delete,
                      startsSection: true,
                      onPress: _record('Excluir'),
                    ),
                  ],
                  child: RebicButton(
                    text: RebicMenuPage.actions,
                    onPress: _actions.toggle,
                  ),
                ),
                RebicMenu(
                  controller: _more,
                  semanticLabel: 'Mais ações',
                  items: [
                    RebicMenuItem(
                      text: 'Atualizar',
                      icon: RebicIcons.refresh,
                      onPress: _record('Atualizar'),
                    ),
                    RebicMenuItem(
                      text: 'Configurações',
                      icon: RebicIcons.actionSettings,
                      onPress: _record('Configurações'),
                    ),
                  ],
                  child: RebicButton(
                    icon: RebicIcons.overflow,
                    tooltip: 'Mais ações',
                    onPress: _more.toggle,
                    type: RebicButtonType.transparent,
                  ),
                ),
              ],
            ),
            if (last != null) RebicText(RebicMenuPage.lastAction(last)),
          ],
        ),
      ],
    );
  }
}
