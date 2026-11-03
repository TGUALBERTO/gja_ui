import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/golden.dart';
import '../../support/traceability.dart';

final _light = RebicThemeData.light();

final _clearIcon = find.byKey(const ValueKey('rebic-input-clear'));

Widget _app(
  Widget home, {
  TextDirection direction = TextDirection.ltr,
  double textScale = 1,
  double width = 300,
}) => RebicApp(
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(textScale)),
    child: Directionality(textDirection: direction, child: child!),
  ),
  home: Center(
    child: SizedBox(width: width, child: home),
  ),
);

/// Campo que guarda o próprio valor e registra os avisos.
class _Host extends StatefulWidget {
  const _Host({
    required this.log,
    this.initial = '',
    this.type = RebicInputType.text,
    this.maxLength = 0,
    this.showClearIcon = false,
  });

  final List<String> log;
  final String initial;
  final RebicInputType type;
  final int maxLength;
  final bool showClearIcon;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late String value = widget.initial;

  @override
  Widget build(BuildContext context) => RebicInput(
    semanticLabel: 'Campo',
    value: value,
    type: widget.type,
    maxLength: widget.maxLength,
    showClearIcon: widget.showClearIcon,
    onLiveChange: (v) {
      widget.log.add('live:$v');
      setState(() => value = v);
    },
    onChange: (v) => widget.log.add('change:$v'),
    onSubmit: (v) => widget.log.add('submit:$v'),
  );
}

/// Moldura (o primeiro `DecoratedBox`) do campo de [index].
Finder _frame([int index = 0]) => find
    .descendant(
      of: find.byType(RebicInput).at(index),
      matching: find.byType(DecoratedBox),
    )
    .first;

BoxDecoration _decoration(WidgetTester tester, [int index = 0]) =>
    tester.widget<DecoratedBox>(_frame(index)).decoration as BoxDecoration;

Color _border(WidgetTester tester, [int index = 0]) =>
    (_decoration(tester, index).border! as Border).top.color;

String _text(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText)).controller.text;

