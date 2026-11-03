# rebic/widgets/rebic-form Specification

## Purpose

`RebicForm` é o formulário do Rebic, como o `sap.ui.layout.form.Form` com o `ColumnLayout` do SAPUI5: contêineres com título e elementos de rótulo e campos, distribuídos em colunas pela largura do próprio formulário, com os rótulos ao lado dos campos nas larguras grandes e acima nas pequenas.

## Requirements

### Requirement: [API] Propriedades
`RebicForm` SHALL expor, como o `Form` e o `ColumnLayout`:

| Prop | Tipo | Padrão |
|---|---|---|
| `title` | `String?` | `null` |
| `formContainers` | `List<RebicFormContainer>` | obrigatória |
| `columnsM` | `int` | `1` |
| `columnsL` | `int` | `2` |
| `columnsXL` | `int` | `2` |
| `labelCellsLarge` | `int` | `4` |

#### Scenario: Formulário mínimo
- **WHEN** um formulário "Fornecedor" com os elementos "Nome" e "Cidade" é renderizado com a largura 1100
- **THEN** o título fica no topo, e cada rótulo fica à esquerda do seu campo, na mesma linha

### Requirement: [API] Contêineres e elementos válidos
`RebicFormContainer`, como o `FormContainer`, SHALL ter `title` (`String?`) e `formElements`; `RebicFormElement`, como o `FormElement`, SHALL ter `label` (`String?`), `required` (padrão `false`) e `fields` (`List<Widget>`). `formContainers`, `formElements` e `fields` MUST NOT ser vazias; `columnsM` MUST estar entre 1 e 2, `columnsL` entre 1 e 3, `columnsXL` entre 1 e 4 e `labelCellsLarge` entre 1 e 11, ou a renderização MUST falhar em modo debug.

#### Scenario: Elemento sem campo
- **WHEN** um formulário com um elemento sem campos é renderizado
- **THEN** a renderização falha em modo debug

### Requirement: [API] Callbacks e controlador
`RebicForm` SHALL NOT ter callbacks, estado ou controlador: os campos mantêm os próprios valores e eventos.

#### Scenario: Campo dentro do formulário
- **GIVEN** um formulário com um `RebicInput` cujo `onLiveChange` registra o texto
- **WHEN** "ACME" é digitado no campo
- **THEN** `onLiveChange` recebe "ACME"

### Requirement: [Comportamento] Colunas e rótulos
O formulário SHALL classificar a própria largura com `breakpoints.classify` e usar 1 coluna no S, `columnsM` no M, `columnsL` no L e `columnsXL` no XL, no máximo uma por contêiner, preenchidas linha a linha. Os rótulos SHALL ficar ao lado dos campos no L e no XL, e no M com uma coluna; nos outros casos, acima.

#### Scenario: Contêineres em colunas
- **GIVEN** um formulário com os contêineres "Dados" e "Contato"
- **WHEN** ele é renderizado com a largura 1100 e depois com a largura 800
- **THEN** com 1100 os contêineres ficam lado a lado, e com 800 um abaixo do outro

#### Scenario: Rótulos acima no celular
- **WHEN** um formulário é renderizado com a largura 400
- **THEN** cada rótulo fica acima do seu campo

### Requirement: [Aparência] Tokens de componente
Ao lado, o rótulo SHALL ocupar `labelCellsLarge` partes de 12 da coluna, centrado numa altura mínima `density.minTargetSize` (a dos campos), com `spacing.s` antes dos campos; acima, `spacing.xs`. Vários campos SHALL dividir a largura, com `spacing.s` entre eles; entre elementos, `spacing.s`; entre colunas e linhas de contêineres, `spacing.l`. Os títulos SHALL ter os estilos H4 (formulário) e H5 (contêiner).

#### Scenario: Largura do rótulo
- **WHEN** um formulário de uma coluna é renderizado com a largura 1200 e `labelCellsLarge` 4
- **THEN** o rótulo ocupa um terço da largura, e o campo começa `spacing.s` depois dele

### Requirement: [Estados] Obrigatório
Um elemento com `required` `true` SHALL mostrar o rótulo com o asterisco de obrigatório do `RebicLabel`. O formulário SHALL NOT ter estados de interação próprios; os campos mantêm os deles.

#### Scenario: Elemento obrigatório
- **WHEN** um formulário com o elemento obrigatório "Nome" é renderizado
- **THEN** o rótulo "Nome" mostra o asterisco

### Requirement: [Acessibilidade] Semântica e contraste
Os títulos do formulário e dos contêineres SHALL ser expostos como cabeçalhos, e cada rótulo SHALL vir antes dos seus campos na ordem de leitura. Os textos MUST ter o contraste de texto.

#### Scenario: Semântica do formulário
- **WHEN** a árvore de semântica de um formulário "Fornecedor" com o contêiner "Dados" é lida
- **THEN** "Fornecedor" e "Dados" são cabeçalhos, e o rótulo "Nome" vem antes do campo

#### Scenario: Contraste do formulário
- **WHEN** as diretrizes de contraste de texto e de alvo mínimo são aplicadas a um formulário com campos, nos temas claro e escuro e nas duas densidades
- **THEN** são atendidas

### Requirement: [Responsividade] Direção
Em RTL, o rótulo ao lado MUST ficar à direita dos campos, e as colunas MUST começar pela direita.

#### Scenario: Formulário em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um formulário é renderizado com a largura 1100
- **THEN** cada rótulo fica à direita do seu campo

### Requirement: [Integração] Dependências
`RebicForm` SHALL depender somente de `rebic/widgets/rebic-label`, `rebic/widgets/rebic-title`, `rebic/foundation/typography`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/breakpoints`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Formulário sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um formulário com campo de texto, seleção e caixa de seleção é renderizado e preenchido
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicForm` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility`.

#### Scenario: Rastreabilidade do formulário
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do formulário
- **WHEN** os goldens de um formulário com dois contêineres, na largura L e na S, são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicForm` SHALL ter dartdoc em toda API pública e uma página "RebicForm" na galeria com um formulário de dois contêineres e um resumo dos valores.

#### Scenario: Página RebicForm na galeria
- **GIVEN** a página "RebicForm" aberta na galeria
- **WHEN** "ACME" é digitado no campo "Nome"
- **THEN** a página mostra "Resumo: ACME"

### Requirement: [Restrições] Fora do escopo
`RebicForm` SHALL NOT aceitar larguras ou cores literais, nem ter `editable`, `emptyCellsLarge`, outros layouts, barras de ferramentas nos títulos, validação ou a distribuição de um contêiner em várias colunas.

#### Scenario: Formulário sem valor literal
- **WHEN** a API pública de `RebicForm` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
