# Design: RebicProgressIndicator

## Context

Peças já disponíveis:
- **Cores:** `colors.brand`, `colors.separator`, `colors.stateColors(state).foreground`, além de
  `rebicContrastRatioOver` para medir contraste.
- **Tamanhos:** `RebicIconSize`, com `icons.<size>` (16 a 32), e os passos `spacing.xxs` e `spacing.xs`.
- **Movimento:** `motion.short` e `motion.long`. `RebicThemeData.of` zera as durações com movimento reduzido.
- **Texto:** `RebicLocalizations.loading` ("Carregando") e `formatInteger`.

O tokens check proíbe dimensões, cores e durações literais em `rebic_widgets/lib`. Este é o primeiro widget da
categoria `exibicao-dados`: a pasta `lib/src/exibicao_dados/` é criada agora.

## Goals / Non-Goals

**Goals:**
- barra e círculo;
- determinado e indeterminado;
- cor por estado de valor;
- semântica de progresso;
- movimento reduzido;
- RTL.

**Non-Goals:**
- texto do valor;
- buffer ou segmentos;
- atraso de exibição;
- camada de bloqueio.

## Decisions

### D1. API

```dart
class RebicProgressIndicator extends StatefulWidget {
  const RebicProgressIndicator.linear({this.value, this.state = RebicValueState.none, this.semanticLabel, super.key})
    : size = RebicIconSize.control, _shape = _Shape.linear, assert(value == null || (value >= 0 && value <= 1), …);
  const RebicProgressIndicator.circular({this.value, this.state = …, this.size = RebicIconSize.control,
      this.semanticLabel, super.key}) : _shape = _Shape.circular, assert(…);
}
```

Um só widget com dois construtores. É assim que o `RebicDivider` trata `.vertical`, e o widget atende ao design da
Fase 0, que previa um único `RebicProgressIndicator`. O `assert` no construtor `const` falha na criação, com a
mensagem `'value deve estar entre 0 e 1: $value'`.

**Alternativa:** dois widgets (`RebicProgressBar`, `RebicBusyIndicator`). Foi descartada, porque duplicaria a
semântica, as cores e o movimento, e o catálogo prevê um só widget.

### D2. Pintura

Um `CustomPaint` com um `CustomPainter` privado (`_ProgressPainter`). Ele recebe:
- `shape`, `value`, `phase` (0..1 do ciclo, ou nulo quando parado);
- `fill`, `track`, `thickness`, `textDirection`.

`shouldRepaint` compara os campos. Expor `fill`, `track` e `value` permite que os testes verifiquem as cores e a
geometria sem comparar pixels.

**Barra:**
- `SizedBox(height: spacing.xs, width: double.infinity)`;
- a trilha ocupa a barra inteira, e o preenchimento é um retângulo de `value × largura`, a partir do início
  (espelhado em RTL);
- no modo indeterminado, um segmento de um terço desliza de antes do início até depois do fim, conforme `phase`;
- os cantos são arredondados pela metade da espessura, um valor derivado e não literal.

**Círculo:**
- `SizedBox.square(icons.<size>)`;
- trilha circular e arco de `value × 2π` a partir do topo, no sentido horário;
- no modo indeterminado, um arco de um quarto que gira com `phase`;
- traço `spacing.xxs`, com pontas arredondadas.

Um `CustomPainter` não é um `RenderObject` próprio, e por isso não precisa de ADR.

### D3. Animação

- Um `AnimationController` no `State`.
- **Determinado:** a mudança de `value` é interpolada com um `Tween` de `motion.short` (curva `motion.standard`) a
  partir do valor exibido no momento. Com duração zero, o salto é imediato.
- **Indeterminado:** o controlador roda em `repeat()` com período `motion.long × 4` (1,2 s nos tokens de
  referência, próximo ao ciclo do `BusyIndicator`). O fator 4 é uma constante nomeada (`_cyclesPerLong`), não uma
  duração literal.
- **Movimento reduzido:** se `motion.long` é zero, o controlador para e o desenho usa `phase` nulo. A barra mostra
  então o segmento central fixo, e o círculo um arco fixo de um quarto. Assim, nenhum quadro é agendado.
- O controlador é recriado ou parado em `didChangeDependencies`/`didUpdateWidget`, quando o tema ou o modo mudam.
  `TickerMode` pausa a animação fora da tela.

### D4. Semântica

`Semantics(label: semanticLabel ?? localizations.loading, value: …)`, com `excludeSemantics` sobre a pintura:
- **Determinado:** o valor é `'${localizations.formatInteger((value * 100).round())}%'`. O sinal de porcentagem é um
  símbolo, não um texto localizado.
- **Indeterminado:** sem valor.

O indicador não é focável.

### D5. Testes, galeria e catálogo

- **Geometria e cores:** pelos campos do `_ProgressPainter`, lidos com `tester.widget<CustomPaint>(...).painter`. O
  teste acessa os campos por uma interface de teste: o painter é privado, mas exporta getters
  `@visibleForTesting` no `State`. Se isso ficar artificial, os testes medem `getRect` do `CustomPaint` e usam
  goldens para o preenchimento.
- **Movimento:** com `tester.binding.hasScheduledFrame` e comparando o `phase` em dois instantes.
- **Contraste:** calculado com `rebicContrastRatioOver` para cada estado, nos temas claro e escuro, sem pixels.
- **Goldens:** 480 × 320, com cinco barras determinadas (0,45) nos estados, uma barra indeterminada com movimento
  reduzido (desenho estático) e círculos nos tamanhos `small`, `control` e `xLarge` com valor 0,6. São gerados nos
  temas claro e escuro × confortável e compacto.
- **Galeria:** página "RebicProgressIndicator" (`rebic_progress_indicator_page.dart`):
  - barras rotuladas por estado;
  - uma barra indeterminada;
  - círculos indeterminados nos tamanhos `small`, `control`, `large` e `xLarge`.

  O cenário se chama "Página RebicProgressIndicator na galeria".
- **Catálogo:** `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [O indeterminado agenda quadros continuamente] → `TickerMode` desliga a animação fora da tela, e os testes usam
  `pump` com duração em vez de `pumpAndSettle`.
- [O fator 4 sobre `motion.long` não é um token] → Um token de ciclo próprio entra no `RebicLoadingOverlay`, se outro
  widget precisar.
- [Painter privado nos testes] → A verificação usa o widget `CustomPaint` e, se necessário, os goldens, sem expor
  API pública.

## Migration Plan

Widget novo; nada a migrar.
