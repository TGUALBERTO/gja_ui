import 'package:flutter/widgets.dart' show IconData;

import 'primitives/icon_primitives.dart';

/// Catálogo de ícones do Rebic, com os nomes do IconPool do SAPUI5.
///
/// Nível: semântico.
///
/// Cada ícone aponta para a fonte Lucide empacotada; o nome de origem está no
/// dartdoc e o código é conferido por teste contra
/// `fonts/lucide/codepoints.json`. Ícones direcionais são espelhados quando
/// o texto é da direita para a esquerda. Use [all] só onde for preciso
/// listar o catálogo (galeria, testes): ele mantém todos os glifos no build.
abstract final class RebicIcons {
  /// Adicionar um item. Lucide: `plus`; IconPool: `sap-icon://add`.
  static const add = IconData(
    0xe13d,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Fechar ou descartar. Lucide: `x`; IconPool: `sap-icon://decline`.
  static const decline = IconData(
    0xe1b2,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Buscar. Lucide: `search`; IconPool: `sap-icon://search`.
  static const search = IconData(
    0xe151,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Confirmar ou marcar como feito. Lucide: `check`; IconPool: `sap-icon://accept`.
  static const accept = IconData(
    0xe06c,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Recolher ou mover para cima. Lucide: `chevron-up`; IconPool: `sap-icon://slim-arrow-up`.
  static const slimArrowUp = IconData(
    0xe070,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Expandir ou abrir uma lista. Lucide: `chevron-down`; IconPool: `sap-icon://slim-arrow-down`.
  static const slimArrowDown = IconData(
    0xe06d,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Anterior (espelhado em RTL). Lucide: `chevron-left`; IconPool: `sap-icon://slim-arrow-left`.
  static const slimArrowLeft = IconData(
    0xe06e,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
    matchTextDirection: true,
  );

  /// Próximo ou avançar (espelhado em RTL). Lucide: `chevron-right`; IconPool: `sap-icon://slim-arrow-right`.
  static const slimArrowRight = IconData(
    0xe06f,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
    matchTextDirection: true,
  );

  /// Voltar (espelhado em RTL). Lucide: `arrow-left`; IconPool: `sap-icon://nav-back`.
  static const navBack = IconData(
    0xe048,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
    matchTextDirection: true,
  );

  /// Seguir (espelhado em RTL). Lucide: `arrow-right`; IconPool: `sap-icon://navigation-right-arrow`.
  static const navigationRightArrow = IconData(
    0xe049,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
    matchTextDirection: true,
  );

  /// Abrir o menu de navegação. Lucide: `menu`; IconPool: `sap-icon://menu2`.
  static const menu2 = IconData(
    0xe115,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Mais ações, em barra horizontal. Lucide: `ellipsis`; IconPool: `sap-icon://overflow`.
  static const overflow = IconData(
    0xe0b6,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Editar. Lucide: `pencil`; IconPool: `sap-icon://edit`.
  static const edit = IconData(
    0xe1f9,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Excluir. Lucide: `trash-2`; IconPool: `sap-icon://delete`.
  static const delete = IconData(
    0xe18e,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Informação. Lucide: `info`; IconPool: `sap-icon://information`.
  static const information = IconData(
    0xe0f9,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Alerta. Lucide: `triangle-alert`; IconPool: `sap-icon://warning`.
  static const warning = IconData(
    0xe193,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Erro. Lucide: `circle-x`; IconPool: `sap-icon://error`.
  static const error = IconData(
    0xe084,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Sucesso. Lucide: `circle-check`; IconPool: `sap-icon://sys-enter-2`.
  static const sysEnter2 = IconData(
    0xe226,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Ajuda. Lucide: `circle-question-mark`; IconPool: `sap-icon://sys-help`.
  static const sysHelp = IconData(
    0xe082,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Data. Lucide: `calendar`; IconPool: `sap-icon://calendar`.
  static const calendar = IconData(
    0xe063,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Hora. Lucide: `clock`; IconPool: `sap-icon://pending`.
  static const pending = IconData(
    0xe087,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Usuário ou perfil. Lucide: `user`; IconPool: `sap-icon://person-placeholder`.
  static const personPlaceholder = IconData(
    0xe19f,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Filtrar. Lucide: `funnel`; IconPool: `sap-icon://filter`.
  static const filter = IconData(
    0xe0dc,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Ordenar. Lucide: `arrow-up-down`; IconPool: `sap-icon://sort`.
  static const sort = IconData(
    0xe37d,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Enviar arquivo. Lucide: `upload`; IconPool: `sap-icon://upload`.
  static const upload = IconData(
    0xe19e,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Baixar arquivo. Lucide: `download`; IconPool: `sap-icon://download`.
  static const download = IconData(
    0xe0b2,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Atualizar. Lucide: `refresh-cw`; IconPool: `sap-icon://refresh`.
  static const refresh = IconData(
    0xe145,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Configurações. Lucide: `settings`; IconPool: `sap-icon://action-settings`.
  static const actionSettings = IconData(
    0xe154,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Página inicial. Lucide: `house`; IconPool: `sap-icon://home`.
  static const home = IconData(
    0xe0f5,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Abrir fora da aplicação (espelhado em RTL). Lucide: `external-link`; IconPool: `sap-icon://popup-window`.
  static const popupWindow = IconData(
    0xe0b9,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
    matchTextDirection: true,
  );

  /// Mostrar conteúdo oculto. Lucide: `eye`; IconPool: `sap-icon://show`.
  static const show = IconData(
    0xe0ba,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Ocultar conteúdo. Lucide: `eye-off`; IconPool: `sap-icon://hide`.
  static const hide = IconData(
    0xe0bb,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Copiar. Lucide: `copy`; IconPool: `sap-icon://copy`.
  static const copy = IconData(
    0xe09e,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Sair da aplicação (espelhado em RTL). Lucide: `log-out`; IconPool: `sap-icon://log`.
  static const log = IconData(
    0xe10e,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
    matchTextDirection: true,
  );

  /// Notificações. Lucide: `bell`; IconPool: `sap-icon://bell`.
  static const bell = IconData(
    0xe059,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Arquivo. Lucide: `file`; IconPool: `sap-icon://document`.
  static const document = IconData(
    0xe0c0,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Pasta. Lucide: `folder`; IconPool: `sap-icon://folder-blank`.
  static const folderBlank = IconData(
    0xe0d7,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Nome de origem na Lucide de cada ícone do catálogo.
  static const lucideNames = <String, String>{
    'add': 'plus',
    'decline': 'x',
    'search': 'search',
    'accept': 'check',
    'slimArrowUp': 'chevron-up',
    'slimArrowDown': 'chevron-down',
    'slimArrowLeft': 'chevron-left',
    'slimArrowRight': 'chevron-right',
    'navBack': 'arrow-left',
    'navigationRightArrow': 'arrow-right',
    'menu2': 'menu',
    'overflow': 'ellipsis',
    'edit': 'pencil',
    'delete': 'trash-2',
    'information': 'info',
    'warning': 'triangle-alert',
    'error': 'circle-x',
    'sysEnter2': 'circle-check',
    'sysHelp': 'circle-question-mark',
    'calendar': 'calendar',
    'pending': 'clock',
    'personPlaceholder': 'user',
    'filter': 'funnel',
    'sort': 'arrow-up-down',
    'upload': 'upload',
    'download': 'download',
    'refresh': 'refresh-cw',
    'actionSettings': 'settings',
    'home': 'house',
    'popupWindow': 'external-link',
    'show': 'eye',
    'hide': 'eye-off',
    'copy': 'copy',
    'log': 'log-out',
    'bell': 'bell',
    'document': 'file',
    'folderBlank': 'folder',
  };

  /// Nome de cada ícone no IconPool do SAPUI5 (`sap-icon://<nome>`). O nome
  /// do catálogo é este nome em camelCase: sem hífens, com a letra seguinte
  /// maiúscula (`slim-arrow-down` → `slimArrowDown`, `menu2` → `menu2`).
  static const iconPoolNames = <String, String>{
    'add': 'add',
    'decline': 'decline',
    'search': 'search',
    'accept': 'accept',
    'slimArrowUp': 'slim-arrow-up',
    'slimArrowDown': 'slim-arrow-down',
    'slimArrowLeft': 'slim-arrow-left',
    'slimArrowRight': 'slim-arrow-right',
    'navBack': 'nav-back',
    'navigationRightArrow': 'navigation-right-arrow',
    'menu2': 'menu2',
    'overflow': 'overflow',
    'edit': 'edit',
    'delete': 'delete',
    'information': 'information',
    'warning': 'warning',
    'error': 'error',
    'sysEnter2': 'sys-enter-2',
    'sysHelp': 'sys-help',
    'calendar': 'calendar',
    'pending': 'pending',
    'personPlaceholder': 'person-placeholder',
    'filter': 'filter',
    'sort': 'sort',
    'upload': 'upload',
    'download': 'download',
    'refresh': 'refresh',
    'actionSettings': 'action-settings',
    'home': 'home',
    'popupWindow': 'popup-window',
    'show': 'show',
    'hide': 'hide',
    'copy': 'copy',
    'log': 'log',
    'bell': 'bell',
    'document': 'document',
    'folderBlank': 'folder-blank',
  };

  /// Todos os ícones do catálogo, pelo nome.
  static const all = <String, IconData>{
    'add': add,
    'decline': decline,
    'search': search,
    'accept': accept,
    'slimArrowUp': slimArrowUp,
    'slimArrowDown': slimArrowDown,
    'slimArrowLeft': slimArrowLeft,
    'slimArrowRight': slimArrowRight,
    'navBack': navBack,
    'navigationRightArrow': navigationRightArrow,
    'menu2': menu2,
    'overflow': overflow,
    'edit': edit,
    'delete': delete,
    'information': information,
    'warning': warning,
    'error': error,
    'sysEnter2': sysEnter2,
    'sysHelp': sysHelp,
    'calendar': calendar,
    'pending': pending,
    'personPlaceholder': personPlaceholder,
    'filter': filter,
    'sort': sort,
    'upload': upload,
    'download': download,
    'refresh': refresh,
    'actionSettings': actionSettings,
    'home': home,
    'popupWindow': popupWindow,
    'show': show,
    'hide': hide,
    'copy': copy,
    'log': log,
    'bell': bell,
    'document': document,
    'folderBlank': folderBlank,
  };
}
