# Design: RebicRow e RebicColumn

## Context

`RebicSpacing.resolve(spacing, RebicSpace)` converte um passo ou papel no valor do tema (`add-rebic-spacing`). O
espaçamento ativo vem de `RebicThemeData.of(context).spacing` e muda com a densidade.

O Flutter 3.32 tem o parâmetro nativo `spacing` em `Flex`/`Row`/`Column` (desde 3.27). Ele coloca o espaço só entre os
filhos, inclusive com `MainAxisAlignment.spaceBetween` e com `Expanded`, sem filhos extras. `Wrap` tem `spacing` e
`runSpacing`.

A pasta de cada widget, que o `rebic_checks catalog` exige, é `fundacao_layout/row` e `fundacao_layout/column`.

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
enum RebicMainAlignment { start, center, end, spaceBetween }
enum RebicCrossAlignment { start, center, end, stretch }

class RebicRow extends StatelessWidget {
  const RebicRow({super.key, required this.children, this.gap = RebicSpace.inlineGap,
      this.mainAlignment = RebicMainAlignment.start, this.crossAlignment = RebicCrossAlignment.center,
      this.shrinkWrap = false});
  const RebicRow.wrap({super.key, required this.children, this.gap = RebicSpace.inlineGap,
      this.mainAlignment = RebicMainAlignment.start});
}

class RebicColumn extends StatelessWidget {
  const RebicColumn({super.key, required this.children, this.gap = RebicSpace.stackGap,
      this.mainAlignment = RebicMainAlignment.start, this.crossAlignment = RebicCrossAlignment.start,
      this.shrinkWrap = false});
}
```

Os padrões seguem o uso mais comum:
- **Linha:** itens centralizados na vertical, com `inlineGap`, como ícone e rótulo;
- **Coluna:** itens alinhados ao início, com `stackGap`, como campos de formulário.

Os enums têm só os alinhamentos do Fiori `FlexBox` mais usados. `spaceAround` e `spaceEvenly` ficam de fora até haver
caso de uso. `baseline` fica de fora porque só vale no eixo horizontal e pede a base do texto.

### D2. Implementação

- Os enums ficam em `fundacao_layout/flex/rebic_flex_alignment.dart`, exportado.
- `fundacao_layout/flex/rebic_flex_layout.dart` não é exportado. Ele contém
  `Widget buildRebicFlex(BuildContext, {required Axis axis, ...})`, que monta:

  ```dart
  Flex(direction: axis, spacing: RebicSpacing.resolve(theme.spacing, gap),
       mainAxisAlignment: <map>, crossAxisAlignment: <map>,
       mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max, children: children)
  ```

- `RebicRow` e `RebicColumn` chamam essa função com `Axis.horizontal` e `Axis.vertical`.
- `RebicRow.wrap` monta
  `Wrap(spacing: v, runSpacing: v, alignment: <WrapAlignment de mainAlignment>, children: children)`.

  Um `assert` no `build` rejeita filhos `Flexible`/`Expanded`, com mensagem que cita `RebicRow.wrap`. O `Wrap` não
  sabe dimensioná-los, e o erro nativo seria menos claro.
- O `Flex` resolve `start`/`end` pela `Directionality`. O espaço não depende da escala de texto, porque vem só da
  densidade.

**Alternativa:** intercalar `RebicSpacing.horizontal/vertical` entre os filhos. Ela foi rejeitada porque
`spaceBetween` distribuiria o espaço livre também em volta dos separadores. O `spacing` nativo trata isso
corretamente.

### D3. Testes

- As medidas são verificadas com `getRect`.
- **Semântica:** o teste compara os rótulos com `Row`/`Column` nativos.
- **Restrições:** os testes inspecionam a fonte dos construtores. Um teste extra cobre o `assert` de filho expansível em
  `RebicRow.wrap`.
- **Rastreabilidade:** um teste por spec, com 17 cenários para a linha e 16 para a coluna. Os nomes não se repetem
  entre as specs.
- Não há goldens, por não haver pintura.

### D4. Galeria e catálogo

- A página "RebicRow e RebicColumn" (`rebic_row_column_page.dart`) mostra:
  - as linhas com os quatro alinhamentos principais;
  - uma linha com `Expanded`;
  - um `RebicRow.wrap` em largura estreita;
  - as colunas com os quatro alinhamentos cruzados;
  - uma coluna com `Expanded`.

  Os blocos são `RebicContainer` com `surface: base` e borda.
- No catálogo, as duas entradas passam a `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [`spacing` do `Flex` é recente (3.27)] → O baseline do protótipo é 3.32 (ADR 0001). Uma aplicação em SDK mais antigo
  não compila, o que já é coberto pela restrição de SDK do pacote.
- [Sem `baseline` na linha] → Rótulo e texto em `crossAlignment: center` costumam bastar. Se faltar, entra numa change
  futura com spec.

## Migration Plan

Widgets novos; nada a migrar. As páginas da galeria podem trocar `Row`/`Column` com `RebicSpacing` por estes widgets em
changes futuras.
