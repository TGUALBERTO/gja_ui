# gja/widgets/gja-radio-button-group Specification

## Purpose

`GjaRadioButtonGroup` agrupa opções de escolha única, como o `sap.m.RadioButtonGroup` do SAPUI5: marca a opção de `selectedIndex`, avisa a escolha por `onSelect`, distribui as opções em colunas e navega entre elas com as setas.

## Requirements

### Requirement: [API] Propriedades
`GjaRadioButtonGroup` SHALL expor, como o `sap.m.RadioButtonGroup`:

| Prop | Tipo | Padrão |
|---|---|---|
| `buttons` | `List<GjaRadioButton>` | obrigatória |
| `selectedIndex` | `int` | `0` |
| `onSelect` | `ValueChanged<int>?` | `null` |
| `columns` | `int` | `1` |
| `enabled` | `bool` | `true` |
| `editable` | `bool` | `true` |
| `valueState` | `GjaValueState` | `none` |

#### Scenario: Grupo mínimo
- **WHEN** um grupo com as opções "Boleto", "Pix" e "Cartão" é renderizado com `selectedIndex` `1`
- **THEN** as opções ficam empilhadas, e só "Pix" está marcada

### Requirement: [API] Opções válidas
O grupo SHALL definir `selected`, `onSelect` e o nó de foco de cada opção; `selectedIndex` `-1` não marca nenhuma. `columns` MUST ser ao menos 1, ou a criação MUST falhar em modo debug; `buttons` MUST NOT ser vazia, ou a renderização MUST falhar em modo debug.

#### Scenario: Grupo sem opções
- **WHEN** um grupo é renderizado com `buttons` vazia, e outro é criado com `columns` `0`
- **THEN** a renderização do primeiro e a criação do segundo falham em modo debug

### Requirement: [API] Callbacks e controlador
Escolher uma opção desmarcada e habilitada SHALL chamar `onSelect` com o índice dela. O grupo MUST NOT mudar sozinho. Com `enabled` ou `editable` `false` no grupo, todas as opções MUST seguir esse valor. `GjaRadioButtonGroup` SHALL NOT ter controlador.

#### Scenario: Escolher no grupo
- **GIVEN** um grupo cujo `onSelect` atualiza `selectedIndex`
- **WHEN** a terceira opção é tocada
- **THEN** `onSelect` recebe `2`, e só a terceira fica marcada

### Requirement: [Comportamento] Navegação pelas setas
Com o foco numa opção, as setas para baixo e para a direita SHALL escolher a próxima opção habilitada, e as setas para cima e para a esquerda a anterior, voltando ao início ou ao fim nas pontas, movendo o foco junto, como no UI5. Somente leitura, as setas SHALL mover só o foco.

#### Scenario: Setas no grupo
- **GIVEN** um grupo com a primeira opção marcada e com o foco, e a segunda desabilitada
- **WHEN** a seta para baixo é pressionada
- **THEN** `onSelect` recebe `2`, e o foco vai à terceira opção

### Requirement: [Aparência] Colunas e espaço
As opções SHALL ser distribuídas em `columns` colunas de mesma largura, em ordem de leitura, sem espaço entre as linhas além do alvo de cada opção. O estado de valor do grupo SHALL valer para todas as opções. O grupo SHALL NOT pintar nada próprio.

#### Scenario: Grupo em duas colunas
- **WHEN** um grupo de quatro opções com `columns` `2` é renderizado
- **THEN** a primeira e a segunda ficam na mesma linha, e a terceira começa a segunda linha, alinhada com a primeira

### Requirement: [Estados] Estados do grupo
O grupo SHALL NOT ter estados de interação próprios: os estados são os de cada `GjaRadioButton`.

#### Scenario: Grupo desabilitado
- **WHEN** um grupo com `enabled` `false` é renderizado
- **THEN** todas as opções estão desabilitadas

### Requirement: [Acessibilidade] Teclado e semântica
Tab SHALL entrar no grupo pela opção marcada (ou pela primeira, sem nenhuma) e sair dele no Tab seguinte, como num grupo de rádio. Cada opção SHALL manter a semântica de `gja/widgets/gja-radio-button`.

#### Scenario: Tab no grupo
- **GIVEN** um campo focável, um grupo de três opções com a segunda marcada e outro campo focável
- **WHEN** Tab é pressionado duas vezes a partir do primeiro campo
- **THEN** o foco passa pela segunda opção e depois vai ao último campo

### Requirement: [Responsividade] Largura
Com `columns` maior que 1, as colunas SHALL dividir a largura disponível; com uma coluna, o grupo SHALL ter a largura das opções. Em RTL, a primeira coluna MUST ficar à direita.

#### Scenario: Colunas em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um grupo de duas opções com `columns` `2` é renderizado
- **THEN** a primeira opção fica à direita da segunda

### Requirement: [Integração] Dependências
`GjaRadioButtonGroup` SHALL depender somente de `gja/widgets/gja-radio-button`, `gja/core/interaction`, `gja/foundation/color` e `gja/foundation/theming`.

#### Scenario: Grupo sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um grupo é renderizado, e as opções são tocadas
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaRadioButtonGroup` MUST ter um teste de widget por cenário. Os goldens e a bateria de acessibilidade são os de `GjaRadioButton`, porque o grupo não pinta nada próprio.

#### Scenario: Rastreabilidade do grupo
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`GjaRadioButtonGroup` SHALL ter dartdoc em toda API pública e aparecer na página "GjaRadioButton" da galeria, com um grupo de uma coluna e um de duas.

#### Scenario: Página GjaRadioButtonGroup na galeria
- **GIVEN** a página "GjaRadioButton" aberta na galeria
- **WHEN** a opção "Pix" do grupo de pagamento é tocada
- **THEN** ela passa a marcada, e "Boleto" deixa de estar

### Requirement: [Restrições] Fora do escopo
`GjaRadioButtonGroup` SHALL NOT aceitar larguras literais, `required` nem texto de estado de valor.

#### Scenario: Grupo sem valor literal
- **WHEN** a API pública de `GjaRadioButtonGroup` é inspecionada
- **THEN** não há parâmetro do tipo `double`
