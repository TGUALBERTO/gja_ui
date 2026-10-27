import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// App com [theme] publicado acima das rotas.
Future<void> _pumpApp(WidgetTester tester, RebicThemeData theme, Widget home) {
  return tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFF000000),
      builder: (context, child) => RebicThemeScope(data: theme, child: child!),
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
          PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
      home: home,
    ),
  );
}

void main() {
  group('Valores do tema ativo nas sobreposições', () {
    testWidgets(
      'Valores do tema ativo nas sobreposições — Camada no tema escuro',
      (tester) async {
        late BuildContext screen;
        final dark = RebicThemeData.dark();
        await _pumpApp(
          tester,
          dark,
          Builder(
            builder: (context) {
              screen = context;
              return const SizedBox.expand();
            },
          ),
        );
        unawaited(
          RebicModal.show<void>(screen, builder: (_) => const Text('modal')),
        );
        await tester.pumpAndSettle();
        final barrier = tester.widget<ModalBarrier>(
          find.byType(ModalBarrier).last,
        );
        expect(barrier.color, dark.colors.blockLayer);
        expect(barrier.color, isNot(RebicThemeData.light().colors.blockLayer));
      },
    );

    testWidgets(
      'Valores do tema ativo nas sobreposições — Espaçamentos da densidade compacta',
      (tester) async {
        final compact = RebicThemeData.light(density: RebicDensity.compact);
        final controller = RebicAnchoredOverlayController();
        addTearDown(controller.dispose);
        await _pumpApp(
          tester,
          compact,
          Stack(
            children: [
              Positioned(
                left: 50,
                top: 20,
                child: RebicAnchoredOverlay(
                  controller: controller,
                  focusOnShow: false,
                  overlayBuilder: (_) => const SizedBox(
                    key: Key('content'),
                    width: 120,
                    height: 80,
                  ),
                  child: const SizedBox(
                    key: Key('anchor'),
                    width: 100,
                    height: 40,
                  ),
                ),
              ),
            ],
          ),
        );
        controller.show();
        await tester.pumpAndSettle();
        final anchor = tester.getRect(find.byKey(const Key('anchor')));
        final content = tester.getRect(find.byKey(const Key('content')));
        expect(content.top, anchor.bottom + compact.spacing.xs);
      },
    );
  });
}
