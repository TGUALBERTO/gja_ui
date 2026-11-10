# Design: Espaçamento no modelo Fiori

## Context

`GjaSpacingTokens` (em `gja_foundation/lib/src/spacing/`) tem nove passos e quatro papéis. O getter `values` (ou
equivalente) alimenta o diagnóstico, e o teste de `GjaSpace` compara os treze nomes. `GjaDensityTokens.compact()`
usa um `_compactSpacing` próprio, com passos e papéis reduzidos (`l` 12, `pageMargin` 12).

Uso de `pageMargin`:
- `GjaPage` usa `GjaSpace.pageMargin` via `GjaSpacing` (padding do conteúdo, da área de título e do rodapé);
- cerca de 18 páginas da galeria usam `spacing.pageMargin` direto.

`GjaBreakpointTokens.classify(width)` já classifica uma largura em `GjaSizeClass` (S < 600 ≤ M < 1024 ≤ L < 1440 ≤
XL), com os mesmos limites do SAPUI5.

Testes que dependem do espaçamento compacto reduzido:
- `density_test.dart`: "Espaçamento compacto" e a interpolação (`mid.spacing.m` 10);
- os testes de widgets de densidade por subárvore (coluna, linha, contêiner, divisor, `GjaSpacing`, página). Eles
  comparam com `compact.spacing.<passo>`, então continuam passando, mas os que exigem valores diferentes entre as
  densidades precisam ser revistos.

## Goals / Non-Goals

**Goals:**
- Margem de página responsiva na `GjaPage`, como a `sap.f.DynamicPage`.
- Espaçamento igual nas duas densidades, como as classes de margem do Fiori.
- Nenhuma mudança na API de `GjaSpacing` e `GjaSpace`.

**Non-Goals:**
- Resolver `pageMargin` no tema pela largura da janela (ver D3).
- Margens responsivas em `GjaSpacing` ou nas páginas da galeria.

## Decisions

### D1. Margens por classe

`GjaSpacingTokens` ganha `pageMarginMedium`, `pageMarginLarge` e `pageMarginExtraLarge`, obrigatórios no construtor
e incluídos em `copyWith`, `lerp`, `==`, `hashCode`, diagnóstico e validação (finitos e ≥ 0). O método é este:

```dart
double pageMarginFor(GjaSizeClass sizeClass) => switch (sizeClass) {
  GjaSizeClass.small => pageMargin,
  GjaSizeClass.medium => pageMarginMedium,
  GjaSizeClass.large => pageMarginLarge,
  GjaSizeClass.extraLarge => pageMarginExtraLarge,
};
```

Na referência, os valores são `space16`, `space32`, `space32` e `space48`. Os três campos novos ficam fora do mapa de
passos e papéis que corresponde a `GjaSpace` (treze nomes), para que `GjaSpacing` continue com a mesma API.

### D2. Espaçamento único nas densidades

`GjaDensityTokens.compact()` passa a usar `const GjaSpacingTokens.fallback()`, e `_compactSpacing` é apagado. A
spec de densidade continua exigindo que o compacto não seja maior que o cozy, o que vale com valores iguais.

Alternativa considerada: manter o compacto reduzido só nos passos internos (`xs`, `s`, `m`). Rejeitada porque o Fiori
não tem uma escala de espaçamento por densidade. As diferenças internas de cada controle compacto, como o padding de
um item de lista, ficam nos tokens de componente de cada widget, quando aparecerem.

### D3. Onde resolver a margem responsiva

`GjaPage` envolve o conteúdo num `LayoutBuilder` e usa
`spacing.pageMarginFor(theme.breakpoints.classify(constraints.maxWidth))`. A área de título e o rodapé usam a mesma
margem, para alinhar o título ao conteúdo, como na `DynamicPage`.

Alternativa considerada: resolver `spacing.pageMargin` dentro de `GjaThemeData.of` pela largura da janela. Rejeitada
por três motivos:
- todo leitor do tema passaria a depender do tamanho da janela e seria reconstruído a cada redimensionamento;
- comparações de tema por igualdade quebrariam acima de S;
- a `DynamicPage` usa a largura da própria página, e não a da janela.

### D4. Galeria e testes

- A página "Espaçamentos" ganha uma seção "Margem de página" com S, M, L e XL.
- Os testes de widgets que exigem espaço compacto menor que o cozy passam a exigir igualdade, ou a comparar com os
  tokens.
- `density_test.dart` confere que o compacto usa o espaçamento de referência.

### D5. ADR 0009

Nova linha provisória: margens de página 16/32/32/48. A referência é `sapUiResponsivePadding` e o padding da
`DynamicPage` (S 1rem, M/L 2rem, XL 3rem), cujos valores exatos do Horizon não foram confirmados.

## Risks / Trade-offs

- **[Compactos mais espaçados]** Telas compactas ficam mais altas, porque os espaços voltam aos do cozy. → É o
  comportamento do Fiori. Os controles continuam menores pelas alturas de elemento.
- **[Páginas da galeria com margem S]** As páginas que não usam `GjaPage` não ficam responsivas. → Registrado no
  escopo, e a correção fica para a change da galeria.
- **[Margem de 48 em XL]** Telas largas ganham mais respiro lateral. Os goldens de página usam uma largura de captura
  fixa e são regerados.
