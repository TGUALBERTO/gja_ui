# Design: Localização

## Context

`gja_core` tem só `interaction/`. A galeria é um `WidgetsApp` sem delegates, então só existem as
`DefaultWidgetsLocalizations` (en, LTR). O design da Fase 0 decidiu o modelo: `GjaLocalizations` via
`Localizations`, com pt-BR como padrão e en. A arquitetura exige mecanismos nativos do Flutter e proíbe Material e
Cupertino. No SAPUI5, os textos da biblioteca vêm de um *resource bundle* com cadeia de reserva (idioma exato,
língua, idioma de desenvolvimento), e números e datas vêm de `NumberFormat`/`DateFormat` sobre dados do CLDR.

## Goals / Non-Goals

**Goals:**
- textos do framework tipados e verificados pelo compilador;
- resolução de idioma nativa;
- funcionar sem configuração;
- extensível pela aplicação;
- formatação por idioma vinda do CLDR.

**Non-Goals:**
- RTL;
- análise de entrada;
- solução de i18n para a aplicação;
- geração de código (`gen-l10n`/ARB).

## Decisions

### D1. Classe abstrata com subclasses por idioma

```dart
abstract class GjaLocalizations {
  const GjaLocalizations(this.locale);
  final Locale locale;
  static const defaultLocale = Locale('pt', 'BR');
  static const supportedLocales = [Locale('pt', 'BR'), Locale('en')];
  static const LocalizationsDelegate<GjaLocalizations> delegate = _Delegate();
  static GjaLocalizations of(BuildContext context);
  String get ok; String get cancel; String get close; String get search; String get clear;
  String get noData; String get loading; String get more; String get required;
  String valueState(GjaValueState state);
  String selectedItems(int count);
  // formatação concreta na base (D3)
}
class GjaLocalizationsPtBr extends GjaLocalizations { ... }
class GjaLocalizationsEn extends GjaLocalizations { ... }
```

As classes são escritas à mão, sem ARB nem `gen-l10n`. São poucos textos, e uma classe abstrata faz o compilador
exigir todo texto em todo idioma. Uma subclasse da aplicação pode estender `GjaLocalizationsPtBr` e sobrescrever um
texto, ou estender a base para um idioma novo.

**Alternativa:** `gen-l10n` com ARB. Ela exige `flutter_localizations` e geração no pacote, e não traz ganho para
algumas dezenas de textos.

### D2. Delegate e resolução

- `isSupported`: língua `pt` ou `en`.
- `load`: `en` gera `GjaLocalizationsEn`, e qualquer outra região de `pt` gera `GjaLocalizationsPtBr`. O retorno é
  um `SynchronousFuture`, para que a primeira moldura já tenha textos.
- `shouldReload`: falso.

A escolha do idioma da aplicação fica com a resolução nativa do `WidgetsApp`:
- `supportedLocales: GjaLocalizations.supportedLocales`, com pt-BR em primeiro;
- o idioma exato vence, depois a mesma língua, e por fim o primeiro da lista.

Assim, pt-PT resolve para pt-BR, en-GB para en e fr-FR para pt-BR, sem código próprio.

Um delegate da aplicação para o mesmo tipo `GjaLocalizations` é registrado antes do delegate do núcleo. O
`Localizations` usa o primeiro delegate que suporta o idioma.

`of(context)` usa `Localizations.of<GjaLocalizations>`. Quando o resultado é nulo, retorna uma instância constante
de `GjaLocalizationsPtBr`.

### D3. Formatação com `intl`

A base tem métodos concretos:
- `formatDecimal(num, {int decimals = 2})`;
- `formatInteger(int)`;
- `formatDate(DateTime)`, com o esqueleto `yMd` → "05/03/2026" e "3/5/2026";
- `formatTime(DateTime)`, com o esqueleto `jm`, que gera 24 h ou 12 h conforme o CLDR;
- `formatDateTime(DateTime)`.

Todos usam `NumberFormat`/`DateFormat` de `package:intl` com o nome de idioma da instância (`pt_BR`, `en`, ou o de
uma subclasse). Os dados de data vêm de `initializeDateFormatting`, chamado uma vez na primeira formatação. Ele é
síncrono na prática (dados locais), o que permite usar `of` sem delegate.

A versão de `intl` acompanha a fixada pelo Flutter SDK, para não conflitar com aplicações que usam
`flutter_localizations`.

### D4. Textos de estado de valor

`valueState(state)`:

| Estado | pt-BR | en |
|---|---|---|
| `none` | (vazio) | (vazio) |
| `success` | "Valor válido" | "Valid value" |
| `warning` | "Aviso" | "Warning" |
| `error` | "Valor inválido" | "Invalid value" |
| `information` | "Informação" | "Information" |

Os textos foram escritos para o GJA. O texto vazio de `none` permite concatenar o texto direto no rótulo
semântico do campo.

### D5. Galeria

- `main.dart` registra o delegate e `supportedLocales`.
- A página "Localização" usa `Localizations.override` para alternar entre pt-BR e en.
- Ela mostra os textos, os estados de valor, as contagens 0, 1 e 1000, e os formatos de 1234567.891 e de
  5/3/2026 14:30.

## Risks / Trade-offs

- [Texto de hora em en usa espaço especial do CLDR (U+202F) antes de "PM"] → Os testes comparam com o espaço
  normalizado. A spec diz que o espaço vem do CLDR.
- [`of` sem delegate esconde esquecimento de registro] → É intencional, para funcionar em qualquer `WidgetsApp`.
  `GjaApp` vai registrar o delegate.
- [Dependência nova (`intl`)] → É do time Dart, sem Flutter Material, e já é transitiva para quem usa
  `flutter_localizations`.

## Migration Plan

Capacidade nova; nada a migrar.
