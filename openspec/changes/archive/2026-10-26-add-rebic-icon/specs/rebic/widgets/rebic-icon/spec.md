## Purpose

`RebicIcon` exibe um ícone da fonte do Rebic, como o `sap.ui.core.Icon` do SAPUI5: aplica um papel de tamanho e uma cor de papel do tema ativo, separa ícones decorativos de ícones com significado para leitores de tela e espelha os direcionais em RTL, sem valores literais.

## ADDED Requirements

### Requirement: [API] Propriedades
`RebicIcon` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `icon` (posicional) | `IconData` | obrigatória |
| `size` | `RebicIconSize` | `control` |
| `tone` | `RebicIconTone` | `standard` |
| `semanticLabel` | `String?` | nulo (decorativo) |

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `RebicApp` e o tema claro
- **WHEN** `RebicIcon(RebicIcons.search)` é criado
- **THEN** o ícone tem o tamanho `control` e a cor `text` do tema, e fica fora da árvore de semântica

### Requirement: [API] Callbacks e controlador
`RebicIcon` SHALL NOT ter callbacks nem controlador: é um widget de exibição. Ícones clicáveis são de `RebicIconButton`.

#### Scenario: Sem ação
- **GIVEN** `RebicIcon` com `semanticLabel`
- **WHEN** o ícone é tocado
- **THEN** nada é executado, e a semântica não informa ação de toque

### Requirement: [Comportamento] Espelhamento em RTL
`RebicIcon` SHALL espelhar os ícones direcionais do catálogo quando a direção do texto é da direita para a esquerda e manter os demais, conforme `rebic/foundation/iconography`.

#### Scenario: Direcional em RTL
- **GIVEN** a direção de texto da direita para a esquerda
- **WHEN** `RebicIcon(RebicIcons.chevronRight)` e `RebicIcon(RebicIcons.check)` são renderizados
- **THEN** o primeiro é desenhado espelhado, e o segundo não

### Requirement: [Aparência] Tokens de componente
`RebicIcon` SHALL obter o tamanho de `icons.<size>` e a cor de `colors.text` (`standard`), `colors.label` (`muted`), `colors.brand` (`brand`) ou do `foreground` do estado de valor correspondente (`success`, `warning`, `error`, `information`), todos do tema ativo, sem valores literais.

#### Scenario: Troca de tema
- **GIVEN** `RebicIcon` com `tone` `brand` renderizado no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** o ícone usa a cor `brand` do tema escuro, sem ser recriado com outros parâmetros

#### Scenario: Tamanhos e tons
- **WHEN** cada combinação de `size` e `tone` é renderizada no tema claro
- **THEN** o ícone mede `icons.<size>` nos dois eixos e usa a cor do papel do `tone`

### Requirement: [Estados] Sem estados de interação
`RebicIcon` SHALL NOT apresentar estados de hover, foco, pressionado, selecionado ou desabilitado, porque não é interativo. A cor vem só de `tone`.

#### Scenario: Não recebe foco
- **GIVEN** uma página com `RebicIcon` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro elemento
- **THEN** o foco vai direto ao segundo elemento

### Requirement: [Acessibilidade] Teclado e foco
`RebicIcon` SHALL NOT entrar na ordem de foco nem responder a teclas.

#### Scenario: Teclas ignoradas
- **GIVEN** uma página com `RebicIcon` e nenhum elemento focável
- **WHEN** Tab, Enter e Espaço são pressionados
- **THEN** nada muda na página

### Requirement: [Acessibilidade] Semântica e contraste
Sem `semanticLabel`, `RebicIcon` MUST ficar fora da árvore de semântica (decorativo). Com `semanticLabel`, MUST ser anunciado como imagem com esse rótulo. As cores de `tone` MUST ter contraste ≥ 3:1 sobre `base` e `background` nos dois temas, conforme `rebic/foundation/accessibility` para elementos não textuais.

#### Scenario: Ícone decorativo
- **WHEN** um leitor de tela percorre uma página com `RebicIcon(RebicIcons.search)` sem rótulo
- **THEN** nada é anunciado para o ícone

#### Scenario: Ícone com significado
- **WHEN** um leitor de tela percorre `RebicIcon(RebicIcons.warning, tone: warning, semanticLabel: 'Aviso')`
- **THEN** anuncia "Aviso" como imagem

#### Scenario: Contraste dos tons
- **WHEN** a razão de contraste de cada cor de `tone` é calculada sobre `base` e `background`, nos temas claro e escuro
- **THEN** todas são ≥ 3:1

### Requirement: [Responsividade] Escala de texto e densidade
O papel `inline` SHALL acompanhar a escala de texto do sistema, para manter o ícone alinhado ao texto. Os demais papéis MUST manter o tamanho dos tokens em qualquer escala. Os tamanhos MUST ser os mesmos nas densidades confortável e compacta.

#### Scenario: Escala de texto 2,0
- **GIVEN** a escala de texto 2,0
- **WHEN** um ícone `inline` e um `control` são renderizados
- **THEN** o `inline` mede o dobro de `icons.inline`, e o `control` mede `icons.control`

#### Scenario: Densidade compacta
- **GIVEN** uma subárvore com densidade `compact`
- **WHEN** `RebicIcon` é renderizado nela
- **THEN** mede o mesmo que na densidade confortável

### Requirement: [Integração] Dependências
`RebicIcon` SHALL depender somente de `rebic/foundation/iconography`, `rebic/foundation/color`, `rebic/foundation/theming` e `rebic/foundation/accessibility`, e do `Icon` nativo do Flutter.

#### Scenario: Funciona sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** todos os ícones do catálogo são renderizados com `RebicIcon`
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicIcon` MUST ter um teste de widget por cenário, goldens dos tamanhos e dos tons nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`: contraste não textual, escala de texto e semântica. As diretrizes de alvo de toque e o teclado não se aplicam, por não ser interativo.

#### Scenario: Rastreabilidade
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens dos tamanhos e tons
- **WHEN** os goldens de `RebicIcon` são comparados com a referência
- **THEN** existem as imagens de claro e escuro em cada densidade, e todas coincidem

### Requirement: [Documentação] Exemplos mínimos
`RebicIcon` SHALL ter dartdoc em toda API pública e uma página "RebicIcon" na galeria com os tamanhos, os tons, um ícone com rótulo e um direcional em RTL.

#### Scenario: Página RebicIcon na galeria
- **WHEN** a página "RebicIcon" é aberta
- **THEN** ela exibe os seis tamanhos, os sete tons, um ícone com rótulo e o mesmo direcional em LTR e RTL

### Requirement: [Restrições] Fora do escopo
`RebicIcon` SHALL NOT ser clicável, exibir dica, aceitar imagens ou SVG, nem aceitar tamanho ou cor arbitrários.

#### Scenario: Sem tamanho nem cor arbitrários
- **WHEN** a API pública de `RebicIcon` é inspecionada
- **THEN** não há parâmetro do tipo `double` para tamanho nem do tipo `Color`
