# Design: `enabled` e `onPress` nas ações

## Context

`RebicInteractable` desabilita quando recebe `onPressed: null`. O link e o item de menu repassam o próprio `onPressed`;
o avatar e o status só montam o `RebicInteractable` quando há `onPressed`.

## Decisions

### D1. Mapeamento para o `RebicInteractable`

Como no `RebicButton`: `onPressed: !enabled ? null : (onPress ?? () {})`. No item de menu, o `enabled` vai para a
lista de opções (`RebicOption.onChosen` nulo quando desabilitado), que já trata o item desabilitado.

### D2. Avatar e status

Só trocam o nome: `onPress` presente ativa a interação, ausente a desliga, como o UI5 faz com o tratador de `press`.

### D3. Migração

O script de migração do botão, adaptado: `onPressed:` → `onPress:` nos construtores `RebicLink`, `RebicMenuItem`,
`RebicAvatar` e `RebicStatusIndicator`; `onPressed: null` → `enabled: false` no link e no item; `label:` → `text:` e
`shortcut:` → `shortcutText:` no item. Os valores que podem ser nulos são listados e convertidos à mão.

## Risks / Trade-offs

- **[Link sem ação habilitado]** → quem usava `onPressed: null` para desabilitar passa a `enabled: false`; a migração
  faz isso nos usos literais e lista os demais.
