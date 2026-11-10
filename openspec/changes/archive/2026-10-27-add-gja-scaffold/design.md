# Design: GjaScaffold

## Context

Peças já disponíveis:
- **Núcleo:**
  - `GjaResponsive.screenSizeClassOf(context)`, que dá a classe pela tela, com os limiares do tema;
  - `GjaInteractable`, que cuida dos estados, da ativação por toque e teclado, do alvo mínimo, do anel de foco e
    da semântica de botão (`semanticLabel`, `selected`). Ele não expõe o estado expandido;
  - `GjaLocalizations`, hoje sem um texto para a navegação.
- **Fundamentos:**
  - `colors.shell`, `colors.base`, `colors.separator`;
  - `elevation.header`, `motion.medium`, `motion.standard`;
  - `GjaControlColors.of(colors, GjaControlFamily.transparent)`;
  - `GjaIcons.menu`.

  `GjaThemeData.of` já zera as durações com movimento reduzido.
- **Widgets:**
  - `GjaContainer`, que já tem `GjaSurface.shell` e `GjaElevation.header`;
  - `GjaDivider.vertical` com tom `subtle`;
  - `GjaIcon`, `GjaText`, `GjaRow`, `GjaSpacing.padding`.

O tokens check proíbe valores literais de largura e altura em `gja_widgets/lib`. Por isso, a largura da
navegação vem do próprio conteúdo, e a altura da barra vem do alvo mínimo do botão mais os espaços do tema.

## Goals / Non-Goals

**Goals:**
- moldura de aplicação no modelo do `ToolPage`;
- navegação expandida ou recolhida ao lado do corpo, ou sobre o corpo no `small`;
- estado controlado ou automático pela classe da tela;
- botão de navegação acessível e localizado;
- RTL.

**Non-Goals:**
- o widget de navegação lateral;
- ações prontas (pesquisa, perfil, notificações);
- cabeçalho e rodapé de página;
- Esc ou toque fora para fechar a navegação;
- migrar as páginas da galeria.

## Decisions

### D1. API

```dart
class GjaScaffold extends StatefulWidget {
  const GjaScaffold({required this.body, this.title, this.logo, this.actions = const [],
      this.navigation, this.navigationExpanded, this.onNavigationExpandedChanged, super.key});
  static bool? navigationExpandedOf(BuildContext context);
}
```

`navigationExpanded` nulo significa o modo automático, e não "recolhido". Assim, o padrão por classe funciona sem
código na aplicação, e quem precisa fechar a navegação após uma escolha (no `small`) passa a controlar o estado.
Isso segue a regra "controlado primeiro" do design da Fase 0.

**Alternativa:** um controlador (`GjaScaffoldController`). Foi descartada por ora, porque um `bool` e um callback
cobrem os casos, como o `sideExpanded` do UI5.

`navigationExpandedOf` é lido por um `InheritedWidget` privado que envolve todo o scaffold. A futura
`GjaSideNavigation` o usa para desenhar a forma expandida ou recolhida.

### D2. Estado automático

O `State` guarda `_override` (`bool?`) e a última classe da tela:
- Em `didChangeDependencies`, se a classe mudou, `_override` volta a `null`.
- O estado em vigor é `widget.navigationExpanded ?? _override ?? sizeClass >= large`.
- O botão calcula `next = !expanded`. Sem controle, ele faz `setState(() => _override = next)`. Nos dois modos,
  ele chama `onNavigationExpandedChanged?.call(next)`.

### D3. Layout e pintura

- O corpo fica num `KeyedSubtree` com uma `GlobalKey` do `State`. Assim, o estado dele é preservado quando a
  estrutura muda entre `small` e as demais classes, ou quando a navegação cobre o corpo.
- **`medium` e acima:** um `Row` com:
  - a navegação num `GjaContainer(surface: base)`, envolvida por um `AnimatedSize` (`motion.medium`,
    `motion.standard`, alinhado ao início);
  - `GjaDivider.vertical` sutil;
  - `Expanded(body)`.
- **`small`:** um `Stack`. O corpo fica em `Visibility(visible: !expanded, maintainState: true)`, que o tira da
  pintura, do foco e da semântica sem descartar o estado. A navegação expandida fica em `Positioned.fill`.
