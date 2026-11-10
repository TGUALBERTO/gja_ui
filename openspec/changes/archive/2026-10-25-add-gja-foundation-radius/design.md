# Design: Fundamento de raios de borda

## Context

Este fundamento segue o padrão já usado em `spacing`: primitivos em `abstract final class` com mapa ordenado,
conjunto semântico com `fallback()` constante e `assert` de valores finitos e não negativos no `copyWith`.
`gja_checks tokens` já cobre `BorderRadius…(<número>)` e `Radius.circular(<número>)`.

## Goals / Non-Goals

**Goals:**

- Poucos passos, e dois papéis que cobrem quase todos os widgets previstos (`control` e `container`).
- Pílula sem caso especial nos widgets: `BorderRadius.circular(radius.full)` resolve.

**Non-Goals:**

- Raios por canto, cortes chanfrados ou formas que não são retângulos arredondados.

## Decisions

### D1. Primitivos

`GjaRadiusPrimitives` (`lib/src/radius/primitives/radius_primitives.dart`) tem `radius0`, `radius2`, `radius4`,
`radius6`, `radius8`, `radius12` e `radius16` (`double`), o mapa ordenado `values` (sem `full`) e
`radiusFull = 9999`.

Por que `9999` e não `double.infinity`: com `RRect`, o Flutter reduz os raios proporcionalmente quando a soma
excede a dimensão do retângulo, então um valor grande e finito vira exatamente a metade da menor dimensão.
`double.infinity` gera `NaN` nessa redução (∞ × 0) e quebra `lerp`.

- **Alternativa:** `StadiumBorder` para pílulas. Foi rejeitada porque obriga os widgets a trocar o tipo de borda
  conforme o token, em vez de usar só um número.

### D2. `GjaRadiusTokens.fallback()`

| Passo | Valor | Papel | Valor |
|---|---|---|---|
| none | radius0 | control | radius4 (= s) |
| xs | radius2 | container | radius8 (= m) |
| s | radius4 | | |
| m | radius8 | | |
| l | radius12 | | |
| xl | radius16 | | |
| full | radiusFull | | |

Os papéis são campos próprios, como os papéis de layout do espaçamento, e podem ser personalizados sem mexer na escala.

### D3. Validação e interpolação

`copyWith` faz `assert` de valores finitos e `>= 0`, com o nome do campo na mensagem. `lerp` usa `lerpDouble` em
todos os campos. Entre `full` (9999) e um passo pequeno, a interpolação passa por valores intermediários grandes,
que o `RRect` continua reduzindo. É um comportamento aceitável para a animação de troca de tema.

### D4. Testes

- **"Pílula em um controle":** `RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, 120, 32), Radius.circular(full)).scaleRadii()`
  deve ter raios de 16 em todos os cantos. É o mesmo cálculo que o motor aplica ao desenhar.
- **Uso sem literais:** dois testes em `tool/gja_checks/test/tokens_test.dart`, como no espaçamento.

### D5. Galeria

A página "Raios" (`pages/radius_page.dart`) mostra uma caixa de 120 × 48 por passo e papel, com
`BorderRadius.circular(valor)`, nome e valor (`full` é exibido como "pílula"). Cores, espaçamentos e tipografia vêm dos tokens.

## Risks / Trade-offs

- [Um componente maior que 2 × 9999 px não ficaria em pílula] → Isso está fora de qualquer caso previsto. A spec fixa o mínimo de 2048, coberto por teste.
- [`lerp` entre `full` e um passo pequeno anima de forma não linear] → É apenas visual, durante a troca de tema, e não é um requisito.

## Migration Plan

Não há consumidores. O rollback é reverter a change.
