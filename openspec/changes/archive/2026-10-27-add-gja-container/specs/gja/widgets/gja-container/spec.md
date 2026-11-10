## Purpose

`GjaContainer` é a superfície do GJA que agrupa conteúdo, como o `backgroundDesign` e os parâmetros de superfície do SAPUI5: aplica fundo, borda, cantos arredondados com recorte, sombra e espaço interno, cada um por um papel nomeado do tema ativo, sem valores literais.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaContainer` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `child` | `Widget?` | nulo |
| `surface` | `GjaSurface` | `none` |
| `border` | `bool` | `false` |
| `radius` | `GjaRadius` | `none` |
| `elevation` | `GjaElevation` | `none` |
| `padding` | `GjaSpace?` | nulo (sem espaço) |

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `GjaApp`
- **WHEN** `GjaContainer(child: GjaText('a'))` é criado
- **THEN** ele não pinta fundo, borda nem sombra, e o filho ocupa a mesma área que ocuparia sem o contêiner

### Requirement: [API] Valores dos papéis
`GjaSurface` SHALL ter `none`, `background`, `base`, `header` e `shell`. `GjaRadius` SHALL ter os passos e papéis do raio (`none`, `xs`, `s`, `m`, `l`, `xl`, `full`, `control`, `container`). `GjaElevation` SHALL ter `none` e os papéis de sombra (`card`, `popover`, `dialog`, `dragged`, `header`).

#### Scenario: Papéis do fundamento
- **WHEN** os valores de `GjaRadius` e os papéis de `GjaElevation` são comparados com os nomes dos tokens de raio e de elevação
- **THEN** cada valor tem um token de mesmo nome

### Requirement: [API] Callbacks e controlador
`GjaContainer` SHALL NOT ter callbacks nem controlador: é uma superfície de exibição. Superfícies clicáveis são de `GjaCard`.

#### Scenario: Sem ação
- **GIVEN** `GjaContainer` com `surface` `base`
- **WHEN** a superfície é tocada fora do filho
- **THEN** nada é executado pelo `GjaContainer`

### Requirement: [Comportamento] Recorte nos cantos
Com `radius` diferente de `none`, `GjaContainer` SHALL recortar o conteúdo no contorno arredondado, para que filhos com fundo próprio não ultrapassem os cantos. Com `radius` `none`, MUST NOT recortar.

#### Scenario: Filho recortado
- **GIVEN** `GjaContainer` com `radius` `container` e um filho que pinta toda a área
- **WHEN** o contêiner é renderizado
- **THEN** o conteúdo é recortado com o raio `container` do tema

#### Scenario: Sem raio, sem recorte
- **WHEN** `GjaContainer` é criado com `radius` `none`
- **THEN** não há recorte do conteúdo

### Requirement: [Aparência] Tokens de componente
`GjaContainer` SHALL obter o fundo de `colors.background`, `colors.base`, `colors.headerBackground` ou `colors.shell`, a borda de `colors.separator` com 1 px, o raio de `radius.<valor>`, a sombra de `elevation.shadowsFor(elevation.<papel>, colors.shadow)` e o espaço de `spacing.<valor>`, todos do tema ativo, sem valores literais.

#### Scenario: Troca de tema
- **GIVEN** `GjaContainer` com `surface` `base`, `border` e `elevation` `card` no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** o fundo, a borda e a cor da sombra passam aos valores do escuro, sem recriar o widget com outros parâmetros

#### Scenario: Superfícies
- **WHEN** cada valor de `GjaSurface` é renderizado no tema claro
- **THEN** o fundo é transparente em `none` e, nos demais, a cor de mesmo papel em `colors`

#### Scenario: Raio e sombra
- **WHEN** cada valor de `GjaRadius` e cada papel de `GjaElevation` são renderizados no tema claro
- **THEN** o raio dos cantos é o token de mesmo nome, e as sombras são as do papel com a cor `shadow`

### Requirement: [Estados] Sem estados de interação
`GjaContainer` SHALL NOT apresentar estados de hover, foco, pressionado, selecionado ou desabilitado, porque não é interativo.

#### Scenario: Não recebe foco
- **GIVEN** um `GjaContainer` com `surface` `base` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro elemento
- **THEN** o foco vai direto ao segundo elemento

### Requirement: [Acessibilidade] Teclado e foco
`GjaContainer` SHALL NOT entrar na ordem de foco nem alterar a ordem dos filhos.

#### Scenario: Ordem preservada
- **GIVEN** dois elementos focáveis dentro de um `GjaContainer`
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo

### Requirement: [Acessibilidade] Semântica e contraste
`GjaContainer` SHALL NOT acrescentar nós à árvore de semântica. O texto do tema sobre cada `surface` MUST manter o contraste verificado por `gja/foundation/color`. A borda `separator` é decorativa e isenta do contraste mínimo, conforme `gja/foundation/accessibility`.

#### Scenario: Semântica inalterada
- **WHEN** a árvore de semântica de um texto é comparada com e sem `GjaContainer` em volta dele
- **THEN** as duas árvores têm os mesmos rótulos e papéis

#### Scenario: Texto sobre as superfícies
- **WHEN** a diretriz de contraste de texto é aplicada a um `GjaText` sobre cada `surface` com fundo, nos temas claro e escuro
- **THEN** a diretriz passa

### Requirement: [Responsividade] Densidade
O `padding` SHALL usar o espaçamento da densidade ativa. Raio e sombra MUST ser os mesmos nas duas densidades. O contêiner MUST se ajustar à largura disponível, sem tamanho próprio.

#### Scenario: Densidade compacta
- **GIVEN** um `GjaContainer` com `padding` `l`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** o espaço interno é o `l` compacto dentro e o `l` confortável fora, com o mesmo raio e a mesma sombra

### Requirement: [Integração] Dependências
`GjaContainer` SHALL depender somente de `gja/foundation/color`, `gja/foundation/radius`, `gja/foundation/elevation`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/theming` e `gja/widgets/gja-spacing` (os valores de `GjaSpace`).

#### Scenario: Funciona sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** `GjaContainer` é renderizado com todas as superfícies
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaContainer` MUST ter um teste de widget por cenário, goldens das superfícies, da borda, dos raios e das sombras nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `gja/foundation/accessibility`: contraste do texto sobre as superfícies e semântica. As diretrizes de alvo de toque e o teclado não se aplicam, por não ser interativo.

#### Scenario: Rastreabilidade
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens das superfícies
- **WHEN** os goldens de `GjaContainer` são comparados com a referência
- **THEN** existem as imagens de claro e escuro em cada densidade, e todas coincidem

### Requirement: [Documentação] Exemplos mínimos
`GjaContainer` SHALL ter dartdoc em toda API pública e uma página "GjaContainer" na galeria com as superfícies, a borda, os raios, as sombras e um exemplo de cartão (`base`, borda, raio `container`, sombra `card` e `padding`).

#### Scenario: Página GjaContainer na galeria
- **WHEN** a página "GjaContainer" é aberta
- **THEN** ela exibe as cinco superfícies, os raios, os seis valores de elevação e o exemplo de cartão

### Requirement: [Restrições] Fora do escopo
`GjaContainer` SHALL NOT aceitar cor, raio, sombra ou espaço literais, nem definir tamanho próprio ou ser clicável.

#### Scenario: Sem valores literais
- **WHEN** a API pública de `GjaContainer` é inspecionada
- **THEN** não há parâmetro dos tipos `Color`, `double`, `BorderRadius`, `BoxShadow`, `EdgeInsets` ou `BoxDecoration`
