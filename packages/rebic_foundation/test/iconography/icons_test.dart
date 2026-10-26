import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_foundation/rebic_primitives.dart';

/// Mapa oficial empacotado (nome Lucide → código).
Map<String, int> _codepoints() =>
    (jsonDecode(File('fonts/lucide/codepoints.json').readAsStringSync())
            as Map<String, dynamic>)
        .cast<String, int>();

const _minimum = [
  'add', 'close', 'search', 'check', 'chevronUp', 'chevronDown', //
  'chevronLeft', 'chevronRight', 'arrowLeft', 'arrowRight', 'menu',
  'moreHorizontal', 'moreVertical', 'edit', 'delete', 'info', 'warning',
  'error', 'success', 'help', 'calendar', 'clock', 'user', 'filter', 'sort',
  'upload', 'download', 'refresh', 'settings', 'home', 'externalLink',
  'visibility', 'visibilityOff', 'copy', 'logout', 'notification', 'file',
  'folder',
];

const _directional = {
  'chevronLeft',
  'chevronRight',
  'arrowLeft',
  'arrowRight',
  'logout',
  'externalLink',
};

/// Se o `Icon` inseriu o espelhamento horizontal (`Transform` com escala -1).
bool _isMirrored(WidgetTester tester) {
  final transforms = tester.widgetList<Transform>(
    find.descendant(of: find.byType(Icon), matching: find.byType(Transform)),
  );
  return transforms.any((t) => t.transform.storage[0] == -1);
}

void main() {
  group('Catálogo semântico de ícones', () {
    test(
      'Catálogo semântico de ícones — Códigos conferem com o mapa oficial',
      () {
        final codepoints = _codepoints();
        expect(RebicIcons.lucideNames.keys, RebicIcons.all.keys);
        for (final MapEntry(key: name, value: icon) in RebicIcons.all.entries) {
          final lucide = RebicIcons.lucideNames[name]!;
          expect(codepoints, contains(lucide), reason: name);
          expect(icon.codePoint, codepoints[lucide], reason: '$name → $lucide');
          expect(icon.fontFamily, 'Lucide', reason: name);
          expect(icon.fontPackage, 'rebic_foundation', reason: name);
        }
      },
    );

    test(
      'Catálogo semântico de ícones — Catálogo completo e sem repetição',
      () {
        expect(RebicIcons.all.keys, containsAll(_minimum));
        final codes = RebicIcons.all.values.map((i) => i.codePoint).toList();
        expect(codes.toSet(), hasLength(codes.length));
      },
    );
  });

  testWidgets('Espelhamento de ícones direcionais — Ícone direcional em RTL', (
    tester,
  ) async {
    for (final MapEntry(key: name, value: icon) in RebicIcons.all.entries) {
      expect(
        icon.matchTextDirection,
        _directional.contains(name),
        reason: name,
      );
    }
    for (final (icon, mirrored) in [
      (RebicIcons.chevronRight, true),
      (RebicIcons.check, false),
    ]) {
      await tester.pumpWidget(
        Directionality(textDirection: TextDirection.rtl, child: Icon(icon)),
      );
      expect(_isMirrored(tester), mirrored, reason: '${icon.codePoint}');
    }
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Icon(RebicIcons.chevronRight),
      ),
    );
    expect(_isMirrored(tester), isFalse);
  });

  test('Uso de ícones fora do catálogo — Ícone extra da aplicação', () {
    final anchorCode = _codepoints()['anchor']!;
    final anchor = IconData(
      anchorCode,
      fontFamily: RebicIconPrimitives.fontFamily,
      fontPackage: RebicIconPrimitives.fontPackage,
    );
    expect(anchor.fontFamily, RebicIcons.add.fontFamily);
    expect(anchor.fontPackage, RebicIcons.add.fontPackage);
    expect(
      RebicIcons.all.values.map((i) => i.codePoint),
      isNot(contains(anchorCode)),
    );
  });

  test('Escala primitiva de tamanhos de ícone — Escala em ordem', () {
    final entries = RebicIconPrimitives.sizes.entries.toList();
    for (final (i, MapEntry(key: name, value: value)) in entries.indexed) {
      expect(double.parse(name.substring('size'.length)), value, reason: name);
      if (i > 0) expect(value, greaterThan(entries[i - 1].value), reason: name);
    }
    expect(
      RebicIconPrimitives.sizes.values,
      containsAll(<double>[12, 16, 20, 24, 32, 40, 48]),
    );
  });
}
