## MODIFIED Requirements

### Requirement: [Integração] Dependências de widgets
Dos widgets, `RebicPage` SHALL depender somente de `rebic/widgets/rebic-text`, `rebic/widgets/rebic-icon`, `rebic/widgets/rebic-icon-button`, `rebic/widgets/rebic-container`, `rebic/widgets/rebic-divider`, `rebic/widgets/rebic-row`, `rebic/widgets/rebic-column` e `rebic/widgets/rebic-spacing`, e SHALL funcionar como corpo de `rebic/widgets/rebic-scaffold`.

#### Scenario: Página no corpo do scaffold
- **GIVEN** uma árvore criada apenas com `RebicApp`, com um `RebicScaffold` cuja barra tem título
- **WHEN** uma `RebicPage` com rodapé é o corpo do scaffold
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino, a área de título da página começa abaixo da barra, e o rodapé termina na borda inferior da tela
