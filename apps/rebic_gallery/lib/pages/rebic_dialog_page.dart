import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicDialog": um diálogo de confirmação que mostra o resultado e
/// um diálogo de erro.
class RebicDialogPage extends StatefulWidget {
  /// Cria a página.
  const RebicDialogPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicDialog';

  /// Rota nomeada.
  static const route = '/rebic-dialog';

  /// Texto do botão que abre a confirmação.
  static const delete = 'Excluir pedido';

  /// Texto mostrado depois de confirmar.
  static const deleted = 'Pedido excluído';

  @override
  State<RebicDialogPage> createState() => _RebicDialogPageState();
}

class _RebicDialogPageState extends State<RebicDialogPage> {
  String? _result;

  Future<void> _confirm() async {
    final confirmed = await RebicDialog.open<bool>(
      context,
      builder: (context) => RebicDialog(
        title: 'Excluir o pedido 4711?',
        state: RebicValueState.warning,
        content: const RebicText(
          'O pedido e os itens dele serão excluídos. Não é possível desfazer.',
        ),
        beginButton: RebicButton(
          text: 'Excluir',
          type: RebicButtonType.emphasized,
          onPress: () => Navigator.of(context).pop(true),
        ),
        endButton: RebicButton(
          text: 'Cancelar',
          onPress: () => Navigator.of(context).pop(false),
        ),
      ),
    );
    if (!mounted) return;
    setState(
      () => _result = confirmed == true ? RebicDialogPage.deleted : 'Cancelado',
    );
  }

  Future<void> _error() => RebicDialog.open<void>(
    context,
    builder: (context) => RebicDialog(
      title: 'Falha ao salvar',
      state: RebicValueState.error,
      content: const RebicText('O servidor não respondeu. Tente de novo.'),
      endButton: RebicButton(
        text: 'Fechar',
        onPress: () => Navigator.of(context).pop(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return RebicPage(
      title: RebicDialogPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Diálogos modais no modelo do sap.m.Dialog'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicHBox(
          items: [
            RebicButton(text: RebicDialogPage.delete, onPress: _confirm),
            RebicButton(text: 'Mostrar erro', onPress: _error),
          ],
        ),
        if (result != null) ...[
          const RebicSpacing.vertical(RebicSpace.l),
          RebicText(result),
        ],
      ],
    );
  }
}
