# Design: Fundamento de breakpoints

## Context

Este fundamento segue o padrão de `spacing` e `radius`: primitivos em `abstract final class` com mapa ordenado,
conjunto semântico com `fallback()` constante e validação com `assert` no `copyWith`. A diferença é que este
conjunto também tem comportamento: a classificação de uma largura. É uma função pura, sem acesso à árvore de
widgets. A medição da largura disponível é de `core/responsive`.

## Goals / Non-Goals

**Goals:**

- Uma única função de classificação, usada por todos os layouts, com regras de borda explícitas e testadas.
- Limiares personalizáveis por tema, sem mudar o código dos widgets.

**Non-Goals:**

- Escolher qual largura medir (tela, janela ou constraints do pai). Fica com `core/responsive`, que provavelmente
  usará a largura do pai via `LayoutBuilder` para os layouts e `MediaQuery.sizeOf` para o scaffold.
- Histerese (evitar oscilação perto do limiar). Se for necessária, será tratada em `core/responsive`.

## Decisions

### D1. Valores de referência

`small` < 600 ≤ `medium` < 1024 ≤ `large` < 1440 ≤ `extraLarge`.

- 600 separa celular de tablet, uma convenção amplamente usada.
- 1024 separa tablet e notebooks pequenos de desktop, onde cabem a navegação lateral fixa e a tabela com várias colunas.
- 1440 marca desktop largo, onde cabem colunas extras e painéis laterais.

Os valores são próprios do Rebic, escolhidos por convenção de mercado. A escala primitiva também inclui 360, 840,
1280 e 1920, para personalizações e para os layouts avançados da Fase 4.

### D2. API

```dart
enum RebicSizeClass { small, medium, large, extraLarge;
  bool isAtLeast(RebicSizeClass other) => index >= other.index;
  bool isAtMost(RebicSizeClass other) => index <= other.index;
}

class RebicBreakpointTokens extends RebicTokenSet<RebicBreakpointTokens> {
  final double medium, large, extraLarge;           // larguras mínimas
  const RebicBreakpointTokens.fallback();
  RebicSizeClass classify(double width);
  double minWidthOf(RebicSizeClass sizeClass);      // small → 0
}
```

Os nomes dos campos coincidem com os da enum de propósito. `minWidthOf` permite à galeria e a `core/responsive`
listar os limiares sem um `switch` próprio.

- **Alternativa:** `Map<RebicSizeClass, double>`. Foi rejeitada porque não é `const` com igualdade por valor
  e não garante a ordem no tipo.

### D3. Regras de borda

`classify` lança `ArgumentError.value(width, 'width')` para `NaN` ou valor negativo. A comparação usa `>=` contra
os limiares do maior para o menor, então `double.infinity` resulta em `extraLarge` naturalmente. O `ArgumentError`
também vale em release, porque um valor inválido indica erro de quem chama e não deve virar `small` em silêncio.

### D4. Validação e interpolação

`copyWith` faz `assert` de limiares finitos, `> 0` e `medium < large < extraLarge`, com uma mensagem que cita os três
valores. `lerp` usa `lerpDouble` em cada limiar. Interpolar dois conjuntos válidos mantém a ordem estrita, por ser
uma combinação convexa. O teste de contrato cobre isso no ponto médio.

### D5. Galeria

A página "Breakpoints" (`pages/breakpoints_page.dart`) mostra:

- a largura atual (`MediaQuery.sizeOf(context).width`);
- a classe resultante de `RebicBreakpointTokens.fallback().classify(...)`;
- a tabela com o limiar mínimo de cada classe.

O uso direto de `MediaQuery` é aceitável na galeria, que é aplicação. Os widgets do framework usarão
`core/responsive`. O teste da página roda com as quatro larguras de janela da spec, usando `setSurfaceSize`.

## Risks / Trade-offs

- [Limiares de mercado podem não servir ao portal] → São personalizáveis por tema. A troca acontece no mapeamento, sem mudar os widgets.
- [Oscilação de layout perto de um limiar durante redimensionamento] → Fica fora deste fundamento (D3, Non-Goals), e `core/responsive` decide.

## Migration Plan

Não há consumidores. O rollback é reverter a change.
