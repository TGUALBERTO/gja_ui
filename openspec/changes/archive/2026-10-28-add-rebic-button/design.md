# Design: RebicButton

## Context

- **`RebicInteractable`** (núcleo) cuida de:
  - estados (hover, pressionado, foco, desabilitado);
  - ativação por toque, Enter e Espaço;
  - alvo mínimo da densidade e anel de foco só pelo teclado;
  - semântica de botão (`label`, `enabled`, `onTap`).

  O widget que o usa pinta a aparência no `builder`.
- **`RebicControlColors.of(family, colors).resolve(states)`** dá fundo, borda e texto, e
  `interaction.opacity(states)` dá a opacidade de desabilitado. Hoje há quatro famílias: `standard`, `emphasized`,
  `transparent` e `list`.
- **`RebicText` e `RebicIcon`** só têm tons fixos (`brand`, `standard`, estados), sem a cor de texto dos estados de
  interação (por exemplo, `contrastText` no ativo). O botão interno do scaffold contornou isso com um `ColorFiltered`
  no ícone.
- **`RebicProgressIndicator`** pinta com `brand` ou a cor do estado de valor, o que fica invisível sobre o fundo
  `brand` de um botão `emphasized`. A animação e a pintura moram no `State` dele e no `RebicProgressPainter`
  (interno).
- **Medidas:** `density.controlHeight`, `spacing.m`/`xs`, `radius.control`, `icons.control`,
  `typography.bodyStrong`; a espessura fina é `const BorderSide().width`.

O contraste dos tipos novos foi calculado sobre as cores de referência. O pior caso é `reject` no hover do tema
escuro, com 4,79:1, acima de 4,5:1.

## Goals / Non-Goals

**Goals:**
- seis tipos Fiori sobre as famílias de controle;
- ícone opcional;
- desabilitado e ocupado;
- semântica, teclado, contraste e escala;
- RTL e reticências.

**Non-Goals:**
- botão só de ícone;
- alternância, menu ou botão dividido;
- ícone depois do rótulo;
- largura configurável.

## Decisions

### D1. Famílias novas no fundamento

`RebicControlFamily` ganha `accept`, `reject` e `attention`, derivadas em `RebicControlColors.of` de
`colors.stateColors(success|error|warning)` (aqui, `st`):
- normal: `(st.background, st.border, st.foreground)`;
- hover: `(hoverBackground, st.border, st.foreground)`;
- ativo, selecionado e selecionado com hover: `active` (`highlight`, `highlight`, `contrastText`), como em
  `emphasized`.

O `state_contrast_check` percorre `RebicControlFamily.values` e já cobre as novas famílias. A página "Estados" da
galeria também as mostra sem mudança, porque percorre `values`.

**Alternativa:** derivar as cores dentro do botão. Foi descartada, porque as famílias são o lugar das cores por
estado, e `RebicToolbar` e os botões de diálogo precisarão delas.

### D2. API

```dart
enum RebicButtonType { standard, emphasized, transparent, accept, reject, attention }

class RebicButton extends StatelessWidget {
  const RebicButton({required this.label, required this.onPressed, this.type = RebicButtonType.standard,
      this.icon, this.busy = false, super.key}) : assert(label != '', 'label não pode ser vazio');
}
```

`onPressed` é obrigatório, mesmo podendo ser nulo, como nos botões do Flutter: desabilitar é uma escolha explícita.
`RebicButtonType.standard` corresponde ao Default do UI5, porque `default` é palavra reservada em Dart. Cada tipo
mapeia para a família de mesmo nome.

### D3. Estrutura e pintura

