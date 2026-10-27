import 'package:flutter/services.dart';

/// Arquivos da Inter empacotada em `rebic_foundation`, como os testes os veem.
const _interAssets = [
  'packages/rebic_foundation/fonts/inter/Inter-Regular.ttf',
  'packages/rebic_foundation/fonts/inter/Inter-Medium.ttf',
  'packages/rebic_foundation/fonts/inter/Inter-SemiBold.ttf',
  'packages/rebic_foundation/fonts/inter/Inter-Bold.ttf',
];

/// Fonte de ícones Lucide empacotada em `rebic_foundation`.
const _lucideAsset = 'packages/rebic_foundation/fonts/lucide/lucide.ttf';

bool _loaded = false;

/// Registra a Inter e a Lucide no motor de testes, que por padrão só usa a
/// fonte Ahem.
///
/// Necessário para goldens e para medidas reais de texto. Os nomes de família
/// são os mesmos que a tipografia e os ícones do Rebic usam.
Future<void> loadRebicFonts() async {
  if (_loaded) return;
  final loader = FontLoader('packages/rebic_foundation/Inter');
  for (final asset in _interAssets) {
    loader.addFont(rootBundle.load(asset));
  }
  await loader.load();
  final icons = FontLoader('packages/rebic_foundation/Lucide')
    ..addFont(rootBundle.load(_lucideAsset));
  await icons.load();
  _loaded = true;
}
