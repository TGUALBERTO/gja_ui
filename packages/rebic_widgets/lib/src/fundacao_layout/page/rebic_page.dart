import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../acoes_navegacao/icon_button/rebic_icon_button.dart';
import '../column/rebic_column.dart';
import '../container/rebic_container.dart';
import '../divider/rebic_divider.dart';
import '../flex/rebic_flex_alignment.dart';
import '../row/rebic_row.dart';
import '../spacing/rebic_spacing.dart';
import '../text/rebic_text.dart';

/// Página de conteúdo, como o `sap.m.Page` e o `sap.f.DynamicPage` do
/// SAPUI5: área de título, conteúdo e rodapé fixo de ações.
///
/// A área de título mostra o botão de voltar (quando há [onBack]), o [title]
/// (anunciado como cabeçalho), o [subtitle] e as [actions]. O [body] rola
/// verticalmente entre o título e o rodapé ou, com [scrollable] `false`,
/// recebe a altura disponível para uma rolagem própria. O rodapé, com as
/// [footerActions] alinhadas ao fim, só aparece quando há ações.
///
/// Precisa de altura limitada: use-a como corpo do `RebicScaffold` ou como
/// página de uma rota.
///
/// ```dart
/// RebicPage(
///   title: 'Pedido 4711',
///   subtitle: 'Aguardando aprovação',
///   onBack: () => Navigator.of(context).maybePop(),
///   actions: [EditarAction()],
///   footerActions: [CancelarAction(), SalvarAction()],
///   body: const DetalhesDoPedido(),
/// )
/// ```
class RebicPage extends StatelessWidget {
  /// Cria a página com [title] e [body].
  const RebicPage({
    required this.title,
    required this.body,
    this.subtitle,
    this.onBack,
    this.actions = const [],
    this.padded = true,
    this.scrollable = true,
    this.footerActions = const [],
    super.key,
  });

  /// Título da página, anunciado como cabeçalho.
  final String title;

  /// Conteúdo da página.
  final Widget body;

  /// Texto secundário abaixo do título.
  final String? subtitle;

  /// Chamado pelo botão de voltar; nulo oculta o botão.
  final VoidCallback? onBack;

  /// Ações da página, no fim da área de título.
  final List<Widget> actions;

  /// Se o conteúdo tem a margem `spacing.pageMargin`.
  final bool padded;

  /// Se o conteúdo rola; `false` lhe dá a altura disponível.
  final bool scrollable;

  /// Ações finais, no rodapé fixo, alinhadas ao fim.
  final List<Widget> footerActions;

  @override
  Widget build(BuildContext context) {
    final onBack = this.onBack;
    final subtitle = this.subtitle;
    final titleArea = RebicContainer(
      surface: RebicSurface.base,
      child: RebicSpacing.padding(
        horizontal: RebicSpace.pageMargin,
        vertical: RebicSpace.m,
        child: RebicRow(
          gap: RebicSpace.s,
          children: [
            if (onBack != null)
              RebicIconButton(
                icon: RebicIcons.arrowLeft,
                tooltip: RebicLocalizations.of(context).back,
                onPressed: onBack,
              ),
            Expanded(
              child: RebicColumn(
                gap: RebicSpace.xxs,
                shrinkWrap: true,
                children: [
                  RebicText(
                    title,
                    variant: RebicTextVariant.headline,
                    maxLines: 2,
                  ),
                  if (subtitle != null)
                    RebicText(subtitle, tone: RebicTextTone.muted, maxLines: 1),
                ],
              ),
            ),
            ...actions,
          ],
        ),
      ),
    );

    Widget content = body;
    if (scrollable) {
      if (padded) {
        content = RebicSpacing.padding(
          all: RebicSpace.pageMargin,
          child: content,
        );
      }
      content = SingleChildScrollView(child: content);
    } else if (padded) {
      content = RebicSpacing.padding(
        all: RebicSpace.pageMargin,
        child: content,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        assert(
          constraints.hasBoundedHeight,
          'RebicPage precisa de altura limitada: use-a como corpo do '
          'RebicScaffold ou como página de uma rota, não dentro de uma rolagem',
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            titleArea,
            const RebicDivider(),
            Expanded(child: content),
            if (footerActions.isNotEmpty) ...[
              const RebicDivider(),
              RebicContainer(
                surface: RebicSurface.base,
                child: RebicSpacing.padding(
                  horizontal: RebicSpace.pageMargin,
                  vertical: RebicSpace.s,
                  child: RebicRow(
                    gap: RebicSpace.s,
                    mainAlignment: RebicMainAlignment.end,
                    children: footerActions,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
