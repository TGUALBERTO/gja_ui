# Proposal: GjaStatusIndicator (`gja/widgets/gja-status-indicator`)

## Why

Listas, tabelas e cabeçalhos de objeto Fiori mostram a situação de um registro: "Aprovado" em verde, "Atrasado" em
vermelho, "Em análise" em azul. No SAPUI5, isso é o `sap.m.ObjectStatus`, que tem:
- `title`, `text` e `icon`;
- `state` (ValueState), que colore texto e ícone;
- `inverted`, uma etiqueta preenchida;
- `active`, que torna o status clicável, com evento `press`.

O GJA não tem esse widget. A galeria usaria `GjaText` com tom, sem ícone, título nem estado ativo.
`GjaAlert` (Fase 2) depende dele. O design da Fase 0 o previu sobre `GjaIcon` e `GjaText`.

## What Changes

- Widget `GjaStatusIndicator` em `gja_widgets` (categoria `exibicao-dados`):
  - `text` e `icon`, ambos opcionais, mas ao menos um é obrigatório;
  - `title`: rótulo antes do valor, como "Situação:", com o tom `muted`;
  - `state` (`GjaValueState`, padrão `none`): o texto e o ícone na cor de frente do estado; em `none`, a cor de
    texto padrão;
  - `inverted`: etiqueta com o fundo, a borda e o texto do estado, raio `s`;
  - `onPressed`: com ele, o status fica ativo, com sublinhado no hover, foco pelo teclado, Enter e Espaço, e é
    anunciado como botão. Sem ele, o status não é interativo.
- O texto quebra em várias linhas, como no `ObjectStatus`. O ícone fica antes do texto, no tamanho `icons.inline`,
  que acompanha a escala de texto.
- Semântica: "título valor" num só nó; o ícone é decorativo quando há texto.
- Página "GjaStatusIndicator" na galeria.

Fora do escopo:
- Cores de indicação além dos estados de valor (`Indication01`…`Indication08` do UI5). Elas dependem de novos
  papéis de cor no fundamento.
- Anúncio automático do texto do estado de valor ao leitor de tela. Os textos de estado do núcleo foram feitos para
  campos ("Valor inválido") e não descrevem uma situação de registro.
- Estado vazio (`emptyIndicatorMode`).

## Capabilities

### New Capabilities

- `gja/widgets/gja-status-indicator`: situação de um registro com título, ícone e texto por estado de valor,
  normal ou invertida, opcionalmente clicável.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/gja_widgets/lib/src/exibicao_dados/status_indicator/` e testes, com goldens.
- **Galeria:** nova página "GjaStatusIndicator".
- **Catálogo:** `gja/widgets/gja-status-indicator` → `implemented`. Além de `gja-icon` e `gja-text`, as
  dependências passam a incluir:
  - `core/interaction`;
  - os fundamentos `color`, `typography`, `iconography`, `spacing`, `radius`, `interaction-states`, `theming` e
    `accessibility`.
- **Portal existente:** sem impacto.
