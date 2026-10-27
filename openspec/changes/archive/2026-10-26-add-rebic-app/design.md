# Design: RebicApp

## Context

A galeria monta hoje, à mão, um `WidgetsApp` com:
- `localizationsDelegates`/`supportedLocales` de `RebicLocalizations`;
- `builder` com `RebicTheme(data: light)` e `RebicScreenSizeScope`;
- `pageRouteBuilder` com um `PageRouteBuilder` sem transição;
- `color` obrigatório.

As peças existem:
- `RebicTheme`, que anima a troca e publica o tema;
- `RebicThemeData.light/dark` e `withDensity`;
- `RebicResponsive.recommendedDensity` e `RebicScreenSizeScope`, que leem os limiares do tema;
- `RebicLocalizations.delegate` e `supportedLocales`.

O `WidgetsApp` exige `color` e um `pageRouteBuilder` quando há `home` ou `routes`. Para `Router`, existe
`WidgetsApp.router`.

## Goals / Non-Goals

**Goals:**
- uma declaração que monta toda a aplicação Rebic;
- modo claro/escuro com o sistema;
- densidade recomendada;
- transição de página própria;
- galeria migrada.

**Non-Goals:**
- `RebicScaffold`;
- persistência de preferências;
- transições por tipo de rota;
- gesto de voltar por arrasto.

## Decisions

### D1. API

```dart
enum RebicThemeMode { system, light, dark }

class RebicApp extends StatelessWidget {
  const RebicApp({
    super.key,
    this.navigatorKey, this.home, this.routes = const {}, this.initialRoute,
    this.onGenerateRoute, this.onUnknownRoute, this.navigatorObservers = const [],
    this.title = '', this.builder, this.locale, this.localizationsDelegates,
    this.supportedLocales, this.theme, this.darkTheme,
    this.themeMode = RebicThemeMode.system, this.density,
    this.debugShowCheckedModeBanner = true,
  });
  const RebicApp.router({ required RouterConfig<Object> routerConfig, ...mesmas propriedades de tema e idioma });
}
```

`RebicThemeMode` fica em `rebic_widgets`, no mesmo arquivo, porque só o `RebicApp` o usa. As propriedades repassadas
mantêm os nomes e tipos do `WidgetsApp`. Ficam de fora as que não fazem sentido sem Material (`color` vem do tema) e as
de uso raro (`shortcuts`, `actions`, restauração). Elas podem entrar depois sem quebra.

### D2. Tema efetivo

O `build` calcula o tema:
1. a partir de `themeMode` e de `MediaQuery.platformBrightnessOf(context)`, escolhe `theme ?? light()` ou
   `darkTheme ?? dark()`;
2. aplica `withDensity(density ?? RebicResponsive.recommendedDensity())`.

A dependência de `platformBrightness` reconstrói só o `RebicApp`, e não a navegação: o `WidgetsApp` mantém o
`Navigator`. Os temas de referência são guardados em campos estáticos, para não recriar instâncias a cada build.

O `MediaQuery` lido por `RebicApp` é o do `View` acima do `WidgetsApp`, e o `WidgetsApp` cria o seu abaixo. Ler o
brilho acima é o mesmo que o `MaterialApp` faz.

### D3. Composição

```
WidgetsApp(
  color: tema.colors.brand,
  localizationsDelegates: [...app, RebicLocalizations.delegate],
  supportedLocales: supportedLocales ?? RebicLocalizations.supportedLocales,
  pageRouteBuilder: <T>(settings, builder) => RebicPageRoute<T>(settings: settings, builder: builder),
  builder: (context, child) => RebicTheme(
    data: tema,
    child: RebicScreenSizeScope(
      child: ColoredBox(color: RebicTheme.of(context).colors.background,   // lido abaixo do RebicTheme
        child: builder?.call(context, child) ?? child)),
  ),
  …demais propriedades repassadas,
)
```

O fundo é lido por um `Builder` abaixo do `RebicTheme`, para acompanhar a transição de tema. Não é preciso passar
`textStyle`: o `RebicTheme` já define o texto padrão.

### D4. `RebicPageRoute`

`RebicPageRoute<T>` é privado ao arquivo do `RebicApp`, porque a spec de rotas para outros usos fica com
`RebicScaffold`/navegação. Ele estende `PageRoute<T>`:
- `opaque: true` e `maintainState: true`;
- `transitionDuration` e `reverseTransitionDuration`: a `motion.medium` de `RebicThemeData.of(navigatorContext)`;
- `buildTransitions` aplica um `SlideTransition` de `Offset(1, 0)` (LTR) ou `Offset(-1, 0)` (RTL, pela `Directionality`)
  até `Offset.zero`, com a curva `motion.standard`.

`RebicThemeData.of` já resolve o movimento reduzido, então a duração é zero quando o sistema desliga as animações.
Esse é o mesmo comportamento do `slide` do `NavContainer` do UI5, sem a sombra do Cupertino.

### D5. Galeria

`RebicGalleryApp` vira `StatefulWidget`, com `RebicThemeMode` e `RebicDensity?` no estado. O índice recebe
`onThemeMode`/`onDensity` por um `InheritedWidget` privado (`_GallerySettings`) e mostra dois grupos de opções
(Sistema/Claro/Escuro e Recomendada/Confortável/Compacta) feitos com `RebicInteractable`. As páginas existentes não
mudam. O comentário "provisória até existir `RebicApp`" e a constante `_colors` saem.

### D6. Catálogo

`rebic/widgets/rebic-app` passa a `implemented`. As dependências do `[Integração]` são `rebic-theme`,
`core/localization`, `core/interaction`, `core/overlay` e `core/responsive`.

## Risks / Trade-offs

- [A densidade recomendada por plataforma erra em notebooks com toque] → A aplicação informa `density`. O padrão segue
  o UI5 (compacto em desktop).
- [Repassar só parte das propriedades do `WidgetsApp`] → As ausentes podem ser acrescentadas sem quebra quando um caso
  real pedir.
- [A transição lê o tema do contexto do `Navigator`] → O `builder` do `WidgetsApp` envolve o `Navigator`, então o
  `RebicTheme` está acima do contexto do `Navigator`. O teste "Meio da transição" confirma.

## Migration Plan

A galeria migra na própria change. Aplicações não existem ainda.
