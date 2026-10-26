// Usa somente as bibliotecas públicas, como faria uma aplicação.
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_foundation/rebic_primitives.dart';

void main() {
  test(
    'Primitivos isolados da camada de widgets — Aplicação personaliza a marca',
    () {
      const brand = RebicMotionTokens(
        instant: RebicMotionPrimitives.duration0,
        short: RebicMotionPrimitives.duration150,
        medium: RebicMotionPrimitives.duration250,
        long: RebicMotionPrimitives.duration400,
        standard: RebicMotionPrimitives.curveStandard,
        enter: RebicMotionPrimitives.curveDecelerate,
        exit: RebicMotionPrimitives.curveAccelerate,
      );
      expect(brand.medium, RebicMotionPrimitives.duration250);
      expect(brand, isNot(const RebicMotionTokens.fallback()));
    },
  );
}
