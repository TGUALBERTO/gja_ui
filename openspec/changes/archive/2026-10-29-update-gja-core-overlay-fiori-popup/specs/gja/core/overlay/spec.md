## MODIFIED Requirements

### Requirement: Dispensa do modal
Como o `sap.m.Dialog`, um modal dispensável MUST fechar com Esc, devolvendo nulo, e um modal não dispensável MUST ignorar Esc e só fechar pela ação do próprio conteúdo. Em nenhum dos dois casos a camada de bloqueio MUST ser interativa: um toque nela MUST NOT fechar o modal, e ela MUST NOT ter rótulo nem ação na árvore de semântica.

#### Scenario: Dispensa por Esc e pela camada
- **GIVEN** um modal dispensável aberto
- **WHEN** Esc é pressionado e, em outra abertura, a camada é tocada fora do conteúdo
- **THEN** o modal fecha com Esc e continua aberto depois do toque na camada

#### Scenario: Modal não dispensável
- **GIVEN** um modal não dispensável aberto
- **WHEN** Esc é pressionado e a camada é tocada
- **THEN** o modal continua aberto

#### Scenario: Camada sem semântica
- **WHEN** um modal dispensável é aberto
- **THEN** nenhum nó da árvore de semântica tem o rótulo `close` nem a ação de toque da camada

### Requirement: Sobreposição ancorada
O núcleo SHALL mostrar um conteúdo junto de uma âncora, na posição preferida (`bottom`, `top`, `start` ou `end`, como o `placement` do Popover do SAPUI5), alinhado por `alignment` e afastado pela distância recebida. Sem espaço na posição preferida e com espaço na oposta, ele MUST ir para a oposta. Ele MUST ficar a pelo menos a margem recebida das bordas e MUST acompanhar a âncora quando ela se move ou muda de tamanho.

#### Scenario: Posição preferida
- **GIVEN** uma âncora no alto da tela, a posição `bottom`, alinhamento ao início e afastamento 4
- **WHEN** a sobreposição é aberta
- **THEN** o topo do conteúdo fica 4 abaixo da base da âncora, e a borda inicial do conteúdo coincide com a da âncora

#### Scenario: Inversão por falta de espaço
- **GIVEN** uma âncora junto à base da tela e a posição `bottom`
- **WHEN** a sobreposição é aberta com um conteúdo mais alto que o espaço abaixo
- **THEN** o conteúdo aparece acima da âncora

#### Scenario: Dentro da tela
- **GIVEN** uma âncora junto à borda direita da tela, alinhamento ao início e margem 8
- **WHEN** a sobreposição é aberta com um conteúdo mais largo que o espaço à direita da âncora
- **THEN** a borda direita do conteúdo fica a 8 da borda direita da tela

#### Scenario: Acompanha a rolagem
- **GIVEN** uma sobreposição aberta junto a uma âncora dentro de uma lista rolável
- **WHEN** a lista rola 100 para cima
- **THEN** o conteúdo sobe 100 junto com a âncora

#### Scenario: Acompanha a âncora que muda de tamanho
- **GIVEN** uma sobreposição aberta na posição `bottom`, junto a uma âncora de 40 de altura
- **WHEN** a âncora passa a ter 60 de altura, sem rolagem
- **THEN** no quadro seguinte o topo do conteúdo fica abaixo da nova base da âncora, à mesma distância de antes

### Requirement: Testes e documentação das sobreposições
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública MUST ter dartdoc. A galeria SHALL ter uma página "Sobreposições" com um modal dispensável, um modal não dispensável e uma sobreposição ancorada com escolha da posição preferida.

#### Scenario: Página na galeria
- **WHEN** a página "Sobreposições" é aberta, o modal dispensável é aberto e fechado com Esc, e a sobreposição ancorada é aberta e fechada com um toque fora
- **THEN** cada sobreposição aparece e some, e a página volta ao estado inicial

## ADDED Requirements

### Requirement: Posição efetiva da sobreposição ancorada
O núcleo SHALL informar ao conteúdo da sobreposição ancorada a posição efetiva, depois da inversão, para que ele possa, por exemplo, desenhar a seta do lado da âncora, como o Popover do SAPUI5. A posição informada MUST mudar quando a inversão muda, enquanto a sobreposição está aberta.

#### Scenario: Posição informada após a inversão
- **GIVEN** uma âncora junto à base da tela, a posição `bottom` e um conteúdo mais alto que o espaço abaixo
- **WHEN** a sobreposição é aberta
- **THEN** o conteúdo recebe a posição efetiva `top`

#### Scenario: Posição sem inversão
- **GIVEN** uma âncora no alto da tela e a posição `bottom`
- **WHEN** a sobreposição é aberta
- **THEN** o conteúdo recebe a posição efetiva `bottom`
