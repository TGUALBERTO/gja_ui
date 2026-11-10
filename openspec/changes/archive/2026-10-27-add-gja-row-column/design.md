# Design: GjaRow e GjaColumn

## Context

`GjaSpacing.resolve(spacing, GjaSpace)` converte um passo ou papel no valor do tema (`add-gja-spacing`). O
espaçamento ativo vem de `GjaThemeData.of(context).spacing` e muda com a densidade.

O Flutter 3.32 tem o parâmetro nativo `spacing` em `Flex`/`Row`/`Column` (desde 3.27). Ele coloca o espaço só entre os
filhos, inclusive com `MainAxisAlignment.spaceBetween` e com `Expanded`, sem filhos extras. `Wrap` tem `spacing` e
`runSpacing`.

A pasta de cada widget, que o `gja_checks catalog` exige, é `fundacao_layout/row` e `fundacao_layout/column`.

## Goals / Non-Goals

**Goals:**
- espaço nomeado entre filhos, sem nas pontas;
- alinhamentos por enum;
- ajuste ao conteúdo;
- quebra na linha;
- uma única implementação para os dois eixos.

**Non-Goals:**
- grade;
- layout por classe de tamanho;
- rolagem;
- divisores;
- coluna com quebra.

## Decisions

### D1. API

```dart
enum GjaMainAlignment { start, center, end, spaceBetween }
enum GjaCrossAlignment { start, center, end, stretch }

class GjaRow extends StatelessWidget {
  const GjaRow({super.key, required this.children, this.gap = GjaSpace.inlineGap,
      this.mainAlignment = GjaMainAlignment.start, this.crossAlignment = GjaCrossAlignment.center,
      this.shrinkWrap = false});
  const GjaRow.wrap({super.key, required this.children, this.gap = GjaSpace.inlineGap,
      this.mainAlignment = GjaMainAlignment.start});
}

class GjaColumn extends StatelessWidget {
  const GjaColumn({super.key, required this.children, this.gap = GjaSpace.stackGap,
      this.mainAlignment = GjaMainAlignment.start, this.crossAlignment = GjaCrossAlignment.start,
      this.shrinkWrap = false});
}
```

Os padrões seguem o uso mais comum:
- **Linha:** itens centralizados na vertical, com `inlineGap`, como ícone e rótulo;
- **Coluna:** itens alinhados ao início, com `stackGap`, como campos de formulário.

Os enums têm só os alinhamentos do Fiori `FlexBox` mais usados. `spaceAround` e `spaceEvenly` ficam de fora até haver
caso de uso. `baseline` fica de fora porque só vale no eixo horizontal e pede a base do texto.

### D2. Implementação

- Os enums ficam em `fundacao_layout/flex/gja_flex_alignment.dart`, exportado.
- `fundacao_layout/flex/gja_flex_layout.dart` não é exportado. Ele contém
  `Widget buildGjaFlex(BuildContext, {required Axis axis, ...})`, que monta:

  ```dart
  Flex(direction: axis, spacing: GjaSpacing.resolve(theme.spacing, gap),
       mainAxisAlignment: <map>, crossAxisAlignment: <map>,
       mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max, children: children)
  ```

- `GjaRow` e `GjaColumn` chamam essa função com `Axis.horizontal` e `Axis.vertical`.
- `GjaRow.wrap` monta
  `Wrap(spacing: v, runSpacing: v, alignment: <WrapAlignment de mainAlignment>, children: children)`.

  Um `assert` no `build` rejeita filhos `Flexible`/`Expanded`, com mensagem que cita `GjaRow.wrap`. O `Wrap` não
  sabe dimensioná-los, e o erro nativo seria menos claro.
- O `Flex` resolve `start`/`end` pela `Directionality`. O espaço não depende da escala de texto, porque vem só da
  densidade.

**Alternativa:** intercalar `GjaSpacing.horizontal/vertical` entre os filhos. Ela foi rejeitada porque
`spaceBetween` distribuiria o espaço livre também em volta dos separadores. O `spacing` nativo trata isso
corretamente.

### D3. Testes

- As medidas são verificadas com `getRect`.
- **Semântica:** o teste compara os rótulos com `Row`/`Column` nativos.
- **Restrições:** os testes inspecionam a fonte dos construtores. Um teste extra cobre o `assert` de filho expansível em
  `GjaRow.wrap`.
- **Rastreabilidade:** um teste por spec, com 17 cenários para a linha e 16 para a coluna. Os nomes não se repetem
  entre as specs.
- Não há goldens, por não haver pintura.

### D4. Galeria e catálogo

- A página "GjaRow e GjaColumn" (`gja_row_column_page.dart`) mostra:
  - as linhas com os quatro alinhamentos principais;
  - uma linha com `Expanded`;
  - um `GjaRow.wrap` em largura estreita;
  - as colunas com os quatro alinhamentos cruzados;
  - uma coluna com `Expanded`.

  Os blocos são `GjaContainer` com `surface: base` e borda.
- No catálogo, as duas entradas passam a `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [`spacing` do `Flex` é recente (3.27)] → O baseline do protótipo é 3.32 (ADR 0001). Uma aplicação em SDK mais antigo
  não compila, o que já é coberto pela restrição de SDK do pacote.
- [Sem `baseline` na linha] → Rótulo e texto em `crossAlignment: center` costumam bastar. Se faltar, entra numa change
  futura com spec.

## Migration Plan

Widgets novos; nada a migrar. As páginas da galeria podem trocar `Row`/`Column` com `GjaSpacing` por estes widgets em
changes futuras.
