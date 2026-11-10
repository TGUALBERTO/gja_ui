# Design: GjaBadge

## Context

- **`GjaText`** tem a variante `label` e os tons `success`, `warning`, `error` e `information`, que mapeiam para
  `colors.stateColors(state).foreground`. O tom `standard` usa `colors.text`. Isso cobre a cor do número em todos os
  estados, com `none` → `standard`.
- **`colors.stateColors(state)`** dá fundo, borda e frente com contraste de texto ≥ 4,5:1 sobre o fundo. Isso é
  verificado pelo fundamento de cor.
- **Medidas:** `radius.full` (pílula), `icons.small` (16), `spacing.xs` e a linha fina `const BorderSide().width`.
- **Formatação:** `GjaLocalizations.formatInteger` formata no idioma ("1.000" em pt-BR).
- **Botões de ícone:** o `GjaIconButton` envolve o conteúdo em `MergeSemantics`. Um `MergeSemantics` externo junta
  o nó do botão e o rótulo do contador num só nó.

## Goals / Non-Goals

**Goals:**
- contador avulso ou sobre um elemento;
- limite com "+";
- ocultação abaixo de 1;
- cores por estado de valor;
- semântica do número;
- RTL;
- escala de texto.

**Non-Goals:**
- ponto sem número;
- animação;
- outras posições.

## Decisions

### D1. API

```dart
class GjaBadge extends StatelessWidget {
  const GjaBadge({required this.count, this.max = 999, this.state = GjaValueState.error, this.child,
      this.semanticLabel, super.key}) : assert(max >= 1, 'max deve ser ao menos 1: $max');
}
```

O padrão `error` corresponde à cor de destaque dos badges Fiori (`sapContent_BadgeBackground`). O rótulo é
`'${formatInteger(max)}+'` quando `count > max`, e `formatInteger(count)` nos demais casos.

**Alternativa:** dois construtores (`GjaBadge.count` e `GjaBadge.on`). Foi descartada: um `child` opcional
expressa as duas formas, como o `BadgeEnabler`, que se aplica a um controle existente.

### D2. Pílula

```
ExcludeSemantics → ConstrainedBox(minWidth: icons.small, minHeight: icons.small)
  └─ DecoratedBox(color: st.background, border: Border.all(st.border, hairline), radius: full)
     └─ Padding(horizontal: spacing.xs) → Center(widthFactor: 1, heightFactor: 1,
                                                 GjaText(label, variant: label, tone: tom do estado, maxLines: 1))
```

Com um dígito, a largura do texto mais o espaço fica abaixo de `icons.small`, e o `minWidth` iguala a altura,
formando um círculo. Com a escala de texto, a altura do texto cresce e a pílula cresce junto.

### D3. Sobre o elemento

```
MergeSemantics
└─ Stack(clipBehavior: Clip.none)
   ├─ child
   └─ PositionedDirectional(top: 0, end: 0) → IgnorePointer
      └─ FractionalTranslation(translation: Offset(±0.5, -0.5)) → pílula
```

- **Centro no canto:** `PositionedDirectional` prende a borda final e o topo da pílula ao canto superior final do
  `child`. A `FractionalTranslation` desloca metade da pílula para fora, em direção ao canto: `+0.5` em x em LTR e
  `-0.5` em RTL, e `-0.5` em y. Assim o centro fica no canto.
- **Tamanho e toque:** o `Stack` mede o `child`, porque a pílula é posicionada. O `IgnorePointer` deixa os toques
  passarem ao `child`.
- **Semântica:** a pílula fica fora da semântica (`ExcludeSemantics`), e um `Semantics(label: semanticLabel ?? texto)`
  vem depois do `child` dentro do `MergeSemantics`. O nó resultante anuncia o rótulo do elemento e depois o do
  contador.
- **Avulso:** `Semantics(label: …, child: pílula)`. Com `count < 1`, o widget é o `child` ou um `SizedBox.shrink()`,
  sem semântica.

### D4. Testes, galeria e catálogo

- **Cores:** pela `BoxDecoration` e pelo tom do `GjaText`.
- **Posição:** pelo centro do `DecoratedBox` da pílula em relação ao retângulo do `child`.
- **Contraste:** num arquivo sem a Inter, com um contador por estado sobre a superfície `background`.
- **Toque:** o teste toca um ponto da pílula dentro do `child` (2 px para dentro do canto). O ponto exatamente no
  canto fica fora dos limites do `child` no teste de toque.
- **Goldens:** 480 × 200, com uma linha por estado ("7" e "128"), "999+" e três `GjaIconButton` com contadores. São
  gerados nos temas claro e escuro × confortável e compacto, dentro de um `Overlay`, porque o botão de ícone tem
  dica.
- **Galeria:** página "GjaBadge" (`gja_badge_page.dart`), com `GjaPage`:
  - contadores por estado;
  - botões de ícone com contador;
  - "Nova notificação" (`GjaButton`), que incrementa o contador sobre o sino.

  O cenário se chama "Página GjaBadge na galeria".
- **Catálogo:** `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [Pílula parcialmente fora do `child`] → Pode ser cortada por ancestrais com recorte. É o mesmo comportamento do
  badge do UI5, e quem o usa deve deixar espaço.
- [Contador cobre parte do `child`] → Ele não recebe toques. O toque passa ao `child`.

## Migration Plan

Widget novo; nada a migrar.
