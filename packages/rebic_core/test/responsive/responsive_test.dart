import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

void _setView(WidgetTester tester, double width, [double height = 600]) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
}

/// Lê a classe da tela e conta os builds.
class _Probe extends StatelessWidget {
  const _Probe();

  static final builds = <RebicSizeClass>[];

  @override
  Widget build(BuildContext context) {
    builds.add(RebicResponsive.screenSizeClassOf(context));
    return const SizedBox();
  }
}

Widget _ltr(Widget child) =>
    Directionality(textDirection: TextDirection.ltr, child: child);

void main() {
  setUp(_Probe.builds.clear);

  group('Classe de tamanho da tela', () {
    testWidgets('Classe de tamanho da tela — Largura da janela', (
      tester,
    ) async {
      addTearDown(tester.view.reset);
      for (final scoped in [true, false]) {
        _Probe.builds.clear();
        _setView(tester, 800);
        await tester.pumpWidget(
          scoped ? const RebicScreenSizeScope(child: _Probe()) : const _Probe(),
        );
        _setView(tester, 1200);
        await tester.pump();
        expect(_Probe.builds, [
          RebicSizeClass.medium,
          RebicSizeClass.large,
        ], reason: scoped ? 'com escopo' : 'sem escopo');
      }
    });

    testWidgets('Classe de tamanho da tela — Mudança que não troca a classe', (
      tester,
    ) async {
      addTearDown(tester.view.reset);
      _setView(tester, 800, 600);
      await tester.pumpWidget(const RebicScreenSizeScope(child: _Probe()));
      _setView(tester, 900, 600);
      await tester.pump();
      _setView(tester, 900, 400);
      await tester.pump();
      expect(_Probe.builds, [RebicSizeClass.medium]);
    });

    testWidgets('Classe de tamanho da tela — Limiares recebidos', (
      tester,
    ) async {
      addTearDown(tester.view.reset);
      _setView(tester, 500);
      const custom = RebicBreakpointTokens(
        medium: 480,
        large: 960,
        extraLarge: 1280,
      );
      late RebicSizeClass scoped;
      late RebicSizeClass unscoped;
      await tester.pumpWidget(
        RebicScreenSizeScope(
          breakpoints: custom,
          child: Builder(
            builder: (context) {
              scoped = RebicResponsive.screenSizeClassOf(
                context,
                breakpoints: custom,
              );
              unscoped = RebicResponsive.screenSizeClassOf(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(scoped, RebicSizeClass.medium);
      // Limiares diferentes dos do escopo: classifica direto pela janela.
      expect(unscoped, RebicSizeClass.small);
    });
  });

  group('Classe de tamanho do contêiner', () {
    testWidgets('Classe de tamanho do contêiner — Contêiner menor que a tela', (
      tester,
    ) async {
      addTearDown(tester.view.reset);
      _setView(tester, 1500);
      late RebicSizeClass panel;
      late RebicSizeClass screen;
      await tester.pumpWidget(
        _ltr(
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 500,
              child: RebicResponsiveBuilder(
                builder: (context, sizeClass) {
                  panel = sizeClass;
                  screen = RebicResponsive.screenSizeClassOf(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      expect(panel, RebicSizeClass.small);
      expect(screen, RebicSizeClass.extraLarge);
    });

    testWidgets('Classe de tamanho do contêiner — Largura sem limite', (
      tester,
    ) async {
      late RebicSizeClass sizeClass;
      await tester.pumpWidget(
        _ltr(
          ListView(
            scrollDirection: Axis.horizontal,
            children: [
              RebicResponsiveBuilder(
                builder: (context, value) {
                  sizeClass = value;
                  return const SizedBox(width: 10);
                },
              ),
            ],
          ),
        ),
      );
      expect(sizeClass, RebicSizeClass.extraLarge);
    });
  });

  group('Valores por classe de tamanho', () {
    test('Valores por classe de tamanho — Herança da classe menor', () {
      const value = RebicResponsiveValue(small: 12, large: 4);
      expect(RebicSizeClass.values.map(value.resolve), [12, 12, 4, 4]);
    });

    testWidgets(
      'Valores por classe de tamanho — Resolução pela tela e pelo contêiner',
      (tester) async {
        addTearDown(tester.view.reset);
        _setView(tester, 800);
        const value = RebicResponsiveValue(small: 1, medium: 2);
        late int byScreen;
        late int byPanel;
        await tester.pumpWidget(
          RebicScreenSizeScope(
            child: _ltr(
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 500,
                  child: RebicResponsiveBuilder(
                    builder: (context, sizeClass) {
                      byScreen = value.resolve(
                        RebicResponsive.screenSizeClassOf(context),
                      );
                      byPanel = value.resolve(sizeClass);
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ),
          ),
        );
        expect(byScreen, 2);
        expect(byPanel, 1);
      },
    );

    test('igualdade por valor', () {
      // Instâncias não canônicas, para testar a igualdade por valor.
      // ignore: prefer_const_constructors
      final a = RebicResponsiveValue(small: 1, large: 3);
      // ignore: prefer_const_constructors
      final b = RebicResponsiveValue(small: 1, large: 3);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(const RebicResponsiveValue(small: 1, medium: 3)));
    });
  });

  test('Densidade recomendada — Plataformas', () {
    final expected = {
      TargetPlatform.windows: RebicDensity.compact,
      TargetPlatform.macOS: RebicDensity.compact,
      TargetPlatform.linux: RebicDensity.compact,
      TargetPlatform.android: RebicDensity.cozy,
      TargetPlatform.iOS: RebicDensity.cozy,
      TargetPlatform.fuchsia: RebicDensity.cozy,
    };
    expect(expected.keys, unorderedEquals(TargetPlatform.values));
    for (final MapEntry(key: platform, value: density) in expected.entries) {
      expect(
        RebicResponsive.recommendedDensity(platform),
        density,
        reason: '$platform',
      );
    }
  });
}
