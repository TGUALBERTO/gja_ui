# Proposal: GjaLink (`gja/widgets/gja-link`)

## Why

Telas Fiori usam links para navegação secundária e referências a objetos: "Ver pedido", o número de um documento
numa tabela, "Esqueci a senha". No SAPUI5, isso é o `sap.m.Link`, que tem:
- `text`, `press` e `enabled`;
- `emphasized` (negrito) e `subtle` (cor do texto);
- `wrapping`;
- cor `sapLinkColor`, sublinhado no hover e papel de link para o leitor de tela.

O GJA ainda não tem um link. A galeria imita links com `GjaText` tocável, sem estados nem semântica.
`GjaBreadcrumbs` (Fase 2) depende dele. O design da Fase 0 o previu sobre `core/interaction` e `GjaText`.

`GjaInteractable` sempre se anuncia como botão. Um link anunciado como botão contraria o modelo do UI5 e a
expectativa de quem usa leitor de tela.

## What Changes

- Widget `GjaLink` em `gja_widgets` (categoria `acoes-navegacao`):
  - `text` (obrigatório, não vazio) e `onPressed` (`null` desabilita, com a opacidade de desabilitado);
  - `emphasized`: rótulo em `bodyStrong`;
  - `subtle`: cor `colors.text`, em vez de `colors.link`;
  - `wrapping` (padrão `false`): numa linha, com reticências, ou em várias linhas;
  - sublinhado no hover e no pressionado, como no UI5;
  - foco pelo teclado com anel, e ativação por Enter e Espaço;
  - anunciado como link, não como botão.
- Em `gja/core/interaction`, o `GjaInteractable` ganha a indicação de papel de link (`link`, padrão `false`), que
  expõe o papel de link em vez do de botão.
- Página "GjaLink" na galeria.

Fora do escopo:
- Abrir URLs (`href`/`target`): isso exige uma dependência de plataforma e fica para uma change própria. A ação é
  sempre `onPressed`.
- Links dentro de um parágrafo, como trechos de texto rico. Este link é um elemento próprio.
- Link com ícone e "visitado".

## Capabilities

### New Capabilities

- `gja/widgets/gja-link`: link de ação com texto, variantes enfatizada e sutil, quebra opcional, sublinhado no
  hover, desabilitado e semântica de link.

### Modified Capabilities

- `gja/core/interaction`: o requisito "Semântica e cursor" passa a admitir o papel de link, com um cenário.

## Impact

- **Código:**
  - `packages/gja_core/lib/src/interaction/interactable.dart`: um parâmetro aditivo `link`. Com o padrão, a
    semântica é a mesma de hoje;
  - `packages/gja_widgets/lib/src/acoes_navegacao/link/` e testes, com goldens.
- **Galeria:** nova página "GjaLink".
- **Catálogo:** `gja/widgets/gja-link` → `implemented`, mantendo P1/Fase 2. `gja-text` sai das dependências,
  porque o link desenha o rótulo com os tokens de tipografia e a cor do estado, como o `GjaButton`. As dependências
  passam a incluir `core/interaction` e os fundamentos `color`, `typography`, `interaction-states`, `radius`,
  `theming` e `accessibility`.
- **Portal existente:** sem impacto.
