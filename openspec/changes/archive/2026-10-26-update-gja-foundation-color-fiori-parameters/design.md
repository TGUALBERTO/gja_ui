# Design: Cores e estados no modelo Fiori

## Context

- O responsável definiu que o SAPUI5/Fiori é o modelo do GJA e que padrões do Material não devem persistir.
- Hoje, `GjaColorTokens` usa papéis do Material 3. `GjaInteractionStateTokens` usa a camada de opacidade
  (*state layer*) e o aumento de elevação no hover.
- Não há widgets públicos. Os consumidores do código são os fundamentos, `GjaInteractable` (`gja_core`) e a galeria.
- A paleta primitiva continua a mesma. O contraste da paleta nova de papéis foi calculado antes desta proposta,
  e todos os pares passaram nos dois modos.

## Goals / Non-Goals

**Goals:**

- Vocabulário e mecanismo do Fiori: parâmetros de tema derivados (fundo, texto, marca, destaque, seleção,
  hover) e cores explícitas por estado em cada família de controle.
- Uma troca de marca (`brand`, `brandHover`, `highlight`) chega a todos os controles, porque as famílias derivam dos papéis.

**Non-Goals:**

- Copiar valores ou nomes literais da SAP. Os papéis seguem os conceitos públicos, sem o prefixo `sap`, e a paleta
  continua própria.
- Famílias de campo (`sapField_*`) e de navegação (`sapShell_*`). Elas entram com os widgets correspondentes, como
  famílias novas.

## Decisions

### D1. Papéis de cor

| Papel GJA | Conceito Fiori | Antes | Claro | Escuro |
|---|---|---|---|---|
| background | sapBackgroundColor | background | neutral50 | neutral950 |
| base | sapBaseColor | surface | white | neutral900 |
| headerBackground | sapList_HeaderBackground | surfaceVariant | neutral100 | neutral800 |
| shell | sapShellColor | — | white | neutral900 |
| text | sapTextColor | onSurface | neutral900 | neutral50 |
| label | sapContent_LabelColor | onSurfaceMuted | neutral600 | neutral300 |
| link | sapLinkColor | — | blue600 | blue300 |
| separator | sapList_BorderColor | border | neutral200 | neutral700 |
| fieldBorder | sapField_BorderColor | borderStrong | neutral500 | neutral400 |
| brand | sapBrandColor | primary | blue600 | blue300 |
| brandHover | sapButton_Emphasized_Hover_Background | — | blue700 | blue200 |
| highlight | sapHighlightColor / sapButton_Active_Background | — | blue800 | blue100 |
| contrastText | sapContent_ContrastTextColor | onPrimary | white | blue900 |
| hoverBackground | sapList_Hover_Background | — | neutral100 | neutral800 |
| selectionBackground | sapList_SelectionBackgroundColor | primaryContainer | blue50 | blue800 |
| selectionHoverBackground | sapList_Hover_SelectionBackground | — | blue100 | blue900 |
| focus | sapContent_FocusColor | focus | blue600 | blue300 |
| shadow | sapContent_ShadowColor | shadow | blackAlpha16 | blackAlpha40 |
| blockLayer | sapBlockLayer_Background | scrim | blackAlpha40 | blackAlpha60 |

Saem `onSurfaceDisabled` e `surfaceDisabled` (o desabilitado passa a ser opacidade) e `onPrimaryContainer`
(o texto sobre a seleção é `text`). A primitiva `transparent` (`0x00000000`) entra para as bordas e fundos
transparentes das famílias. `gjaCheckContrast` passa a verificar os pares da spec nova.

### D2. Famílias e resolução de estados

```dart
enum GjaControlFamily { standard, emphasized, transparent, list }

class GjaStateColors extends GjaTokenSet<GjaStateColors> { final Color background, border, text; }
class GjaControlColors extends GjaTokenSet<GjaControlColors> {
  final GjaStateColors normal, hover, active, selected, selectedHover;
  factory GjaControlColors.of(GjaControlFamily family, GjaColorTokens colors);  // derivação da spec
  GjaStateColors resolve(Set<GjaInteractionState> states);                      // precedência da spec
}

class GjaInteractionStateTokens extends GjaTokenSet<...> {
  final double disabledOpacity, focusWidth, focusOffset;   // 0,4 · 2 · 1
  const GjaInteractionStateTokens.fallback();
  bool showsFocusRing(Set<GjaInteractionState> states);
  double opacity(Set<GjaInteractionState> states);       // disabled → disabledOpacity, senão 1
}
```

As cores das famílias são **derivadas** de `GjaColorTokens` por `GjaControlColors.of`, e não armazenadas no
tema. Assim, `theme.copyWith(colors: …)` muda todas as famílias de uma vez, como os parâmetros derivados do Fiori,
e o tema não ganha mais um campo. Um widget pode sobrescrever as cores pela coleção `components` do tema.

- **Alternativa:** guardar as famílias no conjunto de estados. Foi rejeitada porque uma troca de marca exigiria
  atualizar dois lugares.

### D3. Foco

A espessura passa a se chamar `focusWidth` e continua 2. O afastamento passa a se chamar `focusOffset`, com 1 px
(antes 2), mais próximo do contorno junto à borda do Fiori. `GjaInteractable` e `GjaFocusRing` passam a ler os
nomes novos. A spec `gja/core/interaction` fala em "espessura, afastamento e cor de foco dos tokens" e não muda.

### D4. Contraste

- `gjaCheckContrast(colors)` cobre os papéis.
- `gjaCheckStateContrast(colors)`, novo em `interaction_states/`, cobre cada família e estado não desabilitado.
  Fundo transparente é avaliado sobre `base` e `background`.
- `GjaThemeData.accessibilityIssues()` soma os dois.

### D5. Purpose e catálogo

O Purpose da spec principal `interaction-states` cita camada de estado e elevação. Ele é reescrito direto na spec
principal, já que delta não altera Purpose. A dependência `interaction-states` → `elevation` sai do catálogo.

## Risks / Trade-offs

- [Renomeação ampla quebra a API 0.x] → Não há consumidores externos. O CHANGELOG registra a tabela de/para.
- [A ativação pinta `highlight` com `contrastText`, como o Fiori, e isso é mais forte que o Material] → É intencional:
  é o comportamento de "pressionado" do Fiori.

## Migration Plan

Troca direta de nomes no repositório (fundamentos, `gja_core` e galeria), com o CI verde ao final. Não há consumidores externos.
