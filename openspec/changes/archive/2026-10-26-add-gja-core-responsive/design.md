# Design: Responsividade

## Context

`gja_foundation` já tem:
- `GjaSizeClass` (`small` a `extraLarge`, com `isAtLeast`/`isAtMost`);
- `GjaBreakpointTokens`, com `classify(width)`, que trata 0, infinito e inválidos, e limiares 600/1024/1440 no
  `fallback()`;
- `GjaDensity` (`comfortable`, `compact`).

`gja_core` tem a interação e a localização. Ainda não existe tema propagado (`add-gja-theme`), e por isso os
valores visuais entram por parâmetro com o mapeamento de referência como padrão, como em `GjaInteractable`.

No Flutter 3.32, `MediaQuery` não tem aspecto só de largura: `MediaQuery.sizeOf` reconstrói também na mudança de
altura (teclado virtual, redimensionamento vertical).

O modelo do SAPUI5 tem quatro partes:
- `sap.ui.Device.media` classifica a janela em faixas;
- controles como o `ResponsiveGridLayout` reagem à largura do próprio contêiner;
- os spans `XL/L/M/S` herdam do menor para o maior;
- a densidade é compacta em dispositivos sem toque e confortável nos de toque.

## Goals / Non-Goals

**Goals:**
- classe da tela barata de ler, que reconstrói só quando a classe muda;
- classe do contêiner;
- valores por classe com herança;
- densidade recomendada.

**Non-Goals:**
- widgets de layout;
- orientação;
- detecção de toque em tempo real;
- propagação por tema.

## Decisions

### D1. `GjaResponsive` e o escopo da tela

```dart
abstract final class GjaResponsive {
  static GjaSizeClass screenSizeClassOf(BuildContext context,
      {GjaBreakpointTokens breakpoints = const GjaBreakpointTokens.fallback()});
  static GjaDensity recommendedDensity([TargetPlatform? platform]); // D4
}

class GjaScreenSizeScope extends StatelessWidget {
  const GjaScreenSizeScope({required Widget child,
      GjaBreakpointTokens breakpoints = const GjaBreakpointTokens.fallback()});
}
```

`GjaScreenSizeScope` funciona assim:
- lê `MediaQuery.sizeOf(context).width` e classifica com os seus `breakpoints`;
- publica o resultado num `InheritedWidget` privado, cujo `updateShouldNotify` compara só a classe;
- quem depende do escopo não é reconstruído quando a largura muda dentro da mesma classe, nem quando a altura muda;
- o escopo em si é reconstruído pelo `MediaQuery`, mas é barato.

`screenSizeClassOf` usa o escopo quando há um na árvore com os mesmos `breakpoints`. Sem escopo, ou com limiares
diferentes dos do escopo, ele classifica `MediaQuery.sizeOf(context).width` diretamente. Nesse caso, o resultado é
o mesmo, mas a dependência é do `MediaQuery`. `GjaApp` vai inserir o escopo; até lá, a galeria o insere no
`builder` do `WidgetsApp`.

**Alternativa:** um `InheritedModel` com aspectos. Ela é desnecessária: a classe é o único dado publicado.

### D2. `GjaResponsiveBuilder`

```dart
class GjaResponsiveBuilder extends StatelessWidget {
  const GjaResponsiveBuilder({required Widget Function(BuildContext, GjaSizeClass) builder,
      GjaBreakpointTokens breakpoints = const GjaBreakpointTokens.fallback()});
}
```

Ele usa um `LayoutBuilder` e classifica `constraints.maxWidth`, que pode ser infinito, resultando em `extraLarge`.
É o equivalente aos controles do UI5 que reagem à largura do contêiner.

### D3. `GjaResponsiveValue<T>`

```dart
@immutable
class GjaResponsiveValue<T> {
  const GjaResponsiveValue({required T small, T? medium, T? large, T? extraLarge});
  T resolve(GjaSizeClass sizeClass);
}
```

`resolve` desce a partir da classe pedida até achar um valor não nulo; `small` sempre tem valor. Como `T` pode ser
anulável, a ausência é guardada como `null` só nos opcionais, e `small` é obrigatório. O tipo implementa `==` e
`hashCode` pelos quatro campos.

O uso típico é `value.resolve(GjaResponsive.screenSizeClassOf(context))` ou, dentro do `GjaResponsiveBuilder`,
`value.resolve(sizeClass)`.

### D4. Densidade recomendada

`recommendedDensity([platform])` usa `defaultTargetPlatform` quando `platform` é nulo:
- `windows`, `macOS` e `linux` → `compact`;
- `android`, `iOS` e `fuchsia` → `comfortable`.

O `switch` é exaustivo sobre `TargetPlatform`, e por isso uma plataforma nova quebra a compilação até ser
classificada. Detectar toque em tempo real fica fora do escopo: o Flutter só sabe o tipo de ponteiro após o primeiro
evento, e a densidade precisa existir antes do primeiro quadro.

### D5. Galeria

- O `builder` do `WidgetsApp` envolve as rotas em `GjaScreenSizeScope`.
- A página "Responsividade" mostra:
  - a classe da tela (chave própria, para o teste);
  - um painel de 320 de largura com `GjaResponsiveBuilder`;
  - um `GjaResponsiveValue` de colunas (`small: 1, medium: 2, large: 3, extraLarge: 4`) resolvido pela tela, com
    blocos ilustrativos;
  - a densidade recomendada para a plataforma atual.

### D6. Catálogo

A spec referencia `gja/foundation/density`. A dependência entra no catálogo junto de `gja/foundation/breakpoints`.

## Risks / Trade-offs

- [Sem escopo, quem lê a classe reconstrói a cada mudança de tamanho] → O resultado continua correto, e `GjaApp`
  vai inserir o escopo por padrão. O dartdoc de `screenSizeClassOf` explica o custo.
- [A densidade por plataforma erra em notebooks com tela de toque] → É só a recomendação inicial. A aplicação define
  a densidade do tema.

## Migration Plan

Capacidade nova; nada a migrar.
