# gja/widgets/gja-theme Specification

## Purpose

`GjaTheme` aplica um tema do GJA a uma subárvore: publica o tema para os widgets e o núcleo, anima a troca de tema, troca a densidade de uma subárvore (como o `sapUiSizeCompact` do SAPUI5) e define o texto e o ícone padrão. Não tem aparência nem interação próprias.

## Requirements

### Requirement: [API] Propriedades
`GjaTheme` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `data` | `GjaThemeData` | obrigatória |
| `child` | `Widget` | obrigatória |
| `duration` | `Duration?` | duração `medium` do movimento de `data` |

O construtor `GjaTheme.density(density:, child:)` SHALL aplicar o tema do ancestral com a densidade trocada. `GjaTheme.of(context)` SHALL retornar o tema ativo.

#### Scenario: Uso mínimo
- **GIVEN** `GjaTheme` com o tema escuro de referência
- **WHEN** um widget da subárvore lê `GjaTheme.of(context)`
- **THEN** recebe o tema escuro

### Requirement: [API] Callbacks e controlador
`GjaTheme` SHALL NOT ter callbacks nem controlador: o tema é trocado reconstruindo o widget com outro `data`.

#### Scenario: Troca por reconstrução
- **GIVEN** `GjaTheme` com o tema claro
- **WHEN** o pai o reconstrói com o tema escuro e a animação termina
- **THEN** a subárvore lê o tema escuro

### Requirement: [Comportamento] Troca animada de tema
Ao receber outro `data`, `GjaTheme` SHALL interpolar do tema anterior para o novo durante `duration`, com a curva `standard` do movimento, publicando o tema interpolado a cada quadro. Com `duration` zero ou com o movimento reduzido pelo sistema, a troca MUST ser imediata.

#### Scenario: Meio da transição
- **GIVEN** `GjaTheme` com o tema claro e `duration` de 200 ms
- **WHEN** ele recebe o tema escuro e passam 100 ms
- **THEN** a cor `base` publicada está estritamente entre a do claro e a do escuro, e ao fim dos 200 ms é a do escuro

#### Scenario: Movimento reduzido
- **GIVEN** o sistema com animações desligadas
- **WHEN** `GjaTheme` recebe o tema escuro
- **THEN** o próximo quadro já publica o tema escuro

### Requirement: [Comportamento] Densidade por subárvore
`GjaTheme.density` SHALL publicar, para a sua subárvore, o tema do ancestral com a densidade trocada, preservando cores, tipografia e os demais valores. Fora da subárvore, o tema MUST continuar o do ancestral.

#### Scenario: Subárvore compacta
- **GIVEN** `GjaTheme` com o tema claro confortável e, dentro dele, `GjaTheme.density` com `compact`
- **WHEN** um widget dentro e um widget fora da subárvore leem o tema
- **THEN** o de dentro recebe a densidade compacta com as cores do claro, e o de fora recebe a confortável

### Requirement: [Aparência] Texto e ícone padrão
`GjaTheme` SHALL definir, para a subárvore, o estilo de texto padrão como o estilo `body` com a cor `text` do tema ativo, e o ícone padrão com a cor `text` e o tamanho `control` dos ícones. `GjaTheme` SHALL NOT pintar fundo, borda ou sombra.

#### Scenario: Troca de tema
- **GIVEN** um texto e um ícone sem estilo próprio dentro de `GjaTheme` com o tema claro
- **WHEN** o tema passa a ser o escuro
- **THEN** o texto e o ícone usam a cor `text` do escuro, sem serem recriados com outros parâmetros

### Requirement: [Estados] Sem estados visuais
`GjaTheme` SHALL NOT apresentar estados de interação (hover, foco, pressionado, selecionado ou desabilitado), porque não é interativo. Os estados dos widgets da subárvore usam o tema publicado.

#### Scenario: Não recebe foco
- **GIVEN** `GjaTheme` envolvendo dois elementos focáveis
- **WHEN** Tab é pressionado duas vezes
- **THEN** o foco passa pelos dois elementos, sem parada no próprio `GjaTheme`

### Requirement: [Acessibilidade] Teclado e foco
`GjaTheme` SHALL NOT alterar a ordem de foco nem os atalhos de teclado da subárvore.

#### Scenario: Ordem de foco preservada
- **GIVEN** três elementos focáveis, com e sem `GjaTheme` envolvendo o segundo
- **WHEN** Tab é pressionado três vezes em cada caso
- **THEN** a ordem de foco é a mesma

### Requirement: [Acessibilidade] Semântica, escala e movimento
`GjaTheme` SHALL NOT acrescentar nós à árvore de semântica nem alterar a escala de texto do sistema. O movimento reduzido do sistema MUST valer para a troca de tema e para o tema publicado, conforme `gja/foundation/accessibility`.

#### Scenario: Semântica inalterada
- **WHEN** a árvore de semântica de um conteúdo é comparada com e sem `GjaTheme`
- **THEN** as duas árvores são iguais

### Requirement: [Responsividade] Densidade e plataformas
`GjaTheme` SHALL publicar os limiares de breakpoints e a densidade do tema, usados pelas consultas de responsividade e pelos widgets da subárvore. A densidade de uma subárvore SHALL poder diferir da do restante da tela em qualquer plataforma.

#### Scenario: Densidade compacta
- **GIVEN** uma subárvore com densidade `compact`
- **WHEN** um elemento interativo do núcleo é renderizado nela sem alvo mínimo informado
- **THEN** usa o alvo mínimo da densidade compacta

### Requirement: [Integração] Dependências
`GjaTheme` SHALL depender somente de `gja/foundation/theming`, `gja/foundation/typography`, `gja/foundation/iconography`, `gja/foundation/density` e `gja/foundation/accessibility`. Os componentes de `gja/core/interaction`, `gja/core/overlay` e `gja/core/responsive` leem o tema publicado sem depender deste widget.

#### Scenario: Funciona sem Material
- **GIVEN** uma árvore criada apenas com `WidgetsApp` e `GjaTheme`
- **WHEN** um texto e um elemento interativo do núcleo são renderizados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaTheme` MUST ter um teste de widget por cenário. Por não ter aparência nem interação próprias, os goldens e a bateria de acessibilidade de `gja/foundation/accessibility` não se aplicam ao próprio widget, e SHALL NOT ser exigidos dele.

#### Scenario: Rastreabilidade
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`GjaTheme` SHALL ter dartdoc em toda API pública e uma página "GjaTheme" na galeria. A página MUST alternar entre claro e escuro, com a troca animada, e mostrar uma subárvore compacta ao lado de uma confortável.

#### Scenario: Página na galeria
- **WHEN** a página "GjaTheme" é aberta e o tema é trocado para escuro
- **THEN** a prévia passa a usar a cor `base` do escuro, e a subárvore compacta mostra o alvo mínimo compacto

### Requirement: [Restrições] Fora do escopo
`GjaTheme` SHALL NOT criar `WidgetsApp`, `MediaQuery`, `Directionality` ou localização, nem seguir o brilho do sistema operacional; isso é de `GjaApp`. Ele SHALL NOT depender de `Theme` do Material nem de estado global.

#### Scenario: Sem estado global
- **GIVEN** duas subárvores irmãs, uma com `GjaTheme` claro e outra com `GjaTheme` escuro
- **WHEN** cada uma lê o tema ativo
- **THEN** cada uma recebe o seu, sem interferência entre elas
