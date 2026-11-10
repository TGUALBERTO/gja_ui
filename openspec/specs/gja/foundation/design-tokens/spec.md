# gja/foundation/design-tokens Specification

## Purpose

Define o modelo de design tokens do GJA: os três níveis (primitivo, semântico e de componente), o contrato comum dos conjuntos de tokens, a nomenclatura, os tokens de movimento e as extensões tipadas da aplicação. Os demais fundamentos e todos os widgets declaram e consomem tokens por esse modelo.

## Requirements

### Requirement: Três níveis de tokens
O framework SHALL organizar os tokens em três níveis. Os **primitivos** são valores brutos de escala. Os **semânticos** são papéis que cada tema mapeia para primitivos. Os **de componente** são derivados dos semânticos e agrupados por widget. Cada token público MUST pertencer a exatamente um nível, e esse nível MUST constar na sua documentação de API.

#### Scenario: Token semântico derivado de primitivo
- **GIVEN** um conjunto semântico construído a partir de primitivos
- **WHEN** o valor de um papel semântico é lido
- **THEN** ele é igual ao valor do primitivo mapeado, sem nenhum literal visual repetido no código do conjunto semântico

#### Scenario: Nível documentado
- **WHEN** a documentação de API de um token público é gerada
- **THEN** ela indica se o token é primitivo, semântico ou de componente

### Requirement: Primitivos isolados da camada de widgets
Os primitivos MUST ficar em uma biblioteca pública separada, que o ponto de entrada do fundamento e o agregador `gja_ui` SHALL NOT reexportar. Código de biblioteca das camadas `core` e `widgets` MUST NOT importar essa biblioteca. Aplicações e temas podem importá-la para personalizar a identidade visual.

#### Scenario: Widget importa primitivos
- **GIVEN** um arquivo em `packages/gja_widgets/lib` que importa a biblioteca de primitivos
- **WHEN** a verificação de arquitetura é executada
- **THEN** a verificação falha e indica o arquivo, a linha e o import proibido

#### Scenario: Aplicação personaliza a marca
- **GIVEN** uma aplicação que importa a biblioteca de primitivos
- **WHEN** ela constrói um conjunto semântico com primitivos próprios
- **THEN** a aplicação compila sem importar nenhuma biblioteca interna (`src/`) do framework

#### Scenario: Agregador não expõe primitivos
- **WHEN** uma aplicação importa apenas `package:gja_ui/gja_ui.dart`
- **THEN** nenhum símbolo da biblioteca de primitivos fica visível

### Requirement: Conjuntos de tokens imutáveis
Todo conjunto de tokens semânticos ou de componente MUST ser imutável e ter construtor `const`. O conjunto SHALL oferecer `copyWith`, que retorna um novo conjunto com apenas os campos informados substituídos e o original inalterado.

#### Scenario: copyWith substitui um campo
- **GIVEN** um conjunto de tokens com valores conhecidos
- **WHEN** `copyWith` é chamado informando um único campo
- **THEN** o resultado tem o novo valor nesse campo, mantém todos os demais e o conjunto original permanece inalterado

#### Scenario: copyWith sem argumentos
- **WHEN** `copyWith` é chamado sem argumentos
- **THEN** o resultado é igual ao conjunto original

### Requirement: Igualdade por valor
Dois conjuntos de tokens do mesmo tipo com os mesmos valores MUST ser iguais (`==`) e ter o mesmo `hashCode`. Conjuntos com qualquer valor diferente MUST ser diferentes. Isso permite que a troca para um tema com valores idênticos não reconstrua os dependentes.

#### Scenario: Conjuntos com valores iguais
- **GIVEN** dois conjuntos do mesmo tipo construídos separadamente com os mesmos valores
- **WHEN** eles são comparados
- **THEN** são iguais e têm o mesmo `hashCode`

#### Scenario: Conjuntos com um valor diferente
- **WHEN** dois conjuntos diferem em um único token
- **THEN** eles não são iguais

### Requirement: Interpolação entre conjuntos
Todo conjunto de tokens semânticos ou de componente MUST oferecer `lerp(other, t)`, para que a troca de tema possa ser animada. Em `t = 0` o resultado MUST ser igual ao conjunto de origem, e em `t = 1` igual a `other`. Tokens contínuos (cores, dimensões, durações) SHALL ser interpolados. Tokens discretos (curvas, enums, famílias tipográficas) SHALL trocar em `t = 0.5`.

#### Scenario: Extremos da interpolação
- **GIVEN** dois conjuntos A e B do mesmo tipo
- **WHEN** `A.lerp(B, 0)` e `A.lerp(B, 1)` são calculados
- **THEN** os resultados são iguais a A e a B, respectivamente

#### Scenario: Ponto médio de token contínuo
- **GIVEN** um token de duração de 100 ms em A e 300 ms em B
- **WHEN** `A.lerp(B, 0.5)` é calculado
- **THEN** o token resultante vale 200 ms

#### Scenario: Token discreto
- **GIVEN** um token de curva que difere entre A e B
- **WHEN** a interpolação é calculada em `t = 0.49` e em `t = 0.5`
- **THEN** o resultado usa a curva de A no primeiro caso e a curva de B no segundo

#### Scenario: Interpolação com nulo
- **WHEN** `lerp` é chamado com `other` nulo
- **THEN** o resultado é igual ao conjunto de origem

