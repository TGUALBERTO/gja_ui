import 'package:flutter/services.dart';

/// Arquivos da Inter empacotada em `rebic_foundation`, como os testes os veem.
const _interAssets = [
  'packages/rebic_foundation/fonts/inter/Inter-Regular.ttf',
  'packages/rebic_foundation/fonts/inter/Inter-Medium.ttf',
  'packages/rebic_foundation/fonts/inter/Inter-SemiBold.ttf',
  'packages/rebic_foundation/fonts/inter/Inter-Bold.ttf',
];

bool _loaded = false;

/// Registra a Inter no motor de testes, que por padrão só usa a fonte Ahem.
///
/// Necessário para goldens e para medidas reais de texto. O nome de família
/// é o mesmo que a tipografia do Rebic usa.
Future<void> loadRebicFonts() async {
  if (_loaded) return;
  final loader = FontLoader('packages/rebic_foundation/Inter');
  for (final asset in _interAssets) {
    loader.addFont(rootBundle.load(asset));
  }
  await loader.load();
  _loaded = true;
}
