# Design: GjaText

## Context

`GjaThemeData.of(context)` publica, entre outros:
- a tipografia: `display`, `headline`, `title`, `subtitle`, `body`, `bodyStrong`, `label` e `caption`, sem cor;
- as cores `text`, `label` e `stateColors(state).foreground`. O contraste delas sobre `base` e `background` já é
  verificado por `gjaCheckContrast`.

A densidade não altera a tipografia (spec `density`, "Tipografia preservada").

`gja_widgets` tem `GjaTheme` e `GjaApp`, mas nenhum widget com aparência. Ainda não há goldens no projeto. A
galeria carrega a Inter nos testes com `FontLoader` (`apps/gja_gallery/test/support/inter_font.dart`).

O pipeline do GitHub roda em `ubuntu-latest` (`tool/ci.sh`), e o desenvolvimento local roda em Windows
(`tool/ci.ps1`). O rasterizador produz pixels diferentes em cada sistema.

## Goals / Non-Goals

**Goals:**
- widget de texto só com tokens;
- truncamento e semântica consistentes;
- primeira infraestrutura de goldens.

**Non-Goals:**
- texto selecionável ou rico;
- links;
- indicador de vazio;
- referência de goldens para Linux nesta change.

## Decisions

### D1. API

```dart
enum GjaTextVariant { display, headline, title, subtitle, body, bodyStrong, label, caption }
enum GjaTextTone { standard, muted, success, warning, error, information }

class GjaText extends StatelessWidget {
  const GjaText(this.data, {super.key, this.variant = GjaTextVariant.body,
      this.tone = GjaTextTone.standard, this.maxLines, this.textAlign = TextAlign.start, this.heading})
    : assert(maxLines == null || maxLines > 0, '"maxLines" deve ser maior que zero');
}
```

Os nomes das variantes são os dos estilos semânticos de `gja/foundation/typography`. Os tons são enumerados, e
não uma cor livre, para que todo texto passe pela verificação de contraste. O `assert` no construtor `const` funciona
porque compara um `int`.

### D2. Construção

```dart
final theme = GjaThemeData.of(context);
final style = theme.typography.<variant>.copyWith(color: <cor do tone>);
final isHeading = heading ?? variant in {display, headline, title};
Semantics(header: isHeading, child: Text(data, style: style, maxLines: maxLines,
    overflow: maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
    textAlign: textAlign, softWrap: true))
```

O mapeamento de `tone` é:
- `standard` → `colors.text`;
- `muted` → `colors.label`;
- os quatro estados → `colors.stateColors(GjaValueState.x).foreground`.

O `Text` nativo já expõe o texto completo à semântica, mesmo com reticências, e aplica o `textScaler` da
`MediaQuery`. A troca de tema não exige estado: o widget lê o tema a cada build, e o `GjaTheme` o reconstrói.

### D3. Infraestrutura de goldens

- `packages/gja_widgets/test/support/fonts.dart`: `loadGjaFonts()` registra a Inter, com o nome de família
  `packages/gja_foundation/Inter`, o mesmo que a tipografia usa, a partir dos arquivos de `gja_foundation`.
- `packages/gja_widgets/test/support/golden.dart`: `goldenSurface(theme, child)` monta `GjaTheme` e
  `Directionality`, com fundo `base`, num tamanho fixo e `devicePixelRatio` 1. `expectGolden(tester, name)` chama
  `matchesGoldenFile('goldens/$name.png')`.
- `packages/gja_widgets/dart_test.yaml` declara a etiqueta `golden`.
- Os goldens de `GjaText` são quatro: `gja_text_{light,dark}_{comfortable,compact}.png`. Cada um mostra as oito
  variantes, os seis tons e um texto truncado.
- **Pipeline:**
  - `tool/ci.sh` (Linux) executa `flutter test --exclude-tags golden` no pacote;
  - `tool/ci.ps1` (Windows) executa tudo;
  - a referência é gerada com `flutter test --update-goldens --tags golden` no Windows.
- **ADR 0008, "Goldens com referência no Windows (provisório)":**
  - registra a decisão;
  - a alternativa futura: um job Linux com a referência própria, ou o pacote `alchemist` para goldens de CI sem
    texto real;
  - a condição de saída: o primeiro pipeline Linux com referência.

**Alternativa:** gerar a referência no Linux agora. Não há ambiente Linux disponível no protótipo (memória:
SDK local).

### D4. Testes e acessibilidade

O contraste usa `meetsGuideline(textContrastGuideline)` numa página com todos os tons sobre `base`, nos dois temas.
As diretrizes de alvo de toque não se aplicam, por não ser interativo. A escala 2,0 usa `MediaQuery` com
`textScaler: TextScaler.linear(2)` numa largura de 320, verificando `tester.takeException()` nulo e o
`fontSize` efetivo pelo `RenderParagraph`.

O cenário "Sem cor arbitrária" inspeciona a fonte do arquivo (`gja_text.dart`): o construtor público não pode ter
parâmetro dos tipos `Color`, `TextStyle` ou `TextSpan`.

### D5. Galeria e catálogo

- A página "GjaText" (`gja_text_page.dart`) lista as oito variantes, os seis tons e um parágrafo com
  `maxLines: 2`.
- O cenário da galeria tem nome próprio ("Página GjaText na galeria"), para não coincidir com o de outros widgets na
  verificação de rastreabilidade.
- No catálogo, `gja/widgets/gja-text` passa a `implemented`, com as dependências do `[Integração]` e o
  `proposed: true` mantido.

## Risks / Trade-offs

- [Goldens não são verificados no pipeline do GitHub até existir a referência Linux] → Os testes de widget cobrem
  estilo e cor por valor. O golden é a verificação visual extra, e o ADR 0008 marca a pendência.
- [Diferenças de antialiasing entre máquinas Windows] → A referência é gerada e verificada na mesma máquina do
  protótipo. A tolerância padrão do `matchesGoldenFile` é mantida.

## Migration Plan

Widget novo; nada a migrar. As páginas da galeria podem passar a usar `GjaText` em changes futuras.
