import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

void main() {
  test('Contraste de texto nos estados — Texto de todos os estados', () {
    for (final colors in const [
      RebicColorTokens.light(),
      RebicColorTokens.dark(),
    ]) {
      expect(rebicCheckStateContrast(colors), isEmpty);
    }
  });

  test('a verificação de estados detecta uma marca sem contraste', () {
    const light = RebicColorTokens.light();
    final broken = light.copyWith(contrastText: light.brand);
    final issues = rebicCheckStateContrast(broken);
    expect(issues.map((i) => i.foreground), contains('emphasized.normal.text'));
  });
}
