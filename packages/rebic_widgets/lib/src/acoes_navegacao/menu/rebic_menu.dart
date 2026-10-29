import 'dart:ui' show SemanticsRole;

import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';

import '../../feedback_sobreposicoes/dropdown/rebic_option_list.dart';
import '../../feedback_sobreposicoes/popover/rebic_popover.dart';

/// Item de um [RebicMenu], como o `sap.m.MenuItem` do SAPUI5.
class RebicMenuItem {
  /// Cria o item [label], que chama [onPressed] ao ser acionado.
  const RebicMenuItem({
    required this.label,
    required this.onPressed,
    this.icon,
    this.shortcut,
    this.startsSection = false,
  });

  /// Rótulo do item, em uma linha.
  final String label;

  /// Ação do item; nula deixa o item desabilitado.
  final VoidCallback? onPressed;

  /// Ícone antes do rótulo, do catálogo `RebicIcons` ou da aplicação.
  final IconData? icon;

  /// Atalho exibido no fim do item, no tom `muted` (ex.: "Ctrl+E"), como o
  /// `shortcutText` do UI5. Só exibe; o atalho não é registrado.
  final String? shortcut;

  /// Se um divisor sutil vem antes do item, abrindo uma seção.
  final bool startsSection;
}

/// Menu de ações num popover ancorado, como o `sap.m.Menu` do SAPUI5.
///
/// O [controller] abre o menu junto de [child], na largura da âncora (no
/// mínimo 6 passos `spacing.xxxl`). Acionar um item, por toque, Enter ou
/// Espaço, fecha o menu e chama o `onPressed` dele; toque fora e Esc fecham
/// chamando [onDismiss]. O menu não tem item selecionado.
///
/// O foco abre no primeiro item habilitado; as setas, Home, End e a primeira
/// letra navegam entre os itens. A lista é anunciada com o papel `menu` e os
/// itens com o papel `menuItem`, dentro de uma rota com o nome
/// [semanticLabel].
///
/// ```dart
/// RebicMenu(
///   controller: acoes,
///   semanticLabel: 'Ações',
///   items: [
///     RebicMenuItem(label: 'Editar', icon: RebicIcons.edit, onPressed: editar),
///     RebicMenuItem(label: 'Copiar', icon: RebicIcons.copy, onPressed: copiar),
///     RebicMenuItem(
///       label: 'Excluir',
///       icon: RebicIcons.delete,
///       startsSection: true,
///       onPressed: excluir,
///     ),
///   ],
///   child: RebicButton(label: 'Ações', onPressed: acoes.toggle),
/// )
/// ```
class RebicMenu extends StatelessWidget {
  /// Cria o menu de [items], ancorado em [child].
  RebicMenu({
    required this.controller,
    required this.items,
    required this.semanticLabel,
    required this.child,
    this.placement = RebicPlacement.bottom,
    this.onDismiss,
    super.key,
  }) : assert(items.isNotEmpty, 'items não pode ser vazia'),
       assert(
         items.every((item) => item.label != ''),
         'os rótulos não podem ser vazios',
       ),
       assert(semanticLabel != '', 'semanticLabel não pode ser vazio');

  /// Abre e fecha o menu.
  final RebicPopoverController controller;

  /// Itens, na ordem do menu.
  final List<RebicMenuItem> items;

  /// Nome do menu para leitores de tela.
  final String semanticLabel;

  /// A âncora.
  final Widget child;

  /// Posição preferida em relação à âncora.
  final RebicPlacement placement;

  /// Chamado quando o menu fecha por toque fora ou Esc.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return RebicOptionList(
      controller: controller,
      semanticLabel: semanticLabel,
      placement: placement,
      onDismiss: onDismiss,
      listRole: SemanticsRole.menu,
      itemRole: SemanticsRole.menuItem,
      options: [
        for (final item in items)
          RebicOption(
            label: item.label,
            icon: item.icon,
            trailing: item.shortcut,
            startsSection: item.startsSection,
            onChosen: item.onPressed,
          ),
      ],
      child: child,
    );
  }
}
