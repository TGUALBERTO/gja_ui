import 'package:rebic_checks/rebic_checks.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  group('imports entre camadas', () {
    test('dependências na direção correta são aceitas', () {
      final repo = fixtureRepo({
        'packages/rebic_foundation/lib/rebic_foundation.dart':
            "import 'package:flutter/widgets.dart';\n",
        'packages/rebic_core/lib/rebic_core.dart':
            "import 'package:rebic_foundation/rebic_foundation.dart';\n",
        'packages/rebic_widgets/lib/rebic_widgets.dart':
            "import 'package:rebic_core/rebic_core.dart';\nimport 'package:rebic_foundation/rebic_foundation.dart';\n",
        'packages/gja_ui/lib/gja_ui.dart':
            "export 'package:rebic_widgets/rebic_widgets.dart';\n",
      });
      expect(checkImports(repo), isEmpty);
    });

    test('import proibido é detectado com arquivo e linha', () {
      final repo = fixtureRepo({
        'packages/rebic_foundation/lib/src/tokens.dart':
            "import 'package:flutter/widgets.dart';\nimport 'package:rebic_widgets/rebic_widgets.dart';\n",
      });
      final violations = checkImports(repo);
      expect(violations, hasLength(1));
      expect(
        violations.single.path,
        'packages/rebic_foundation/lib/src/tokens.dart',
      );
      expect(violations.single.line, 2);
      expect(
        violations.single.message,
        contains('não pode depender de rebic_widgets'),
      );
    });
  });

  group('primitivos de rebic_foundation', () {
    test(
      'Primitivos isolados da camada de widgets — Widget importa primitivos',
      () {
        final repo = fixtureRepo({
          'packages/rebic_widgets/lib/src/actions/button/button.dart':
              "import 'package:flutter/widgets.dart';\nimport 'package:rebic_foundation/rebic_primitives.dart';\n",
        });
        final violations = checkImports(repo);
        expect(violations, hasLength(1));
        expect(
          violations.single.path,
          'packages/rebic_widgets/lib/src/actions/button/button.dart',
        );
        expect(violations.single.line, 2);
        expect(violations.single.message, contains('rebic_primitives.dart'));
      },
    );

    test('core importando src/ de rebic_foundation é rejeitado', () {
      final repo = fixtureRepo({
        'packages/rebic_core/lib/src/interaction/focus.dart':
            "import 'package:rebic_foundation/src/tokens/lerp.dart';\n",
      });
      expect(messages(checkImports(repo)), [
        contains('restritos ao próprio pacote'),
      ]);
    });

    test(
      'Primitivos isolados da camada de widgets — Agregador não expõe primitivos',
      () {
        final repo = fixtureRepo({
          'packages/gja_ui/lib/gja_ui.dart':
              "export 'package:rebic_foundation/rebic_foundation.dart';\nexport 'package:rebic_foundation/rebic_primitives.dart';\n",
        });
        final violations = checkImports(repo);
        expect(violations, hasLength(1));
        expect(violations.single.line, 2);
        expect(violations.single.message, startsWith('export de'));
      },
    );

    test('rebic_foundation pode importar os próprios primitivos', () {
      final repo = fixtureRepo({
        'packages/rebic_foundation/lib/src/tokens/motion_tokens.dart':
            "import 'package:rebic_foundation/rebic_primitives.dart';\nimport 'package:rebic_foundation/src/tokens/lerp.dart';\n",
      });
      expect(checkImports(repo), isEmpty);
    });
  });

  group('Material e Cupertino', () {
    test('import sem marcador de ADR é rejeitado', () {
      final repo = fixtureRepo({
        'packages/rebic_widgets/lib/src/inputs/text_field/text_field.dart':
            "import 'package:flutter/material.dart';\n",
      });
      expect(messages(checkImports(repo)), [
        contains('sem marcador "// rebic-adr: NNNN"'),
      ]);
    });

    test('import com marcador apontando para ADR existente é aceito', () {
      final repo = fixtureRepo({
        'docs/adr/0042-selecao-de-texto.md': '# ADR 0042\n',
        'packages/rebic_widgets/lib/src/inputs/text_field/text_field.dart':
            "import 'package:flutter/material.dart' show TextSelectionTheme; // rebic-adr: 0042\n",
      });
      expect(checkImports(repo), isEmpty);
    });

    test('marcador apontando para ADR inexistente é rejeitado', () {
      final repo = fixtureRepo({
        'packages/rebic_widgets/lib/src/inputs/text_field/text_field.dart':
            "import 'package:flutter/cupertino.dart'; // rebic-adr: 0099\n",
      });
      expect(checkImports(repo), hasLength(1));
    });

    test('reexportar Material é sempre rejeitado', () {
      final repo = fixtureRepo({
        'docs/adr/0042-x.md': '',
        'packages/gja_ui/lib/gja_ui.dart':
            "export 'package:flutter/material.dart'; // rebic-adr: 0042\n",
      });
      expect(messages(checkImports(repo)), [contains('reexporta')]);
    });
  });

  group('ciclos entre módulos internos', () {
    test('ciclo entre widgets do mesmo pacote é rejeitado', () {
      final repo = fixtureRepo({
        'packages/rebic_widgets/lib/src/actions/button/button.dart':
            "import '../../feedback/dialog/dialog.dart';\n",
        'packages/rebic_widgets/lib/src/feedback/dialog/dialog.dart':
            "import 'package:rebic_widgets/src/actions/button/button.dart';\n",
      });
      expect(messages(checkImports(repo)), [
        contains('actions/button -> feedback/dialog -> actions/button'),
      ]);
    });

    test('dependência em uma direção entre módulos é aceita', () {
      final repo = fixtureRepo({
        'packages/rebic_widgets/lib/src/actions/button/button.dart':
            "import 'button_style.dart';\n",
        'packages/rebic_widgets/lib/src/actions/button/button_style.dart': '',
        'packages/rebic_widgets/lib/src/feedback/dialog/dialog.dart':
            "import '../../actions/button/button.dart';\n",
      });
      expect(checkImports(repo), isEmpty);
    });
  });

  group('API pública', () {
    test(
      'tipo Material em símbolo exportado é detectado',
      () async {
        final repo = fixtureRepo(resolvable: true, {
          'packages/rebic_widgets/lib/rebic_widgets.dart': '''
import 'package:flutter/material.dart';

class RebicLeaky {
  RebicLeaky(this.color);
  final MaterialColor color;
  ThemeData theme() => ThemeData();
}

typedef RebicBuilder = Widget Function(ScaffoldState state);
''',
        });
        final found = messages(await checkPublicApi(repo));
        expect(
          found,
          contains(contains('"RebicLeaky" referencia MaterialColor')),
        );
        expect(found, contains(contains('"RebicLeaky" referencia ThemeData')));
        expect(
          found,
          contains(contains('"RebicBuilder" referencia ScaffoldState')),
        );
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    test(
      'API composta só com widgets.dart é aceita',
      () async {
        final repo = fixtureRepo(resolvable: true, {
          'packages/rebic_widgets/lib/rebic_widgets.dart': '''
import 'package:flutter/widgets.dart';

class RebicClean extends StatelessWidget {
  const RebicClean({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => child;
}
''',
        });
        expect(await checkPublicApi(repo), isEmpty);
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );
  });
}
