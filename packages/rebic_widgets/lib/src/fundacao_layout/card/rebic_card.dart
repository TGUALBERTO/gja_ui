import 'package:flutter/widgets.dart';

import '../card_header/rebic_card_header.dart';
import '../container/rebic_container.dart';
import '../separator/rebic_separator.dart';
import '../title/rebic_title.dart';

/// Posição do cabeçalho de um [RebicCard], como o
/// `sap.f.cards.HeaderPosition` do SAPUI5.
enum RebicCardHeaderPosition {
  /// Cabeçalho acima do conteúdo.
  top,

  /// Cabeçalho abaixo do conteúdo.
  bottom,
}

/// Cartão, como o `sap.f.Card` do SAPUI5.
///
/// Uma superfície `base` com borda, raio `tile` e sombra `card`, na largura
/// disponível. O [header], em geral um `RebicCardHeader`, fica acima do
/// [content] ou, com [headerPosition] `bottom`, abaixo dele, separado por uma
/// linha. O conteúdo não tem margem própria. O título do cabeçalho é
/// anunciado com o [headingLevel].
///
/// ```dart
/// RebicCard(
///   header: RebicCardHeader(
///     iconInitials: 'MB',
///     title: 'Pedidos pendentes',
///     subtitle: 'Compras',
///     statusText: '3 de 5',
///     onPress: abrirPedidos,
///   ),
///   content: const RebicSpacing.padding(
///     all: RebicSpace.l,
///     child: ListaDePedidos(),
///   ),
/// )
/// ```
class RebicCard extends StatelessWidget {
  /// Cria o cartão.
  const RebicCard({
    this.header,
    this.headerPosition = RebicCardHeaderPosition.top,
    this.content,
    this.headingLevel = RebicTitleLevel.h3,
    super.key,
  });

  /// Cabeçalho do cartão, em geral um `RebicCardHeader`.
  final Widget? header;

  /// Posição do cabeçalho.
  final RebicCardHeaderPosition headerPosition;

  /// Conteúdo do cartão, sem margem própria.
  final Widget? content;

  /// Nível do título do cabeçalho para leitores de tela.
  final RebicTitleLevel headingLevel;

  @override
  Widget build(BuildContext context) {
    final header = this.header;
    final content = this.content;
    final scoped = header == null
        ? null
        : RebicCardHeadingScope(level: headingLevel, child: header);
    final line = scoped != null && content != null
        ? const RebicSeparator()
        : null;
    // A linha fica sempre entre o cabeçalho e o conteúdo.
    final children = [?scoped, ?line, ?content];
    return RebicContainer(
      surface: RebicSurface.base,
      border: true,
      radius: RebicRadius.tile,
      shadow: RebicShadow.card,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: headerPosition == RebicCardHeaderPosition.top
            ? children
            : children.reversed.toList(),
      ),
    );
  }
}
