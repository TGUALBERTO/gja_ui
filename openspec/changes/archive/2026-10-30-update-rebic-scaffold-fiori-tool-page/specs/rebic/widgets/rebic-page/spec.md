# Spec Delta

## REMOVED Requirements

### Requirement: [Integração] Dependências de widgets
**Reason**: o `RebicScaffold` dá lugar ao `RebicToolPage`, que passa a hospedar a página.
**Migration**: os mesmos itens estão em "[Integração] Dependências de widgets e hospedeiro".

## ADDED Requirements

### Requirement: [Integração] Dependências de widgets e hospedeiro
Dos widgets, `RebicPage` SHALL depender somente de `rebic/widgets/rebic-icon`, `rebic/widgets/rebic-icon-button`, `rebic/widgets/rebic-container`, `rebic/widgets/rebic-divider`, `rebic/widgets/rebic-row`, `rebic/widgets/rebic-column` e `rebic/widgets/rebic-spacing`, e SHALL funcionar como conteúdo principal de `rebic/widgets/rebic-tool-page`.

#### Scenario: Página na página de ferramentas
- **GIVEN** uma árvore criada apenas com `RebicApp`, com um `RebicToolPage` cujo cabeçalho é um `RebicShellBar` com título
- **WHEN** uma `RebicPage` com rodapé é o conteúdo principal
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino, a área de título da página começa abaixo do cabeçalho, e o rodapé termina na borda inferior da tela
