import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/golden.dart';
import '../../support/traceability.dart';

/// PNG válido de 1 × 1 pixel.
final _png = MemoryImage(
  base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwAD'
    'hgGAWjR9awAAAABJRU5ErkJggg==',
  ),
);

/// Bytes que não são uma imagem.
final _broken = MemoryImage(Uint8List.fromList([0, 1, 2, 3]));

/// Monta [child] centralizado, sob [theme] e escala de texto, sem `RebicApp`.
Widget _host(Widget child, {RebicThemeData? theme, double textScale = 1}) =>
    RebicTheme(
      data: theme ?? RebicThemeData.light(),
      duration: Duration.zero,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: Center(child: child),
          ),
        ),
      ),
    );

/// Fundo pintado do avatar de [index].
Color _background(WidgetTester tester, [int index = 0]) => tester
    .widget<ColoredBox>(
      find
          .descendant(
            of: find.byType(RebicAvatar).at(index),
            matching: find.byType(ColoredBox),
          )
          .first,
    )
    .color;

Size _side(WidgetTester tester, [int index = 0]) => tester.getSize(
  find
      .descendant(
        of: find.byType(RebicAvatar).at(index),
        matching: find.byType(ColoredBox),
      )
      .first,
);

final _light = RebicThemeData.light();

