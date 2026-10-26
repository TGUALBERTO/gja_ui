import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Testes e documentação das cores — Galeria sem cor fixa', () {
    final source = File('lib/main.dart').readAsStringSync();
    expect(source, isNot(contains('Color(0x')));
    expect(source, contains('color: _colors.brand'));
    expect(source, contains('RebicColorTokens.light()'));
  });
}