### Requirement: Nomenclatura dos tokens
Os nomes MUST seguir o nível do token. Primitivos são nomeados pela posição na escala (ex.: `duration200`). Semânticos são nomeados pelo papel, nunca pelo valor (ex.: `short`, não `ms150`). Tokens de componente seguem `<widget>.<variante>.<propriedade>` em lowerCamelCase no Dart (ex.: `button.emphasized.background`). Nomes de cor por matiz (ex.: `blue`) SHALL NOT aparecer nos níveis semântico e de componente.

#### Scenario: Revisão de nome semântico
- **GIVEN** uma change que adiciona um token semântico chamado pelo valor
- **WHEN** a change é revisada
- **THEN** a revisão a rejeita até o token ser renomeado pelo papel

#### Scenario: Primitivo identificado pela escala
- **WHEN** a biblioteca de primitivos é inspecionada
- **THEN** cada primitivo de uma escala tem nome com a posição na escala, e a ordem dos nomes corresponde à ordem dos valores

### Requirement: Tokens de movimento
O fundamento SHALL fornecer primitivos de duração e de curva de animação e um conjunto semântico de movimento com, no mínimo, os papéis de duração `instant`, `short`, `medium` e `long` e os papéis de curva `standard`, `enter` e `exit`. As durações semânticas MUST ser não decrescentes nessa ordem, e `instant` MUST valer zero. As curvas MUST ser as curvas CSS usadas pelo SAPUI5, e não as do Material.

#### Scenario: Ordem das durações
- **WHEN** o conjunto semântico de movimento padrão é inspecionado
- **THEN** `instant` ≤ `short` ≤ `medium` ≤ `long`, e `instant` vale zero

#### Scenario: Curvas CSS
- **WHEN** as curvas do conjunto semântico de movimento padrão são inspecionadas
- **THEN** `standard` é `ease-in-out` (0.42, 0, 0.58, 1), `enter` é `ease-out` (0, 0, 0.58, 1) e `exit` é `ease-in` (0.42, 0, 1, 1)

#### Scenario: Sem curvas do Material
- **WHEN** as curvas primitivas são listadas
- **THEN** nenhuma é (0.4, 0, 0.2, 1), (0, 0, 0.2, 1) ou (0.4, 0, 1, 1), e os nomes seguem as curvas CSS (`curveEaseInOut`, `curveEaseOut`, `curveEaseIn`)

#### Scenario: Widget anima sem literal
- **GIVEN** um widget que anima uma transição
- **WHEN** a verificação de tokens é executada no código do widget
- **THEN** a duração e a curva vêm do conjunto semântico de movimento, e nenhum literal de `Duration` é reportado

### Requirement: Extensões tipadas da aplicação
O framework SHALL permitir que a aplicação registre conjuntos de tokens próprios como extensões tipadas, cada uma identificada pelo seu tipo. A busca por um tipo registrado MUST retornar a instância daquele tipo. A busca por um tipo não registrado MUST retornar nulo, sem lançar exceção. As extensões MUST seguir o mesmo contrato de imutabilidade, igualdade e interpolação dos conjuntos do framework.

#### Scenario: Extensão registrada
- **GIVEN** uma coleção de extensões com uma extensão do tipo `MarcaTokens`
- **WHEN** a aplicação busca o tipo `MarcaTokens`
- **THEN** recebe a instância registrada, já tipada, sem precisar de cast

#### Scenario: Extensão ausente
- **WHEN** a aplicação busca um tipo que não foi registrado
- **THEN** o resultado é nulo

#### Scenario: Interpolação das extensões
- **GIVEN** duas coleções que contêm o mesmo tipo de extensão com valores diferentes
- **WHEN** as coleções são interpoladas
- **THEN** cada extensão é interpolada pelo seu próprio `lerp`, e extensões presentes em só uma das coleções são mantidas como estão

#### Scenario: Registro duplicado
- **WHEN** uma coleção é criada com duas extensões do mesmo tipo
- **THEN** a criação falha em modo debug com uma mensagem que identifica o tipo duplicado

### Requirement: Inspeção dos tokens
Todo conjunto de tokens MUST expor seus valores nas ferramentas de diagnóstico do Flutter: cada token aparece como propriedade nomeada na árvore de diagnóstico (`toDiagnosticsNode().toStringDeep()`) e no inspetor de widgets.

#### Scenario: Propriedades no diagnóstico
- **WHEN** a árvore de diagnóstico de um conjunto de tokens é impressa (`toDiagnosticsNode().toStringDeep()`)
- **THEN** a saída contém o nome e o valor de cada token do conjunto

### Requirement: Testes e documentação
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`, exceto os de revisão, que são verificados na revisão da change. Toda API pública do fundamento MUST ter dartdoc. A galeria SHALL ter uma página "Design tokens" que mostra os tokens de movimento e anima a interpolação entre dois conjuntos.

#### Scenario: Rastreabilidade
- **WHEN** os testes de `gja_foundation` são executados
- **THEN** existe um teste aprovado para cada cenário automatizável desta spec, nomeado pelo requisito e pelo cenário

#### Scenario: Página na galeria
- **WHEN** a galeria é aberta
- **THEN** a página "Design tokens" está acessível e exibe os papéis de movimento com suas durações
