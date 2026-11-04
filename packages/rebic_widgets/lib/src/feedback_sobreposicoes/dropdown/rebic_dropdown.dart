import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';

import '../popover/rebic_popover.dart';
import 'rebic_option_list.dart';

/// Item de um [RebicDropdown], como o `sap.ui.core.Item` do SAPUI5.
class RebicDropdownItem<T> {
  /// Cria o item [label] com o valor [value].
  const RebicDropdownItem({
    required this.key,
    required this.text,
    this.icon,
    this.additionalText,
    this.enabled = true,
  });

  /// Chave devolvida por `onSelectionChange` quando o item é escolhido.
  final T key;

  /// Texto do item, em uma linha.
  final String text;

  /// Ícone antes do texto, do catálogo `RebicIcons` ou da aplicação.
  final IconData? icon;

  /// Texto no fim do item, no tom `muted` (ex.: uma contagem).
  final String? additionalText;

  /// Se o item pode ser escolhido e receber o foco.
  final bool enabled;
}

/// Lista de itens selecionáveis num popover ancorado, como a lista do
/// `sap.m.Select` do SAPUI5.
///
/// O [controller] abre a lista junto de [child], na largura da âncora
/// (`RebicPopoverWidth.anchor`). O item cuja chave é [selectedKey] aparece
/// selecionado e recebe o foco ao abrir; sem ele, o foco vai ao primeiro item
/// habilitado. Escolher um item, por toque, Enter ou Espaço, fecha a lista e
/// chama [onSelectionChange]; toque fora e Esc fecham chamando [onDismiss].
///
/// Pelo teclado, as setas movem entre os itens habilitados, Home e End vão ao
/// primeiro e ao último, e uma letra leva ao próximo item que começa com ela.
/// A lista é anunciada como uma rota com o nome [semanticLabel], e cada item
/// como um botão com o estado de selecionado.
///
/// É a base de campos de seleção e menus; não é um campo.
///
/// ```dart
/// RebicDropdown<String>(
///   controller: status,
///   semanticLabel: 'Status',
///   selectedKey: atual,
///   items: const [
///     RebicDropdownItem(key: 'aberto', text: 'Em aberto'),
///     RebicDropdownItem(key: 'aprovado', text: 'Aprovado'),
///   ],
///   onSelectionChange: escolher,
///   child: RebicButton(text: 'Status', onPress: status.toggle),
/// )
/// ```
class RebicDropdown<T> extends StatelessWidget {
  /// Cria o dropdown de [items], ancorado em [child].
  RebicDropdown({
    required this.controller,
    required this.items,
    required this.onSelectionChange,
    required this.semanticLabel,
    required this.child,
    this.selectedKey,
    this.placement = RebicPlacement.bottom,
    this.onDismiss,
    super.key,
  }) : assert(items.isNotEmpty, 'items não pode ser vazia'),
       assert(
         items.map((item) => item.key).toSet().length == items.length,
         'os valores dos itens devem ser distintos',
       ),
       assert(
         items.every((item) => item.text != ''),
         'os rótulos não podem ser vazios',
       ),
       assert(semanticLabel != '', 'semanticLabel não pode ser vazio');

  /// Abre e fecha a lista.
  final RebicPopoverController controller;

  /// Itens, na ordem da lista.
  final List<RebicDropdownItem<T>> items;

  /// Chamado com o valor do item escolhido.
  final ValueChanged<T> onSelectionChange;

  /// Nome da lista para leitores de tela.
  final String semanticLabel;

  /// A âncora.
  final Widget child;

  /// Chave do item selecionado, ou nula.
  final T? selectedKey;

  /// Posição preferida em relação à âncora.
  final RebicPlacement placement;

  /// Chamado quando a lista fecha por toque fora ou Esc.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return RebicOptionList(
      controller: controller,
      semanticLabel: semanticLabel,
      placement: placement,
      onDismiss: onDismiss,
      options: [
        for (final item in items)
          RebicOption(
            label: item.text,
            icon: item.icon,
            trailing: item.additionalText,
            selected: item.key == selectedKey,
            onChosen: item.enabled ? () => onSelectionChange(item.key) : null,
          ),
      ],
      child: child,
    );
  }
}
