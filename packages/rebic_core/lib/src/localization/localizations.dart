import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Textos e formatos do framework Rebic em um idioma.
///
/// Equivale aos *resource bundles* de biblioteca do SAPUI5: os widgets do
/// framework leem daqui todo texto que exibem ou anunciam, com
/// `RebicLocalizations.of(context)`. O Rebic fornece pt-BR (padrão) e en. Para
/// outro idioma, ou para trocar textos, a aplicação estende esta classe (ou
/// uma das fornecidas) e registra um delegate próprio antes de [delegate].
///
/// A formatação de números e datas é concreta e segue o [locale] da
/// instância, com os dados do CLDR de `package:intl`.
abstract class RebicLocalizations {
  /// Cria os textos de [locale].
  const RebicLocalizations(this.locale);

  /// Idioma destes textos e formatos.
  final Locale locale;

  /// Idioma padrão, usado quando nenhum outro se aplica.
  static const defaultLocale = Locale('pt', 'BR');

  /// Idiomas fornecidos pelo Rebic, com o padrão em primeiro, para
  /// `WidgetsApp.supportedLocales`.
  static const supportedLocales = <Locale>[defaultLocale, Locale('en')];

  /// Delegate dos idiomas fornecidos, para `WidgetsApp.localizationsDelegates`.
  ///
  /// Aceita qualquer região de `pt` (carrega pt-BR) e de `en`.
  static const LocalizationsDelegate<RebicLocalizations> delegate =
      _RebicLocalizationsDelegate();

  /// Textos do contexto, ou os de pt-BR quando nenhum delegate de
  /// [RebicLocalizations] está registrado.
  static RebicLocalizations of(BuildContext context) {
    return Localizations.of<RebicLocalizations>(context, RebicLocalizations) ??
        const RebicLocalizationsPtBr();
  }

  /// Confirmação ("OK").
  String get ok;

  /// Cancelar uma ação.
  String get cancel;

  /// Fechar um painel, diálogo ou mensagem.
  String get close;

  /// Pesquisar.
  String get search;

  /// Limpar um valor ou filtro.
  String get clear;

  /// Lista ou tabela sem dados.
  String get noData;

  /// Conteúdo em carregamento.
  String get loading;

  /// Mais itens ou ações ocultos.
  String get more;

  /// Campo obrigatório.
  String get required;

  /// Área de navegação da aplicação (ex.: rótulo do botão que a expande).
  String get navigation;

  /// Voltar à página anterior (ex.: rótulo do botão de voltar).
  String get back;

  /// Texto de [state] para leitores de tela; vazio para
  /// [RebicValueState.none].
  String valueState(RebicValueState state);

  /// Contagem de itens selecionados, com [count] formatado no idioma.
  String selectedItems(int count);

  /// Nome do idioma para `package:intl` (ex.: `pt_BR`, `en`).
  String get intlLocale => Intl.canonicalizedLocale(locale.toLanguageTag());

  /// [value] como decimal com [decimals] casas.
  String formatDecimal(num value, {int decimals = 2}) {
    return NumberFormat.decimalPatternDigits(
      locale: intlLocale,
      decimalDigits: decimals,
    ).format(value);
  }

  /// [value] como inteiro, com agrupamento de milhares.
  String formatInteger(int value) =>
      NumberFormat.decimalPattern(intlLocale).format(value);

  /// Data curta de [date] (ex.: 05/03/2026 em pt-BR).
  String formatDate(DateTime date) {
    _ensureDateData();
    return DateFormat.yMd(intlLocale).format(date);
  }

  /// Hora de [time], em 24 h ou 12 h conforme o idioma.
  String formatTime(DateTime time) {
    _ensureDateData();
    return DateFormat.jm(intlLocale).format(time);
  }

  /// Data curta e hora de [dateTime].
  String formatDateTime(DateTime dateTime) {
    _ensureDateData();
    return DateFormat.yMd(intlLocale).add_jm().format(dateTime);
  }
}

bool _dateDataReady = false;

// Os dados de data são locais: a inicialização termina antes de retornar.
void _ensureDateData() {
  if (_dateDataReady) return;
  initializeDateFormatting();
  _dateDataReady = true;
}

/// Textos e formatos em português do Brasil, o idioma padrão.
class RebicLocalizationsPtBr extends RebicLocalizations {
  /// Cria os textos em pt-BR.
  const RebicLocalizationsPtBr() : super(RebicLocalizations.defaultLocale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Fechar';

  @override
  String get search => 'Pesquisar';

  @override
  String get clear => 'Limpar';

  @override
  String get noData => 'Sem dados';

  @override
  String get loading => 'Carregando';

  @override
  String get more => 'Mais';

  @override
  String get required => 'Obrigatório';

  @override
  String get navigation => 'Navegação';

  @override
  String get back => 'Voltar';

  @override
  String valueState(RebicValueState state) => switch (state) {
    RebicValueState.none => '',
    RebicValueState.success => 'Valor válido',
    RebicValueState.warning => 'Aviso',
    RebicValueState.error => 'Valor inválido',
    RebicValueState.information => 'Informação',
  };

  @override
  String selectedItems(int count) => switch (count) {
    0 => 'Nenhum item selecionado',
    1 => '1 item selecionado',
    _ => '${formatInteger(count)} itens selecionados',
  };
}

/// Textos e formatos em inglês.
class RebicLocalizationsEn extends RebicLocalizations {
  /// Cria os textos em en.
  const RebicLocalizationsEn() : super(const Locale('en'));

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get search => 'Search';

  @override
  String get clear => 'Clear';

  @override
  String get noData => 'No data';

  @override
  String get loading => 'Loading';

  @override
  String get more => 'More';

  @override
  String get required => 'Required';

  @override
  String get navigation => 'Navigation';

  @override
  String get back => 'Back';

  @override
  String valueState(RebicValueState state) => switch (state) {
    RebicValueState.none => '',
    RebicValueState.success => 'Valid value',
    RebicValueState.warning => 'Warning',
    RebicValueState.error => 'Invalid value',
    RebicValueState.information => 'Information',
  };

  @override
  String selectedItems(int count) => switch (count) {
    0 => 'No items selected',
    1 => '1 item selected',
    _ => '${formatInteger(count)} items selected',
  };
}

class _RebicLocalizationsDelegate
    extends LocalizationsDelegate<RebicLocalizations> {
  const _RebicLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'pt' || locale.languageCode == 'en';

  @override
  Future<RebicLocalizations> load(Locale locale) {
    return SynchronousFuture(
      locale.languageCode == 'en'
          ? const RebicLocalizationsEn()
          : const RebicLocalizationsPtBr(),
    );
  }

  @override
  bool shouldReload(_RebicLocalizationsDelegate old) => false;
}
