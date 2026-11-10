# Spec Delta

## MODIFIED Requirements

### Requirement: [API] Propriedades
`GjaForm` SHALL expor, como o `Form` e o `ColumnLayout`:

| Prop | Tipo | Padrão |
|---|---|---|
| `title` | `String?` | `null` |
| `formContainers` | `List<GjaFormContainer>` | obrigatória |
| `columnsM` | `int` | `1` |
| `columnsL` | `int` | `2` |
| `columnsXL` | `int` | `2` |
| `labelCellsLarge` | `int` | `4` |
| `editable` | `bool` | `false` |

#### Scenario: Formulário mínimo
- **WHEN** um formulário editável "Fornecedor" com os elementos "Nome" e "Cidade" é renderizado com a largura 1100
- **THEN** o título fica no topo, e cada rótulo fica à esquerda do seu campo, na mesma linha

### Requirement: [Aparência] Tokens de componente
Ao lado, o rótulo SHALL ocupar `labelCellsLarge` partes de 12 da coluna (no formulário editável, centrado na altura `density.minTargetSize` dos campos), com `spacing.s` antes dos campos; acima, `spacing.xs`. Vários campos SHALL dividir a largura, com `spacing.s` entre eles; entre elementos, `spacing.s`; entre colunas e linhas de contêineres, `spacing.l`. Os títulos SHALL ter os estilos H4 (formulário) e H5 (contêiner).

#### Scenario: Largura do rótulo
- **WHEN** um formulário editável de uma coluna é renderizado com a largura 1200 e `labelCellsLarge` 4
- **THEN** o rótulo ocupa um terço da largura, e o campo começa `spacing.s` depois dele

### Requirement: [Restrições] Fora do escopo
`GjaForm` SHALL NOT aceitar larguras ou cores literais, nem ter `emptyCellsLarge`, outros layouts, barras de ferramentas nos títulos, validação ou a distribuição de um contêiner em várias colunas.

#### Scenario: Formulário sem valor literal
- **WHEN** a API pública de `GjaForm` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`

## ADDED Requirements

### Requirement: [Comportamento] Modo de exibição
Com `editable` `false` (o padrão, como no `sap.ui.layout.form.Form`), o formulário SHALL mostrar valores: o rótulo ao lado SHALL ficar alinhado ao topo dos campos, sem a altura mínima dos campos editáveis. Com `editable` `true`, para campos de entrada, o rótulo SHALL ficar centrado na altura `density.minTargetSize`. `editable` SHALL NOT mudar os campos, que a aplicação escolhe.

#### Scenario: Formulário de exibição
- **WHEN** um formulário de exibição com o elemento "Cidade" e o texto "Belo Horizonte" é renderizado com a largura 1100
- **THEN** o rótulo "Cidade" e o texto começam na mesma altura
