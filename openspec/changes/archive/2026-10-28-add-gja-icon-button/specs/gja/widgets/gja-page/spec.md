## MODIFIED Requirements

### Requirement: [Integração] Dependências de widgets
Dos widgets, `GjaPage` SHALL depender somente de `gja/widgets/gja-text`, `gja/widgets/gja-icon`, `gja/widgets/gja-icon-button`, `gja/widgets/gja-container`, `gja/widgets/gja-divider`, `gja/widgets/gja-row`, `gja/widgets/gja-column` e `gja/widgets/gja-spacing`, e SHALL funcionar como corpo de `gja/widgets/gja-scaffold`.

#### Scenario: Página no corpo do scaffold
- **GIVEN** uma árvore criada apenas com `GjaApp`, com um `GjaScaffold` cuja barra tem título
- **WHEN** uma `GjaPage` com rodapé é o corpo do scaffold
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino, a área de título da página começa abaixo da barra, e o rodapé termina na borda inferior da tela
