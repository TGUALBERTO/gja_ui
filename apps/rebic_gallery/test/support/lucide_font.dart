import 'package:flutter/services.dart';

/// Fonte de ícones Lucide empacotada em `rebic_foundation`, como a aplicação a vê.
const lucideAsset = 'packages/rebic_foundation/fonts/lucide/lucide.ttf';

/// Registra a Lucide no motor de testes.
Future<void> loadLucideFont() async {
  final loader = FontLoader('packages/rebic_foundation/Lucide')
    ..addFont(rootBundle.load(lucideAsset));
  await loader.load();
}
