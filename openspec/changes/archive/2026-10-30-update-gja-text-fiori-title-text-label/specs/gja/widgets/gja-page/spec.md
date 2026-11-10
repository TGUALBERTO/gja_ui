# Spec Delta

## MODIFIED Requirements

### Requirement: [Aparência] Tokens de componente
A área de título e o rodapé SHALL usar o fundo `colors.base` e ser separados do conteúdo por divisores sutis de `gja/widgets/gja-divider`. O conteúdo SHALL NOT pintar fundo próprio. O título SHALL usar `typography.header2` com `colors.text`, e o subtítulo `typography.base` com `colors.label`. Os espaços SHALL vir de `spacing`, sem valores literais.

#### Scenario: Cores da página
- **WHEN** a página com rodapé é renderizada nos temas claro e escuro
- **THEN** a área de título e o rodapé têm o fundo `colors.base` de cada tema, e o conteúdo não pinta fundo

#### Scenario: Margem da densidade compacta
- **GIVEN** uma página numa subárvore compacta
- **WHEN** a página é renderizada
- **THEN** o conteúdo começa à margem de página do espaçamento compacto para a classe de tamanho da página, igual à da densidade cozy
