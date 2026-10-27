# rebic/core/overlay Specification

## Purpose

Define as sobreposições do núcleo do Rebic: o modal com camada de bloqueio, o foco preso e restaurado, a dispensa por Esc e por toque, a sobreposição ancorada com posição preferida, inversão e limite de tela, o fechamento automático e o empilhamento. Usa a ativação e o foco de `rebic/core/interaction`, a cor `blockLayer` de `rebic/foundation/color` e o texto `close` de `rebic/core/localization`.

## Requirements

### Requirement: Modal com camada de bloqueio
O núcleo SHALL abrir um conteúdo modal acima da tela, sobre uma camada de bloqueio que cobre toda a tela com a cor recebida ou, sem ela, com o `blockLayer` do tema ativo de `rebic/foundation/theming`. Enquanto o modal está aberto, o conteúdo abaixo MUST NOT receber toques nem ser exposto à árvore de semântica. O modal MUST devolver a quem o abriu o resultado informado ao fechar, ou nulo quando é dispensado.

#### Scenario: Interação bloqueada
- **GIVEN** um modal aberto sobre uma tela com um botão
- **WHEN** o ponto do botão é tocado
- **THEN** a ação do botão não é chamada, e o botão não aparece na árvore de semântica

#### Scenario: Resultado ao fechar
- **WHEN** o modal é fechado com o resultado "ok" e, em outra abertura, é dispensado
- **THEN** quem o abriu recebe "ok" na primeira vez e nulo na segunda

### Requirement: Foco no modal
Ao abrir, o modal MUST mover o foco para dentro dele: para o elemento indicado como foco inicial ou, sem indicação, para o primeiro elemento focável. Tab e Shift+Tab MUST circular só entre os elementos do modal. Ao fechar, o foco MUST voltar ao elemento que o tinha antes da abertura.

#### Scenario: Tab preso no modal
- **GIVEN** um modal com dois elementos focáveis, aberto sobre uma tela com outros elementos focáveis
- **WHEN** Tab é pressionado três vezes
- **THEN** o foco passa pelo primeiro, pelo segundo e de novo pelo primeiro elemento do modal

#### Scenario: Foco devolvido
- **GIVEN** um elemento com foco que abre um modal
- **WHEN** o modal é fechado
- **THEN** o foco volta ao elemento

### Requirement: Dispensa do modal
Um modal dispensável MUST fechar com Esc e com um toque na camada de bloqueio, devolvendo nulo. Um modal não dispensável MUST ignorar ambos e só fechar pela ação do próprio conteúdo. Nas plataformas em que o Flutter expõe a camada a leitores de tela (Android, iOS e macOS), a camada de um modal dispensável MUST ter o rótulo `close` do idioma ativo.

#### Scenario: Dispensa por Esc e pela camada
- **GIVEN** um modal dispensável aberto
- **WHEN** Esc é pressionado e, em outra abertura, a camada é tocada fora do conteúdo
- **THEN** o modal fecha nas duas vezes

#### Scenario: Modal não dispensável
- **GIVEN** um modal não dispensável aberto
- **WHEN** Esc é pressionado e a camada é tocada
- **THEN** o modal continua aberto

### Requirement: Sobreposição ancorada
O núcleo SHALL mostrar um conteúdo junto de um elemento âncora, no lado preferido (abaixo, acima, início ou fim), alinhado ao início, ao centro ou ao fim da âncora e afastado dela pela distância recebida. Quando o conteúdo não cabe no lado preferido e cabe no oposto, ele MUST ir para o oposto. O conteúdo MUST ficar dentro da área da sobreposição, a pelo menos a margem recebida das bordas. Enquanto aberto, ele MUST acompanhar a âncora quando ela se move por rolagem.

#### Scenario: Posição preferida
- **GIVEN** uma âncora no alto da tela e o lado preferido abaixo, alinhado ao início, com afastamento 4
- **WHEN** a sobreposição é aberta
- **THEN** o topo do conteúdo fica 4 abaixo da base da âncora, e a borda inicial do conteúdo coincide com a da âncora

#### Scenario: Inversão por falta de espaço
- **GIVEN** uma âncora junto à base da tela e o lado preferido abaixo
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

### Requirement: Fechamento automático da sobreposição ancorada
Com o fechamento automático ligado (padrão), a sobreposição ancorada MUST fechar com um toque fora dela e fora da âncora, e com Esc, e MUST avisar quem a controla. Um toque na âncora MUST NOT ser tratado como toque fora. Ao abrir com foco, o foco MUST ir para o conteúdo e, ao fechar, MUST voltar à âncora.

#### Scenario: Toque fora e Esc
- **GIVEN** uma sobreposição ancorada aberta com fechamento automático
- **WHEN** um ponto fora dela e fora da âncora é tocado e, em outra abertura, Esc é pressionado
- **THEN** ela fecha nas duas vezes, e o aviso de fechamento é recebido

#### Scenario: Toque na âncora
- **GIVEN** uma âncora que alterna a sobreposição a cada ativação
- **WHEN** a âncora é tocada com a sobreposição aberta
- **THEN** a sobreposição fecha uma única vez, sem reabrir

#### Scenario: Foco da âncora restaurado
- **GIVEN** uma âncora com foco que abre a sobreposição com foco no conteúdo
- **WHEN** Esc é pressionado
- **THEN** o foco volta à âncora

### Requirement: Empilhamento
Uma sobreposição aberta de dentro de outra MUST aparecer acima dela. Esc MUST fechar só a sobreposição do topo. Fechar um modal MUST fechar as sobreposições ancoradas abertas dentro dele.

#### Scenario: Popover dentro de modal
- **GIVEN** um modal aberto e, dentro dele, uma sobreposição ancorada aberta
- **WHEN** Esc é pressionado uma vez e depois outra
- **THEN** a primeira vez fecha só a sobreposição ancorada, e a segunda fecha o modal

### Requirement: Testes e documentação das sobreposições
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública MUST ter dartdoc. A galeria SHALL ter uma página "Sobreposições" com um modal dispensável, um modal não dispensável e uma sobreposição ancorada com escolha do lado preferido.

#### Scenario: Página na galeria
- **WHEN** a página "Sobreposições" é aberta, o modal dispensável é aberto e fechado com Esc, e a sobreposição ancorada é aberta e fechada com um toque fora
- **THEN** cada sobreposição aparece e some, e a página volta ao estado inicial

### Requirement: Valores do tema ativo nas sobreposições
Sem valores recebidos, a camada do modal MUST usar o `blockLayer` do tema ativo, e a sobreposição ancorada MUST usar o espaçamento `xs` como afastamento e `s` como margem. Um valor recebido MUST ter precedência sobre o do tema.

#### Scenario: Camada no tema escuro
- **GIVEN** o tema escuro ativo
- **WHEN** um modal é aberto sem cor de camada
- **THEN** a camada tem o `blockLayer` do tema escuro

#### Scenario: Espaçamentos da densidade compacta
- **GIVEN** um tema ativo compacto
- **WHEN** uma sobreposição ancorada abaixo da âncora é aberta sem afastamento
- **THEN** o topo do conteúdo fica abaixo da base da âncora à distância `xs` do espaçamento compacto
