# Proposal: RebicIconButton (`rebic/widgets/rebic-icon-button`)

## Why

Ações só com ícone (editar, excluir, mais opções, abrir a navegação, voltar) aparecem em barras, linhas de tabela e
cabeçalhos. No SAPUI5, são um `sap.m.Button` só com `icon` e com `tooltip`. A dica é obrigatória, porque é o único
texto da ação.

Hoje o `RebicScaffold` e a `RebicPage` usam um botão interno (`RebicTransparentIconAction`). Ele foi criado como
provisório até existir um botão de ícone público, e não tem dica visível. O design da Fase 0 previu
`RebicIconButton` sobre `core/interaction`, `RebicIcon` e `RebicTooltip`, logo depois do `RebicButton`.

## What Changes

- Widget `RebicIconButton` em `rebic_widgets` (categoria `acoes-navegacao`):
  - `icon` e `tooltip` obrigatórios, sendo que a dica não pode ser vazia;
  - `onPressed` (`null` desabilita);
  - `type` (`RebicButtonType`), com padrão `transparent`, como os botões de ícone das barras Fiori.

  Comportamento:
  - é quadrado, com lado `density.controlHeight`, e tem o ícone `icons.control` na cor de texto do estado;
  - tem os estados e as cores da família do tipo, como o `RebicButton`;
  - a dica abre por hover, foco ou toque longo, pelo `RebicTooltip`;
  - para o leitor de tela, `tooltip` é o rótulo do botão, uma única vez.
- `RebicTooltip` ganha `excludeFromSemantics` (padrão `false`). Ele é usado quando o filho já anuncia a mensagem como
  rótulo, para que ela não seja anunciada duas vezes.
- `RebicScaffold` e `RebicPage` passam a usar `RebicIconButton` no botão de navegação e no de voltar, com as dicas
  "Navegação" e "Voltar". O botão interno `RebicTransparentIconAction` é removido.
- Página "RebicIconButton" na galeria.

Fora do escopo:
- Estado ocupado e alternância (selecionado) no botão de ícone.
- Tamanhos de ícone diferentes de `control`.
- Badge sobre o ícone, que é do `RebicBadge`.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-icon-button`: botão só com ícone, com dica obrigatória, tipos Fiori, estados de interação e
  desabilitado.

### Modified Capabilities

- `rebic/widgets/rebic-tooltip`: `[API] Propriedades` ganha `excludeFromSemantics`, e `[Acessibilidade] Semântica e
  contraste` ganha a exceção correspondente, com um cenário.
- `rebic/widgets/rebic-scaffold`: `[Integração] Dependências de widgets e núcleo` passa a incluir
  `rebic/widgets/rebic-icon-button`.
- `rebic/widgets/rebic-page`: `[Integração] Dependências de widgets` passa a incluir `rebic/widgets/rebic-icon-button`.

## Impact

- **Código:**
  - `packages/rebic_widgets/lib/src/acoes_navegacao/icon_button/` e testes, com goldens;
  - `RebicTooltip`, que ganha o parâmetro aditivo;
  - o scaffold e a página, que trocam o botão interno pelo público;
  - a remoção de `lib/src/fundacao_layout/action/`.

  O comportamento do scaffold e da página não muda: o rótulo, o estado expandido, as cores e o tamanho continuam
  iguais. Eles ganham a dica visível. Os goldens deles são verificados e só regenerados se a única diferença for o
  antialiasing do ícone, que passa de `ColorFiltered` a cor direta.
- **Galeria:** nova página "RebicIconButton".
- **Catálogo:**
  - `rebic/widgets/rebic-icon-button` → `implemented`, com as dependências usadas de fato;
  - `rebic-scaffold` e `rebic-page` ganham `rebic/widgets/rebic-icon-button` nas dependências.
- **Reclassificação no catálogo:** `rebic-progress-indicator`, `rebic-tooltip`, `rebic-button` e
  `rebic-icon-button` passam de P1/Fase 2 para P0/Fase 1. O catálogo não deixa um item da Fase 1 depender de um da
  Fase 2, e o scaffold e a página (P0/Fase 1) passam a usar o botão de ícone, que depende dos outros três. No
  SAPUI5, a barra da aplicação e a página usam o próprio `sap.m.Button` público com dica; tratá-lo como controle
  básico, junto com a dica e o indicador, segue esse modelo. Os quatro já estão implementados.
- **Portal existente:** sem impacto.
