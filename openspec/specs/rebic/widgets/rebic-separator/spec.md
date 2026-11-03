# rebic/widgets/rebic-separator Specification

## Purpose

`RebicSeparator` separa itens e grupos de conteúdo com uma linha fina, como o `sap.m.ToolbarSeparator` do SAPUI5: horizontal, ocupando a largura disponível, ou vertical, com a altura de separador da densidade. Não tem propriedades além da orientação; o espaço em volta vem do contêiner, e a cor e a altura vêm do tema, sem valores literais.

## Requirements

### Requirement: [API] Propriedades
`RebicSeparator` SHALL expor dois construtores, sem outras propriedades além de `key`: `RebicSeparator()`, horizontal, e `RebicSeparator.vertical()`, vertical.

#### Scenario: Separador mínimo
- **GIVEN** uma árvore com `RebicApp` e uma coluna de 300 de largura
- **WHEN** `RebicSeparator()` é colocado nela
- **THEN** ele ocupa os 300 de largura e tem a altura da linha fina, na cor `separator`

### Requirement: [API] Callbacks e controlador
`RebicSeparator` SHALL NOT ter callbacks nem controlador: é um elemento decorativo.

#### Scenario: Separador sem ação
- **GIVEN** um `RebicSeparator()` numa coluna
- **WHEN** a área do separador é tocada
- **THEN** nada é executado pelo `RebicSeparator`

### Requirement: [Comportamento] Orientação
`RebicSeparator()` SHALL ocupar toda a largura disponível, com a altura da linha fina. `RebicSeparator.vertical()` SHALL ter a largura da linha fina e a altura `density.separatorHeight`, como o `sapMTBSeparator`, sem esticar até a altura de quem o contém. Nenhum dos dois MUST ter espaço próprio em volta da linha.

#### Scenario: Separador vertical numa barra
- **GIVEN** um `RebicBar` com dois `RebicButton` separados por `RebicSeparator.vertical()`
- **WHEN** a barra é renderizada
- **THEN** o separador tem a largura da linha fina e a altura `density.separatorHeight`, menor que `density.barHeight`, e fica centrado na altura da barra

#### Scenario: Separador vertical numa linha esticada
- **GIVEN** um `RebicRow` de 80 de altura com `crossAlignment` `stretch` e `RebicSeparator.vertical()` entre dois textos
- **WHEN** a linha é renderizada
- **THEN** o separador continua com a altura `density.separatorHeight`

### Requirement: [Aparência] Tokens de componente
`RebicSeparator` SHALL obter a cor de `colors.separator`, como o `sapToolbar_SeparatorColor`, e a altura vertical de `density.separatorHeight`, ambas do tema ativo. A espessura SHALL ser a linha fina padrão, como o `sapElement_BorderWidth`, sem valores literais.

#### Scenario: Troca de tema do separador
- **GIVEN** `RebicSeparator()` no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** a linha usa o `separator` do escuro, sem recriar o widget

### Requirement: [Estados] Sem estados de interação
`RebicSeparator` SHALL NOT apresentar estados de hover, foco, pressionado, selecionado ou desabilitado.

#### Scenario: Separador não recebe foco
- **GIVEN** um `RebicSeparator` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai direto ao segundo

### Requirement: [Acessibilidade] Teclado e foco
`RebicSeparator` SHALL NOT entrar na ordem de foco nem responder a teclas.

#### Scenario: Teclas ignoradas pelo separador
- **GIVEN** uma página com `RebicSeparator` e nenhum elemento focável
- **WHEN** Tab, Enter e Espaço são pressionados
- **THEN** nada muda na página

### Requirement: [Acessibilidade] Semântica e contraste
`RebicSeparator` SHALL ficar fora da árvore de semântica, por ser decorativo: o Flutter não tem o papel `separator` que o UI5 declara. A cor `separator` é decorativa e isenta de contraste mínimo, conforme `rebic/foundation/color`.

#### Scenario: Separador fora da semântica
- **WHEN** um leitor de tela percorre uma página com dois textos separados por `RebicSeparator`
- **THEN** são anunciados só os dois textos

### Requirement: [Responsividade] Densidade
A altura do separador vertical SHALL seguir `density.separatorHeight` da densidade ativa, conforme `rebic/foundation/density`. A espessura MUST ser a mesma nas duas densidades e em qualquer escala de texto.

#### Scenario: Densidade compacta do separador
- **GIVEN** um `RebicSeparator.vertical()`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** o de fora tem a `separatorHeight` cozy, o de dentro a compacta, e os dois têm a mesma largura

### Requirement: [Integração] Dependências
`RebicSeparator` SHALL depender somente de `rebic/foundation/color`, `rebic/foundation/density`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Separador sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** as duas orientações de `RebicSeparator` são renderizadas
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicSeparator` MUST ter um teste de widget por cenário, goldens das duas orientações nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`: semântica. As diretrizes de contraste, de texto, de alvo de toque e o teclado não se aplicam.

#### Scenario: Rastreabilidade do separador
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do separador
- **WHEN** os goldens de `RebicSeparator` são comparados com a referência
- **THEN** existem as imagens de claro e escuro em cada densidade, e todas coincidem

### Requirement: [Documentação] Exemplos mínimos
`RebicSeparator` SHALL ter dartdoc em toda API pública e uma página "RebicSeparator" na galeria com o separador horizontal numa lista e o vertical numa barra.

#### Scenario: Página RebicSeparator na galeria
- **WHEN** a página "RebicSeparator" é aberta
- **THEN** ela exibe separadores horizontais entre itens de uma coluna e um separador vertical entre ações de um `RebicBar`

### Requirement: [Restrições] Fora do escopo
`RebicSeparator` SHALL NOT aceitar cor, espessura, espaço, recuo ou tom, desenhar linha tracejada nem exibir texto.

#### Scenario: Separador sem parâmetros visuais
- **WHEN** a API pública de `RebicSeparator` é inspecionada
- **THEN** os construtores só aceitam `key`
