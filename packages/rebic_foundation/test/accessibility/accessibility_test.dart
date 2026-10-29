import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Superfície tocável de [side] × [side] com rótulo semântico.
Widget _target(double side) => Directionality(
  textDirection: TextDirection.ltr,
  child: Center(
    child: Semantics(
      button: true,
      label: 'alvo',
      child: GestureDetector(
        onTap: () {},
        child: SizedBox.square(dimension: side),
      ),
    ),
  ),
);

AccessibilityGuideline _targetGuideline(RebicDensityTokens density) =>
    MinimumTapTargetGuideline(
      size: Size.square(RebicAccessibility.minTargetSize(density)),
      link: RebicAccessibility.targetSizeLink,
    );

void main() {
  test('Meta de conformidade — Limites declarados', () {
    expect(RebicAccessibility.conformanceTarget, 'WCAG 2.2 AA');
    expect(RebicAccessibility.minTextContrast, 4.5);
    expect(RebicAccessibility.minNonTextContrast, 3);
    expect(RebicAccessibility.minSupportedTextScale, 2.0);
    expect(RebicAccessibility.minTargetSizeFloor, 24);
  });

  test(
    'Contraste pelos papéis de cor — Mesmos mínimos do fundamento de cor',
    () {
      expect(RebicAccessibility.minTextContrast, rebicTextContrastMinimum);
      expect(
        RebicAccessibility.minNonTextContrast,
        rebicNonTextContrastMinimum,
      );
      for (final colors in const [
        RebicColorTokens.light(),
        RebicColorTokens.dark(),
      ]) {
        expect(rebicCheckContrast(colors), isEmpty);
      }
    },
  );

  test('alvo mínimo padrão é o da densidade confortável de referência', () {
    expect(
      RebicAccessibility.defaultMinTargetSize,
      const RebicDensityTokens.comfortable().minTargetSize,
    );
  });

  test('Alvo mínimo de interação por densidade — Alvo por densidade', () {
    expect(
      RebicAccessibility.minTargetSize(const RebicDensityTokens.comfortable()),
      48,
    );
    expect(
      RebicAccessibility.minTargetSize(const RebicDensityTokens.compact()),
      24,
    );
  });

  group('Movimento reduzido', () {
    const motion = RebicMotionTokens.fallback();

    test('Movimento reduzido — Animações desativadas', () {
      for (final mode in [
        RebicAnimationMode.minimal,
        RebicAnimationMode.none,
      ]) {
        final reduced = RebicAccessibility.resolveMotion(motion, mode: mode);
        for (final d in [
          reduced.instant,
          reduced.short,
          reduced.medium,
          reduced.long,
        ]) {
          expect(d, Duration.zero, reason: mode.name);
        }
        expect(reduced.standard, motion.standard, reason: mode.name);
        expect(reduced.enter, motion.enter, reason: mode.name);
        expect(reduced.exit, motion.exit, reason: mode.name);
      }
    });

    test('Movimento reduzido — Animações ativas', () {
      for (final mode in [RebicAnimationMode.full, RebicAnimationMode.basic]) {
        expect(
          RebicAccessibility.resolveMotion(motion, mode: mode),
          same(motion),
          reason: mode.name,
        );
      }
    });

    test('Movimento reduzido — Modo efetivo', () {
      expect(RebicAnimationMode.values.map((m) => m.name), [
        'full',
        'basic',
        'minimal',
        'none',
      ]);
      for (final mode in RebicAnimationMode.values) {
        expect(mode.effective(disableAnimations: false), mode);
        expect(
          mode.effective(disableAnimations: true),
          RebicAnimationMode.none,
        );
      }
      expect(
        [for (final m in RebicAnimationMode.values) m.reducesMotion],
        [false, false, true, true],
      );
    });
  });

  testWidgets(
    'Bateria mínima de testes de acessibilidade — Diretriz de alvo pela densidade',
    (tester) async {
      final handle = tester.ensureSemantics();
      final densities = [
        const RebicDensityTokens.comfortable(),
        const RebicDensityTokens.compact(),
      ];

      await tester.pumpWidget(_target(48));
      for (final density in densities) {
        await expectLater(
          tester,
          meetsGuideline(_targetGuideline(density)),
          reason: density.density.name,
        );
      }

      await tester.pumpWidget(_target(20));
      for (final density in densities) {
        final result = await _targetGuideline(density).evaluate(tester);
        expect(result.passed, isFalse, reason: density.density.name);
      }
      handle.dispose();
    },
  );
}
