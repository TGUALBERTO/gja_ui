# Proposal: Botão no modelo do SAPUI5 (`update-gja-button-fiori-button`)

## Why

O SAPUI5 tem um só `sap.m.Button` (conferido em `SAP/openui5`, `sap.m/Button.js`): `text`, `icon`, `type`, `enabled`
(padrão `true`), o `tooltip` herdado de `Control` e o evento `press`. O botão só com ícone é o mesmo controle, com
`icon`, sem `text` e com `tooltip`. O GJA divide isso em dois widgets e usa os nomes e a convenção do Flutter:

- `GjaButton` tem `label` e `onPressed`, e `GjaIconButton` repete a família de cores, a borda, o raio e a
  interação, com `icon`, `tooltip` e `onPressed`;
- o estado desabilitado vem de `onPressed: null`, e não de uma propriedade `enabled`; a regra de nomes de
  `gja/framework-architecture` exige isso para todo o framework.

É o primeiro passo do bloco de ações e dados do realinhamento ao SAPUI5.

## What Changes

- **BREAKING** `GjaIconButton` sai; `GjaButton` passa a cobrir o botão só com ícone, como o `sap.m.Button`:
  - `label` → `text` (`String?`), `onPressed` → `onPress`;
  - novo `enabled` (`bool`, padrão `true`): `false` desabilita; `onPress` nulo deixa o botão habilitado, sem ação,
    como um `sap.m.Button` sem tratador de `press`;
  - novo `tooltip` (`String?`), mostrado pelo `GjaTooltip`;
  - sem `text`, o botão é quadrado, de lado `density.controlHeight`, com o ícone centrado; `icon` e uma `tooltip`
    não vazia são obrigatórios, e a `tooltip` é o rótulo anunciado;
  - com `text`, a `tooltip` é opcional e anunciada como dica, além do rótulo;
  - `busy` vale também para o botão só com ícone: o indicador ocupa o lugar do ícone.
- O tipo padrão continua `standard` (o `Default` do UI5) nos dois casos; o botão só com ícone deixa de ter o padrão
  `transparent`, e quem o usa numa barra passa `type: transparent`.
- `GjaPage`, `GjaShellBar` e os exemplos do dartdoc (`GjaBar`, `GjaMenu`, `GjaDropdown`, `GjaPopover`,
  `GjaBadge`, `GjaIcon`) passam ao novo `GjaButton`.
- `gja/framework-architecture`: o padrão de callback passa a seguir o evento do UI5 (`onPress`, `onChange`,
  `onSelectionChange`), e o desabilitado passa a ser `enabled: false`, não um callback nulo.
- A galeria troca as páginas "GjaButton" e "GjaIconButton" por uma só "GjaButton", com uma barra de ações de
  ícone.

Fora desta change, por escolha do usuário: `GjaLink`, `GjaMenuItem`, `GjaAvatar` e `GjaStatusIndicator`
continuam com `onPressed` e desabilitado por callback nulo; a próxima change os traz para `enabled`/`onPress`. Até
lá, eles divergem da regra de nomes revisada, e isso fica registrado na tarefa de acompanhamento.

Fora do escopo, cada um com change própria quando houver uso: `width`, `iconFirst` (ícone depois do texto),
`activeIcon`, `ariaHasPopup`, `accessibleRole`, os tipos `Ghost`, `Back`, `Up`, `Critical`, `Negative`, `Success` e
`Neutral`, e alternância (`ToggleButton`) e menu (`MenuButton`).

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/widgets/gja-button`: API do UI5, botão só com ícone, dica, `enabled`.
- `gja/widgets/gja-icon-button`: retirada (`retire_capabilities`). Os requisitos passam a `gja-button`.
- `gja/framework-architecture`: convenção de callbacks e de desabilitado.
- `gja/widgets/gja-page`, `gja/widgets/gja-shell-bar`, `gja/widgets/gja-icon`: passam a citar
  `GjaButton`.

## Impact

- `packages/gja_widgets`:
  - `acoes_navegacao/button/gja_button.dart` com os dois formatos; `acoes_navegacao/icon_button/` sai, com a
    exportação;
  - `GjaPage` e `GjaShellBar`; dartdoc de barra, menu, dropdown, popover, badge e ícone;
  - testes e goldens do botão (os do botão de ícone passam para o botão), e os testes que montam botões (cerca de
    80 usos de `GjaButton` e `GjaIconButton`);
  - CHANGELOG com o de/para.
- `apps/gja_gallery`: cerca de 40 usos e a página única "GjaButton".
- `docs/catalog.yaml`: sai `gja/widgets/gja-icon-button`; quem dependia dele (página, ShellBar e os itens
  planejados de barra de ferramentas, paginação e alerta) passa a depender de `gja/widgets/gja-button`, que
  ganha `gja/widgets/gja-tooltip`.
- Portal existente: nenhum impacto. A change é do framework e não altera o portal.
