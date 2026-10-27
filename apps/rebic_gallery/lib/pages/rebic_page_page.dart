import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicPage": construída com `RebicPage`, com voltar, subtítulo,
/// uma ação, conteúdo rolável e rodapé de ações.
class RebicPagePage extends StatelessWidget {
  /// Cria a página.
  const RebicPagePage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicPage';

  /// Rota nomeada.
  static const route = '/rebic-page';

  @override
  Widget build(BuildContext context) {
    void back() => Navigator.of(context).maybePop();
    return RebicPage(
      title: title,
      subtitle: 'Área de título, conteúdo e rodapé de ações',
      onBack: back,
      actions: const [
        RebicIcon(
          RebicIcons.help,
          tone: RebicIconTone.brand,
          semanticLabel: 'Ajuda',
        ),
      ],
      footerActions: [
        GestureDetector(
          onTap: back,
          child: Semantics(
            button: true,
            child: const RebicText('Cancelar', tone: RebicTextTone.muted),
          ),
        ),
        GestureDetector(
          onTap: back,
          child: Semantics(button: true, child: const RebicText('Salvar')),
        ),
      ],
      body: const RebicColumn(
        gap: RebicSpace.l,
        children: [
          RebicText('Quando usar', variant: RebicTextVariant.title),
          RebicText(
            'Use RebicPage como corpo do RebicScaffold ou como página de uma '
            'rota. O botão de voltar aparece quando há onBack, e o rodapé, '
            'quando há ações finais.',
          ),
          RebicText('Rolagem', variant: RebicTextVariant.title),
          RebicText(
            'O conteúdo rola entre a área de título e o rodapé, que ficam '
            'fixos. Para listas e tabelas com rolagem própria, use '
            'scrollable: false.',
          ),
        ],
      ),
    );
  }
}
