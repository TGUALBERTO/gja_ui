# Design: RebicPage

## Context

Já existem:
- `RebicScaffold`, cujo corpo é um `Expanded` com altura limitada. Ele tem um botão interno privado
  (`_NavigationButton`) com:
  - `RebicInteractable`;
  - a família `transparent`;
  - o ícone pintado pela cor de texto do estado (`ColorFiltered`);
  - `MergeSemantics`.
- `RebicContainer` (`surface: base`), `RebicDivider`, `RebicText` (`headline` já é cabeçalho; tom `muted`),
  `RebicIcon`, `RebicRow`, `RebicColumn`, `RebicSpacing`.
- `RebicIcons.arrowLeft`, com `matchTextDirection`, que espelha a seta em RTL.
- `RebicLocalizations`, ainda sem o texto "voltar".

O tokens check proíbe dimensões literais em `rebic_widgets/lib`.

## Goals / Non-Goals

**Goals:**
- área de título no modelo do `sap.m.Page` (voltar, título, subtítulo, ações);
- conteúdo rolável ou de altura limitada;
- rodapé fixo de ações;
- margem do tema;
- RTL e acessibilidade.

**Non-Goals:**
- cabeçalho expansível ao rolar;
- margem por classe de tela;
- botões prontos;
- migrar a galeria.

## Decisions

### D1. API

```dart
class RebicPage extends StatelessWidget {
  const RebicPage({required this.title, required this.body, this.subtitle, this.onBack,
      this.actions = const [], this.padded = true, this.scrollable = true,
      this.footerActions = const [], super.key});
}
```

`StatelessWidget`: o estado da rolagem fica no `Scrollable`, e não há estado próprio.

### D2. Layout

`Column(crossAxisAlignment: stretch)` com quatro partes:
1. **Área de título:** `RebicContainer(surface: base)` com `RebicSpacing.padding(horizontal: pageMargin,
   vertical: m)` e um `RebicRow(gap: s)` com:
   - o botão de voltar;
   - `Expanded(RebicColumn(gap: xxs, [título headline maxLines 2, subtítulo body muted maxLines 1]))`;
   - as ações.
2. **Divisor** sutil.
3. **`Expanded` com o conteúdo:**
   - Com `scrollable`, o conteúdo fica num `SingleChildScrollView` vertical, com a margem por dentro
     (`RebicSpacing.padding(all: pageMargin)` quando `padded`).
   - Sem `scrollable`, o conteúdo recebe a altura do `Expanded`, com a margem por fora.
4. **Rodapé**, se houver ações: divisor e `RebicContainer(surface: base)` com padding `pageMargin`/`s`, e as ações
   num `RebicRow(mainAlignment: end, gap: s)`.

O `Row` e o `RebicRow` respeitam a `Directionality`. Em RTL, voltar fica à direita e as ações terminam à esquerda, sem
código próprio.

**Foco que revela o conteúdo:** o `SingleChildScrollView` e a política de foco padrão já chamam
`Scrollable.ensureVisible` quando um descendente recebe foco pelo teclado. O cenário verifica isso.

**Altura limitada:** `RebicPage` precisa de altura limitada, como corpo do `RebicScaffold` ou como `home` de uma
rota. Um `assert` com mensagem clara cobre o uso dentro de uma rolagem externa.

**Alternativa:** `CustomScrollView` com slivers, para um futuro cabeçalho expansível. Foi adiada, porque o cabeçalho
expansível está fora do escopo e o `SingleChildScrollView` é mais simples.

### D3. Botão interno compartilhado

O `_NavigationButton` do scaffold vira `RebicTransparentIconAction`, em
`lib/src/fundacao_layout/action/rebic_transparent_icon_action.dart`, não exportado. Ele recebe:
- `icon`;
- `semanticLabel`;
- `onPressed`;
- `expanded` (`bool?`), que adiciona o estado expandido à semântica quando não é nulo.

O scaffold passa a usá-lo com o mesmo comportamento: os testes e goldens do scaffold não mudam. A página o usa com
`RebicIcons.arrowLeft` e `localizations.back`.

**Alternativa:** duplicar o botão na página. Foi descartada, porque as duas cópias tenderiam a divergir até o
`RebicIconButton` (Fase 2), que absorverá o widget interno.

### D4. Localização

Novo getter abstrato `String get back`: "Voltar" em pt-BR e "Back" em en. A subclasse `_Es` do teste ganha
"Volver". O teste "Textos do framework — Texto de voltar" fica em `rebic_core/test/localization`.

### D5. Testes, galeria e catálogo

- **Medidas:** com `getRect` e a janela de teste ajustada. A rolagem é verificada com `tester.drag` no conteúdo.
- **Altura limitada sem rolagem:** um `LayoutBuilder` de teste no conteúdo registra `constraints.maxHeight`.
- **Goldens:** 800 × 600, com voltar, título, subtítulo, duas ações (`RebicIcon`), conteúdo com texto e duas ações de
  rodapé (`RebicText`). São gerados nos temas claro e escuro × confortável e compacto, com a tag `golden`. A
  superfície do `expectGolden` é `background`.
- **Acessibilidade:** semântica, contraste e alvo num arquivo sem a Inter.
- **Rastreabilidade:** 21 cenários.
- **Galeria:** página "RebicPage" (`rebic_page_page.dart`) construída com `RebicPage`:
  - `onBack: Navigator.maybePop`;
  - subtítulo e uma ação (ícone);
  - conteúdo com parágrafos sobre o uso;
  - rodapé com "Cancelar" e "Salvar" em `RebicText` tocável.

  O cenário se chama "Página RebicPage na galeria".
- **Catálogo:** `implemented`, com as dependências dos dois requisitos `[Integração]`, incluindo
  `rebic-scaffold`.

## Risks / Trade-offs

- [Refatorar o botão do scaffold pode mudar pixels] → Os goldens e testes do scaffold são executados sem atualização.
  Qualquer diferença é um erro da extração.
- [`SingleChildScrollView` constrói todo o conteúdo] → Isso é adequado para formulários e textos. Conteúdos longos
  com listas usam `scrollable: false` e a própria rolagem virtualizada.
- [Getter abstrato novo em `RebicLocalizations`] → Segue o precedente de `navigation`. Sem consumidores externos, não
  há impacto.
- [Título com duas linhas no máximo] → Títulos longos terminam com reticências. O texto completo continua na
  semântica.

## Migration Plan

Widget novo. As únicas mudanças em código existente são o texto `back` e a extração interna do botão do scaffold,
sem mudança de API pública.
