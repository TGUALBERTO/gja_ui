# Proposal: Botão no modelo do SAPUI5 (`update-rebic-button-fiori-button`)

## Why

O SAPUI5 tem um só `sap.m.Button` (conferido em `SAP/openui5`, `sap.m/Button.js`): `text`, `icon`, `type`, `enabled`
(padrão `true`), o `tooltip` herdado de `Control` e o evento `press`. O botão só com ícone é o mesmo controle, com
`icon`, sem `text` e com `tooltip`. O Rebic divide isso em dois widgets e usa os nomes e a convenção do Flutter:

- `RebicButton` tem `label` e `onPressed`, e `RebicIconButton` repete a família de cores, a borda, o raio e a
  interação, com `icon`, `tooltip` e `onPressed`;
- o estado desabilitado vem de `onPressed: null`, e não de uma propriedade `enabled`; a regra de nomes de
  `rebic/framework-architecture` exige isso para todo o framework.

É o primeiro passo do bloco de ações e dados do realinhamento ao SAPUI5.

## What Changes

- **BREAKING** `RebicIconButton` sai; `RebicButton` passa a cobrir o botão só com ícone, como o `sap.m.Button`:
  - `label` → `text` (`String?`), `onPressed` → `onPress`;
  - novo `enabled` (`bool`, padrão `true`): `false` desabilita; `onPress` nulo deixa o botão habilitado, sem ação,
    como um `sap.m.Button` sem tratador de `press`;
  - novo `tooltip` (`String?`), mostrado pelo `RebicTooltip`;
  - sem `text`, o botão é quadrado, de lado `density.controlHeight`, com o ícone centrado; `icon` e uma `tooltip`
    não vazia são obrigatórios, e a `tooltip` é o rótulo anunciado;
  - com `text`, a `tooltip` é opcional e anunciada como dica, além do rótulo;
  - `busy` vale também para o botão só com ícone: o indicador ocupa o lugar do ícone.
- O tipo padrão continua `standard` (o `Default` do UI5) nos dois casos; o botão só com ícone deixa de ter o padrão
  `transparent`, e quem o usa numa barra passa `type: transparent`.
- `RebicPage`, `RebicShellBar` e os exemplos do dartdoc (`RebicBar`, `RebicMenu`, `RebicDropdown`, `RebicPopover`,
  `RebicBadge`, `RebicIcon`) passam ao novo `RebicButton`.
- `rebic/framework-architecture`: o padrão de callback passa a seguir o evento do UI5 (`onPress`, `onChange`,
  `onSelectionChange`), e o desabilitado passa a ser `enabled: false`, não um callback nulo.
- A galeria troca as páginas "RebicButton" e "RebicIconButton" por uma só "RebicButton", com uma barra de ações de
  ícone.

Fora desta change, por escolha do usuário: `RebicLink`, `RebicMenuItem`, `RebicAvatar` e `RebicStatusIndicator`
continuam com `onPressed` e desabilitado por callback nulo; a próxima change os traz para `enabled`/`onPress`. Até
lá, eles divergem da regra de nomes revisada, e isso fica registrado na tarefa de acompanhamento.

Fora do escopo, cada um com change própria quando houver uso: `width`, `iconFirst` (ícone depois do texto),
`activeIcon`, `ariaHasPopup`, `accessibleRole`, os tipos `Ghost`, `Back`, `Up`, `Critical`, `Negative`, `Success` e
`Neutral`, e alternância (`ToggleButton`) e menu (`MenuButton`).

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/widgets/rebic-button`: API do UI5, botão só com ícone, dica, `enabled`.
- `rebic/widgets/rebic-icon-button`: retirada (`retire_capabilities`). Os requisitos passam a `rebic-button`.
- `rebic/framework-architecture`: convenção de callbacks e de desabilitado.
- `rebic/widgets/rebic-page`, `rebic/widgets/rebic-shell-bar`, `rebic/widgets/rebic-icon`: passam a citar
  `RebicButton`.

## Impact

- `packages/rebic_widgets`:
  - `acoes_navegacao/button/rebic_button.dart` com os dois formatos; `acoes_navegacao/icon_button/` sai, com a
    exportação;
  - `RebicPage` e `RebicShellBar`; dartdoc de barra, menu, dropdown, popover, badge e ícone;
  - testes e goldens do botão (os do botão de ícone passam para o botão), e os testes que montam botões (cerca de
    80 usos de `RebicButton` e `RebicIconButton`);
  - CHANGELOG com o de/para.
- `apps/rebic_gallery`: cerca de 40 usos e a página única "RebicButton".
- `docs/catalog.yaml`: sai `rebic/widgets/rebic-icon-button`; quem dependia dele (página, ShellBar e os itens
  planejados de barra de ferramentas, paginação e alerta) passa a depender de `rebic/widgets/rebic-button`, que
  ganha `rebic/widgets/rebic-tooltip`.
- Portal existente: nenhum impacto. A change é do framework e não altera o portal.
