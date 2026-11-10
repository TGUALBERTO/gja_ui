# Design: GjaIcon

## Context

`gja_foundation` já entrega o que o ícone precisa:
- `GjaIcons`: 40 `IconData` da Lucide, com `matchTextDirection: true` nos 6 direcionais;
- `GjaIconTokens`: `small`, `medium`, `large`, `xLarge`, `inline` e `control`, sem variação por densidade;
- `GjaThemeData.of`;
- as cores `text`, `label`, `brand` e os `foreground` dos estados, com contraste já verificado por
  `gjaCheckContrast`. `brand` é verificado a ≥ 4,5:1 sobre `background` e `base`.

`GjaTheme` define `IconTheme` com a cor `text` e o tamanho `control`.

`gja_widgets` tem a infraestrutura de goldens da change `add-gja-text`: `test/support/fonts.dart`,
`test/support/golden.dart`, a etiqueta `golden` e o ADR 0008. O suporte de fontes só carrega a Inter.

O `Icon` nativo tem `semanticLabel`, `applyTextScaling` e espelhamento por `matchTextDirection`.

## Goals / Non-Goals

**Goals:**
- ícone só com tokens;
- decorativo por padrão;
- rótulo semântico opcional;
- `inline` alinhado à escala de texto.

**Non-Goals:**
- ícone clicável;
- dica;
- imagens ou SVG;
- tamanho ou cor livres.

## Decisions

### D1. API

```dart
enum GjaIconSize { small, medium, large, xLarge, inline, control }
enum GjaIconTone { standard, muted, brand, success, warning, error, information }

class GjaIcon extends StatelessWidget {
  const GjaIcon(this.icon, {super.key, this.size = GjaIconSize.control,
      this.tone = GjaIconTone.standard, this.semanticLabel});
}
```

`GjaIconTone` repete os tons de `GjaTextTone` e acrescenta `brand`, comum em ícones de destaque. São enums
separados porque um texto em `brand` não é um caso previsto: links terão o `GjaLink`. Os nomes dos tamanhos são os
papéis de `GjaIconTokens`.

### D2. Construção

```dart
final t = GjaThemeData.of(context);
final glyph = Icon(icon, size: t.icons.<size>, color: <cor do tone>,
    applyTextScaling: size == GjaIconSize.inline);
return semanticLabel == null
    ? ExcludeSemantics(child: glyph)
    : Semantics(label: semanticLabel, image: true, excludeSemantics: true, child: glyph);
```

O espelhamento vem do próprio `Icon`, que respeita `matchTextDirection` do `IconData` e a `Directionality`. O papel
`inline` usa `applyTextScaling`, que multiplica o tamanho pelo `textScaler` da `MediaQuery`. Os outros papéis ficam
fixos, porque estão dentro de controles com altura definida pela densidade.

### D3. Testes, goldens e fontes

- `test/support/fonts.dart`: `loadGjaFonts()` passa a carregar também a Lucide, com a família
  `packages/gja_foundation/Lucide`.
- **Goldens:** quatro imagens, `gja_icon_{light,dark}_{comfortable,compact}.png`, com:
  - uma linha por tamanho;
  - uma linha por tom;
  - `chevronRight` em LTR e em RTL.

  Elas usam a etiqueta `golden` e são geradas no Windows (ADR 0008).
- **Contraste:** é verificado por valor, com `gjaContrastRatioOver` de cada cor de tom sobre `base` e `background`.
  O `textContrastGuideline` mede só texto.
- **Escala:** `MediaQuery` com `TextScaler.linear(2)`. O teste compara o tamanho renderizado (`tester.getSize`) do
  `inline` com o dobro do token e o do `control` com o token.
- **RTL:** o teste compara a transformação do `RenderBox` do glifo com `matchTextDirection`. O `Icon` envolve o glifo
  num `Transform` de escala −1 no eixo x quando espelha, e o teste procura esse `Transform`.
- **Rastreabilidade:** 17 cenários, contra as suítes de `gja_widgets` e da galeria.

### D4. Galeria e catálogo

- A página "GjaIcon" (`gja_icon_page.dart`) tem:
  - os seis tamanhos com o nome;
  - os sete tons;
  - `GjaIcon(GjaIcons.warning, tone: warning, semanticLabel: 'Aviso')`;
  - `chevronRight` em LTR e dentro de `Directionality(rtl)`.
- O cenário da galeria se chama "Página GjaIcon na galeria".
- No catálogo, `gja/widgets/gja-icon` passa a `implemented`, com as dependências do `[Integração]` e o
  `proposed: true` mantido.

## Risks / Trade-offs

- [`inline` crescendo com a escala pode desalinhar em linhas de texto com altura fixa] → `inline` é para texto
  corrido, que também cresce. Controles usam `control`, que é fixo.
- [Dois enums de tom quase iguais] → É intencional. Se outros widgets pedirem o mesmo conjunto, um `GjaContentTone`
  comum pode ser extraído numa change futura, com depreciação.

## Migration Plan

Widget novo; nada a migrar.
