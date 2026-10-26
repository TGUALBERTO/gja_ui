import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

Widget _ring({required bool visible}) {
  const tokens = RebicInteractionStateTokens.fallback();
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Center(
      child: RebicFocusRing(
        visible: visible,
        width: tokens.focusWidth,
        offset: tokens.focusOffset,
        color: const RebicColorTokens.light().focus,
        child: const SizedBox(key: Key('content'), width: 80, height: 32),
      ),
    ),
  );
}

void main() {
  testWidgets('anel visível usa os tokens e não muda o tamanho do conteúdo', (
    tester,
  ) async {
    await tester.pumpWidget(_ring(visible: false));
    final hiddenSize = tester.getSize(find.byKey(const Key('content')));
    expect(
      find.descendant(
        of: find.byType(RebicFocusRing),
        matching: find.byType(CustomPaint),
      ),
      findsNothing,
    );

    await tester.pumpWidget(_ring(visible: true));
    expect(tester.getSize(find.byKey(const Key('content'))), hiddenSize);
    final paint = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(RebicFocusRing),
        matching: find.byType(CustomPaint),
      ),
    );
    final painter = paint.foregroundPainter! as RebicFocusRingPainter;
    const tokens = RebicInteractionStateTokens.fallback();
    expect(painter.width, tokens.focusWidth);
    expect(painter.offset, tokens.focusOffset);
    expect(painter.color, const RebicColorTokens.light().focus);
    // O traço fica fora do conteúdo: afastamento + meia espessura.
    final rect = painter.ringRect(hiddenSize);
    expect(rect.left, -(tokens.focusOffset + tokens.focusWidth / 2));
    expect(
      rect.width,
      hiddenSize.width + 2 * (tokens.focusOffset + tokens.focusWidth / 2),
    );
  });
}
