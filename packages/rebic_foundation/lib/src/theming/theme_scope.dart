import 'package:flutter/widgets.dart';

import 'theme_data.dart';

/// Publica um [RebicThemeData] para a subárvore.
///
/// Nível: semântico.
///
/// Escopo de baixo nível, lido por [RebicThemeData.of]. Aplicações usam o
/// widget `RebicTheme` de `rebic_widgets`, que também anima a troca de tema,
/// troca a densidade por subárvore e define o texto e o ícone padrão.
class RebicThemeScope extends InheritedWidget {
  /// Publica [data] para [child].
  const RebicThemeScope({required this.data, required super.child, super.key});

  /// Tema publicado.
  final RebicThemeData data;

  @override
  bool updateShouldNotify(RebicThemeScope oldWidget) => data != oldWidget.data;
}
