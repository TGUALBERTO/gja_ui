# Design: GjaApp

## Context

A galeria monta hoje, à mão, um `WidgetsApp` com:
- `localizationsDelegates`/`supportedLocales` de `GjaLocalizations`;
- `builder` com `GjaTheme(data: light)` e `GjaScreenSizeScope`;
- `pageRouteBuilder` com um `PageRouteBuilder` sem transição;
- `color` obrigatório.

As peças existem:
- `GjaTheme`, que anima a troca e publica o tema;
- `GjaThemeData.light/dark` e `withDensity`;
- `GjaResponsive.recommendedDensity` e `GjaScreenSizeScope`, que leem os limiares do tema;
- `GjaLocalizations.delegate` e `supportedLocales`.

O `WidgetsApp` exige `color` e um `pageRouteBuilder` quando há `home` ou `routes`. Para `Router`, existe
`WidgetsApp.router`.

## Goals / Non-Goals

**Goals:**
- uma declaração que monta toda a aplicação GJA;
- modo claro/escuro com o sistema;
- densidade recomendada;
- transição de página própria;
- galeria migrada.

**Non-Goals:**
- `GjaScaffold`;
- persistência de preferências;
- transições por tipo de rota;
- gesto de voltar por arrasto.

## Decisions

### D1. API

```dart
enum GjaThemeMode { system, light, dark }

class GjaApp extends StatelessWidget {
  const GjaApp({
    super.key,
    this.navigatorKey, this.home, this.routes = const {}, this.initialRoute,
    this.onGenerateRoute, this.onUnknownRoute, this.navigatorObservers = const [],
    this.title = '', this.builder, this.locale, this.localizationsDelegates,
    this.supportedLocales, this.theme, this.darkTheme,
    this.themeMode = GjaThemeMode.system, this.density,
    this.debugShowCheckedModeBanner = true,
  });
  const GjaApp.router({ required RouterConfig<Object> routerConfig, ...mesmas propriedades de tema e idioma });
}
```

`GjaThemeMode` fica em `gja_widgets`, no mesmo arquivo, porque só o `GjaApp` o usa. As propriedades repassadas
mantêm os nomes e tipos do `WidgetsApp`. Ficam de fora as que não fazem sentido sem Material (`color` vem do tema) e as
de uso raro (`shortcuts`, `actions`, restauração). Elas podem entrar depois sem quebra.

### D2. Tema efetivo

O `build` calcula o tema:
1. a partir de `themeMode` e de `MediaQuery.platformBrightnessOf(context)`, escolhe `theme ?? light()` ou
   `darkTheme ?? dark()`;
2. aplica `withDensity(density ?? GjaResponsive.recommendedDensity())`.

A dependência de `platformBrightness` reconstrói só o `GjaApp`, e não a navegação: o `WidgetsApp` mantém o
`Navigator`. Os temas de referência são guardados em campos estáticos, para não recriar instâncias a cada build.

O `MediaQuery` lido por `GjaApp` é o do `View` acima do `WidgetsApp`, e o `WidgetsApp` cria o seu abaixo. Ler o
brilho acima é o mesmo que o `MaterialApp` faz.

### D3. Composição

```
WidgetsApp(
  color: tema.colors.brand,
  localizationsDelegates: [...app, GjaLocalizations.delegate],
  supportedLocales: supportedLocales ?? GjaLocalizations.supportedLocales,
  pageRouteBuilder: <T>(settings, builder) => GjaPageRoute<T>(settings: settings, builder: builder),
  builder: (context, child) => GjaTheme(
    data: tema,
    child: GjaScreenSizeScope(
      child: ColoredBox(color: GjaTheme.of(context).colors.background,   // lido abaixo do GjaTheme
        child: builder?.call(context, child) ?? child)),
  ),
  …demais propriedades repassadas,
)
```

O fundo é lido por um `Builder` abaixo do `GjaTheme`, para acompanhar a transição de tema. Não é preciso passar
`textStyle`: o `GjaTheme` já define o texto padrão.

### D4. `GjaPageRoute`

`GjaPageRoute<T>` é privado ao arquivo do `GjaApp`, porque a spec de rotas para outros usos fica com
`GjaScaffold`/navegação. Ele estende `PageRoute<T>`:
- `opaque: true` e `maintainState: true`;
- `transitionDuration` e `reverseTransitionDuration`: a `motion.medium` de `GjaThemeData.of(navigatorContext)`;
- `buildTransitions` aplica um `SlideTransition` de `Offset(1, 0)` (LTR) ou `Offset(-1, 0)` (RTL, pela `Directionality`)
  até `Offset.zero`, com a curva `motion.standard`.

`GjaThemeData.of` já resolve o movimento reduzido, então a duração é zero quando o sistema desliga as animações.
Esse é o mesmo comportamento do `slide` do `NavContainer` do UI5, sem a sombra do Cupertino.

### D5. Galeria

`GjaGalleryApp` vira `StatefulWidget`, com `GjaThemeMode` e `GjaDensity?` no estado. O índice recebe
`onThemeMode`/`onDensity` por um `InheritedWidget` privado (`_GallerySettings`) e mostra dois grupos de opções
(Sistema/Claro/Escuro e Recomendada/Confortável/Compacta) feitos com `GjaInteractable`. As páginas existentes não
mudam. O comentário "provisória até existir `GjaApp`" e a constante `_colors` saem.

### D6. Catálogo

`gja/widgets/gja-app` passa a `implemented`. As dependências do `[Integração]` são `gja-theme`,
`core/localization`, `core/interaction`, `core/overlay` e `core/responsive`.

## Risks / Trade-offs

- [A densidade recomendada por plataforma erra em notebooks com toque] → A aplicação informa `density`. O padrão segue
  o UI5 (compacto em desktop).
- [Repassar só parte das propriedades do `WidgetsApp`] → As ausentes podem ser acrescentadas sem quebra quando um caso
  real pedir.
- [A transição lê o tema do contexto do `Navigator`] → O `builder` do `WidgetsApp` envolve o `Navigator`, então o
  `GjaTheme` está acima do contexto do `Navigator`. O teste "Meio da transição" confirma.

## Migration Plan

A galeria migra na própria change. Aplicações não existem ainda.
