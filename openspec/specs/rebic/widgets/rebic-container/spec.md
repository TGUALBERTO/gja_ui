# rebic/widgets/rebic-container Specification

## Purpose

`RebicContainer` é a superfície do Rebic que agrupa conteúdo, como o `backgroundDesign` e os parâmetros de superfície do SAPUI5: aplica fundo, borda, cantos arredondados com recorte, sombra e espaço interno, cada um por um papel nomeado do tema ativo, sem valores literais.

## Requirements

### Requirement: [API] Propriedades
`RebicContainer` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `child` | `Widget?` | nulo |
| `surface` | `RebicSurface` | `none` |
| `border` | `bool` | `false` |
| `radius` | `RebicRadius` | `none` |
| `shadow` | `RebicShadow` | `none` |
| `padding` | `RebicSpace?` | nulo (sem espaço) |

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `RebicApp`
- **WHEN** `RebicContainer(child: RebicText('a'))` é criado
- **THEN** ele não pinta fundo, borda nem sombra, e o filho ocupa a mesma área que ocuparia sem o contêiner

### Requirement: [API] Valores dos papéis
`RebicSurface` SHALL ter `none`, `background`, `base`, `header` e `shell`. `RebicRadius` SHALL ter os passos e papéis do raio (`none`, `xs`, `s`, `m`, `l`, `xl`, `full`, `button`, `field`, `popover`, `element`, `tile`). `RebicShadow` SHALL ter `none` e os papéis de sombra (`card`, `popover`, `dialog`, `dragged`, `header`).

#### Scenario: Papéis do fundamento
- **WHEN** os valores de `RebicRadius` e os papéis de `RebicShadow` são comparados com os nomes dos tokens de raio e de sombra
- **THEN** cada valor tem um token de mesmo nome

### Requirement: [API] Callbacks e controlador
`RebicContainer` SHALL NOT ter callbacks nem controlador: é uma superfície de exibição. Superfícies clicáveis são de `RebicCard`.

#### Scenario: Sem ação
- **GIVEN** `RebicContainer` com `surface` `base`
- **WHEN** a superfície é tocada fora do filho
- **THEN** nada é executado pelo `RebicContainer`

### Requirement: [Comportamento] Recorte nos cantos
Com `radius` diferente de `none`, `RebicContainer` SHALL recortar o conteúdo no contorno arredondado, para que filhos com fundo próprio não ultrapassem os cantos. Com `radius` `none`, MUST NOT recortar.

#### Scenario: Filho recortado
- **GIVEN** `RebicContainer` com `radius` `tile` e um filho que pinta toda a área
- **WHEN** o contêiner é renderizado
- **THEN** o conteúdo é recortado com o raio `tile` do tema

#### Scenario: Sem raio, sem recorte
- **WHEN** `RebicContainer` é criado com `radius` `none`
- **THEN** não há recorte do conteúdo

### Requirement: [Aparência] Tokens de componente
`RebicContainer` SHALL obter o fundo de `colors.background`, `colors.base`, `colors.headerBackground` ou `colors.shell`, a borda de `colors.separator` com 1 px, o raio de `radius.<valor>`, a sombra de `shadows.boxShadows(shadows.<papel>, colors.shadow)` e o espaço de `spacing.<valor>`, todos do tema ativo, sem valores literais.

#### Scenario: Troca de tema
- **GIVEN** `RebicContainer` com `surface` `base`, `border` e `shadow` `card` no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** o fundo, a borda e a cor da sombra passam aos valores do escuro, sem recriar o widget com outros parâmetros

#### Scenario: Superfícies
- **WHEN** cada valor de `RebicSurface` é renderizado no tema claro
- **THEN** o fundo é transparente em `none` e, nos demais, a cor de mesmo papel em `colors`

#### Scenario: Raio e sombra
- **WHEN** cada valor de `RebicRadius` e cada papel de `RebicShadow` são renderizados no tema claro
- **THEN** o raio dos cantos é o token de mesmo nome, e as sombras são as do papel com a cor `shadow`

