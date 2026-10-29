# Design: Raios no modelo Fiori

## Context

`RebicRadiusTokens` (em `rebic_foundation/lib/src/radius/`) tem sete passos e os papéis `control` (4) e `container`
(8). O getter `values` alimenta o diagnóstico e a comparação de nomes com `RebicRadius`, o enum de `RebicContainer`.

Usos de `control` e `container`:
- núcleo: `RebicInteractable`, no raio padrão do anel de foco;
- widgets: `RebicButton`, `RebicIconButton`, `RebicLink` (anel), `RebicCard` (contêiner e anel do cabeçalho),
  `RebicPopover` e `RebicContainer` (enum);
- galeria: cerca de 15 páginas;
- testes de contêiner, cartão, popover, dropdown e valores do tema do núcleo.

A escala primitiva já tem 2, 4, 8, 12 e 16.

## Goals / Non-Goals

**Goals:**
- Papéis com os nomes e valores dos parâmetros `sap*_BorderCornerRadius` do Horizon.
- Cada widget existente no papel do seu tipo Fiori.

**Non-Goals:**
- Mudar a escala primitiva ou os passos.
- Mapear os raios de dica, avatar e status (ver proposal.md).

## Decisions

### D1. Papéis

`RebicRadiusTokens` ganha `button`, `field`, `popover`, `element` e `tile`, obrigatórios no construtor e incluídos em
`copyWith`, `lerp`, `==`, `hashCode`, `values` e diagnóstico, nessa ordem, depois dos passos. `control` e
`container` são removidos sem alias.

Referência:
- `button` = `radius8`;
- `field` = `radius4`;
- `popover` = `radius8`;
- `element` = `radius12`;
- `tile` = `radius16`.

O dartdoc de cada papel cita o parâmetro Fiori.

A spec deixa de exigir `control ≤ container`, porque os papéis do Fiori não formam uma ordem: `popover` é igual a
`button`, e `field` é menor que os dois.

### D2. Widgets e núcleo

| Uso | Antes | Depois |
|---|---|---|
| `RebicButton`, `RebicIconButton` | `control` (4) | `button` (8) |
| `RebicInteractable` (anel padrão) | `control` | `button` |
| `RebicLink` (anel) | `control` | `xs` (2) |
| `RebicCard` (superfície e anel do cabeçalho) | `container` (8) | `tile` (16) |
| `RebicPopover` | `container` (8) | `popover` (8) |
| `RebicContainer` (`RebicRadius`) | `control`, `container` | `button`, `field`, `popover`, `element`, `tile` |

O anel do link usa `xs` porque o Horizon desenha o contorno de foco do `sap.m.Link` quase reto. Fica registrado como
provisório.

### D3. Galeria

As páginas que usam `radius.control` em amostras de controle passam a `radius.button`, e as que usam
`radius.container` em superfícies passam a `radius.tile` (cartões) ou `radius.popover` (sobreposições), conforme o
que a amostra representa. A página "Raios" lista os doze nomes de `values`.

### D4. ADR 0009

Nova linha provisória: os valores de `button`, `field`, `popover`, `element` e `tile`, e o raio `xs` do anel do link.

## Risks / Trade-offs

- **[Botões mais arredondados]** Os cantos dos botões passam de 4 a 8. É o visual do Horizon, e os goldens de botão,
  botão de ícone e páginas com botões são regerados.
- **[Cartões mais arredondados]** O raio do cartão passa de 8 a 16. O recorte do conteúdo continua acompanhando o
  raio. → Os goldens de cartão e contêiner são regerados e conferidos por amostragem.
- **[Quebra de API 0.x]** `control`, `container` e os valores do enum `RebicRadius` mudam. → O CHANGELOG traz o
  de/para.
