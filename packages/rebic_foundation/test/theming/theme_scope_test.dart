import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Lê o tema ativo e guarda cada leitura.
class _Reader extends StatelessWidget {
  const _Reader(this.reads);

  final List<RebicThemeData> reads;

  @override
  Widget build(BuildContext context) {
    reads.add(RebicThemeData.of(context));
    return const SizedBox();
  }
}

void main() {
  group('Tema na árvore de widgets', () {
    testWidgets('Tema na árvore de widgets — Tema mais próximo', (
      tester,
    ) async {
      final reads = <RebicThemeData>[];
      await tester.pumpWidget(
        RebicThemeScope(
          data: RebicThemeData.light(),
          child: RebicThemeScope(
            data: RebicThemeData.dark(),
            child: _Reader(reads),
          ),
        ),
      );
      expect(reads.single, RebicThemeData.dark());
    });

    testWidgets('Tema na árvore de widgets — Árvore sem tema', (tester) async {
      final reads = <RebicThemeData>[];
      await tester.pumpWidget(_Reader(reads));
      expect(reads.single, RebicThemeData.light());
    });

    testWidgets(
      'Tema na árvore de widgets — Animações desligadas pelo sistema',
      (tester) async {
        final reads = <RebicThemeData>[];
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: RebicThemeScope(
              data: RebicThemeData.light(),
              child: _Reader(reads),
            ),
          ),
        );
        final motion = reads.single.motion;
        for (final d in [
          motion.instant,
          motion.short,
          motion.medium,
          motion.long,
        ]) {
          expect(d, Duration.zero);
        }
        expect(reads.single.animationMode, RebicAnimationMode.none);
      },
    );

    testWidgets('Tema na árvore de widgets — Animações desligadas pelo tema', (
      tester,
    ) async {
      final reads = <RebicThemeData>[];
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: RebicThemeScope(
            data: RebicThemeData.light().copyWith(
              animationMode: RebicAnimationMode.none,
            ),
            child: _Reader(reads),
          ),
        ),
      );
      final motion = reads.single.motion;
      for (final d in [
        motion.instant,
        motion.short,
        motion.medium,
        motion.long,
      ]) {
        expect(d, Duration.zero);
      }
    });

    testWidgets('Tema na árvore de widgets — Reconstrução na troca', (
      tester,
    ) async {
      final reads = <RebicThemeData>[];
      // O leitor é constante: só a dependência do escopo o reconstrói.
      final reader = _Reader(reads);
      await tester.pumpWidget(
        RebicThemeScope(data: RebicThemeData.light(), child: reader),
      );
      await tester.pumpWidget(
        RebicThemeScope(data: RebicThemeData.dark(), child: reader),
      );
      expect(reads, [RebicThemeData.light(), RebicThemeData.dark()]);
    });

    testWidgets('mesmo tema não reconstrói quem lê', (tester) async {
      final reads = <RebicThemeData>[];
      final reader = _Reader(reads);
      await tester.pumpWidget(
        RebicThemeScope(data: RebicThemeData.light(), child: reader),
      );
      await tester.pumpWidget(
        RebicThemeScope(data: RebicThemeData.light(), child: reader),
      );
      expect(reads, hasLength(1));
    });
  });
}
