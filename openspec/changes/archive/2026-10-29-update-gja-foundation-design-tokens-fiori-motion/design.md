# Design: Movimento no modelo SAPUI5

## Context

O movimento vive em `gja/foundation/design-tokens` (`GjaMotionPrimitives` e `GjaMotionTokens`, em
`lib/src/tokens/`). A redução fica em `GjaAccessibility.resolveMotion(motion, disableAnimations:)`, que zera
`short`, `medium` e `long`.

A redução é aplicada em três pontos:
- `GjaThemeData.resolve(disableAnimations:)` e `GjaThemeData.of`, que leem `MediaQuery.disableAnimations`;
- a rota de `GjaApp`, que lê o `MediaQuery` do navigator e chama `resolve`;
- `GjaTheme`, que zera a duração da troca quando `MediaQuery.disableAnimations` é verdadeiro.

Os widgets que animam (`GjaProgressView`, scaffold, dica, rota e tema) leem os tokens do tema ativo. O indeterminado
do progresso fica parado quando `motion.long` é zero.

Usam os nomes das curvas primitivas: o teste `brand_customization_test.dart` e o teste de `motion_tokens_test.dart`.
Chamam `resolveMotion` diretamente: a página "Acessibilidade" da galeria e `accessibility_test.dart`.

## Goals / Non-Goals

**Goals:**
- Curvas e nomes das curvas CSS que o SAPUI5 usa.
- Um modo de animação configurável pelo tema, no modelo de `sap.ui.core.AnimationMode`, combinado com o pedido da
  plataforma.
- Nenhuma mudança de API em widgets.

**Non-Goals:**
- Diferenciar `basic` de `full` e `minimal` de `none` no comportamento dos widgets (ver D3).
- Mudar as durações.
- Corrigir o atraso da dica (ver proposal.md).

## Decisions

### D1. Curvas

`GjaMotionPrimitives` troca as três curvas pelas curvas CSS, com os mesmos valores das `Curves.easeInOut`,
`Curves.easeOut` e `Curves.easeIn` do SDK. Elas são declaradas como `Cubic` próprios, para que a biblioteca de
primitivos não dependa dos nomes do SDK. O mapeamento de referência fica `standard` = `curveEaseInOut`, `enter` =
`curveEaseOut` e `exit` = `curveEaseIn`.

Os nomes dos papéis (`standard`, `enter`, `exit`) ficam. Eles descrevem o uso, e não a forma, e não são exclusivos do
Material.

Alternativa considerada: renomear os papéis para `easeInOut` etc. Rejeitada porque o papel diz para que serve a
curva, e o primitivo diz qual é ela.

### D2. `GjaAnimationMode`

```dart
enum GjaAnimationMode { full, basic, minimal, none }
```

O enum fica em `lib/src/accessibility/animation_mode.dart`, exportado pelo fundamento, com dartdoc citando
`sap.ui.core.AnimationMode`. Ele expõe:
- `reducesMotion`, verdadeiro para `minimal` e `none`;
- `effective({required bool disableAnimations})`, que retorna `none` com o pedido da plataforma e o próprio modo sem
  ele.

`GjaAccessibility.resolveMotion(motion, {required GjaAnimationMode mode})` zera `short`, `medium` e `long` quando
`mode.reducesMotion` é verdadeiro e retorna `motion` sem alteração nos outros casos.

### D3. Efeito de cada modo

| Modo | Durações | Comportamento hoje |
|---|---|---|
| `full` | tokens | todas as animações |
| `basic` | tokens | igual a `full` |
| `minimal` | zero | igual a `none` |
| `none` | zero | sem animações, indeterminado parado |

No SAPUI5, `basic` desliga efeitos decorativos caros, e `minimal` mantém só animações de estado, como o
`BusyIndicator`. O GJA ainda não tem efeitos caros. O indeterminado do progresso para quando `long` é zero, e isso o
alinha a `none` também em `minimal`. As duas igualdades são provisórias e entram na ADR 0009. Um widget futuro que
precise diferenciar os modos lê `GjaThemeData.animationMode`.

### D4. Tema

`GjaThemeData` ganha `animationMode` (`GjaAnimationMode`, padrão `full`) no construtor, nos temas de referência,
em `copyWith`, em `lerp` (troca em `t = 0.5`, como o brilho), em `==`, em `hashCode` e no diagnóstico.

`resolve({required bool disableAnimations})` calcula `mode = animationMode.effective(disableAnimations: ...)`:
- se `mode == animationMode` e `!mode.reducesMotion`, retorna `this`;
- senão, retorna `copyWith(animationMode: mode, motion: GjaAccessibility.resolveMotion(motion, mode: mode))`.

`GjaThemeData.of` continua chamando `resolve` com o `MediaQuery`.

### D5. Widgets

- `GjaApp`, na rota: continua chamando `data.resolve(disableAnimations: ...)`. O tema já traz o modo, então
  nenhuma lógica nova é necessária.
- `GjaTheme`: a duração da troca passa a ser zero quando
  `target.animationMode.effective(disableAnimations: ...).reducesMotion` é verdadeiro. Hoje ela depende só do
  `MediaQuery`.

Os dois ganham um teste com o modo vindo do tema (`none`), além dos testes atuais com o modo do sistema.

### D6. Galeria

- "Design tokens": mostra os nomes CSS das curvas.
- "Acessibilidade": troca a comparação "com e sem redução" por uma tabela das durações nos quatro modos.

### D7. ADR 0009

Novas linhas de valores provisórios:
- as durações de referência (100/200/300 ms), que o SAPUI5 não publica como parâmetros de tema;
- `basic` = `full` e `minimal` = `none` (D3).

## Risks / Trade-offs

- **[Curvas mais suaves nos extremos]** `ease-in-out` acelera mais devagar que o standard do Material. Os testes que
  conferem um quadro intermediário só exigem "entre a origem e o destino", então continuam válidos. → Os goldens que
  capturarem quadros intermediários são regerados.
- **[`minimal` igual a `none`]** Diverge do SAPUI5, onde o indicador de ocupado continua animado em `minimal`. → É
  provisório (ADR 0009), e o tema expõe o modo para a correção futura sem quebrar API.
- **[Quebra de API 0.x]** `resolveMotion` e os nomes das curvas primitivas mudam. → O CHANGELOG traz o de/para.
