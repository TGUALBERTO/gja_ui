# Design: Fundamento de espaçamentos

## Context

- O contrato de tokens, os helpers internos e as bibliotecas de primitivos já existem (`rebic/foundation/design-tokens`).
  `color` e `motion` servem de modelo: primitivos em `abstract final class`, um mapa ordenado para testes,
  conjunto semântico com `fallback()`/`light()` constantes e validação com `assert` no `copyWith`.
- `rebic_checks tokens` já cobre `EdgeInsets…(<número>)` e `width|height|spacing|gap…: <número>` em
  `rebic_widgets/lib`, e aceita referências a tokens. Os testes atuais usam fixtures genéricas,
  sem o nome dos cenários desta spec.

## Goals / Non-Goals

**Goals:**

- Uma escala pequena e previsível (grade de 4 px), que a densidade compacta possa reduzir trocando só o mapeamento.
- Papéis de layout com nomes de intenção, para que os widgets de layout não escolham passos arbitrários.

**Non-Goals:**

- Tokens que variam por largura de tela. `pageMargin` tem um valor só aqui; `core/responsive` poderá trocar o
  conjunto por classe de tamanho.
- Espaçamento negativo (sobreposição), que não é um caso de uso dos componentes previstos.

## Decisions

### D1. Primitivos

`RebicSpacingPrimitives` (`lib/src/spacing/primitives/spacing_primitives.dart`), reexportado por `rebic_primitives.dart`:
`space0`, `space2`, `space4`, `space8`, `space12`, `space16`, `space20`, `space24`, `space32`, `space40`, `space48`,
`space64` (`double`) e o mapa ordenado `values`. Os nomes seguem o valor, como `durationN` no movimento.

### D2. `RebicSpacingTokens.fallback()` (densidade confortável)

| Passo | Valor | Papel de layout | Valor |
|---|---|---|---|
| none | space0 | inlineGap | space8 (= s) |
| xxs | space2 | stackGap | space12 (= m) |
| xs | space4 | sectionGap | space32 (= xxl) |
| s | space8 | pageMargin | space16 (= l) |
| m | space12 | | |
| l | space16 | | |
| xl | space24 | | |
| xxl | space32 | | |
| xxxl | space48 | | |

Os papéis são campos próprios, e não getters que apontam para passos. Assim a densidade e as aplicações podem
ajustar um papel sem mexer na escala. A coerência "papel = algum passo" é garantida só no mapeamento de
referência, por teste.

- **Alternativa:** papéis como getters derivados (`inlineGap => s`). Foi rejeitada porque impede personalizar um
  papel isoladamente e esconde a intenção no `copyWith`.

### D3. Validação

`copyWith` verifica com `assert` que todos os valores são finitos e `>= 0`, e a mensagem nomeia o campo inválido.
O motivo é o mesmo do movimento: o construtor `const` não chama `isFinite`. A ordem dos passos não é imposta fora
do mapeamento de referência, porque uma densidade ou marca pode querer, por exemplo, `xxs == xs`.

### D4. Teste de uso sem literal

`tool/rebic_checks/test/tokens_test.dart` ganha dois testes com os nomes dos cenários de "Uso sem literais nos widgets":

- uma fixture com `EdgeInsets.all(spacing.m)` e `SizedBox(width: spacing.inlineGap)`, que deve ser aceita;
- uma fixture com `SizedBox(width: 8)`, que deve falhar com a linha correta.

Nenhuma regra do CLI muda.

### D5. Galeria

Página "Espaçamentos" (`pages/spacing_page.dart`): uma linha por passo e por papel, com nome, valor e uma barra de
largura proporcional. A página já usa `RebicSpacingTokens.fallback()` nos próprios paddings, como primeiro
consumidor real. Cores vêm de `RebicColorTokens.light()`.

## Risks / Trade-offs

- [Escala confortável grande demais para telas densas de dados] → A densidade compacta (próxima change dependente) reduz o mapeamento sem mudar os nomes.
- [Papéis independentes dos passos podem divergir em personalizações] → Isso é intencional (D2). O teste só cobre a referência, e a documentação recomenda derivar os papéis dos passos.

## Migration Plan

Não há consumidores. O rollback é reverter a change.
