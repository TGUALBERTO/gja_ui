# Spec Delta

## Purpose

Define a infraestrutura de interação do GJA: detecção de estados, ativação por toque e teclado, desabilitado, foco e anel de foco, área mínima, semântica e cursor, aplicando os valores de `gja/foundation/interaction-states` e as regras de `gja/foundation/accessibility`.

## ADDED Requirements

### Requirement: Detecção de estados
O núcleo SHALL fornecer um elemento interativo que informe ao widget que o usa o conjunto de estados ativos: `hovered` enquanto o ponteiro está sobre ele, `pressed` entre o toque e a soltura ou o cancelamento, `focused` enquanto tem o foco, `selected` quando recebido do widget e `disabled` quando não há ação. Toda mudança de estado MUST reconstruir o conteúdo com o novo conjunto.

#### Scenario: Hover e pressionado
- **GIVEN** um elemento interativo habilitado
- **WHEN** o ponteiro entra, pressiona, solta e sai
- **THEN** os conjuntos informados são `{hovered}`, `{hovered, pressed}`, `{hovered}` e `{}`, nessa ordem

#### Scenario: Seleção recebida
- **WHEN** o elemento é criado com `selected` verdadeiro
- **THEN** o conjunto informado contém `selected`

### Requirement: Ativação por toque e teclado
Um elemento habilitado MUST chamar sua ação uma vez por toque completo e uma vez por Enter, Enter numérico ou Espaço quando tiver o foco. Um toque cancelado (o ponteiro sai antes de soltar) MUST NOT chamar a ação.

#### Scenario: Ativação por teclado
- **GIVEN** um elemento habilitado com foco
- **WHEN** Enter, Enter numérico e Espaço são pressionados
- **THEN** a ação é chamada três vezes

#### Scenario: Toque cancelado
- **WHEN** o ponteiro pressiona o elemento, sai da área dele e solta
- **THEN** a ação não é chamada, e `pressed` sai do conjunto

### Requirement: Elemento desabilitado
Sem ação, o elemento MUST estar desabilitado: fora da ordem de foco, sem `hovered` nem `pressed`, sem responder a toque ou teclado, com semântica de desabilitado e cursor padrão.

#### Scenario: Desabilitado ignora interação
- **GIVEN** um elemento sem ação
- **WHEN** ele recebe hover, toque e Tab a partir do elemento anterior
- **THEN** o conjunto informado é sempre `{disabled}`, e o foco passa para o elemento seguinte

### Requirement: Anel de foco pelo teclado
O anel de foco MUST aparecer somente quando o elemento tem foco, não está desabilitado e o foco veio do teclado (modo de destaque tradicional). Foco obtido por toque ou ponteiro MUST NOT mostrar o anel. O anel MUST usar a espessura, o afastamento e a cor de foco dos tokens.

#### Scenario: Foco por teclado
- **WHEN** o foco chega ao elemento por Tab
- **THEN** o anel é desenhado com a espessura e a cor de foco dos tokens

#### Scenario: Foco por toque
- **WHEN** o elemento recebe foco após um toque
- **THEN** `focused` está no conjunto, e o anel não é desenhado

### Requirement: Ordem de foco
A navegação por Tab e Shift+Tab MUST seguir a ordem de leitura dos elementos e pular os desabilitados.

#### Scenario: Tab entre três elementos
- **GIVEN** três elementos em coluna, com o do meio desabilitado
- **WHEN** Tab é pressionado duas vezes a partir do primeiro, e depois Shift+Tab
- **THEN** o foco vai ao terceiro, volta ao primeiro (ciclo) e, com Shift+Tab, vai ao terceiro de novo

### Requirement: Área mínima de interação
O elemento MUST ocupar e responder ao toque em uma área de pelo menos o alvo mínimo recebido, em largura e altura, mesmo quando o conteúdo é menor. O padrão é o alvo da densidade confortável de referência.

#### Scenario: Conteúdo menor que o alvo
- **GIVEN** um elemento com conteúdo de 16 × 16 e alvo mínimo 48
- **WHEN** ele é medido e tocado a 20 px do centro
- **THEN** ele mede pelo menos 48 × 48, e a ação é chamada

### Requirement: Semântica e cursor
O elemento MUST expor ao leitor de tela o papel de botão, o rótulo recebido, o estado habilitado e o selecionado, e a ação de toque quando habilitado. Com ação, o cursor do ponteiro MUST ser o de clique.

#### Scenario: Semântica de botão
- **WHEN** a árvore semântica de um elemento habilitado e selecionado, com rótulo "Salvar", é inspecionada
- **THEN** ele é botão, tem o rótulo "Salvar", está habilitado e selecionado e tem a ação de toque

### Requirement: Testes e documentação da interação
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública MUST ter dartdoc. A galeria SHALL ter uma página "Interação" com um elemento interativo que mostra os estados ativos e o número de ativações.

#### Scenario: Página na galeria
- **WHEN** a página "Interação" é aberta e o elemento é tocado
- **THEN** o contador de ativações aumenta, e os estados ativos são exibidos como texto
