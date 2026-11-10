import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicIcon": tamanhos, tons, um ícone com rótulo e um direcional em
/// LTR e RTL.
///
/// O catálogo completo de ícones fica na página "Ícones" (fundamento); esta
/// página mostra o widget.
class RebicIconPage extends StatelessWidget {
  /// Cria a página.
  const RebicIconPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicIcon';

  /// Rota nomeada.
  static const route = '/rebic-icon';

  /// Chave do direcional em LTR.
  static const ltrKey = Key('rebic-icon-ltr');

  /// Chave do direcional em RTL.
  static const rtlKey = Key('rebic-icon-rtl');

  @override
  Widget build(BuildContext context) {
    final spacing = RebicTheme.of(context).spacing;

    Widget labeled(Widget icon, String label) => Padding(
      padding: EdgeInsets.only(right: spacing.l, bottom: spacing.s),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(height: spacing.xs),
          RebicLabel(label),
        ],
      ),
    );

    return ListView(
      padding: EdgeInsets.all(spacing.pageMargin),
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Semantics(button: true, child: const RebicText('← Voltar')),
        ),
        SizedBox(height: spacing.stackGap),
        const RebicTitle(
          title,
          level: RebicTitleLevel.h1,
          titleStyle: RebicTitleLevel.h2,
        ),
        SizedBox(height: spacing.sectionGap),
        const RebicTitle(
          'Tamanhos',
          level: RebicTitleLevel.h2,
          titleStyle: RebicTitleLevel.h3,
        ),
        SizedBox(height: spacing.s),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            for (final size in RebicIconSize.values)
              labeled(RebicIcon(RebicIcons.search, size: size), size.name),
          ],
        ),
        SizedBox(height: spacing.sectionGap),
        const RebicTitle(
          'Tons',
          level: RebicTitleLevel.h2,
          titleStyle: RebicTitleLevel.h3,
        ),
        SizedBox(height: spacing.s),
        Wrap(
          children: [
            for (final tone in RebicIconTone.values)
              labeled(
                RebicIcon(
                  RebicIcons.information,
                  size: RebicIconSize.large,
                  tone: tone,
                ),
                tone.name,
              ),
          ],
        ),
        SizedBox(height: spacing.sectionGap),
        const RebicTitle(
          'Com rótulo',
          level: RebicTitleLevel.h2,
          titleStyle: RebicTitleLevel.h3,
        ),
        SizedBox(height: spacing.s),
        Row(
          children: [
            const RebicIcon(
              RebicIcons.warning,
              tone: RebicIconTone.warning,
              semanticLabel: 'Aviso',
            ),
            SizedBox(width: spacing.s),
            const RebicText('O leitor de tela anuncia "Aviso".'),
          ],
        ),
        SizedBox(height: spacing.sectionGap),
        const RebicTitle(
          'Direcional em LTR e RTL',
          level: RebicTitleLevel.h2,
          titleStyle: RebicTitleLevel.h3,
        ),
        SizedBox(height: spacing.s),
        Row(
          children: [
            labeled(
              const RebicIcon(
                RebicIcons.slimArrowRight,
                key: ltrKey,
                size: RebicIconSize.large,
              ),
              'LTR',
            ),
            labeled(
              const Directionality(
                textDirection: TextDirection.rtl,
                child: RebicIcon(
                  RebicIcons.slimArrowRight,
                  key: rtlKey,
                  size: RebicIconSize.large,
                ),
              ),
              'RTL',
            ),
          ],
        ),
      ],
    );
  }
}
