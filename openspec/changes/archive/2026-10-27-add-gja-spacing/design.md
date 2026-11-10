# Design: GjaSpacing

## Context

`GjaSpacingTokens` tem:
- os campos `none`, `xxs`, `xs`, `s`, `m`, `l`, `xl`, `xxl` e `xxxl`;
- os papéis `inlineGap`, `stackGap`, `sectionGap` e `pageMargin`.

O diagnóstico lista cada valor pelo nome, e o mapa `_values` é privado. O espaçamento ativo vem de
`GjaThemeData.of(context).spacing`, que é o da densidade (`density.spacing`). `GjaTheme.density` troca a densidade
de uma subárvore.

A verificação de tokens (`gja_checks tokens`) rejeita literais de espaçamento em `packages/gja_widgets/lib`.

`gja_widgets` tem `GjaTheme`, `GjaApp`, `GjaText` e `GjaIcon`, e a infraestrutura de goldens, que aqui não
se aplica.

## Goals / Non-Goals

**Goals:**
- espaço nomeado, sem literais;
- separadores horizontais e verticais que não afetam o eixo cruzado;
- padding com precedência clara e sensível à direção.

**Non-Goals:**
- espaço automático entre filhos;
- margem responsiva;
- fundo e borda;
- espaço negativo.

## Decisions

### D1. API

```dart
enum GjaSpace { none, xxs, xs, s, m, l, xl, xxl, xxxl, inlineGap, stackGap, sectionGap, pageMargin }

class GjaSpacing extends StatelessWidget {
  const GjaSpacing.horizontal(GjaSpace this.space, {super.key}) : axis = Axis.horizontal, child = null, …;
  const GjaSpacing.vertical(GjaSpace this.space, {super.key}) : axis = Axis.vertical, child = null, …;
  const GjaSpacing.padding({super.key, required Widget this.child, this.all, this.horizontal, this.vertical,
      this.start, this.end, this.top, this.bottom}) : space = null, axis = null;
}
```

Os separadores usam construtores nomeados, e não um construtor com eixo automático. Detectar o eixo pelo ancestral
`Flex` falharia dentro de listas e de `Wrap`, e o eixo explícito deixa claro onde o espaço entra. A classe é única,
com campos opcionais por construtor, para manter uma spec por widget (ADR 0007).

### D2. Resolução

- `GjaSpace` é convertido no valor com um `switch` exaustivo sobre `spacing`, em
  `GjaSpacing.resolve(GjaSpacingTokens, GjaSpace)`. O método é estático e público, para reuso por
  `GjaRow`/`GjaColumn`.
- `horizontal` gera `SizedBox(width: v)`, e `vertical` gera `SizedBox(height: v)`. A dimensão cruzada fica nula, e por
  isso o espaço não aumenta a altura de uma linha nem a largura de uma coluna.
- `padding` gera `Padding(padding: EdgeInsetsDirectional.only(start, end, top, bottom))`. Cada lado é
  `start ?? horizontal ?? all`, e assim por diante, com zero quando nada se aplica. O
  `EdgeInsetsDirectional` resolve início e fim pela `Directionality`.
- Os valores são lidos em `build` com `GjaThemeData.of(context)`. A troca de densidade reconstrói pelo escopo do
  tema.

### D3. Testes

- As medidas são verificadas com `tester.getSize`, `getTopLeft` e `getTopRight`.
- O cenário "Valores do fundamento" compara `GjaSpace.values.map((v) => v.name)` com os nomes das propriedades do
  diagnóstico de `GjaSpacingTokens.fallback()`.
- O cenário "Sem valor literal" inspeciona a fonte dos construtores.
- Não há goldens, por não haver pintura.
- **Rastreabilidade:** 17 cenários.

### D4. Galeria e catálogo

- A página "GjaSpacing" (`gja_spacing_page.dart`) tem:
  - para cada `GjaSpace`, uma barra com a largura do valor, preenchida com a cor `selectionBackground` e com o nome
    e o número ao lado;
  - um cartão com `GjaSpacing.padding(all: l)` na densidade confortável e outro sob
    `GjaTheme.density(compact)`.
- O cenário da galeria se chama "Página GjaSpacing na galeria".
- No catálogo, `gja/widgets/gja-spacing` passa a `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [Três construtores numa classe deixam campos sem uso em cada forma] → Os campos são privados à construção. O
  dartdoc de cada construtor descreve só os seus parâmetros.
- [Sem eixo automático, o separador errado não dá erro] → Um `vertical` numa `Row` só não acrescenta largura. O
  dartdoc e a galeria mostram o uso certo, e `GjaRow`/`GjaColumn` vão aplicar o espaço sozinhos.

## Migration Plan

Widget novo; nada a migrar. As páginas da galeria podem passar a usar `GjaSpacing` em changes futuras.
