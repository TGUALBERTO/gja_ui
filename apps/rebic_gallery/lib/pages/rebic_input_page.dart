import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicInput": um campo com saudação, campos de cada tipo, um com
/// limite, um com ícone de limpar, um com validação e campos somente leitura
/// e desabilitado.
class RebicInputPage extends StatefulWidget {
  /// Cria a página.
  const RebicInputPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicInput';

  /// Rota nomeada.
  static const route = '/rebic-input';

  /// Rótulo do campo de nome.
  static const nameLabel = 'Nome';

  @override
  State<RebicInputPage> createState() => _RebicInputPageState();
}

class _RebicInputPageState extends State<RebicInputPage> {
  String _name = '';
  String _search = 'Pedidos de outubro';
  String _code = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    final emailState = _email.isEmpty || _email.contains('@')
        ? RebicValueState.none
        : RebicValueState.error;
    Widget field(String label, Widget input) => RebicVBox(
      gap: RebicSpace.xxs,
      alignItems: RebicFlexAlignItems.stretch,
      items: [RebicLabel(label), input],
    );

    return RebicPage(
      title: RebicInputPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Campos de texto no modelo do sap.m.Input'),
        const RebicSpacing.vertical(RebicSpace.l),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: RebicVBox(
              gap: RebicSpace.m,
              alignItems: RebicFlexAlignItems.stretch,
              items: [
                field(
                  RebicInputPage.nameLabel,
                  RebicInput(
                    semanticLabel: RebicInputPage.nameLabel,
                    placeholder: 'Nome completo',
                    value: _name,
                    onLiveChange: (value) => setState(() => _name = value),
                  ),
                ),
                if (_name.isNotEmpty) RebicText('Olá, $_name'),
                field(
                  'E-mail',
                  RebicInput(
                    semanticLabel: 'E-mail',
                    type: RebicInputType.email,
                    value: _email,
                    valueState: emailState,
                    valueStateText: 'Informe um e-mail válido',
                    onLiveChange: (value) => setState(() => _email = value),
                  ),
                ),
                field(
                  'Senha',
                  const RebicInput(
                    semanticLabel: 'Senha',
                    type: RebicInputType.password,
                    value: 'segredo',
                  ),
                ),
                field(
                  'Código (até 6 caracteres)',
                  RebicInput(
                    semanticLabel: 'Código',
                    maxLength: 6,
                    value: _code,
                    onLiveChange: (value) => setState(() => _code = value),
                  ),
                ),
                field(
                  'Pesquisa',
                  RebicInput(
                    semanticLabel: 'Pesquisa',
                    showClearIcon: true,
                    value: _search,
                    onLiveChange: (value) => setState(() => _search = value),
                  ),
                ),
                field(
                  'Telefone',
                  const RebicInput(
                    semanticLabel: 'Telefone',
                    type: RebicInputType.tel,
                    placeholder: '(00) 00000-0000',
                  ),
                ),
                field(
                  'Pedido',
                  const RebicInput(
                    semanticLabel: 'Pedido',
                    value: '4711',
                    editable: false,
                  ),
                ),
                field(
                  'Desabilitado',
                  const RebicInput(
                    semanticLabel: 'Desabilitado',
                    value: 'Indisponível',
                    enabled: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
