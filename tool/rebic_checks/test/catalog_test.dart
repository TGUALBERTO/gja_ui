import 'package:rebic_checks/rebic_checks.dart';
import 'package:test/test.dart';

import 'support.dart';

String _item(String id, String kind, String priority, int phase,
        {String status = 'planned', List<String> deps = const [], String category = 'acoes'}) =>
    '''
  - id: $id
    name: X
    kind: $kind
    category: $category
    priority: $priority
    phase: $phase
    status: $status
    depends_on: [${deps.join(', ')}]
''';

String _catalog(List<String> items) => items.isEmpty ? 'items: []\n' : 'items:\n${items.join()}';

void main() {
  test('catálogo coerente é aceito', () {
    final repo = fixtureRepo({
      catalogFile: _catalog([
        _item('rebic/foundation/typography', 'foundation', 'P0', 1, status: 'specified'),
        _item('rebic/widgets/rebic-button', 'widget', 'P1', 2, deps: ['rebic/foundation/typography']),
      ]),
      'openspec/specs/rebic/foundation/typography/spec.md': componentSpec(),
    });
    expect(checkCatalog(repo), isEmpty);
  });

  test('catálogo ausente é indicado', () {
    expect(messages(checkCatalog(fixtureRepo({}))), [contains('catálogo não encontrado')]);
  });

  test('item especificado sem spec é rejeitado', () {
    final repo = fixtureRepo({
      catalogFile: _catalog([_item('rebic/widgets/rebic-button', 'widget', 'P1', 2, status: 'specified')]),
    });
    expect(messages(checkCatalog(repo)), [contains('exige spec')]);
  });

  test('item especificado com spec em change ativa é aceito', () {
    final repo = fixtureRepo({
      catalogFile: _catalog([_item('rebic/widgets/rebic-button', 'widget', 'P1', 2, status: 'specified')]),
      'openspec/changes/add-rebic-button/specs/rebic/widgets/rebic-button/spec.md': widgetSpec(),
    });
    expect(checkCatalog(repo), isEmpty);
  });

  test('spec existente fora do catálogo é rejeitada', () {
    final repo = fixtureRepo({
      catalogFile: _catalog([]),
      'openspec/specs/rebic/foundation/color/spec.md': componentSpec(),
    });
    expect(messages(checkCatalog(repo)), [contains('não está no catálogo')]);
  });

  test('prioridade mais urgente que a dependência é rejeitada', () {
    final repo = fixtureRepo({
      catalogFile: _catalog([
        _item('rebic/widgets/rebic-dropdown', 'widget', 'P2', 2),
        _item('rebic/widgets/rebic-select', 'widget', 'P1', 2, deps: ['rebic/widgets/rebic-dropdown']),
      ]),
    });
    expect(messages(checkCatalog(repo)), [contains('prioridade P1 mais urgente que a dependência')]);
  });

  test('fase anterior à da dependência é rejeitada', () {
    final repo = fixtureRepo({
      catalogFile: _catalog([
        _item('rebic/widgets/rebic-dropdown', 'widget', 'P1', 3),
        _item('rebic/widgets/rebic-select', 'widget', 'P1', 2, deps: ['rebic/widgets/rebic-dropdown']),
      ]),
    });
    expect(messages(checkCatalog(repo)), [contains('fase 2 anterior')]);
  });

  test('dependência desconhecida e ciclo são rejeitados', () {
    final repo = fixtureRepo({
      catalogFile: _catalog([
        _item('rebic/widgets/rebic-a', 'widget', 'P1', 2, deps: ['rebic/widgets/rebic-b', 'rebic/widgets/rebic-z']),
        _item('rebic/widgets/rebic-b', 'widget', 'P1', 2, deps: ['rebic/widgets/rebic-a']),
      ]),
    });
    expect(messages(checkCatalog(repo)), [
      contains('"rebic/widgets/rebic-z" não está no catálogo'),
      contains('ciclo de dependências no catálogo'),
    ]);
  });

  test('widget implementado exige a pasta do widget', () {
    final catalog = _catalog([
      _item('rebic/widgets/rebic-icon-button', 'widget', 'P1', 2, status: 'implemented', category: 'acoes-navegacao'),
    ]);
    const spec = 'openspec/specs/rebic/widgets/rebic-icon-button/spec.md';
    final missing = fixtureRepo({catalogFile: catalog, spec: widgetSpec()});
    expect(messages(checkCatalog(missing)),
        [contains('packages/rebic_widgets/lib/src/acoes_navegacao/icon_button')]);

    final present = fixtureRepo({
      catalogFile: catalog,
      spec: widgetSpec(),
      'packages/rebic_widgets/lib/src/acoes_navegacao/icon_button/icon_button.dart': '',
    });
    expect(checkCatalog(present), isEmpty);
  });

  test('dependência do catálogo ausente da spec é rejeitada', () {
    final repo = fixtureRepo({
      catalogFile: _catalog([
        _item('rebic/foundation/color', 'foundation', 'P0', 1),
        _item('rebic/widgets/rebic-badge', 'widget', 'P1', 2, status: 'specified', deps: ['rebic/foundation/color']),
      ]),
      'openspec/specs/rebic/widgets/rebic-badge/spec.md': widgetSpec(),
    });
    expect(messages(checkCatalog(repo)), [contains('não aparece na spec')]);
  });

  test('kind incompatível com o id é rejeitado', () {
    final repo = fixtureRepo({catalogFile: _catalog([_item('rebic/widgets/rebic-a', 'foundation', 'P1', 2)])});
    expect(messages(checkCatalog(repo)), [contains('não corresponde ao caminho')]);
  });
}
