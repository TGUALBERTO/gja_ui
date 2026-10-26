# Design: Fundamento de design tokens

## Context

- `rebic_foundation` está vazio (Fase 0). Ele depende só do SDK Flutter e é a camada base (ADR 0002).
- Os três níveis foram decididos na ADR 0005. Os requisitos estão na spec `rebic/foundation/design-tokens` desta change.
- A API pública não pode usar Material (ADR 0004). Por isso, `ThemeExtension`, que fica em `package:flutter/material.dart`, não pode ser reutilizado.
- `rebic_checks tokens` já rejeita literais de `Duration`, `Color`, `EdgeInsets` e `BorderRadius` em `rebic_widgets/lib`.
  `rebic_checks architecture` já rejeita imports que vão contra a direção das camadas, mas ainda não distingue bibliotecas dentro de um pacote.

## Goals / Non-Goals

**Goals:**

- Uma base pequena e reutilizável, que cada fundamento seguinte (cores, tipografia etc.) apenas estende.
- Nenhuma dependência nova: nada de geração de código nem de pacotes de terceiros.
- Isolamento dos primitivos verificado por máquina, e não só por revisão.

**Non-Goals:**

- `RebicThemeData`, a agregação dos conjuntos em um tema e a propagação pela árvore (`InheritedWidget`).
  Ficam com `add-rebic-foundation-theming` e `add-rebic-theme`. Esta change entrega só os blocos que eles vão compor.
- Preferência de movimento reduzido do sistema. É assunto da convenção de acessibilidade, que vai ler o conjunto de movimento daqui.
- Tokens gerados de JSON (Style Dictionary), adiados pela ADR 0005.

## Decisions

### D1. Contrato `RebicTokenSet<T>` como classe base abstrata

```dart
@immutable
abstract class RebicTokenSet<T extends RebicTokenSet<T>> with Diagnosticable {
  const RebicTokenSet();
  T copyWith();          // as subclasses declaram os parâmetros nomeados
  T lerp(T? other, double t);
}
```

Cada conjunto concreto implementa `==`, `hashCode`, `copyWith`, `lerp` e `debugFillProperties` à mão.
A classe base não declara `==`, só documenta a obrigação. Os testes cobrem o contrato de cada conjunto com um
helper compartilhado (`expectTokenSetContract`), que verifica `copyWith()` igual ao original, os extremos de `lerp`,
`lerp(null)` e igualdade/`hashCode`.

- **Alternativa:** `freezed`/`equatable`. Foi rejeitada porque adiciona dependência e `build_runner` a uma camada
  base que precisa ser consumível por qualquer aplicação (spec `rebic/framework-architecture`).
- **Alternativa:** só convenção, sem classe base. Foi rejeitada porque as extensões (D4) precisam de um tipo comum para `lerp`.

### D2. Primitivos como constantes estáticas em biblioteca separada

```
packages/rebic_foundation/lib/
  rebic_foundation.dart          // exporta src/tokens/ (contrato, movimento semântico, extensões)
  rebic_primitives.dart          // exporta src/tokens/primitives/
  src/tokens/
    token_set.dart
    token_extensions.dart
    lerp.dart                    // helpers internos, não exportados
    motion_tokens.dart
    primitives/motion_primitives.dart
```

Primitivos são `abstract final class RebicMotionPrimitives { static const duration100 = Duration(milliseconds: 100); … }`.
Eles não são conjuntos (não têm `lerp`), porque nunca são trocados em tempo de execução: o tema troca o
**mapeamento** semântico, não as escalas.

- **Alternativa:** enum com valor. Foi rejeitada porque `Curve` e `Duration` não são constantes canônicas em enum,
  e a extensão por marcas ficaria mais rígida.
- **Alternativa:** primitivos em `src/` sem biblioteca pública. Foi rejeitada porque a aplicação precisa deles para
  personalizar a marca sem importar `src/` (cenário "Aplicação personaliza a marca").

### D3. Conjunto semântico de movimento

`RebicMotionTokens extends RebicTokenSet<RebicMotionTokens>` tem os campos `instant`, `short`, `medium` e `long`
(`Duration`) e `standard`, `enter` e `exit` (`Curve`). O construtor `const RebicMotionTokens.fallback()` mapeia os primitivos:

| Papel | Primitivo | Valor |
|---|---|---|
| `instant` | `duration0` | 0 ms |
| `short` | `duration100` | 100 ms |
| `medium` | `duration200` | 200 ms |
| `long` | `duration300` | 300 ms |
| `standard` | `curveStandard` | `Cubic(0.4, 0, 0.2, 1)` |
| `enter` | `curveDecelerate` | `Cubic(0, 0, 0.2, 1)` |
| `exit` | `curveAccelerate` | `Cubic(0.4, 0, 1, 1)` |

