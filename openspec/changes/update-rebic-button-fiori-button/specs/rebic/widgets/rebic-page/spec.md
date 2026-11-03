# Spec Delta

## MODIFIED Requirements

### Requirement: [Estados] Botão de voltar
O botão de voltar SHALL ser um `RebicButton` só com ícone, do tipo `transparent`, com os estados normal, hover, pressionado, foco do teclado e desabilitado de `rebic/core/interaction`. A página SHALL NOT apresentar outros estados de interação.

#### Scenario: Botão de voltar em hover
- **WHEN** o ponteiro fica sobre o botão de voltar
- **THEN** o fundo do botão é o de hover da família `transparent`

### Requirement: [Integração] Dependências de widgets e hospedeiro
Dos widgets, `RebicPage` SHALL depender somente de `rebic/widgets/rebic-bar`, `rebic/widgets/rebic-title`, `rebic/widgets/rebic-button` e `rebic/widgets/rebic-container`, e SHALL funcionar como conteúdo principal de `rebic/widgets/rebic-tool-page`.

#### Scenario: Página na página de ferramentas
- **GIVEN** uma árvore criada apenas com `RebicApp`, com um `RebicToolPage` cujo cabeçalho é um `RebicShellBar` com título
- **WHEN** uma `RebicPage` com rodapé é o conteúdo principal
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino, o cabeçalho da página começa abaixo do da página de ferramentas, e o rodapé termina na borda inferior da tela