void main() {
  testWidgets('[API] Propriedades — Campo mínimo', (tester) async {
    await tester.pumpWidget(
      _app(RebicInput(placeholder: 'Nome', onLiveChange: (_) {})),
    );
    final size = tester.getSize(_frame());
    expect(size.width, 300);
    expect(size.height, _light.density.controlHeight);
    expect(find.text('Nome'), findsOneWidget);
  });

  test('[API] Rótulo válido — Campo sem rótulo', () {
    expect(() => RebicInput(onLiveChange: (_) {}), throwsAssertionError);
  });

  group('[API] Callbacks e controlador', () {
    testWidgets('[API] Callbacks e controlador — Digitar no campo', (
      tester,
    ) async {
      final log = <String>[];
      await tester.pumpWidget(_app(_Host(log: log)));
      await tester.tap(find.byType(RebicInput));
      await tester.pump();
      for (final text in ['a', 'ab', 'abc']) {
        await tester.enterText(find.byType(EditableText), text);
        await tester.pump();
      }
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(log, [
        'live:a',
        'live:ab',
        'live:abc',
        'submit:abc',
        'change:abc',
      ]);
    });

    testWidgets('[API] Callbacks e controlador — Valor vindo do pai', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(const RebicInput(semanticLabel: 'x', value: 'a')),
      );
      await tester.pumpWidget(
        _app(const RebicInput(semanticLabel: 'x', value: 'xyz')),
      );
      expect(_text(tester), 'xyz');
    });
  });

  testWidgets('[Comportamento] Tipos e limite — Senha e limite', (
    tester,
  ) async {
    final log = <String>[];
    await tester.pumpWidget(
      _app(_Host(log: log, type: RebicInputType.password, maxLength: 4)),
    );
    await tester.tap(find.byType(RebicInput));
    await tester.pump();
    await tester.enterText(find.byType(EditableText), '123456');
    await tester.pump();
    expect(_text(tester), '1234');
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isTrue,
    );
  });

  testWidgets('[Comportamento] Botão de limpar — Limpar o campo', (
    tester,
  ) async {
    final log = <String>[];
    await tester.pumpWidget(
      _app(_Host(log: log, initial: 'abc', showClearIcon: true)),
    );
    expect(_clearIcon, findsOneWidget);
    await tester.tap(_clearIcon);
    await tester.pump();
    expect(log, ['live:', 'change:']);
    expect(_clearIcon, findsNothing);
  });

  testWidgets(
    '[Comportamento] Mensagem de estado de valor — Mensagem de erro no foco',
    (tester) async {
      final other = FocusNode();
      addTearDown(other.dispose);
      await tester.pumpWidget(
        _app(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const RebicInput(
                semanticLabel: 'Nome',
                valueState: RebicValueState.error,
                valueStateText: 'Informe o nome',
              ),
              Focus(
                focusNode: other,
                child: const SizedBox.square(dimension: 8),
              ),
            ],
          ),
        ),
      );
      expect(find.text('Informe o nome'), findsNothing);
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(find.text('Informe o nome'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Informe o nome')).dy,
        greaterThanOrEqualTo(tester.getBottomLeft(_frame()).dy),
      );
      other.requestFocus();
      await tester.pump();
      await tester.pump();
      expect(find.text('Informe o nome'), findsNothing);
    },
  );

  testWidgets('[Aparência] Tokens de componente — Aparência do campo', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RebicInput(semanticLabel: 'a'),
            RebicInput(semanticLabel: 'b', valueState: RebicValueState.warning),
            RebicInput(semanticLabel: 'c', editable: false),
          ],
        ),
      ),
    );
    expect(_decoration(tester).color, _light.colors.base);
    expect(_border(tester), _light.colors.fieldBorder);
    final warning = _light.colors.stateColors(RebicValueState.warning);
    expect(_decoration(tester, 1).color, warning.background);
    expect(_border(tester, 1), warning.border);
    expect(_decoration(tester, 2).color, _light.colors.headerBackground);
  });

  group('[Estados] Interação', () {
    testWidgets('[Estados] Interação — Foco no campo', (tester) async {
      await tester.pumpWidget(_app(const RebicInput(semanticLabel: 'f')));
      await tester.tap(find.byType(RebicInput));
      await tester.pump();
      expect(_border(tester), _light.colors.brand);
      expect(
        tester
            .widget<RebicFocusRing>(
              find.descendant(
                of: find.byType(RebicInput),
                matching: find.byType(RebicFocusRing),
              ),
            )
            .visible,
        isTrue,
      );
    });

    testWidgets('[Estados] Interação — Campo desabilitado', (tester) async {
      await tester.pumpWidget(
        _app(const RebicInput(semanticLabel: 'd', enabled: false)),
      );
      await tester.tap(find.byType(RebicInput), warnIfMissed: false);
      await tester.pump();
      expect(
        FocusManager.instance.primaryFocus?.context
            ?.findAncestorWidgetOfExactType<RebicInput>(),
        isNull,
      );
      expect(
        tester
            .widget<Opacity>(
              find.descendant(
                of: find.byType(RebicInput),
                matching: find.byType(Opacity),
              ),
            )
            .opacity,
        _light.interaction.disabledOpacity,
      );
    });

    testWidgets('[Estados] Interação — Campo somente leitura', (tester) async {
      await tester.pumpWidget(
        _app(
          const RebicInput(semanticLabel: 'r', value: 'abc', editable: false),
        ),
      );
      await tester.tap(find.byType(RebicInput));
      await tester.pump();
      expect(
        FocusManager.instance.primaryFocus?.context
            ?.findAncestorWidgetOfExactType<RebicInput>(),
        isNotNull,
      );
      await tester.enterText(find.byType(EditableText), 'x');
      await tester.pump();
      expect(_text(tester), 'abc');
    });

    testWidgets('hover muda a borda', (tester) async {
      await tester.pumpWidget(_app(const RebicInput(semanticLabel: 'h')));
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(_frame()));
      await tester.pump();
      expect(_border(tester), _light.colors.brand);
    });
  });

  testWidgets('[Acessibilidade] Semântica — Semântica do campo', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        const RebicInput(
          semanticLabel: 'Nome',
          value: 'Ana',
          valueState: RebicValueState.warning,
          valueStateText: 'Confira',
        ),
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Nome')),
      containsSemantics(
        isTextField: true,
        label: 'Nome',
        value: 'Ana',
        hint: 'Confira',
      ),
    );
    handle.dispose();
  });

  group('[Acessibilidade] Contraste, alvo e escala', () {
    testWidgets(
      '[Acessibilidade] Contraste, alvo e escala — Contraste e alvo do campo',
      (tester) async {
        final handle = tester.ensureSemantics();
        for (final (_, theme) in goldenThemes) {
          await tester.pumpWidget(
            RebicApp(
              key: ValueKey(theme),
              theme: theme,
              darkTheme: theme,
              density: theme.density.density,
              home: RebicContainer(
                surface: RebicSurface.background,
                child: const Center(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RebicInput(semanticLabel: 'a', value: 'Texto'),
                        RebicInput(semanticLabel: 'b', placeholder: 'Vazio'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          await expectLater(
            tester,
            meetsGuideline(
              MinimumTapTargetGuideline(
                size: Size.square(
                  RebicAccessibility.minTargetSize(theme.density),
                ),
                link: RebicAccessibility.targetSizeLink,
              ),
            ),
          );
          final c = theme.colors;
          for (final ground in [c.base, c.background]) {
            expect(
              rebicContrastRatioOver(c.fieldBorder, ground),
              greaterThanOrEqualTo(RebicAccessibility.minNonTextContrast),
            );
          }
        }
        handle.dispose();
      },
    );

    testWidgets(
      '[Acessibilidade] Contraste, alvo e escala — Escala de texto do campo',
      (tester) async {
        await tester.pumpWidget(
          _app(
            textScale: 2,
            width: 200,
            const RebicInput(semanticLabel: 'e', value: 'Texto longo'),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(_frame()).height,
          greaterThanOrEqualTo(_light.density.controlHeight),
        );
      },
    );
  });

  testWidgets('[Responsividade] Largura e direção — Campo em RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        direction: TextDirection.rtl,
        _Host(log: [], initial: 'abc', showClearIcon: true),
      ),
    );
    expect(
      tester.getCenter(_clearIcon).dx,
      lessThan(tester.getCenter(_frame()).dx),
    );
  });

  testWidgets('[Integração] Dependências — Campo sem Material', (tester) async {
    await tester.pumpWidget(
      _app(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final type in RebicInputType.values)
              RebicInput(semanticLabel: type.name, type: type),
            const RebicInput(semanticLabel: 'r', editable: false),
            const RebicInput(semanticLabel: 'd', enabled: false),
          ],
        ),
      ),
    );
    await tester.tap(find.byType(RebicInput).first);
    await tester.enterText(find.byType(EditableText).first, 'abc');
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade do campo', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-input',
        'add-rebic-input',
      );
      expect(names, hasLength(20));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens do campo', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await tester.pumpWidget(const SizedBox());
        await expectGolden(
          tester,
          name: 'rebic_input_$name',
          theme: theme,
          size: const Size(380, 520),
          child: SizedBox(
            width: 300,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (_) => RebicVBox(
                    gap: RebicSpace.s,
                    items: [
                      const RebicInput(placeholder: 'Vazio'),
                      const RebicInput(semanticLabel: 'a', value: 'Com texto'),
                      RebicInput(
                        semanticLabel: 'b',
                        value: 'Com limpar',
                        showClearIcon: true,
                        onLiveChange: (_) {},
                      ),
                      for (final state in RebicValueState.values.skip(1))
                        RebicInput(
                          semanticLabel: state.name,
                          value: state.name,
                          valueState: state,
                        ),
                      const RebicInput(
                        semanticLabel: 'r',
                        value: 'Somente leitura',
                        editable: false,
                      ),
                      const RebicInput(
                        semanticLabel: 'd',
                        value: 'Desabilitado',
                        enabled: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Campo sem valor literal', () {
    final source = File(
      'lib/src/formularios/input/rebic_input.dart',
    ).readAsStringSync();
    final fields = RegExp(
      r'^  final (\S+) (\w+);$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(fields, isNotEmpty);
    for (final type in fields) {
      expect(type, isNot(anyOf('double', 'double?', 'Color', 'Color?')));
    }
  });
}
