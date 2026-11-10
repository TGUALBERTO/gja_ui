# Design: Estados de interação no modelo Fiori

## Context

`gja/foundation/interaction-states` já usa o modelo Fiori de famílias de controle com cores explícitas por estado,
desde `update-gja-foundation-color-fiori-parameters`. Sobram três pontos (ver proposal.md, Why):
- `GjaInteractionState.dragged`, usado só em `GjaControlColors.resolve`, que o trata como `pressed`. Nenhum
  widget nem `gja_core` o produz.
- `GjaInteractionPrimitives.opacities`, com nove valores. Só `opacity40` é lido, em
  `GjaInteractionStateTokens.fallback`. O teste de primitivos percorre a escala inteira.
- `GjaControlColors._semantic`, que monta `accept`, `reject` e `attention` com o `hoverBackground` global no hover
  e o `active` compartilhado (`highlight`, `highlight`, `contrastText`) nos demais estados.

`GjaValueStateColors` tem `foreground`, `background` e `border`. A verificação de contraste
(`contrast_check.dart`) já mede `foreground` sobre `base`, `background` e o `background` do estado.

O `GjaElevation.dragged` de `GjaContainer` e o papel `dragged` de elevação são sombras, não estados de
interação, e não mudam.

## Goals / Non-Goals

**Goals:**
- Ações semânticas na própria cor em todos os estados, como os botões Accept, Reject e Attention do Horizon.
- Nenhum primitivo nem estado sem equivalente no Fiori.
- Nenhuma mudança de API nos widgets.

**Non-Goals:**
- Arrastar e soltar, e o indicador `sapContent_DragAndDropActiveColor`.
- Foco em contraste sobre fundos de marca (`sapContent_ContrastFocusColor`).
- Rever o ativo das famílias `standard`, `emphasized`, `transparent` e `list`.

## Decisions

### D1. `hoverBackground` por estado de valor

`GjaValueStateColors` ganha `hoverBackground`, obrigatório no construtor e incluído em `copyWith`, `lerp`, `==`,
`hashCode` e no diagnóstico. Os valores de referência ficam um tom acima do `background` do estado:

| Estado | Claro (`background` → `hoverBackground`) | Escuro |
|---|---|---|
| `none` | `neutral100` → `neutral200` | `neutral800` → `neutral700` |
| `success` | `green50` → `green100` | `green900` → `green800` |
| `warning` | `amber50` → `amber100` | `amber900` → `amber800` |
| `error` | `red50` → `red100` | `red900` → `red800` |
| `information` | `cyan50` → `cyan100` | `cyan900` → `cyan800` |

Contraste do `foreground` sobre o novo fundo, medido com os primitivos atuais: mínimo de 5,49 no claro (`error`) e
4,82 no escuro (`error`). Todos os pares ficam ≥ 4,5.

`contrast_check.dart` passa a incluir `foreground` sobre `hoverBackground` de cada estado.

O papel é definido para os cinco estados, e não só para os três das ações, para manter a consulta exaustiva e porque
futuros controles com estado de valor (mensagens, campos) também têm hover no Fiori.

Alternativas consideradas:
- **Derivar o hover misturando a borda sobre o fundo.** Rejeitada: seria uma "state layer" do Material, e o Fiori
  define o hover como cor explícita.
- **Manter o hover neutro.** Rejeitada: diverge do Horizon, onde o hover de um botão Accept continua verde.

### D2. Ativo das ações semânticas como inverso do normal

O ativo, o selecionado e o selecionado com hover de `accept`, `reject` e `attention` passam a (`foreground`,
`foreground`, `background`) do estado. O contraste já está garantido, porque a spec de cor exige `foreground` ≥ 4,5:1
sobre o `background` do estado. Assim não é preciso um papel `activeBackground`.

`_semantic` deixa de receber o `active` compartilhado. As famílias não leem mais `brand`, `highlight` nem o
`hoverBackground` global, o que o cenário "Ações semânticas sem cores da marca" verifica.

Alternativa considerada: papéis `activeBackground` e `activeText` por estado. Rejeitada por ora: dobraria os papéis
sem ganho visível, e os valores do Horizon não podem ser confirmados (ADR 0009).

### D3. Remoção de `dragged`

`GjaInteractionState` fica com `hovered`, `focused`, `pressed`, `selected` e `disabled`. `resolve` deixa de testar
`dragged`. O dartdoc de `GjaControlColors.resolve` e do enum é atualizado. O arraste, quando existir, aplica a
sombra `dragged` de elevação ao item e o estado `pressed` às suas cores.

### D4. Primitivos de opacidade

`GjaInteractionPrimitives` mantém `opacity40` e o mapa `opacities` com essa única entrada, para o teste de escala
continuar genérico. As espessuras `stroke1`…`stroke3` não mudam. O dartdoc da classe cita
`sapContent_DisabledOpacity`.

### D5. Galeria

A página "Estados" passa a listar as sete famílias, na ordem de `GjaControlFamily.values`. O teste da página
verifica as sete famílias e os sete rótulos de estado.

### D6. ADR 0009

Novas linhas de valores provisórios:
- tons de hover dos estados de valor (um tom acima do fundo), referência `sapButton_<Tipo>_Hover_Background`;
- ativo das ações semânticas como inverso do normal, referência `sapButton_<Tipo>_Active_Background` e
  `_Active_TextColor`.

## Risks / Trade-offs

- **[Ativo invertido no escuro fica claro]** No escuro, o ativo de Accept tem fundo `green300` e texto `green900`.
  É o inverso do normal e mantém o contraste, mas pode diferir do Horizon Evening → registrado como provisório na
  ADR 0009.
- **[Quebra de API 0.x]** `dragged`, os primitivos de opacidade e o construtor de `GjaValueStateColors` mudam. Não
  há consumidores externos, e o CHANGELOG lista as remoções e o novo papel obrigatório.
- **[Goldens]** Se algum golden de `GjaButton` mostrar Accept, Reject ou Attention em hover ou ativo, ele muda. A
  tarefa de widgets confere e regera só os afetados, no Windows (ADR 0008).
