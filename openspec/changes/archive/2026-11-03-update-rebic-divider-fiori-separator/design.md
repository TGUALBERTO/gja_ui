# Design: Separador no modelo do SAPUI5

## Context

- `RebicDivider` (`fundacao_layout/divider/rebic_divider.dart`) desenha um `ColoredBox` com a espessura
  `BorderSide().width` dentro de um `Padding` com `spacing` no eixo cruzado e `indent`/`endIndent` nas pontas. O
  vertical usa `height: double.infinity` e depende do pai para ter altura. Fica dentro de `ExcludeSemantics`.
- Usos no framework, todos `const RebicDivider()` horizontal e sutil: linha entre cabeçalho e conteúdo do
  `RebicCard`, separador de seção da lista de opções (dropdown e menu, `startsSection`) e as duas linhas do
  `RebicPopover`. `spacing`, `indent`, `endIndent`, `strong` e o vertical só aparecem na galeria.
- `RebicDensityTokens` tem `controlHeight`, `listItemHeight`, `minTargetSize` e `barHeight`; a escala primitiva vai
  de 26 a 48.

Veja proposal.md para o `sap.m.ToolbarSeparator` conferido.

## Goals / Non-Goals

**Goals:**
- Nome, API e medidas do `sap.m.ToolbarSeparator`.
- Nenhuma mudança visual nos widgets que já usam a linha horizontal.

**Non-Goals:**
- O separador no menu "mais" do `sap.m.OverflowToolbar`.
- Separadores de lista (`showSeparators` do `sap.m.List`), que entram com a lista.

## Decisions

### D1. `RebicSeparator` sem propriedades

```dart
class RebicSeparator extends StatelessWidget {
  const RebicSeparator({super.key}) : _axis = Axis.horizontal;
  const RebicSeparator.vertical({super.key}) : _axis = Axis.vertical;
}
```

O arquivo passa a `fundacao_layout/separator/rebic_separator.dart`, e a exportação troca no `rebic_widgets.dart`.
Não há typedef de compatibilidade: o Rebic é um protótipo, e os quatro usos internos mudam na mesma change.

Alternativa considerada: manter `spacing` como atalho. Rejeitada porque o UI5 não tem essa propriedade; o espaço
vem do contêiner (`RebicColumn.spacing`, o espaço entre itens do `RebicBar`, `RebicSpacing`), como as classes de
margem do UI5.

### D2. Tom único

A linha usa sempre `colors.separator`. O tom `strong` (`fieldBorder`) sai: as linhas do UI5 usam
`sapToolbar_SeparatorColor`, `sapList_BorderColor` ou `sapGroup_ContentBorderColor`, todas claras. Uma linha de
estrutura mais escura, se for preciso (como o `sapGroup_TitleBorderColor` sob títulos de grupo), entra com o widget
que a usa, com papel de cor próprio.

### D3. Altura do vertical

`RebicDensityTokens` ganha `separatorHeight`: `size32` no cozy e `size24` no compacto, com o primitivo novo
`RebicDensityPrimitives.size24` na escala e no mapa `sizes`. A dimensão entra em `dimensions`, `copyWith`, `lerp`,
`==` e `hashCode`, como `barHeight`.

O vertical é `Center(child: SizedBox(width: linha, height: density.separatorHeight, child: ColoredBox(...)))`. O
`Center` faz o separador ficar com a altura da densidade mesmo quando o pai impõe a altura (um `RebicRow` com
`stretch`), e o centraliza nessa altura, como o `align-items: center` da barra do UI5. Na largura, sem limite dentro
de uma linha, o `Center` encolhe para a largura da linha fina.

O horizontal continua `SizedBox(height: linha, width: double.infinity)`.

### D4. Espessura e semântica

A espessura continua `const BorderSide().width` (1, o `sapElement_BorderWidth` de 0,0625rem), a mesma da borda do
`RebicContainer`. O separador continua em `ExcludeSemantics`: o `SemanticsRole` do Flutter não tem `separator`, e um
nó sem rótulo nem papel não acrescentaria nada ao leitor de tela.

### D5. Galeria

A página "RebicSeparator" (rota própria, no lugar da do divisor) mostra uma coluna de textos com separadores
horizontais e um `RebicBar` com ações separadas por `RebicSeparator.vertical()`. A página do card troca
`RebicDivider()` por `RebicSeparator()`.

## Risks / Trade-offs

- **[Quebra de API]** → os usos fora do framework não existem (o portal não adota o Rebic). O CHANGELOG traz o de/para.
- **[Goldens]** → os do card, do menu, do dropdown e do popover não devem mudar, porque a linha horizontal é a mesma;
  qualquer diferença nesses goldens indica regressão. Os goldens do separador são novos e os do divisor saem.
- **[O vertical não estica mais]** → quem precisar de uma linha da altura toda usa a borda de um `RebicContainer`,
  como o UI5 usa bordas de contêiner.
