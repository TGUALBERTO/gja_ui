/// Widgets públicos do framework Rebic.
///
/// Cada widget vive em `lib/src/<categoria>/<widget>/` e é exportado aqui.
/// Depende de `rebic_foundation` e `rebic_core`.
library;

export 'src/fundacao_layout/theme/rebic_theme.dart';
export 'src/fundacao_layout/app/rebic_app.dart';
export 'src/fundacao_layout/text/rebic_text.dart';
export 'src/fundacao_layout/title/rebic_title.dart';
export 'src/fundacao_layout/label/rebic_label.dart';
export 'src/fundacao_layout/bar/rebic_bar.dart' hide RebicBarScope;
export 'src/fundacao_layout/card_header/rebic_card_header.dart'
    hide RebicCardHeadingScope;
export 'src/fundacao_layout/shell_bar/rebic_shell_bar.dart';
export 'src/fundacao_layout/tool_page/rebic_tool_page.dart';
export 'src/fundacao_layout/icon/rebic_icon.dart';
export 'src/fundacao_layout/spacing/rebic_spacing.dart';
export 'src/fundacao_layout/container/rebic_container.dart';
export 'src/fundacao_layout/flex/rebic_flex_enums.dart';
export 'src/fundacao_layout/hbox/rebic_hbox.dart';
export 'src/fundacao_layout/vbox/rebic_vbox.dart';
export 'src/fundacao_layout/separator/rebic_separator.dart';
export 'src/fundacao_layout/responsive_layout/rebic_responsive_layout.dart';
export 'src/fundacao_layout/grid/rebic_grid.dart';
export 'src/fundacao_layout/page/rebic_page.dart';
export 'src/fundacao_layout/card/rebic_card.dart';
export 'src/exibicao_dados/progress_indicator/rebic_progress_indicator.dart';
export 'src/exibicao_dados/status_indicator/rebic_status_indicator.dart';
export 'src/exibicao_dados/avatar/rebic_avatar.dart';
export 'src/exibicao_dados/badge/rebic_badge.dart';
export 'src/exibicao_dados/illustrated_message/rebic_illustrated_message.dart';
export 'src/exibicao_dados/tooltip/rebic_tooltip.dart';
export 'src/acoes_navegacao/button/rebic_button.dart';
export 'src/acoes_navegacao/link/rebic_link.dart';
export 'src/acoes_navegacao/menu/rebic_menu.dart';
export 'src/feedback_sobreposicoes/popover/rebic_popover.dart';
export 'src/feedback_sobreposicoes/busy_indicator/rebic_busy_indicator.dart';
export 'src/feedback_sobreposicoes/dialog/rebic_dialog.dart';
export 'src/feedback_sobreposicoes/dropdown/rebic_dropdown.dart';
export 'src/feedback_sobreposicoes/message_strip/rebic_message_strip.dart';
export 'src/formularios/check_box/rebic_check_box.dart';
export 'src/formularios/input/rebic_input.dart';
export 'src/formularios/radio_button/rebic_radio_button.dart';
export 'src/formularios/radio_button_group/rebic_radio_button_group.dart';
export 'src/formularios/select/rebic_select.dart';
export 'src/formularios/switch/rebic_switch.dart';
