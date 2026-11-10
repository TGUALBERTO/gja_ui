import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicTable": produtos com seleção múltipla, linhas de navegação e
/// colunas em popin.
class RebicTablePage extends StatefulWidget {
  /// Cria a página.
  const RebicTablePage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicTable';

  /// Rota nomeada.
  static const route = '/rebic-table';

  @override
  State<RebicTablePage> createState() => _RebicTablePageState();
}

const _products = [
  ('teclado', 'Teclado', 'Periféricos', 'R\$ 120,00', '12'),
  ('mouse', 'Mouse', 'Periféricos', 'R\$ 45,00', '30'),
  ('monitor', 'Monitor 27"', 'Vídeo', 'R\$ 1.250,00', '4'),
  ('cabo', 'Cabo HDMI', 'Vídeo', 'R\$ 25,00', '80'),
  ('webcam', 'Webcam', 'Periféricos', 'R\$ 210,00', '7'),
];

class _RebicTablePageState extends State<RebicTablePage> {
  Set<String> _selected = const {};
  String? _opened;

  @override
  Widget build(BuildContext context) {
    final opened = _opened;
    return RebicPage(
      title: RebicTablePage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText(
          'Tabela no modelo do sap.m.Table: em larguras pequenas, "Categoria" '
          'some e "Preço" desce para baixo da linha; os produtos vêm em grupos, '
          'três de cada vez (growing).',
        ),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicTable<String>(
          headerText: 'Produtos (${_products.length})',
          mode: RebicListMode.multiSelect,
          selectedKeys: _selected,
          onSelectionChange: (keys) => setState(() => _selected = keys),
          onItemPress: (key) => setState(
            () => _opened = _products.firstWhere((p) => p.$1 == key).$2,
          ),
          columns: const [
            RebicColumn(header: 'Produto', flex: 2),
            RebicColumn(
              header: 'Categoria',
              minScreenWidth: RebicSizeClass.large,
            ),
            RebicColumn(
              header: 'Preço',
              hAlign: RebicColumnHAlign.end,
              minScreenWidth: RebicSizeClass.medium,
              demandPopin: true,
            ),
            RebicColumn(header: 'Estoque', hAlign: RebicColumnHAlign.end),
          ],
          growing: true,
          growingThreshold: 3,
          items: [
            for (final group in ['Periféricos', 'Vídeo']) ...[
              RebicGroupHeaderListItem(
                title: group,
                count: '${_products.where((p) => p.$3 == group).length}',
              ),
              for (final (key, name, category, price, stock) in _products)
                if (category == group)
                  RebicColumnListItem(
                    key: key,
                    type: RebicListType.navigation,
                    cells: [
                      RebicText(name),
                      RebicText(category),
                      RebicText(price),
                      RebicText(stock),
                    ],
                  ),
            ],
          ],
        ),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicText('${_selected.length} selecionados'),
        if (opened != null) RebicText('Aberto: $opened'),
      ],
    );
  }
}
