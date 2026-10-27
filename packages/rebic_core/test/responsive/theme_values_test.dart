import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

void main() {
  testWidgets('Limiares do tema ativo — Tema com limiares próprios', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(500, 600);
    addTearDown(tester.view.reset);
    final base = RebicThemeData.light();
    final theme = base.copyWith(
      breakpoints: base.breakpoints.copyWith(medium: 480),
    );
    late RebicSizeClass screen;
    late RebicSizeClass scoped;
    late RebicSizeClass panel;
    await tester.pumpWidget(
      RebicThemeScope(
        data: theme,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              screen = RebicResponsive.screenSizeClassOf(context);
              return RebicScreenSizeScope(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 500,
                    child: RebicResponsiveBuilder(
                      builder: (context, sizeClass) {
                        scoped = RebicResponsive.screenSizeClassOf(context);
                        panel = sizeClass;
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    expect(screen, RebicSizeClass.medium);
    expect(scoped, RebicSizeClass.medium);
    expect(panel, RebicSizeClass.medium);
  });
}
