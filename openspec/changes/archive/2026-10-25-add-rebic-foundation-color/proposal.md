# Proposal: Fundamento de cores semânticas (`rebic/foundation/color`)

## Why

Nenhum widget, sombra ou estado visual pode ser implementado sem cores vindas do design system: a spec
`rebic/framework-architecture` proíbe literais de cor nos widgets e exige o estado semântico de valor
(`none`/`success`/`warning`/`error`/`information`) "definido nos fundamentos". Elevação, estados de interação,
acessibilidade e tema dependem deste item no catálogo, e o contrato de tokens (`rebic/foundation/design-tokens`)
já está pronto para recebê-lo.

## What Changes

- Escalas primitivas de cor próprias do Rebic (neutro, azul, verde, âmbar, vermelho e ciano), em
  `rebic_primitives.dart`. A paleta é **provisória**, sem cores da SAP, e foi escolhida para o protótipo
  (questão em aberto 5 do design arquivado). Uma paleta de marca substitui as escalas sem alterar os papéis.
- Conjunto semântico `RebicColorTokens`, com papéis de superfície, conteúdo, borda, primário, foco, desabilitado,
  sombra e véu (*scrim*), e as cores de cada estado semântico de valor. Mapeamentos `light()` e `dark()` de referência.
- Enum `RebicValueState` (`none`, `success`, `warning`, `error`, `information`), compartilhado por entradas e status.
- Regra de contraste verificada por teste: texto ≥ 4,5:1 e elementos não textuais (borda forte, foco, primário,
  borda de estado) ≥ 3:1 sobre as superfícies, nos dois mapeamentos (WCAG 2.1 AA).
- Função pública de razão de contraste (WCAG), reutilizada depois pela convenção de acessibilidade.
- Página "Cores" na galeria, com as amostras dos papéis nos modos claro e escuro e a razão de contraste de cada par.
  A cor fixa da galeria (`#0A6ED1`, o azul do Fiori) passa a vir de `RebicColorTokens`.

Fora do escopo:
- Cores de hover/pressionado/selecionado, que pertencem a `add-rebic-foundation-interaction-states`.
- Sombras e níveis de elevação (`add-rebic-foundation-elevation`, que usará os papéis `shadow` e `scrim`).
- Escolha entre claro e escuro, propagação pela árvore e personalização (`add-rebic-foundation-theming`).
- Paleta oficial da marca da empresa.

## Capabilities

### New Capabilities

- `rebic/foundation/color`: escalas primitivas de cor, papéis semânticos de cor, mapeamentos claro e escuro de
  referência, estado semântico de valor e suas cores, e garantia de contraste mínimo dos pares de papéis.

### Modified Capabilities

Nenhuma. O requisito "Estado semântico de valor" de `rebic/framework-architecture` já diz que os estados ficam
nos fundamentos; esta change os define, sem alterar aquele texto.

## Impact

- **Código:** `packages/rebic_foundation/lib/src/color/`, exportações em `rebic_foundation.dart` (papéis, estado
  de valor e contraste) e `rebic_primitives.dart` (escalas). Os testes ficam em `packages/rebic_foundation/test/color/`.
- **Galeria:** nova página "Cores". `main.dart` deixa de usar o azul do Fiori.
- **Catálogo:** `rebic/foundation/color` → `implemented`.
- **Dependências:** apenas `rebic/foundation/design-tokens` (já é spec principal), P0 e fase 1, coerente com o
  catálogo. Nenhum pacote novo.
- **Portal existente:** sem impacto. Nenhum arquivo do portal é lido ou alterado.
