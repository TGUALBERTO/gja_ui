import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

const _pt = RebicLocalizationsPtBr();
const _en = RebicLocalizationsEn();

/// Troca espaços especiais do CLDR (ex.: U+202F antes de "PM") por espaço.
String _normalize(String s) => s.replaceAll(RegExp(r'[  ]'), ' ');

class _Es extends RebicLocalizations {
  const _Es() : super(const Locale('es'));

  @override
  String get ok => 'Aceptar';
  @override
  String get cancel => 'Cancelar';
  @override
  String get close => 'Cerrar';
  @override
  String get search => 'Buscar';
  @override
  String get clear => 'Borrar';
  @override
  String get noData => 'Sin datos';
  @override
  String get loading => 'Cargando';
  @override
  String get more => 'Más';
  @override
  String get required => 'Obligatorio';
  @override
  String get navigation => 'Navegación';
  @override
  String valueState(RebicValueState state) => state.name;
  @override
  String selectedItems(int count) => '$count';
}

class _EsDelegate extends LocalizationsDelegate<RebicLocalizations> {
  const _EsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'es';

  @override
  Future<RebicLocalizations> load(Locale locale) =>
      SynchronousFuture(const _Es());

  @override
  bool shouldReload(_EsDelegate old) => false;
}

/// Monta um `WidgetsApp` com [locale] e guarda os textos lidos.
Future<RebicLocalizations> _pumpApp(
  WidgetTester tester, {
  Locale? locale,
  List<LocalizationsDelegate<dynamic>> delegates = const [
    RebicLocalizations.delegate,
  ],
  List<Locale> supportedLocales = RebicLocalizations.supportedLocales,
}) async {
  late RebicLocalizations read;
  if (locale != null) {
    tester.platformDispatcher.localesTestValue = [locale];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  }
  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFF000000),
      localizationsDelegates: delegates,
      supportedLocales: supportedLocales,
      builder: (context, _) {
        read = RebicLocalizations.of(context);
        return const SizedBox();
      },
    ),
  );
  return read;
}

void main() {
  group('Textos do framework', () {
    test('Textos do framework — Textos em pt-BR', () {
      expect(_pt.cancel, 'Cancelar');
      expect(_pt.noData, 'Sem dados');
      expect(_pt.valueState(RebicValueState.error), 'Valor inválido');
    });

    test('Textos do framework — Textos em en', () {
      expect(_en.cancel, 'Cancel');
      expect(_en.noData, 'No data');
      expect(_en.valueState(RebicValueState.error), 'Invalid value');
    });

    test('Textos do framework — Contagem de selecionados', () {
      expect([0, 1, 1000].map(_pt.selectedItems), [
        'Nenhum item selecionado',
        '1 item selecionado',
        '1.000 itens selecionados',
      ]);
      expect([0, 1, 1000].map(_en.selectedItems), [
        'No items selected',
        '1 item selected',
        '1,000 items selected',
      ]);
    });

    test('Textos do framework — Estado sem texto', () {
      for (final l in const <RebicLocalizations>[_pt, _en]) {
        for (final state in RebicValueState.values) {
          expect(
            l.valueState(state).isEmpty,
            state == RebicValueState.none,
            reason: '${l.locale}/${state.name}',
          );
        }
      }
    });

    test('Textos do framework — Texto da navegação', () {
      expect(_pt.navigation, 'Navegação');
      expect(_en.navigation, 'Navigation');
    });

    test('todos os textos simples existem nos dois idiomas', () {
      for (final l in const <RebicLocalizations>[_pt, _en]) {
        final texts = [
          l.ok,
          l.cancel,
          l.close,
          l.search,
          l.clear,
          l.noData,
          l.loading,
          l.more,
          l.required,
          l.navigation,
        ];
        expect(texts.every((t) => t.isNotEmpty), isTrue, reason: '${l.locale}');
      }
    });
  });

  testWidgets('Idiomas e resolução — Região sem tradução própria', (
    tester,
  ) async {
    for (final (device, expected) in [
      (const Locale('pt', 'PT'), RebicLocalizations.defaultLocale),
      (const Locale('en', 'GB'), const Locale('en')),
      (const Locale('fr', 'FR'), RebicLocalizations.defaultLocale),
    ]) {
      final l = await _pumpApp(tester, locale: device);
      expect(l.locale, expected, reason: '$device');
    }
  });

  testWidgets('Acesso sem delegate — Árvore sem o delegate', (tester) async {
    final l = await _pumpApp(
      tester,
      delegates: const [],
      supportedLocales: const [Locale('en', 'US')],
    );
    expect(l.cancel, 'Cancelar');
    expect(l.formatDecimal(1.5), '1,50');
  });

  testWidgets('Extensão por idioma da aplicação — Idioma da aplicação', (
    tester,
  ) async {
    final l = await _pumpApp(
      tester,
      locale: const Locale('es', 'ES'),
      delegates: const [_EsDelegate(), RebicLocalizations.delegate],
      supportedLocales: const [
        ...RebicLocalizations.supportedLocales,
        Locale('es'),
      ],
    );
    expect(l, isA<_Es>());
    expect(l.cancel, 'Cancelar');
    expect(l.formatDecimal(1234.5, decimals: 1), contains(',5'));
  });

  group('Formatação de números e datas', () {
    test('Formatação de números e datas — Números', () {
      expect(_pt.formatDecimal(1234567.891), '1.234.567,89');
      expect(_pt.formatInteger(1234567), '1.234.567');
      expect(_en.formatDecimal(1234567.891), '1,234,567.89');
      expect(_en.formatInteger(1234567), '1,234,567');
    });

    test('Formatação de números e datas — Datas e horas', () {
      final when = DateTime(2026, 3, 5, 14, 30);
      expect(_pt.formatDate(when), '05/03/2026');
      expect(_pt.formatTime(when), '14:30');
      expect(_en.formatDate(when), '3/5/2026');
      expect(_normalize(_en.formatTime(when)), '2:30 PM');
      expect(_normalize(_pt.formatDateTime(when)), '05/03/2026 14:30');
    });
  });
}
