## Purpose

`RebicTheme` aplica um tema do Rebic a uma subárvore: publica o tema para os widgets e o núcleo, anima a troca de tema, troca a densidade de uma subárvore (como o `sapUiSizeCompact` do SAPUI5) e define o texto e o ícone padrão. Não tem aparência nem interação próprias.

## ADDED Requirements

### Requirement: [API] Propriedades
`RebicTheme` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `data` | `RebicThemeData` | obrigatória |
| `child` | `Widget` | obrigatória |
| `duration` | `Duration?` | duração `medium` do movimento de `data` |

O construtor `RebicTheme.density(density:, child:)` SHALL aplicar o tema do ancestral com a densidade trocada. `RebicTheme.of(context)` SHALL retornar o tema ativo.

#### Scenario: Uso mínimo
- **GIVEN** `RebicTheme` com o tema escuro de referência
- **WHEN** um widget da subárvore lê `RebicTheme.of(context)`
- **THEN** recebe o tema escuro

### Requirement: [API] Callbacks e controlador
`RebicTheme` SHALL NOT ter callbacks nem controlador: o tema é trocado reconstruindo o widget com outro `data`.

#### Scenario: Troca por reconstrução
- **GIVEN** `RebicTheme` com o tema claro
- **WHEN** o pai o reconstrói com o tema escuro e a animação termina
- **THEN** a subárvore lê o tema escuro

### Requirement: [Comportamento] Troca animada de tema
Ao receber outro `data`, `RebicTheme` SHALL interpolar do tema anterior para o novo durante `duration`, com a curva `standard` do movimento, publicando o tema interpolado a cada quadro. Com `duration` zero ou com o movimento reduzido pelo sistema, a troca MUST ser imediata.

#### Scenario: Meio da transição
- **GIVEN** `RebicTheme` com o tema claro e `duration` de 200 ms
- **WHEN** ele recebe o tema escuro e passam 100 ms
- **THEN** a cor `base` publicada está estritamente entre a do claro e a do escuro, e ao fim dos 200 ms é a do escuro

#### Scenario: Movimento reduzido
- **GIVEN** o sistema com animações desligadas
- **WHEN** `RebicTheme` recebe o tema escuro
- **THEN** o próximo quadro já publica o tema escuro

### Requirement: [Comportamento] Densidade por subárvore
`RebicTheme.density` SHALL publicar, para a sua subárvore, o tema do ancestral com a densidade trocada, preservando cores, tipografia e os demais valores. Fora da subárvore, o tema MUST continuar o do ancestral.

#### Scenario: Subárvore compacta
- **GIVEN** `RebicTheme` com o tema claro confortável e, dentro dele, `RebicTheme.density` com `compact`
- **WHEN** um widget dentro e um widget fora da subárvore leem o tema
- **THEN** o de dentro recebe a densidade compacta com as cores do claro, e o de fora recebe a confortável

### Requirement: [Aparência] Texto e ícone padrão
`RebicTheme` SHALL definir, para a subárvore, o estilo de texto padrão como o estilo `body` com a cor `text` do tema ativo, e o ícone padrão com a cor `text` e o tamanho `control` dos ícones. `RebicTheme` SHALL NOT pintar fundo, borda ou sombra.

#### Scenario: Troca de tema
- **GIVEN** um texto e um ícone sem estilo próprio dentro de `RebicTheme` com o tema claro
- **WHEN** o tema passa a ser o escuro
- **THEN** o texto e o ícone usam a cor `text` do escuro, sem serem recriados com outros parâmetros

### Requirement: [Estados] Sem estados visuais
`RebicTheme` SHALL NOT apresentar estados de interação (hover, foco, pressionado, selecionado ou desabilitado), porque não é interativo. Os estados dos widgets da subárvore usam o tema publicado.

#### Scenario: Não recebe foco
- **GIVEN** `RebicTheme` envolvendo dois elementos focáveis
- **WHEN** Tab é pressionado duas vezes
- **THEN** o foco passa pelos dois elementos, sem parada no próprio `RebicTheme`

### Requirement: [Acessibilidade] Teclado e foco
`RebicTheme` SHALL NOT alterar a ordem de foco nem os atalhos de teclado da subárvore.

#### Scenario: Ordem de foco preservada
- **GIVEN** três elementos focáveis, com e sem `RebicTheme` envolvendo o segundo
- **WHEN** Tab é pressionado três vezes em cada caso
- **THEN** a ordem de foco é a mesma

### Requirement: [Acessibilidade] Semântica, escala e movimento
`RebicTheme` SHALL NOT acrescentar nós à árvore de semântica nem alterar a escala de texto do sistema. O movimento reduzido do sistema MUST valer para a troca de tema e para o tema publicado, conforme `rebic/foundation/accessibility`.

#### Scenario: Semântica inalterada
- **WHEN** a árvore de semântica de um conteúdo é comparada com e sem `RebicTheme`
- **THEN** as duas árvores são iguais

### Requirement: [Responsividade] Densidade e plataformas
`RebicTheme` SHALL publicar os limiares de breakpoints e a densidade do tema, usados pelas consultas de responsividade e pelos widgets da subárvore. A densidade de uma subárvore SHALL poder diferir da do restante da tela em qualquer plataforma.

#### Scenario: Densidade compacta
- **GIVEN** uma subárvore com densidade `compact`
- **WHEN** um elemento interativo do núcleo é renderizado nela sem alvo mínimo informado
- **THEN** usa o alvo mínimo da densidade compacta

### Requirement: [Integração] Dependências
`RebicTheme` SHALL depender somente de `rebic/foundation/theming`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/density` e `rebic/foundation/accessibility`. Os componentes de `rebic/core/interaction`, `rebic/core/overlay` e `rebic/core/responsive` leem o tema publicado sem depender deste widget.

#### Scenario: Funciona sem Material
- **GIVEN** uma árvore criada apenas com `WidgetsApp` e `RebicTheme`
- **WHEN** um texto e um elemento interativo do núcleo são renderizados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicTheme` MUST ter um teste de widget por cenário. Por não ter aparência nem interação próprias, os goldens e a bateria de acessibilidade de `rebic/foundation/accessibility` não se aplicam ao próprio widget, e SHALL NOT ser exigidos dele.

#### Scenario: Rastreabilidade
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`RebicTheme` SHALL ter dartdoc em toda API pública e uma página "RebicTheme" na galeria. A página MUST alternar entre claro e escuro, com a troca animada, e mostrar uma subárvore compacta ao lado de uma confortável.

#### Scenario: Página na galeria
- **WHEN** a página "RebicTheme" é aberta e o tema é trocado para escuro
- **THEN** a prévia passa a usar a cor `base` do escuro, e a subárvore compacta mostra o alvo mínimo compacto

### Requirement: [Restrições] Fora do escopo
`RebicTheme` SHALL NOT criar `WidgetsApp`, `MediaQuery`, `Directionality` ou localização, nem seguir o brilho do sistema operacional; isso é de `RebicApp`. Ele SHALL NOT depender de `Theme` do Material nem de estado global.

#### Scenario: Sem estado global
- **GIVEN** duas subárvores irmãs, uma com `RebicTheme` claro e outra com `RebicTheme` escuro
- **WHEN** cada uma lê o tema ativo
- **THEN** cada uma recebe o seu, sem interferência entre elas
