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
      subtitle: 'Menus de ações no modelo do sap.m.Menu',
      onBack: () => Navigator.of(context).maybePop(),
      body: RebicColumn(
        gap: RebicSpace.l,
        children: [
          const RebicText(
            'Os atalhos são só exibidos; seções começam com um divisor.',
          ),
          RebicRow(
            gap: RebicSpace.m,
            children: [
              RebicMenu(
                controller: _actions,
                semanticLabel: RebicMenuPage.actions,
                items: [
                  RebicMenuItem(
                    label: 'Editar',
                    icon: RebicIcons.edit,
                    shortcut: 'Ctrl+E',
                    onPressed: _record('Editar'),
                  ),
                  RebicMenuItem(
                    label: 'Copiar',
                    icon: RebicIcons.copy,
                    shortcut: 'Ctrl+C',
                    onPressed: _record('Copiar'),
                  ),
                  const RebicMenuItem(
                    label: 'Exportar',
                    icon: RebicIcons.download,
                    onPressed: null,
                  ),
                  RebicMenuItem(
                    label: 'Excluir',
                    icon: RebicIcons.delete,
                    startsSection: true,
                    onPressed: _record('Excluir'),
                  ),
                ],
                child: RebicButton(
                  label: RebicMenuPage.actions,
                  onPressed: _actions.toggle,
                ),
              ),
              RebicMenu(
                controller: _more,
                semanticLabel: 'Mais ações',
                items: [
                  RebicMenuItem(
                    label: 'Atualizar',
                    icon: RebicIcons.refresh,
                    onPressed: _record('Atualizar'),
                  ),
                  RebicMenuItem(
                    label: 'Configurações',
                    icon: RebicIcons.settings,
                    onPressed: _record('Configurações'),
                  ),
                ],
                child: RebicIconButton(
                  icon: RebicIcons.moreHorizontal,
                  tooltip: 'Mais ações',
                  onPressed: _more.toggle,
                ),
              ),
            ],
          ),
          if (last != null) RebicText(RebicMenuPage.lastAction(last)),
        ],
      ),
    );
  }
}
