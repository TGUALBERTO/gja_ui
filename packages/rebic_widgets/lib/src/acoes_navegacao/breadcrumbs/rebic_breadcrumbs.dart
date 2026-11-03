import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../link/rebic_link.dart';

/// Separador de uma [RebicBreadcrumbs], como o `BreadcrumbsSeparatorStyle`.
enum RebicBreadcrumbsSeparator {
  /// `/`
  slash('/'),

  /// `\`
  backSlash(r'\'),

  /// `//`
  doubleSlash('//'),

  /// `\\`
  doubleBackSlash(r'\\'),

  /// `>`
  greaterThan('>'),

  /// `>>`
  doubleGreaterThan('>>');

  const RebicBreadcrumbsSeparator(this.symbol);

  /// Caractere mostrado entre os níveis.
  final String symbol;
}

/// Caminho até a página atual, como o `sap.m.Breadcrumbs` do SAPUI5.
///
/// Mostra os níveis anteriores ([links]) separados pelo [separatorStyle] e,
/// no fim, o nome da página atual ([currentLocationText]) como texto. Os
/// itens quebram em várias linhas quando falta largura; os separadores ficam
/// fora da semântica.
///
/// ```dart
/// RebicBreadcrumbs(
///   links: [
///     RebicLink(text: 'Início', onPress: irParaInicio),
///     RebicLink(text: 'Pedidos', onPress: irParaPedidos),
///   ],
///   currentLocationText: 'Pedido 4711',
/// )
/// ```
class RebicBreadcrumbs extends StatelessWidget {
  /// Cria a trilha.
  const RebicBreadcrumbs({
    required this.links,
    this.currentLocationText,
    this.separatorStyle = RebicBreadcrumbsSeparator.slash,
    this.semanticLabel,
    super.key,
  });

  /// Níveis anteriores, do mais alto ao mais próximo.
  final List<RebicLink> links;

  /// Nome da página atual, mostrado como texto no fim.
  final String? currentLocationText;

  /// Caractere entre os níveis.
  final RebicBreadcrumbsSeparator separatorStyle;

  /// Nome da trilha para o leitor de tela.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    assert(
      links.isNotEmpty || (currentLocationText ?? '') != '',
      'RebicBreadcrumbs precisa de links ou currentLocationText',
    );
    final theme = RebicThemeData.of(context);
    final current = currentLocationText;
    final separator = ExcludeSemantics(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
        child: Text(
          separatorStyle.symbol,
          style: theme.typography.base.copyWith(color: theme.colors.label),
        ),
      ),
    );
    return Semantics(
      container: true,
      label: semanticLabel,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final (i, link) in links.indexed)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                link,
                if (i < links.length - 1 || current != null) separator,
              ],
            ),
          if (current != null)
            Text(
              current,
              style: theme.typography.base.copyWith(color: theme.colors.text),
            ),
        ],
      ),
    );
  }
}
