import 'package:flutter/widgets.dart' show IconData;

import 'primitives/icon_primitives.dart';

/// Catálogo semântico de ícones do Rebic, nomeados pelo significado.
///
/// Nível: semântico.
///
/// Cada ícone aponta para a fonte Lucide empacotada; o nome de origem está no
/// dartdoc e o código é conferido por teste contra
/// `fonts/lucide/codepoints.json`. Ícones direcionais são espelhados quando
/// o texto é da direita para a esquerda. Use [all] só onde for preciso
/// listar o catálogo (galeria, testes): ele mantém todos os glifos no build.
abstract final class RebicIcons {
  /// Adicionar um item. Lucide: `plus`.
  static const add = IconData(
    0xe13d,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Fechar ou descartar. Lucide: `x`.
  static const close = IconData(
    0xe1b2,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Buscar. Lucide: `search`.
  static const search = IconData(
    0xe151,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Confirmar ou marcar como feito. Lucide: `check`.
  static const check = IconData(
    0xe06c,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Recolher ou mover para cima. Lucide: `chevron-up`.
  static const chevronUp = IconData(
    0xe070,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Expandir ou abrir uma lista. Lucide: `chevron-down`.
  static const chevronDown = IconData(
    0xe06d,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Anterior (espelhado em RTL). Lucide: `chevron-left`.
  static const chevronLeft = IconData(
    0xe06e,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
    matchTextDirection: true,
  );

  /// Próximo ou avançar (espelhado em RTL). Lucide: `chevron-right`.
  static const chevronRight = IconData(
    0xe06f,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
    matchTextDirection: true,
  );

  /// Voltar (espelhado em RTL). Lucide: `arrow-left`.
  static const arrowLeft = IconData(
    0xe048,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
    matchTextDirection: true,
  );

  /// Seguir (espelhado em RTL). Lucide: `arrow-right`.
  static const arrowRight = IconData(
    0xe049,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
    matchTextDirection: true,
  );

  /// Abrir o menu de navegação. Lucide: `menu`.
  static const menu = IconData(
    0xe115,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Mais ações, em barra horizontal. Lucide: `ellipsis`.
  static const moreHorizontal = IconData(
    0xe0b6,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Mais ações, em lista ou linha de tabela. Lucide: `ellipsis-vertical`.
  static const moreVertical = IconData(
    0xe0b7,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Editar. Lucide: `pencil`.
  static const edit = IconData(
    0xe1f9,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Excluir. Lucide: `trash-2`.
  static const delete = IconData(
    0xe18e,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Informação. Lucide: `info`.
  static const info = IconData(
    0xe0f9,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Alerta. Lucide: `triangle-alert`.
  static const warning = IconData(
    0xe193,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Erro. Lucide: `circle-x`.
  static const error = IconData(
    0xe084,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Sucesso. Lucide: `circle-check`.
  static const success = IconData(
    0xe226,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Ajuda. Lucide: `circle-question-mark`.
  static const help = IconData(
    0xe082,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Data. Lucide: `calendar`.
  static const calendar = IconData(
    0xe063,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Hora. Lucide: `clock`.
  static const clock = IconData(
    0xe087,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Usuário ou perfil. Lucide: `user`.
  static const user = IconData(
    0xe19f,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Filtrar. Lucide: `funnel`.
  static const filter = IconData(
    0xe0dc,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Ordenar. Lucide: `arrow-up-down`.
  static const sort = IconData(
    0xe37d,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Enviar arquivo. Lucide: `upload`.
  static const upload = IconData(
    0xe19e,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Baixar arquivo. Lucide: `download`.
  static const download = IconData(
    0xe0b2,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Atualizar. Lucide: `refresh-cw`.
  static const refresh = IconData(
    0xe145,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Configurações. Lucide: `settings`.
  static const settings = IconData(
    0xe154,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Página inicial. Lucide: `house`.
  static const home = IconData(
    0xe0f5,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Abrir fora da aplicação (espelhado em RTL). Lucide: `external-link`.
  static const externalLink = IconData(
    0xe0b9,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
    matchTextDirection: true,
  );

  /// Mostrar conteúdo oculto. Lucide: `eye`.
  static const visibility = IconData(
    0xe0ba,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Ocultar conteúdo. Lucide: `eye-off`.
  static const visibilityOff = IconData(
    0xe0bb,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Copiar. Lucide: `copy`.
  static const copy = IconData(
    0xe09e,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Sair da aplicação (espelhado em RTL). Lucide: `log-out`.
  static const logout = IconData(
    0xe10e,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
    matchTextDirection: true,
  );

  /// Notificações. Lucide: `bell`.
  static const notification = IconData(
    0xe059,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Arquivo. Lucide: `file`.
  static const file = IconData(
    0xe0c0,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Pasta. Lucide: `folder`.
  static const folder = IconData(
    0xe0d7,
    fontFamily: RebicIconPrimitives.fontFamily,
    fontPackage: RebicIconPrimitives.fontPackage,
  );

  /// Nome de origem na Lucide de cada ícone do catálogo.
  static const lucideNames = <String, String>{
    'add': 'plus',
    'close': 'x',
    'search': 'search',
    'check': 'check',
    'chevronUp': 'chevron-up',
    'chevronDown': 'chevron-down',
    'chevronLeft': 'chevron-left',
    'chevronRight': 'chevron-right',
    'arrowLeft': 'arrow-left',
    'arrowRight': 'arrow-right',
    'menu': 'menu',
    'moreHorizontal': 'ellipsis',
    'moreVertical': 'ellipsis-vertical',
    'edit': 'pencil',
    'delete': 'trash-2',
    'info': 'info',
    'warning': 'triangle-alert',
    'error': 'circle-x',
    'success': 'circle-check',
    'help': 'circle-question-mark',
    'calendar': 'calendar',
    'clock': 'clock',
    'user': 'user',
    'filter': 'funnel',
    'sort': 'arrow-up-down',
    'upload': 'upload',
    'download': 'download',
    'refresh': 'refresh-cw',
    'settings': 'settings',
    'home': 'house',
    'externalLink': 'external-link',
    'visibility': 'eye',
    'visibilityOff': 'eye-off',
    'copy': 'copy',
    'logout': 'log-out',
    'notification': 'bell',
    'file': 'file',
    'folder': 'folder',
  };

  /// Todos os ícones do catálogo, por nome semântico.
  static const all = <String, IconData>{
    'add': add,
    'close': close,
    'search': search,
    'check': check,
    'chevronUp': chevronUp,
    'chevronDown': chevronDown,
    'chevronLeft': chevronLeft,
    'chevronRight': chevronRight,
    'arrowLeft': arrowLeft,
    'arrowRight': arrowRight,
    'menu': menu,
    'moreHorizontal': moreHorizontal,
    'moreVertical': moreVertical,
    'edit': edit,
    'delete': delete,
    'info': info,
    'warning': warning,
    'error': error,
    'success': success,
    'help': help,
    'calendar': calendar,
    'clock': clock,
    'user': user,
    'filter': filter,
    'sort': sort,
    'upload': upload,
    'download': download,
    'refresh': refresh,
    'settings': settings,
    'home': home,
    'externalLink': externalLink,
    'visibility': visibility,
    'visibilityOff': visibilityOff,
    'copy': copy,
    'logout': logout,
    'notification': notification,
    'file': file,
    'folder': folder,
  };
}
