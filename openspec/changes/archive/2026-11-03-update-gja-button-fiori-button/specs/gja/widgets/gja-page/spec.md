# Spec Delta

## MODIFIED Requirements

### Requirement: [Estados] Botão de voltar
O botão de voltar SHALL ser um `GjaButton` só com ícone, do tipo `transparent`, com os estados normal, hover, pressionado, foco do teclado e desabilitado de `gja/core/interaction`. A página SHALL NOT apresentar outros estados de interação.

#### Scenario: Botão de voltar em hover
- **WHEN** o ponteiro fica sobre o botão de voltar
- **THEN** o fundo do botão é o de hover da família `transparent`

### Requirement: [Integração] Dependências de widgets e hospedeiro
Dos widgets, `GjaPage` SHALL depender somente de `gja/widgets/gja-bar`, `gja/widgets/gja-title`, `gja/widgets/gja-button` e `gja/widgets/gja-container`, e SHALL funcionar como conteúdo principal de `gja/widgets/gja-tool-page`.

#### Scenario: Página na página de ferramentas
- **GIVEN** uma árvore criada apenas com `GjaApp`, com um `GjaToolPage` cujo cabeçalho é um `GjaShellBar` com título
- **WHEN** uma `GjaPage` com rodapé é o conteúdo principal
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino, o cabeçalho da página começa abaixo do da página de ferramentas, e o rodapé termina na borda inferior da tela
