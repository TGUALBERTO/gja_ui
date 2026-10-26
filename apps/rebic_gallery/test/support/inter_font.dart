import 'package:flutter/services.dart';

/// Arquivos da Inter empacotada em `rebic_foundation`, como a aplicação os vê.
const interAssets = [
  'packages/rebic_foundation/fonts/inter/Inter-Regular.ttf',
  'packages/rebic_foundation/fonts/inter/Inter-Medium.ttf',
  'packages/rebic_foundation/fonts/inter/Inter-SemiBold.ttf',
  'packages/rebic_foundation/fonts/inter/Inter-Bold.ttf',
];

/// Registra a Inter no motor de testes, que por padrão só usa a fonte Ahem.
Future<void> loadInterFont() async {
  final loader = FontLoader('packages/rebic_foundation/Inter');
  for (final asset in interAssets) {
    loader.addFont(rootBundle.load(asset));
  }
  await loader.load();
}
