# Spec Delta

## ADDED Requirements

### Requirement: Convenções de nomenclatura e de eventos da API pública
Tipos públicos MUST usar o prefixo `Rebic`. Callbacks SHALL seguir o padrão `on<Evento>`, com o nome do evento do SAPUI5 (`onPress`, `onChange`, `onSelectionChange`). O componente desabilitado SHALL ser `enabled: false`, como no SAPUI5; um callback nulo MUST significar só que não há ação. Variantes visuais SHALL ser enums e configuração visual SHALL vir do tema, não de parâmetros soltos.

#### Scenario: Botão desabilitado por enabled
- **GIVEN** um `RebicButton` criado com `enabled: false` e um `onPress`
- **WHEN** o usuário toca, clica ou pressiona Enter sobre ele
- **THEN** `onPress` não é chamado e o botão é exposto como desabilitado à semântica de acessibilidade

#### Scenario: Revisão de API inconsistente
- **WHEN** uma change propõe um callback público chamado `pressHandler`
- **THEN** a revisão exige renomeá-lo para seguir o padrão `on<Evento>`

## REMOVED Requirements

### Requirement: Convenções de nomenclatura da API pública
**Reason**: o desabilitado por callback nulo é convenção do Flutter; o SAPUI5 usa `enabled` e nomeia os callbacks pelo evento (`press`).
**Migration**: Use "Convenções de nomenclatura e de eventos da API pública": `enabled: false` para desabilitar e `on<Evento>` com o nome do evento do SAPUI5 (`onPress`).
