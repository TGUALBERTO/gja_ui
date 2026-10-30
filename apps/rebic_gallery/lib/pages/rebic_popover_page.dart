import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicPopover": um popover de filtros aberto por um botão, com
/// ações no rodapé, e um popover só com conteúdo aberto por um ícone.
class RebicPopoverPage extends StatefulWidget {
  /// Cria a página.
  const RebicPopoverPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicPopover';

  /// Rota nomeada.
  static const route = '/rebic-popover';

  /// Rótulo do botão que abre o popover de filtros.
  static const filter = 'Filtrar';

  /// Rótulo da ação que aplica os filtros.
  static const apply = 'Aplicar';

  /// Mensagem mostrada depois de aplicar os filtros.
  static const applied = 'Filtros aplicados';

  @override
  State<RebicPopoverPage> createState() => _RebicPopoverPageState();
}

class _RebicPopoverPageState extends State<RebicPopoverPage> {
  final _filters = RebicPopoverController();
  final _details = RebicPopoverController();
  bool _applied = false;

  @override
  void dispose() {
    _filters.dispose();
    _details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicPopoverPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Painéis ancorados no modelo do sap.m.Popover'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicColumn(
          gap: RebicSpace.l,
          children: [
            const RebicText(
              'O popover fecha com um toque fora ou com Esc, e o foco volta à '
              'âncora.',
            ),
            RebicRow(
              gap: RebicSpace.m,
              children: [
                RebicPopover(
                  controller: _filters,
                  title: 'Filtros',
                  content: const RebicColumn(
                    gap: RebicSpace.s,
                    children: [
                      RebicText('Status: em aberto'),
                      RebicText('Período: últimos 30 dias'),
                      RebicText('Centro: 1000 — São Paulo'),
                    ],
                  ),
                  actions: [
                    RebicButton(
                      label: RebicPopoverPage.apply,
                      type: RebicButtonType.emphasized,
                      onPressed: () {
                        _filters.close();
                        setState(() => _applied = true);
                      },
                    ),
                    RebicButton(
                      label: 'Cancelar',
                      type: RebicButtonType.transparent,
                      onPressed: _filters.close,
                    ),
                  ],
                  child: RebicButton(
                    label: RebicPopoverPage.filter,
                    icon: RebicIcons.filter,
                    onPressed: _filters.toggle,
                  ),
                ),
                RebicPopover(
                  controller: _details,
                  semanticLabel: 'Detalhes do pedido',
                  content: const RebicText(
                    'Pedido 4711, criado em 12/10 por Maria Barros.',
                  ),
                  child: RebicIconButton(
                    icon: RebicIcons.information,
                    tooltip: 'Detalhes do pedido',
                    onPressed: _details.toggle,
                  ),
                ),
              ],
            ),
            if (_applied) const RebicText(RebicPopoverPage.applied),
          ],
        ),
      ],
    );
  }
}
