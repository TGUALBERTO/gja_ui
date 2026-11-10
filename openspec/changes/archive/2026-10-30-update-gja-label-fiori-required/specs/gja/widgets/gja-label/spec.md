# Spec Delta

## MODIFIED Requirements

### Requirement: [Aparência] Estilo e cor
`GjaLabel` SHALL usar `typography.base` no desenho `standard` e `typography.baseBold` no `bold`, com a cor `colors.label` (`sapContent_LabelColor`). Os dois-pontos SHALL ter o estilo e a cor do texto, e o asterisco SHALL usar `typography.large` em negrito, na cor `colors.required` (`sapField_RequiredColor`), com `spacing.xxs` antes dele, como no `sap.m.Label`, todos do tema ativo, sem valores literais.

#### Scenario: Desenhos e sinais
- **WHEN** rótulos `standard` e `bold`, com e sem `required`, são renderizados no tema claro
- **THEN** o texto tem o estilo do desenho e a cor `label`, e o asterisco tem o tamanho de `large`, o negrito e a cor `required`

#### Scenario: Troca de tema do rótulo
- **GIVEN** `GjaLabel` com `required` renderizado no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** o texto e o asterisco usam as cores `label` e `required` do tema escuro, sem ser recriados com outros parâmetros