### Requirement: [Estados] Sem estados de interação
`RebicContainer` SHALL NOT apresentar estados de hover, foco, pressionado, selecionado ou desabilitado, porque não é interativo.

#### Scenario: Não recebe foco
- **GIVEN** um `RebicContainer` com `surface` `base` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro elemento
- **THEN** o foco vai direto ao segundo elemento

### Requirement: [Acessibilidade] Teclado e foco
`RebicContainer` SHALL NOT entrar na ordem de foco nem alterar a ordem dos filhos.

#### Scenario: Ordem preservada
- **GIVEN** dois elementos focáveis dentro de um `RebicContainer`
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo

### Requirement: [Acessibilidade] Semântica e contraste
`RebicContainer` SHALL NOT acrescentar nós à árvore de semântica. O texto do tema sobre cada `surface` MUST manter o contraste verificado por `rebic/foundation/color`. A borda `separator` é decorativa e isenta do contraste mínimo, conforme `rebic/foundation/accessibility`.

#### Scenario: Semântica inalterada
- **WHEN** a árvore de semântica de um texto é comparada com e sem `RebicContainer` em volta dele
- **THEN** as duas árvores têm os mesmos rótulos e papéis

#### Scenario: Texto sobre as superfícies
- **WHEN** a diretriz de contraste de texto é aplicada a um `RebicText` sobre cada `surface` com fundo, nos temas claro e escuro
- **THEN** a diretriz passa

### Requirement: [Responsividade] Densidade
O `padding` SHALL usar o espaçamento do tema ativo, que é o mesmo nas densidades cozy e compacta, conforme `rebic/foundation/density`. Raio e sombra MUST ser os mesmos nas duas densidades. O contêiner MUST se ajustar à largura disponível, sem tamanho próprio.

#### Scenario: Densidade compacta
- **GIVEN** um `RebicContainer` com `padding` `l`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** o espaço interno é o mesmo `l` dentro e fora, com o mesmo raio e a mesma sombra

### Requirement: [Integração] Dependências
`RebicContainer` SHALL depender somente de `rebic/foundation/color`, `rebic/foundation/radius`, `rebic/foundation/shadows`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/theming` e `rebic/widgets/rebic-spacing` (os valores de `RebicSpace`).

#### Scenario: Funciona sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** `RebicContainer` é renderizado com todas as superfícies
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicContainer` MUST ter um teste de widget por cenário, goldens das superfícies, da borda, dos raios e das sombras nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`: contraste do texto sobre as superfícies e semântica. As diretrizes de alvo de toque e o teclado não se aplicam, por não ser interativo.

#### Scenario: Rastreabilidade
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens das superfícies
- **WHEN** os goldens de `RebicContainer` são comparados com a referência
- **THEN** existem as imagens de claro e escuro em cada densidade, e todas coincidem

### Requirement: [Documentação] Exemplos mínimos
`RebicContainer` SHALL ter dartdoc em toda API pública e uma página "RebicContainer" na galeria com as superfícies, a borda, os raios, as sombras e um exemplo de cartão (`base`, borda, raio `tile`, sombra `card` e `padding`).

#### Scenario: Página RebicContainer na galeria
- **WHEN** a página "RebicContainer" é aberta
- **THEN** ela exibe as cinco superfícies, os raios, os seis valores de sombra e o exemplo de cartão

### Requirement: [Restrições] Fora do escopo
`RebicContainer` SHALL NOT aceitar cor, raio, sombra ou espaço literais, nem definir tamanho próprio ou ser clicável.

#### Scenario: Sem valores literais
- **WHEN** a API pública de `RebicContainer` é inspecionada
- **THEN** não há parâmetro dos tipos `Color`, `double`, `BorderRadius`, `BoxShadow`, `EdgeInsets` ou `BoxDecoration`
