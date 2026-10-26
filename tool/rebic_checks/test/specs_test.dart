import 'package:rebic_checks/rebic_checks.dart';
import 'package:test/test.dart';

import 'support.dart';

const _button = 'openspec/specs/rebic/widgets/rebic-button/spec.md';
const _typography = 'openspec/specs/rebic/foundation/typography/spec.md';

void main() {
  group('estrutura das specs de widget', () {
    test('spec completa é aceita', () {
      final repo = fixtureRepo({
        _typography: componentSpec(),
        _button: widgetSpec(dependencies: ['rebic/foundation/typography']),
      });
      expect(checkSpecs(repo), isEmpty);
    });

    test('etiqueta ausente é indicada', () {
      final repo = fixtureRepo({_button: widgetSpec(omit: {'Acessibilidade'})});
      final violations = checkSpecs(repo);
      expect(violations.single.path, _button);
      expect(violations.single.message, 'falta requisito com a etiqueta [Acessibilidade]');
    });

    test('Purpose ausente é indicado', () {
      final repo = fixtureRepo({_button: widgetSpec(purpose: false)});
      expect(messages(checkSpecs(repo)), [contains('## Purpose')]);
    });

    test('delta de widget existente não precisa repetir a estrutura', () {
      final repo = fixtureRepo({
        _button: widgetSpec(),
        'openspec/changes/update-rebic-button-loading/specs/rebic/widgets/rebic-button/spec.md': '''
## MODIFIED Requirements

### Requirement: [Estados] Requisito
O widget SHALL exibir estado carregando.

#### Scenario: Carregando
- **WHEN** loading é verdadeiro
- **THEN** o indicador aparece
''',
      });
      expect(checkSpecs(repo), isEmpty);
    });

    test('nova spec de widget em change também é verificada', () {
      final repo = fixtureRepo({
        'openspec/changes/add-rebic-badge/specs/rebic/widgets/rebic-badge/spec.md': widgetSpec(omit: {'Testes'}),
      });
      expect(messages(checkSpecs(repo)), [contains('[Testes]')]);
    });
  });

  group('referências', () {
    test('referência inexistente é rejeitada', () {
      final repo = fixtureRepo({_button: widgetSpec(dependencies: ['rebic/widgets/rebic-icon'])});
      final violations = checkSpecs(repo);
      expect(violations.single.message, contains('"rebic/widgets/rebic-icon"'));
      expect(violations.single.line, isNotNull);
    });

    test('referência a spec da mesma change é aceita', () {
      const change = 'openspec/changes/add-rebic-form/specs/rebic/widgets';
      final repo = fixtureRepo({
        '$change/rebic-form/spec.md': widgetSpec(dependencies: ['rebic/widgets/rebic-form-field']),
        '$change/rebic-form-field/spec.md': widgetSpec(),
      });
      expect(checkSpecs(repo), isEmpty);
    });

    test('referência a spec de outra change ainda não arquivada é rejeitada', () {
      final repo = fixtureRepo({
        'openspec/changes/add-rebic-dropdown/specs/rebic/widgets/rebic-dropdown/spec.md': widgetSpec(),
        'openspec/changes/add-rebic-select/specs/rebic/widgets/rebic-select/spec.md':
            widgetSpec(dependencies: ['rebic/widgets/rebic-dropdown']),
      });
      expect(messages(checkSpecs(repo)), [contains('rebic/widgets/rebic-dropdown')]);
    });

    test('changes arquivadas são ignoradas', () {
      final repo = fixtureRepo({
        'openspec/changes/archive/2026-01-01-add-x/specs/rebic/widgets/rebic-x/spec.md':
            widgetSpec(omit: {'API'}),
      });
      expect(checkSpecs(repo), isEmpty);
    });
  });

  test('ciclo entre specs é rejeitado', () {
    final repo = fixtureRepo({
      'openspec/specs/rebic/widgets/rebic-menu/spec.md': widgetSpec(dependencies: ['rebic/widgets/rebic-dropdown']),
      'openspec/specs/rebic/widgets/rebic-dropdown/spec.md': widgetSpec(dependencies: ['rebic/widgets/rebic-menu']),
    });
    expect(messages(checkSpecs(repo)),
        [contains('rebic/widgets/rebic-dropdown -> rebic/widgets/rebic-menu -> rebic/widgets/rebic-dropdown')]);
  });

  test('menções fora de [Integração] não criam dependência', () {
    final repo = fixtureRepo({
      'openspec/specs/rebic/widgets/rebic-menu/spec.md': widgetSpec(dependencies: ['rebic/widgets/rebic-dropdown']),
      'openspec/specs/rebic/widgets/rebic-dropdown/spec.md':
          '${widgetSpec()}\n### Requirement: [Restrições] Extra\nNão substitui `rebic/widgets/rebic-menu`.\n\n'
          '#### Scenario: X\n- **WHEN** a\n- **THEN** b\n',
    });
    expect(checkSpecs(repo), isEmpty);
  });
}