- **Barra:** `GjaContainer(surface: shell, elevation: header)`, com `GjaSpacing.padding` (horizontal `m`,
  vertical `xs`) e um `GjaRow` (gap `s`) com:
  - o botão;
  - o logo;
  - o título (`GjaText` `title`, num `Flexible`, com uma elipse);
  - um espaço flexível;
  - as ações.
- **Pintura da sombra:** para que a sombra da barra fique sobre o corpo, a coluna externa usa
  `verticalDirection: up`, com `[área, barra]`. O corpo é pintado antes e a barra depois, por cima.

  A ordem de foco e a da semântica seguem a geometria (barra acima), e o cenário "Ordem de foco no scaffold" a
  verifica. Se a política de leitura não bastar, a barra entra num `FocusTraversalGroup` com
  `FocusTraversalOrder` antes da área.

  **Alternativa:** um `RenderObject` próprio. Foi descartada, porque os widgets nativos bastam.

### D4. Botão de navegação

Fica num `MergeSemantics`, que contém um `Semantics(expanded: …)` e o
`GjaInteractable(semanticLabel: localizations.navigation, …)`. O `MergeSemantics` reúne o estado expandido e o
botão num só nó. Assim, `GjaInteractable` não muda.

O conteúdo é um `GjaIcon(GjaIcons.menu)` com a cor de `GjaControlColors.resolve(states)` da família
`transparent`. O fundo é desenhado como nos estados de interação, com a opacidade de `interaction`.

### D5. Localização

Novo getter abstrato `String get navigation` em `GjaLocalizations`: "Navegação" em pt-BR e "Navigation" em en.
A subclasse `_Es` do teste de extensão ganha o getter.

Um getter abstrato é a regra dos textos tipados, que não fixam texto no código. A mudança quebraria subclasses
externas, mas não há nenhuma, porque o projeto é um protótipo.

### D6. Testes, galeria e catálogo

- **Medidas:** com a janela de teste ajustada por classe (500, 800, 1200, 1500) e `getRect`. A navegação de teste
  é um `SizedBox` cuja largura vem de `navigationExpandedOf` (240 ou 64), o que também exercita a API.
- **Goldens:** 1200 × 480, com barra (logo, título, duas ações), navegação expandida e corpo. São gerados nos temas
  claro e escuro × confortável e compacto, pelo `expectGolden`, com a tag `golden`.
- **Contraste e alvo:** num arquivo separado, sem a fonte Inter, como nos demais widgets.
- **Rastreabilidade:** 23 cenários da spec do widget. O cenário novo da localização ganha teste em
  `gja_core/test/localization`.
- **Galeria:** página "GjaScaffold" (`gja_scaffold_page.dart`) com um scaffold de demonstração ocupando a página:
  - logo e título "Compras";
  - uma ação;
  - uma navegação simples (itens em `GjaText`/`GjaIcon`, recolhidos só em ícones);
  - um corpo com texto.

  O cenário da galeria se chama "Página GjaScaffold na galeria". As demais páginas não mudam.
- **Catálogo:** `implemented`, com as dependências dos dois requisitos `[Integração]`. `gja-responsive-layout` sai
  da lista.

## Risks / Trade-offs

- [`verticalDirection: up` pode surpreender quem lê o código] → Um comentário explica, e o teste de ordem de foco
  protege o comportamento.
- [Getter abstrato novo quebra subclasses externas de `GjaLocalizations`] → Não há subclasses externas no
  protótipo. Quando houver consumidores, textos novos precisarão de um padrão em inglês ou de uma nota de migração.
- [A navegação define a própria largura] → Sem `GjaSideNavigation`, cada aplicação escolhe a largura. A Fase 2
  fixa as larguras como tokens de componente da navegação.
- [Sem Esc nem toque fora no `small`] → A navegação só fecha pelo botão ou pelo estado controlado. Fica para uma
  change futura com `gja/core/overlay`.

## Migration Plan

Widget novo. A única mudança em código existente é o texto `navigation` da localização, sem migração no repositório.
