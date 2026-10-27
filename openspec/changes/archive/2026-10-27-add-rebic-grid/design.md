# Design: RebicGrid

## Context

Já existem as peças de que a grade precisa:
- **Núcleo** (`rebic/core/responsive`):
  - `RebicResponsiveValue<T extends Object>`, com herança da classe menor;
  - `RebicResponsiveBuilder`, que dá a classe pela largura disponível;
  - `RebicResponsive.screenSizeClassOf`, que dá a classe pela tela.

  Todos usam os limiares do tema ativo.
- **Widgets:**
  - `RebicLayoutBasis` (`container`/`screen`), de `add-rebic-responsive-layout`;
  - `RebicSpace` e `RebicSpacing.resolve`;
  - `RebicRow`, `RebicColumn`.

A regra "uma spec nunca cobre mais de um widget público" impede um `RebicGridItem` como widget na mesma spec.

## Goals / Non-Goals

**Goals:**
- grade de 12 colunas com span por classe e herança;
- span por item;
- fluxo em linhas determinístico;
- espaço nomeado;
- RTL.

**Non-Goals:**
- `indent`;
- ocultar por classe;
- altura igual na linha;
- número de colunas configurável;
- virtualização.

## Decisions

### D1. API

```dart
@immutable
class RebicGridCell {
  const RebicGridCell({required this.child, this.span});
  final Widget child;
  final RebicResponsiveValue<int>? span;
}

class RebicGrid extends StatelessWidget {
  static const columns = 12;
  static const standardSpan = RebicResponsiveValue(small: 12, medium: 6, large: 4, extraLarge: 3);
  RebicGrid({super.key, required List<Widget> children, this.defaultSpan = standardSpan,
      this.gap = RebicSpace.l, this.runGap = RebicSpace.l, this.basis = RebicLayoutBasis.container})
    : cells = [for (final c in children) RebicGridCell(child: c)];
  const RebicGrid.cells({super.key, required this.cells, this.defaultSpan = standardSpan, …});
}
```

`RebicGridCell` é uma classe de dados, e não um widget. Ela faz o papel do `GridData` do UI5, que é uma
configuração e não um controle, e mantém a regra de um widget público por spec.

`RebicGrid(children:)` não é `const`, porque converte os filhos em células. `RebicGrid.cells` é `const`.

`columns = 12` é uma constante pública, só para documentação e testes. Ela não é parâmetro.

### D2. Layout

1. A classe é obtida por `RebicResponsiveBuilder` (base `container`) ou por `screenSizeClassOf` (base `screen`).
2. A largura da grade vem de `LayoutBuilder`.
3. Cada span `n` é resolvido por `(cell.span ?? defaultSpan).resolve(sizeClass)`. Um `assert` exige
   `1 ≤ n ≤ 12`, com mensagem que cita o span e o índice da célula.
4. As linhas são montadas em ordem, acumulando spans: quando `usado + n > 12`, uma linha nova começa.
5. A largura de coluna é `c = (L − 11 × gap) / 12`, e a largura de um item é `n × c + (n − 1) × gap`.
6. Cada linha é um `Row` com `spacing: gap`, `crossAxisAlignment: start` e `mainAxisSize: min`, com os itens em
   `SizedBox(width: …)`. As linhas ficam numa `Column` com `spacing: runGap`, `crossAxisAlignment: start`.

O `Row` nativo respeita a `Directionality`, e por isso a primeira coluna fica à direita em RTL.

**Alternativa:** `Wrap` com larguras calculadas. Ela foi descartada porque erros de arredondamento podem levar o
último item para a linha seguinte. As linhas montadas explicitamente são determinísticas.

### D3. Testes

- **Medidas:** com `getRect`, em larguras escolhidas para cada classe (500, 800, 1200, 1500), com a janela de teste
  ajustada.
- **Assert:** um span 13 em `defaultSpan` (via `RebicGrid.cells`) é verificado com `takeException`.
- **Restrição:** o teste inspeciona a fonte dos construtores de `RebicGrid` e de `RebicGridCell`.
- Não há goldens, por não haver pintura.
- **Rastreabilidade:** 16 cenários.

### D4. Galeria e catálogo

- A página "RebicGrid" (`rebic_grid_page.dart`) tem:
  - seis cartões (`RebicContainer`) no `defaultSpan` padrão, com base `screen`, para acompanhar a janela;
  - uma segunda grade com uma célula de destaque (`span: small 12, large 8`) ao lado de uma comum.
- O cenário da galeria se chama "Página RebicGrid na galeria".
- No catálogo, a entrada passa a `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [`RebicGrid(children:)` não é `const`] → É raro precisar de `const`. `RebicGrid.cells` é `const` quando necessário.
- [Linhas com alturas diferentes entre itens] → Cada item tem a altura do próprio conteúdo, alinhado ao topo. Altura
  igual entra numa change futura, se houver uso.

## Migration Plan

Widget novo; nada a migrar.
