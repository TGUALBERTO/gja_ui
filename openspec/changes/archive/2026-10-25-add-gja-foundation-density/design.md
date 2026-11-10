# Design: Fundamento de densidade

## Context

- Já existem `GjaSpacingTokens.fallback()` (o mapeamento confortável), `GjaTypographyTokens.fallback()`
  (`label` 14/20) e a escala `GjaSpacingPrimitives` (0 a 64, grade de 4 px).
- A spec `gja/framework-architecture` exige que a densidade seja selecionável por tema ou subárvore. Isso depende de
  um `InheritedWidget` (`GjaTheme`), que ainda não existe e que fica com `theming`/`GjaTheme`. Aqui ficam só os valores.
- O design da Fase 0 (D8) prevê `androidTapTargetGuideline` (48) e `iOSTapTargetGuideline` (44) conforme a densidade.
  O mínimo compacto segue o WCAG 2.2 AA (2.5.8, 24 × 24).

## Goals / Non-Goals

**Goals:**

- Um único objeto por densidade, com tudo o que muda entre toque e ponteiro: dimensões e espaçamento.
- Garantias de acessibilidade verificáveis já nos valores de referência.

**Non-Goals:**

- Escolha automática da densidade pela plataforma ou pelo dispositivo de entrada. O tema decide.
- Dimensões específicas de componentes (altura de linha de tabela, largura de campo). Ficam como tokens de componente
  dos widgets, derivados destes.

## Decisions

### D1. API

```dart
enum GjaDensity { comfortable, compact }

class GjaDensityTokens extends GjaTokenSet<GjaDensityTokens> {
  final GjaDensity density;
  final double controlHeight, listItemHeight, minTargetSize;
  final GjaSpacingTokens spacing;
  const GjaDensityTokens.comfortable();
  const GjaDensityTokens.compact();
  static GjaDensityTokens of(GjaDensity density);   // switch exaustivo
}
```

O conjunto contém um `GjaSpacingTokens`, em vez de só um fator de escala, por dois motivos: uma marca pode querer
um espaçamento compacto específico, e um fator gera valores fora da grade de 4 px.

- **Alternativa:** fator multiplicativo (por exemplo, 0,75). Foi rejeitada porque produz 9 px, 3 px e outros valores fora
  da escala, e porque contraria a regra "valores vêm dos primitivos".
- **Alternativa:** `GjaSpacingTokens.compact()` no próprio fundamento de espaçamento. Foi rejeitada para não alterar
  a API de `spacing` (já arquivada). O mapeamento compacto mora na densidade, que é quem o define.

### D2. Valores de referência

| | comfortable | compact |
|---|---|---|
| controlHeight | space40 | space32 |
| listItemHeight | space48 | space32 |
| minTargetSize | space48 | space24 |
| spacing | `GjaSpacingTokens.fallback()` | compacto (abaixo) |

Espaçamento compacto (passos `none`…`xxxl` e papéis):

| none | xxs | xs | s | m | l | xl | xxl | xxxl | inlineGap | stackGap | sectionGap | pageMargin |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 0 | 2 | 4 | 4 | 8 | 12 | 16 | 24 | 32 | 4 (= s) | 8 (= m) | 24 (= xxl) | 12 (= l) |

Conferência da regra do rótulo (`label` = 20 px de linha): no confortável, 20 + 2 × 4 = 28 ≤ 40; no compacto,
20 + 2 × 4 = 28 ≤ 32.

### D3. Validação e interpolação

`copyWith` faz `assert` de dimensões finitas e `> 0`, e de `minTargetSize >= 24`, com a mensagem citando o mínimo.
`lerp` usa `lerpDouble` nas dimensões, `spacing.lerp` no espaçamento e troca discreta do modo em 0,5
(`lerpDiscrete`, helper interno de `tokens/lerp.dart`).

### D4. Testes

- "Densidade sem estilos de texto": o teste lê as propriedades de diagnóstico do conjunto e verifica que nenhuma é
  `TextStyle` nem tamanho de fonte. Também confirma que a página da galeria usa a mesma `GjaTypographyTokens` nas duas colunas.
- "Rótulo cabe no controle" usa `GjaTypographyTokens.fallback().label` (tamanho × altura) e o `xs` do espaçamento de cada densidade.

### D5. Galeria

A página "Densidade" (`pages/density_page.dart`) tem duas colunas, `comfortable` e `compact`. Cada coluna mostra:

- um controle simulado (`Container` com a altura de controle, a borda `borderStrong` e o rótulo no estilo `label`);
- uma lista de dois itens com a altura de item;
- as medidas (`controle 40 · item 48 · alvo 48`).

O espaçamento interno de cada coluna vem do `spacing` da própria densidade.

## Risks / Trade-offs

- [O alvo de 24 no compacto é pequeno para toque] → O compacto é para ponteiro, por definição. O tema da aplicação escolhe a densidade, e a ampliação da área de toque é responsabilidade de `core/interaction`.
- [Duplicação do espaçamento compacto se outra densidade for criada] → Não há outra prevista. Se houver, os mapeamentos passam para uma tabela única.

## Migration Plan

Não há consumidores. O rollback é reverter a change.
