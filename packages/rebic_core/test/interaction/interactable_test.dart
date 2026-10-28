import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

const _hovered = RebicInteractionState.hovered;
const _pressed = RebicInteractionState.pressed;
const _focused = RebicInteractionState.focused;
const _selected = RebicInteractionState.selected;
const _disabled = RebicInteractionState.disabled;

/// App mínimo com os atalhos e a travessia de foco padrão do `WidgetsApp`.
Widget _app(Widget child) => WidgetsApp(
  color: const RebicColorTokens.light().brand,
  builder: (context, _) => Center(child: child),
);

/// Elemento que grava cada conjunto de estados recebido.
RebicInteractable _recorder(
  List<Set<RebicInteractionState>> log, {
  VoidCallback? onPressed,
  bool selected = false,
  FocusNode? focusNode,
  bool autofocus = false,
  String? label,
  double side = 48,
  bool link = false,
  Key? key,
}) => RebicInteractable(
  key: key,
  link: link,
  onPressed: onPressed,
  selected: selected,
  focusNode: focusNode,
  autofocus: autofocus,
  semanticLabel: label,
  builder: (context, states) {
    if (log.isEmpty || !setEquals(log.last, states)) log.add({...states});
    return SizedBox.square(dimension: side);
  },
);

bool setEquals<T>(Set<T> a, Set<T> b) =>
    a.length == b.length && a.containsAll(b);

/// Se há um anel de foco desenhado sob [finder].
bool _ringDrawn(WidgetTester tester, Finder finder) {
  final rings = tester.widgetList<RebicFocusRing>(
    find.descendant(of: finder, matching: find.byType(RebicFocusRing)),
  );
  return rings.any((r) => r.visible);
}