Escala de duração dos primitivos: 0, 50, 100, 150, 200, 250, 300, 400 e 500 ms. As curvas não formam escala e são
nomeadas pela forma, o que a regra de nomenclatura admite, porque ela fala da posição na escala apenas quando há escala.
A ordem `instant ≤ short ≤ medium ≤ long` e `instant == 0` é verificada com `assert` em `copyWith`. O construtor `const` não pode verificá-la, porque comparar `Duration` não é uma expressão constante em Dart. O mapeamento `fallback()` tem teste próprio de ordem.

O nome `fallback` deixa claro que este é o valor usado quando o tema não define outro. Os temas claro e escuro de
`theming` vão usar o mesmo mapeamento ou um próprio.

### D4. Extensões tipadas sem Material

`RebicTokenExtension<T extends RebicTokenExtension<T>> extends RebicTokenSet<T>`, com `Object get type => T`.
`RebicTokenExtensions` é uma coleção imutável `Map<Object, RebicTokenExtension<dynamic>>`, construída a partir de um `Iterable`, com:

- `T? get<T extends RebicTokenExtension<T>>()`, que retorna nulo quando o tipo não está registrado;
- `lerp(other, t)`, que interpola pelo tipo e mantém as extensões presentes em só uma das coleções;
- `==`/`hashCode` por conteúdo (`mapEquals`);
- um `assert` contra tipos duplicados, com mensagem que nomeia o tipo.

O desenho é o mesmo do `ThemeExtension` do Material, reimplementado para não depender dele (ADR 0004).
`theming` vai incluir um `RebicTokenExtensions` no `RebicThemeData`.

- **Alternativa:** `Map<Type, Object>` público. Foi rejeitada porque perde a tipagem e a interpolação.

### D5. Helpers de interpolação internos

Ficam em `src/tokens/lerp.dart`, sem exportação:

- `lerpDurationValue(a, b, t)`, por microssegundos com arredondamento;
- `lerpDiscrete<V>(a, b, t)`, que retorna `t < 0.5 ? a : b`.

Os fundamentos seguintes os reutilizam por import relativo dentro do pacote. Para `Color`, `double` e `EdgeInsets`
eles usam os `lerp` do SDK.

### D6. Regra de isolamento em `rebic_checks architecture`

Nova regra no laço de diretivas de `architecture_check.dart`. Em qualquer pacote do framework diferente de
`rebic_foundation`, um `import` ou `export` de `package:rebic_foundation/rebic_primitives.dart` ou de
`package:rebic_foundation/src/…` é violação, com arquivo e linha. Isso cobre também o agregador `rebic_ui`,
já que reexportar seria a forma de "expor primitivos". Testes com fixtures:

- widget importando primitivos;
- `core` importando `src/`;
- `rebic_ui` exportando primitivos;
- `rebic_foundation` importando a própria biblioteca (aceito).

- **Alternativa:** checar só `rebic_widgets`. Foi rejeitada porque `core` também não deve conhecer valores brutos,
  e o agregador não pode reexportá-los.

### D7. Rastreabilidade do nível de cada token

O dartdoc de cada classe pública de tokens começa com uma linha `Nível: primitivo|semântico|componente.`
Um teste em `rebic_foundation` lê `lib/src/tokens/**` e verifica que toda classe pública tem essa linha.
É o cenário "Nível documentado".

### D8. Página da galeria

A galeria continua sobre `WidgetsApp` (`RebicApp` é posterior). A página inicial passa a listar as páginas,
e cada página vira uma rota nomeada. A página "Design tokens" mostra a tabela de papéis de movimento e um controle
que anima `RebicMotionTokens.lerp` entre `fallback()` e um conjunto "lento" (o dobro das durações). A galeria é
aplicação, fora de `rebic_widgets/lib`, então pode usar literais visuais provisórios até existirem os tokens de cor e de espaçamento.

## Risks / Trade-offs

- [`==`/`hashCode`/`copyWith` escritos à mão podem esquecer um campo] → `expectTokenSetContract` em todo conjunto, e um teste que altera cada campo isoladamente.
- [Assinatura genérica auto-referente (`T extends RebicTokenSet<T>`) é menos familiar] → Dartdoc com exemplo completo de conjunto e de extensão.
- [Valores de curva e duração parecidos com os de outros design systems] → São curvas cúbicas genéricas, de domínio público. A identidade de marca está na cor e na tipografia, não no movimento.
- [A regra D6 bloqueia testes de `rebic_widgets` que queiram primitivos] → A regra só olha `lib/`. Os testes podem importar primitivos.

## Migration Plan

Não há migração: a API é nova e não existe nenhum consumidor. O rollback é reverter a change.
