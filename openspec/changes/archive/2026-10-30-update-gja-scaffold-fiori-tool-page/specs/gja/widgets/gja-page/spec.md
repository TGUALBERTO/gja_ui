# Spec Delta

## REMOVED Requirements

### Requirement: [Integração] Dependências de widgets
**Reason**: o `GjaScaffold` dá lugar ao `GjaToolPage`, que passa a hospedar a página.
**Migration**: os mesmos itens estão em "[Integração] Dependências de widgets e hospedeiro".

## ADDED Requirements

### Requirement: [Integração] Dependências de widgets e hospedeiro
Dos widgets, `GjaPage` SHALL depender somente de `gja/widgets/gja-icon`, `gja/widgets/gja-icon-button`, `gja/widgets/gja-container`, `gja/widgets/gja-divider`, `gja/widgets/gja-row`, `gja/widgets/gja-column` e `gja/widgets/gja-spacing`, e SHALL funcionar como conteúdo principal de `gja/widgets/gja-tool-page`.

#### Scenario: Página na página de ferramentas
- **GIVEN** uma árvore criada apenas com `GjaApp`, com um `GjaToolPage` cujo cabeçalho é um `GjaShellBar` com título
- **WHEN** uma `GjaPage` com rodapé é o conteúdo principal
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino, a área de título da página começa abaixo do cabeçalho, e o rodapé termina na borda inferior da tela