```
MergeSemantics
└─ Semantics(value: busy ? localizations.loading : null)
   └─ RebicInteractable(semanticLabel: label, onPressed: onPressed == null ? null : (busy ? () {} : onPressed),
      │                 focusRingBorderRadius: radius.control)
      └─ builder: (states) → Opacity(interaction.opacity(states))
         └─ ConstrainedBox(minHeight: controlHeight)
            └─ DecoratedBox(color: c.background, border: Border.all(color: c.border, width: hairline), radius)
               └─ Padding(horizontal: spacing.m)
                  └─ Row(min, center, spacing: xs)
                     ├─ [busy] RebicProgressView(circular, inline, fill: c.text, track: transparent)
                     ├─ [!busy && icon] Icon(icon, size: icons.control, color: c.text)
                     └─ Flexible(Text(label, style: typography.bodyStrong.copyWith(color: c.text),
                                      maxLines: 1, overflow: ellipsis))
```

- **Rótulo e ícone:** o botão usa `Text` e `Icon` com os tokens de tipografia e iconografia, e a cor de texto do
  estado. Por isso o botão não depende de `RebicText`/`RebicIcon`. Uma opção de cor herdada nesses widgets, se surgir
  em outros controles, entra numa change própria.
- **Ocupado:** quando há ícone, o indicador tem o tamanho `icons.control`, o mesmo do ícone, e a largura não muda.
  O acionamento vira um no-op, sem desabilitar. Assim, as cores, o foco e o estado habilitado na semântica
  continuam como antes.
- **Alinhamento:** o `Row` usa `mainAxisSize.min` e alinhamento central. O `ConstrainedBox` com `minHeight` permite
  crescer com a escala de texto.

### D4. Extração interna do indicador

O `State` animado do `RebicProgressIndicator` (determinado ou indeterminado, movimento reduzido) passa a ser
`RebicProgressView` em `progress_indicator/rebic_progress_view.dart`, não exportado. Ele recebe:
- `circular`, `value`, `fill`, `track`;
- a dimensão: `IconSize` para o círculo, ou altura `spacing.xs` para a barra.

`RebicProgressIndicator` passa a ser um `StatelessWidget` que resolve as cores e a semântica e delega a ele. Os
testes e os goldens do indicador validam que o comportamento não muda.

### D5. Testes, galeria e catálogo

- **Cores e estados:** verificados pela `BoxDecoration` do `DecoratedBox` do botão e pela opacidade do `Opacity`.
- **Fundamento:** o teste "Famílias de controle — Famílias accept, reject e attention" fica em
  `rebic_foundation/test/interaction_states`. O teste de contraste existente passa a cobrir as novas famílias.
- **Acessibilidade:** contraste, `labeledTapTargetGuideline` e alvo mínimo, por tipo, nos temas claro e escuro e nas
  duas densidades, num arquivo sem a Inter. Escala 2,0 com `MediaQuery(textScaler: TextScaler.linear(2))` e verificação
  de `takeException`.
- **Goldens:** 480 × 400, com uma linha por tipo (sem e com ícone), mais desabilitado e ocupado (movimento reduzido).
  São gerados nos temas claro e escuro × confortável e compacto.
- **Galeria:** página "RebicButton" (`rebic_button_page.dart`), com `RebicPage`:
  - um botão de cada tipo;
  - botões com ícone;
  - um desabilitado;
  - "Enviar", que fica ocupado ao ser tocado, num `StatefulWidget` da página.

  O cenário se chama "Página RebicButton na galeria".
- **Catálogo:** `implemented`, com as dependências dos dois `[Integração]`. `rebic-text` e `rebic-icon` saem da
  lista.

## Risks / Trade-offs

- [Enum do fundamento cresce] → A mudança é aditiva. Não há `switch` exaustivo sobre `RebicControlFamily` fora de
  `RebicControlColors.of`, e a galeria percorre `values`.
- [`Text`/`Icon` diretos em vez de `RebicText`/`RebicIcon`] → Os tokens são os mesmos. O teste de cores verifica a
  cor do rótulo, e os goldens verificam a tipografia.
- [Extração do indicador pode mudar pixels] → Os goldens do indicador são executados sem atualização.

## Migration Plan

O widget é novo, e as famílias são aditivas. A extração interna do indicador não muda a API.
