# ADR 0009 — Valores provisórios do tema Horizon

- **Status:** Aceita (protótipo)
- **Data:** 2026-10-28

## Contexto

O Rebic adota o SAPUI5 e o tema Horizon do SAP Fiori como modelo de conceitos, nomes e comportamento, sem código nem
assets da SAP. A auditoria de fidelidade de 2026-10-28 abriu uma série de changes de realinhamento da fundação, uma
por fundamento.

Alguns valores exatos do Horizon não podem ser confirmados sem material da SAP: pesos, alturas de linha, raios e
cores de estados específicos. Bloquear cada change até confirmar esses valores travaria o protótipo (ADR 0001).

## Decisão

1. Quando um valor exato do Horizon não puder ser confirmado, o Rebic adota o valor mais próximo que seja coerente
   com as regras das specs, como a grade de 4 px e as razões de contraste.
2. O valor fica marcado como provisório na tabela abaixo, com a change que o introduziu.
3. Cada change de realinhamento acrescenta suas linhas a esta ADR, em vez de criar uma ADR por fundamento.
4. Os nomes seguem os parâmetros de tema do SAPUI5 (`sapFontHeader1Size`, `sapContent_Shadow0` etc.) mesmo quando o
   valor é provisório.

### Valores provisórios

| Fundamento | Valor | Adotado | Referência Horizon | Change |
|---|---|---|---|---|
| Tipografia | Peso dos títulos `header1`…`header6` | bold (700) | `sapFontHeaderFamily` | `update-rebic-foundation-typography-fiori-sizes` |
| Tipografia | Alturas de linha de todos os estilos | múltiplo de 4 ≥ 1,2 × tamanho (`header1` 48/60) | alturas do Horizon não confirmadas | `update-rebic-foundation-typography-fiori-sizes` |
| Tipografia | Família semibold do texto de botões | Inter 600 | `sapButton_FontFamily` (72 semibold duplex) | `update-rebic-foundation-typography-fiori-sizes` |
| Estados de interação | Fundo de hover de cada estado de valor | um tom acima do `background` do estado (claro: 100, `none` 200; escuro: 800, `none` 700) | `sapButton_Accept_Hover_Background`, `_Reject_`, `_Attention_` | `update-rebic-foundation-interaction-states-fiori-alignment` |
| Estados de interação | Ativo, selecionado e selecionado com hover de Accept, Reject e Attention | normal invertido: fundo e borda `foreground`, texto `background` do estado | `sapButton_Accept_Active_Background` e `_Active_TextColor` (também no Horizon Evening) | `update-rebic-foundation-interaction-states-fiori-alignment` |
| Sombras | Geometria de `shadow0`…`shadow3` | `shadow0`: (0, 2) e (2, 4); `shadow1`…`3`: contorno de 1 px e difusa (2, 8), (10, 30) e (20, 80), com fatores de opacidade 1 e 0,5 sobre `colors.shadow` | `sapContent_Shadow0`…`3` (cor de sombra e opacidades por camada não confirmadas) | `update-rebic-foundation-elevation-horizon-shadows` |
| Sombras | Papel `dragged` | `shadow3` | o SAPUI5 não define sombra de item arrastado | `update-rebic-foundation-elevation-horizon-shadows` |

## Alternativas consideradas

- **Bloquear até confirmar cada valor.** Rejeitada porque o protótipo não tem acesso ao material de referência
  (ADR 0001).
- **Uma ADR por fundamento.** Rejeitada porque espalharia a mesma política em nove ADRs.

## Consequências

- Os valores provisórios ficam localizados num só lugar e podem ser corrigidos por changes `update-rebic-…` quando
  forem confirmados.
- **Condição de saída:** todos os valores da tabela confirmados ou substituídos por uma decisão de identidade
  própria; nesse caso esta ADR é marcada como substituída.
