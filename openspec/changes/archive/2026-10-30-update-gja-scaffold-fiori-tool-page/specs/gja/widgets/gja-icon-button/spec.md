# Spec Delta

## REMOVED Requirements

### Requirement: [Integração] Dependências
**Reason**: o cenário de uso pelo `GjaScaffold` passa ao `GjaShellBar`, que substitui a barra do scaffold.
**Migration**: os mesmos itens estão em "[Integração] Dependências e uso".

## ADDED Requirements

### Requirement: [Integração] Dependências e uso
`GjaIconButton` SHALL depender somente de `gja/core/interaction`, `gja/widgets/gja-tooltip`, `gja/widgets/gja-button` (`GjaButtonType`), `gja/foundation/interaction-states`, `gja/foundation/iconography`, `gja/foundation/density`, `gja/foundation/radius`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Botão de ícone sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um botão de ícone de cada tipo e um desabilitado são renderizados e tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

#### Scenario: Barra e página usam o botão de ícone
- **WHEN** um `GjaShellBar` com o botão de menu e uma `GjaPage` com `onBack` são renderizados, em pt-BR
- **THEN** o botão de menu e o de voltar são `GjaIconButton` com as dicas "Menu" e "Voltar"