void main() {
  tearDown(() {
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic;
  });

  group('Detecção de estados', () {
    testWidgets('Detecção de estados — Hover e pressionado', (tester) async {
      final log = <Set<RebicInteractionState>>[];
      await tester.pumpWidget(_app(_recorder(log, onPressed: () {})));
      final center = tester.getCenter(find.byType(RebicInteractable));
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      log.clear();

      await mouse.moveTo(center);
      await tester.pump();
      await mouse.down(center);
      await tester.pump();
      await mouse.up();
      await tester.pump();
      await mouse.moveTo(Offset.zero);
      await tester.pump();

      // O toque pede foco: `focused` acompanha os conjuntos após pressionar.
      final withoutFocus = [
        for (final s in log) s.difference({_focused}),
      ];
      final collapsed = <Set<RebicInteractionState>>[];
      for (final s in withoutFocus) {
        if (collapsed.isEmpty || !setEquals(collapsed.last, s)) {
          collapsed.add(s);
        }
      }
      expect(collapsed, [
        {_hovered},
        {_hovered, _pressed},
        {_hovered},
        <RebicInteractionState>{},
      ]);
    });

    testWidgets('Detecção de estados — Seleção recebida', (tester) async {
      final log = <Set<RebicInteractionState>>[];
      await tester.pumpWidget(
        _app(_recorder(log, onPressed: () {}, selected: true)),
      );
      expect(log.last, contains(_selected));
    });
  });

  group('Ativação por toque e teclado', () {
    testWidgets('Ativação por toque e teclado — Ativação por teclado', (
      tester,
    ) async {
      var count = 0;
      await tester.pumpWidget(
        _app(_recorder([], onPressed: () => count++, autofocus: true)),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.numpadEnter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(count, 3);
    });

    testWidgets('Ativação por toque e teclado — Toque cancelado', (
      tester,
    ) async {
      var count = 0;
      final log = <Set<RebicInteractionState>>[];
      await tester.pumpWidget(_app(_recorder(log, onPressed: () => count++)));
      final center = tester.getCenter(find.byType(RebicInteractable));
      final gesture = await tester.startGesture(center);
      await tester.pump();
      expect(log.last, contains(_pressed));
      await gesture.moveTo(center + const Offset(400, 400));
      await gesture.up();
      await tester.pump();
      expect(count, 0);
      expect(log.last, isNot(contains(_pressed)));
    });

    testWidgets('toque completo ativa uma vez', (tester) async {
      var count = 0;
      await tester.pumpWidget(_app(_recorder([], onPressed: () => count++)));
      await tester.tap(find.byType(RebicInteractable));
      await tester.pump();
      expect(count, 1);
    });
  });

  testWidgets('Elemento desabilitado — Desabilitado ignora interação', (
    tester,
  ) async {
    final first = FocusNode();
    final last = FocusNode();
    addTearDown(first.dispose);
    addTearDown(last.dispose);
    final disabledLog = <Set<RebicInteractionState>>[];
    await tester.pumpWidget(
      _app(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _recorder([], onPressed: () {}, focusNode: first, autofocus: true),
            _recorder(disabledLog, key: const Key('disabled')),
            _recorder([], onPressed: () {}, focusNode: last),
          ],
        ),
      ),
    );
    final disabled = find.byKey(const Key('disabled'));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: tester.getCenter(disabled));
    addTearDown(mouse.removePointer);
    await tester.pump();
    await tester.tap(disabled);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(disabledLog.toSet().map((s) => s.toList()), [
      [_disabled],
    ]);
    expect(last.hasFocus, isTrue);
    final detector = tester.widget<FocusableActionDetector>(
      find.descendant(
        of: disabled,
        matching: find.byType(FocusableActionDetector),
      ),
    );
    expect(detector.mouseCursor, SystemMouseCursors.basic);
  });

  group('Anel de foco pelo teclado', () {
    testWidgets('Anel de foco pelo teclado — Foco por teclado', (tester) async {
      final second = FocusNode();
      addTearDown(second.dispose);
      await tester.pumpWidget(
        _app(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _recorder([], onPressed: () {}, autofocus: true),
              _recorder(
                [],
                onPressed: () {},
                focusNode: second,
                key: const Key('second'),
              ),
            ],
          ),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(second.hasFocus, isTrue);
      final target = find.byKey(const Key('second'));
      expect(_ringDrawn(tester, target), isTrue);
      final ring = tester.widget<RebicFocusRing>(
        find.descendant(of: target, matching: find.byType(RebicFocusRing)),
      );
      const tokens = RebicInteractionStateTokens.fallback();
      expect(ring.width, tokens.focusWidth);
      expect(ring.offset, tokens.focusOffset);
      expect(ring.color, const RebicColorTokens.light().focus);
    });

    testWidgets('Anel de foco pelo teclado — Foco por toque', (tester) async {
      final log = <Set<RebicInteractionState>>[];
      await tester.pumpWidget(_app(_recorder(log, onPressed: () {})));
      await tester.tap(find.byType(RebicInteractable));
      await tester.pump();
      expect(log.last, contains(_focused));
      expect(_ringDrawn(tester, find.byType(RebicInteractable)), isFalse);
    });
  });

  testWidgets('Ordem de foco — Tab entre três elementos', (tester) async {
    final nodes = [FocusNode(), FocusNode(), FocusNode()];
    for (final n in nodes) {
      addTearDown(n.dispose);
    }
    await tester.pumpWidget(
      _app(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _recorder(
              [],
              onPressed: () {},
              focusNode: nodes[0],
              autofocus: true,
            ),
            _recorder([], focusNode: nodes[1]),
            _recorder([], onPressed: () {}, focusNode: nodes[2]),
          ],
        ),
      ),
    );
    await tester.pump();
    expect(nodes[0].hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(nodes[2].hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(nodes[0].hasFocus, isTrue);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();
    expect(nodes[2].hasFocus, isTrue);
    expect(nodes[1].hasFocus, isFalse);
  });

  testWidgets('Área mínima de interação — Conteúdo menor que o alvo', (
    tester,
  ) async {
    var count = 0;
    await tester.pumpWidget(
      _app(_recorder([], onPressed: () => count++, side: 16)),
    );
    final size = tester.getSize(find.byType(RebicInteractable));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
    await tester.tapAt(
      tester.getCenter(find.byType(RebicInteractable)) + const Offset(20, 0),
    );
    await tester.pump();
    expect(count, 1);
  });

  group('Semântica e cursor', () {
    testWidgets('Semântica e cursor — Semântica de botão', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(_recorder([], onPressed: () {}, selected: true, label: 'Salvar')),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Salvar')),
        containsSemantics(
          label: 'Salvar',
          isButton: true,
          isEnabled: true,
          isSelected: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('Semântica e cursor — Semântica de link', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(_recorder([], onPressed: () {}, label: 'Ver pedido', link: true)),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Ver pedido')),
        containsSemantics(
          label: 'Ver pedido',
          isLink: true,
          isButton: false,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('cursor de clique quando habilitado', (tester) async {
      await tester.pumpWidget(_app(_recorder([], onPressed: () {})));
      final detector = tester.widget<FocusableActionDetector>(
        find.byType(FocusableActionDetector),
      );
      expect(detector.mouseCursor, SystemMouseCursors.click);
    });
  });
}