void main() {
  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Avatar com iniciais', (tester) async {
      await tester.pumpWidget(_host(const RebicAvatar(initials: 'mb')));
      expect(_side(tester), Size.square(_light.icons.xLarge * 1.5));
      expect(find.byType(ClipOval), findsOneWidget);
      expect(_background(tester), _light.colors.selectionBackground);
      final text = tester.widget<Text>(find.text('MB'));
      expect(text.style!.color, _light.colors.brand);
    });

    testWidgets('[API] Propriedades — Avatar com imagem', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          _host(RebicAvatar(image: _png, initials: 'MB')),
        );
        await precacheImage(_png, tester.element(find.byType(RebicAvatar)));
      });
      await tester.pump();
      expect(
        find.descendant(
          of: find.byType(ClipOval),
          matching: find.byType(Image),
        ),
        findsOneWidget,
      );
      expect(find.text('MB'), findsNothing);
    });
  });

  test('[API] Iniciais válidas — Iniciais longas', () {
    for (final initials in ['ABCD']) {
      expect(
        () => RebicAvatar(initials: initials),
        throwsA(
          isA<AssertionError>().having(
            (e) => '${e.message}',
            'message',
            contains('ABCD'),
          ),
        ),
      );
    }
  });

  group('[API] Callbacks e controlador', () {
    testWidgets('[API] Callbacks e controlador — Avatar ativo', (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        RebicApp(
          home: Center(
            child: RebicAvatar(initials: 'MB', onPressed: () => calls++),
          ),
        ),
      );
      await tester.tap(find.byType(RebicAvatar));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(calls, 2);
    });

    testWidgets('[API] Callbacks e controlador — Avatar inativo', (
      tester,
    ) async {
      final first = FocusNode();
      final second = FocusNode();
      addTearDown(() {
        first.dispose();
        second.dispose();
      });
      await tester.pumpWidget(
        RebicApp(
          home: Column(
            children: [
              Focus(focusNode: first, child: const SizedBox(height: 20)),
              const RebicAvatar(initials: 'MB'),
              Focus(focusNode: second, child: const SizedBox(height: 20)),
            ],
          ),
        ),
      );
      first.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(second.hasPrimaryFocus, isTrue);
    });
  });

  group('[Comportamento] Ordem e fallback', () {
    testWidgets(
      '[Comportamento] Ordem e fallback — Imagem com erro mostra as iniciais',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(
            _host(RebicAvatar(image: _broken, initials: 'MB')),
          );
          // Dá tempo para a decodificação falhar e o erro ser notificado.
          await Future<void>.delayed(const Duration(milliseconds: 200));
        });
        await tester.pump();
        await tester.pump();
        expect(find.text('MB'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      '[Comportamento] Ordem e fallback — Avatar sem conteúdo mostra o ícone padrão',
      (tester) async {
        await tester.pumpWidget(_host(const RebicAvatar()));
        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.icon, RebicIcons.personPlaceholder);
        expect(icon.color, _light.colors.brand);
      },
    );
  });

  testWidgets('[Aparência] Tamanhos — Lados por tamanho', (tester) async {
    await tester.pumpWidget(
      _host(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final size in RebicAvatarSize.values)
              RebicAvatar(initials: 'A', size: size),
          ],
        ),
      ),
    );
    final sides = [
      for (var i = 0; i < RebicAvatarSize.values.length; i++)
        _side(tester, i).width,
    ];
    final x = _light.icons.xLarge;
    expect(sides, [x, x * 1.5, x * 2, x * 2.5, x * 3.5]);
  });

  testWidgets('[Aparência] Forma e cores — Avatar quadrado', (tester) async {
    for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
      await tester.pumpWidget(
        _host(
          theme: theme,
          RebicAvatar(
            key: ValueKey(theme.brightness),
            initials: 'MB',
            shape: RebicAvatarShape.square,
          ),
        ),
      );
      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, BorderRadius.circular(theme.radius.s));
      expect(_background(tester), theme.colors.selectionBackground);
      expect(
        tester.widget<Text>(find.text('MB')).style!.color,
        theme.colors.brand,
      );
    }
  });

  testWidgets('[Estados] Interação do avatar ativo — Avatar ativo em hover', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(RebicAvatar(initials: 'MB', onPressed: () {})),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.byType(RebicAvatar)));
    await tester.pump();
    expect(_background(tester), _light.colors.selectionHoverBackground);
    await mouse.moveTo(Offset.zero);
    await tester.pump();
    expect(_background(tester), _light.colors.selectionBackground);
  });

  testWidgets('[Acessibilidade] Semântica — Semântica do avatar', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const RebicAvatar(initials: 'MB', semanticLabel: 'Maria Barros'),
            RebicAvatar(initials: 'JS', onPressed: () {}),
          ],
        ),
      ),
    );
    expect(
      tester.getSemantics(find.byType(RebicAvatar).at(0)),
      containsSemantics(label: 'Maria Barros', isImage: true, isButton: false),
    );
    expect(
      tester.getSemantics(find.byType(RebicAvatar).at(1)),
      containsSemantics(label: 'JS', isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });

  testWidgets(
    '[Responsividade] Tamanho fixo — Avatar com escala de texto 2,0',
    (tester) async {
      await tester.pumpWidget(
        _host(
          textScale: 2,
          const RebicAvatar(initials: 'ABC', size: RebicAvatarSize.xs),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(_side(tester), Size.square(_light.icons.xLarge));
      final text = tester.getRect(find.text('ABC'));
      final box = tester.getRect(find.byType(ClipOval));
      expect(
        box.contains(text.topLeft) &&
            box.contains(text.bottomRight - const Offset(0.01, 0.01)),
        isTrue,
      );
    },
  );

  testWidgets('[Integração] Dependências — Avatar sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      RebicApp(
        home: Column(
          children: [
            const RebicAvatar(initials: 'MB'),
            const RebicAvatar(icon: RebicIcons.folderBlank),
            RebicAvatar(initials: 'JS', onPressed: () {}),
          ],
        ),
      ),
    );
    for (final element in find.byType(RebicAvatar).evaluate().toList()) {
      await tester.tap(find.byWidget(element.widget), warnIfMissed: false);
    }
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade do avatar', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-avatar',
        'add-rebic-avatar',
      );
      expect(names, hasLength(18));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens do avatar', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_avatar_$name',
          theme: theme,
          size: const Size(560, 400),
          child: RebicVBox(
            gap: RebicSpace.l,
            items: [
              for (final shape in RebicAvatarShape.values)
                RebicHBox(
                  alignItems: RebicFlexAlignItems.end,
                  items: [
                    for (final size in RebicAvatarSize.values)
                      RebicAvatar(initials: 'MB', size: size, shape: shape),
                  ],
                ),
              const RebicHBox(
                items: [
                  RebicAvatar(),
                  RebicAvatar(icon: RebicIcons.folderBlank),
                  RebicAvatar(
                    icon: RebicIcons.document,
                    shape: RebicAvatarShape.square,
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Avatar sem valor literal', () {
    final source = File(
      'lib/src/exibicao_dados/avatar/rebic_avatar.dart',
    ).readAsStringSync();
    final fields = RegExp(
      r'^  final (\S+) (\w+);$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(fields, isNotEmpty);
    for (final type in fields) {
      expect(type.replaceAll('?', ''), isNot(isIn(['double', 'Color'])));
    }
  });
}
