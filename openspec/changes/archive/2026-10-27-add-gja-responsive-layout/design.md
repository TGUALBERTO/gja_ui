# Design: GjaResponsiveLayout

## Context

`gja_core` (spec `gja/core/responsive`, com os limiares do tema desde `add-gja-theme`) oferece:
- `GjaResponsive.screenSizeClassOf(context)`: a classe da tela. Sob o `GjaScreenSizeScope` que o `GjaApp`
  insere, quem a lê só é reconstruído quando a classe muda.
- `GjaResponsiveBuilder(builder: (context, sizeClass) => …)`: a classe da largura máxima disponível, por
  `LayoutBuilder`.
- `GjaResponsiveValue<T extends Object>`: valor por classe, com herança da classe menor e igualdade por valor.

Os três usam os limiares do tema ativo quando não recebem outros.

## Goals / Non-Goals

**Goals:**
- um construtor por classe com herança;
- base contêiner ou tela;
- reconstrução só na troca de classe, quando a base é a tela.

**Non-Goals:**
- colunas flexíveis;
- grade;
- animação;
- preservar estado entre layouts.

## Decisions

### D1. API

```dart
enum GjaLayoutBasis { container, screen }

class GjaResponsiveLayout extends StatelessWidget {
  const GjaResponsiveLayout({super.key, required this.small, this.medium, this.large, this.extraLarge,
      this.basis = GjaLayoutBasis.container});
}
```

`container` é o padrão porque um layout costuma estar dentro de um painel, cartão ou coluna, e o que importa é o
espaço dele, como nos controles responsivos do UI5. `screen` serve à estrutura da página, como o `GjaScaffold`.

### D2. Implementação sobre o núcleo

```dart
final builders = GjaResponsiveValue<WidgetBuilder>(small: small, medium: medium, large: large,
    extraLarge: extraLarge);
return switch (basis) {
  GjaLayoutBasis.container =>
    GjaResponsiveBuilder(builder: (context, sizeClass) => builders.resolve(sizeClass)(context)),
  GjaLayoutBasis.screen => builders.resolve(GjaResponsive.screenSizeClassOf(context))(context),
};
```

A herança, a classificação e os limiares do tema vêm prontos do núcleo, sem lógica nova.

Com a base `screen`, a dependência é do escopo de tela. Sob o `GjaApp`, a reconstrução só ocorre na troca de classe.

Com a base `container`, o `LayoutBuilder` reconstrói quando as restrições mudam. O construtor escolhido só muda
quando a classe muda.

### D3. Testes

- **Larguras controladas:** com `SizedBox` e `tester.view.physicalSize`.
- **Conteúdo exibido:** os construtores retornam textos com o nome da classe, e o teste usa `find.text` para saber
  qual está na tela.
- **Limiares do tema:** os testes usam `GjaThemeScope` com `breakpoints.copyWith(medium: 480)`.
- **Densidade:** os testes usam `GjaTheme.density`.
- Não há goldens, por não haver pintura.
- **Rastreabilidade:** 14 cenários.

### D4. Galeria e catálogo

- A página "GjaResponsiveLayout" (`gja_responsive_layout_page.dart`) mostra o mesmo formulário de exemplo duas
  vezes, nas bases `screen` e `container`. O exemplo é feito com `GjaColumn`/`GjaRow` e `GjaContainer`:
  - em `small`, uma coluna;
  - a partir de `medium`, duas colunas.

  O exemplo de base `container` fica num painel de 400 de largura, e por isso continua com uma coluna mesmo em tela
  larga.
- O cenário da galeria se chama "Página GjaResponsiveLayout na galeria".
- No catálogo, a entrada passa a `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [O estado de campos se perde ao trocar de layout] → Está documentado como fora do escopo. Aplicações que precisam
  preservar valores os mantêm em controladores acima do layout (ADR 0006, estado controlado).
- [Construtores como funções impedem `const`] → É o mesmo padrão de `LayoutBuilder` e `WidgetsApp.routes`.

## Migration Plan

Widget novo; nada a migrar.
