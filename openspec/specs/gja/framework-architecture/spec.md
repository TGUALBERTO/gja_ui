# gja/framework-architecture Specification

## Purpose

Define a arquitetura do framework de UI corporativa GJA: camadas, limites entre módulos, direção de dependências, compatibilidade de SDK e regras que permitem consumi-lo de forma consistente em várias aplicações Flutter.

## Requirements

### Requirement: Camadas do framework
O framework SHALL ser organizado nas camadas `foundation` (design tokens, tema, breakpoints e convenções de acessibilidade), `core` (comportamentos compartilhados e infraestrutura), `widgets` (componentes públicos) e um ponto de entrada agregador. Cada camada MUST ser publicada como uma unidade independente de dependência.

#### Scenario: Aplicação consome apenas o ponto de entrada agregador
- **GIVEN** uma aplicação Flutter que declara somente a dependência do pacote agregador
- **WHEN** a aplicação importa a biblioteca pública do framework
- **THEN** todos os widgets, temas e tokens públicos ficam disponíveis sem imports adicionais de camadas internas

#### Scenario: Fundamentos utilizáveis isoladamente
- **GIVEN** uma aplicação que precisa apenas dos design tokens
- **WHEN** ela declara somente a dependência da camada `foundation`
- **THEN** a resolução de dependências não inclui as camadas `core` nem `widgets`

### Requirement: Direção única de dependências
As dependências entre camadas MUST seguir a direção `foundation` ← `core` ← `widgets` ← agregador. Uma camada MUST NOT depender de camada posterior, e MUST NOT existir dependência circular entre pacotes nem entre bibliotecas internas de um pacote.

#### Scenario: Import proibido é detectado
- **GIVEN** um arquivo da camada `foundation` que importa uma biblioteca da camada `widgets`
- **WHEN** a verificação de arquitetura é executada na integração contínua
- **THEN** a verificação falha e identifica o arquivo e o import proibido

#### Scenario: Ciclo entre pacotes é rejeitado
- **WHEN** uma alteração introduz uma dependência que forma um ciclo entre pacotes do framework
- **THEN** a resolução de dependências ou a verificação de arquitetura falha antes do merge

### Requirement: API pública independente de Material e Cupertino
Nenhum tipo exportado pelo framework (parâmetro, retorno, classe base ou typedef público) SHALL pertencer às bibliotecas `material` ou `cupertino` do Flutter. Os widgets MUST funcionar em uma árvore sem `MaterialApp`, `CupertinoApp`, `Theme` ou `Material` como ancestrais.

#### Scenario: Widget renderizado sem ancestrais Material
- **GIVEN** uma árvore de widgets criada apenas com `GjaApp`
- **WHEN** qualquer widget público do framework é renderizado nela
- **THEN** a renderização ocorre sem exceções nem asserts relacionados a ancestrais Material ou Cupertino

#### Scenario: Superfície pública auditada
- **WHEN** a verificação de API pública inspeciona as bibliotecas exportadas
- **THEN** nenhum símbolo exportado referencia tipos definidos em `package:flutter/material.dart` ou `package:flutter/cupertino.dart`

### Requirement: Uso interno excepcional de Material ou Cupertino
O uso interno de Material ou Cupertino SHALL ocorrer somente quando registrado em decisão arquitetural aprovada, com justificativa e plano de remoção, e MUST NOT exigir que a aplicação consumidora forneça ancestrais dessas bibliotecas.

#### Scenario: Uso interno sem registro
- **GIVEN** um arquivo de implementação que importa `package:flutter/material.dart`
- **WHEN** não existe decisão arquitetural registrada que o autorize
- **THEN** a verificação de arquitetura falha e indica o arquivo

### Requirement: Uso dos mecanismos nativos do Flutter
O framework SHALL usar os mecanismos nativos do Flutter para composição, layout, renderização, semântica, foco, atalhos de teclado, overlays e localização. Um mecanismo próprio de renderização ou de foco MUST NOT ser criado quando o recurso nativo atende ao requisito.

#### Scenario: Componente com necessidade de render object próprio
- **GIVEN** a proposta de um componente que exige um `RenderObject` personalizado
- **WHEN** a change é revisada
- **THEN** o `design.md` da change justifica por que a composição de widgets existentes não atende ao requisito

### Requirement: Aparência centralizada no design system
Os widgets públicos MUST obter cores, tipografia, espaçamentos, raios, elevações, durações de animação e dimensões a partir do tema ativo e dos design tokens. Valores visuais literais SHALL NOT aparecer no código dos widgets.

#### Scenario: Valor de cor literal em widget
- **GIVEN** um arquivo da camada `widgets` que contém um literal de cor ou de espaçamento
- **WHEN** a verificação de tokens é executada
- **THEN** a verificação falha e indica o arquivo e a linha

#### Scenario: Troca de tema altera todos os componentes
- **GIVEN** uma aplicação que exibe vários widgets do framework
- **WHEN** o tema ativo é trocado de claro para escuro
- **THEN** todos os widgets passam a usar os valores do tema escuro sem precisar ser recriados com parâmetros visuais diferentes

### Requirement: Compatibilidade com o SDK das aplicações consumidoras
As restrições de SDK Flutter e Dart do framework SHALL ser definidas a partir da versão verificada do portal existente e MUST NOT exigir versão superior à usada pelo portal sem aprovação explícita.

#### Scenario: Restrição de SDK compatível com o portal
- **GIVEN** a versão de Flutter e Dart registrada para o portal na Fase 0
- **WHEN** o portal resolve dependências com o framework adicionado
- **THEN** a resolução é concluída sem exigir atualização do SDK do portal

#### Scenario: Recurso de SDK mais novo
- **WHEN** uma change propõe usar um recurso disponível apenas em versão de SDK superior à do portal
- **THEN** a change é bloqueada até que exista aprovação explícita para elevar a versão mínima

### Requirement: Consumo por múltiplas aplicações
O framework MUST NOT depender de código, rotas, serviços, estado global ou configuração de uma aplicação específica. A integração com sistemas corporativos SHALL ocorrer por contratos abstratos que a aplicação consumidora implementa.

#### Scenario: Duas aplicações com temas diferentes
- **GIVEN** duas aplicações Flutter que dependem da mesma versão do framework
- **WHEN** cada uma configura uma identidade visual diferente pelo tema centralizado
- **THEN** ambas funcionam com suas identidades sem alterar o código do framework

### Requirement: Independência de gerenciador de estado
A API pública SHALL NOT exigir uma biblioteca específica de gerenciamento de estado. Componentes com estado MUST suportar uso controlado (valor e callback fornecidos pela aplicação) e, quando aplicável, uso por controlador público.

#### Scenario: Uso controlado
- **GIVEN** um componente de entrada recebendo `value` e `onChanged` da aplicação
- **WHEN** o usuário altera o valor
- **THEN** o componente notifica `onChanged` e exibe o valor recebido no próximo build, sem manter cópia divergente

### Requirement: Versionamento semântico e depreciação
O framework SHALL seguir versionamento semântico com changelog por pacote. Uma mudança incompatível na API pública MUST ser precedida de uma versão com o símbolo marcado como `@Deprecated` e instrução de migração, exceto durante a série `0.x`, em que a quebra MUST ser registrada no changelog.

#### Scenario: Remoção de parâmetro público
- **GIVEN** a versão `1.x` do framework com o parâmetro público `p`
- **WHEN** uma change propõe remover `p`
- **THEN** existe uma versão menor anterior em que `p` está marcado como depreciado com mensagem de migração, e a remoção ocorre somente em versão maior

### Requirement: Isolamento do portal de produção
Changes do framework MUST NOT modificar o código, a configuração ou o pipeline do portal existente. A adoção pelo portal SHALL ocorrer em change dedicada com aprovação explícita.

#### Scenario: Change do framework sem impacto no portal
- **WHEN** qualquer change do framework é aplicada
- **THEN** nenhum arquivo do repositório do portal é alterado

### Requirement: Aplicação de demonstração
O repositório SHALL conter uma aplicação de demonstração (galeria) que apresenta cada widget implementado em seus estados documentados, nos temas claro e escuro e nas densidades suportadas.

#### Scenario: Widget novo aparece na galeria
- **GIVEN** uma change que implementa um widget público
- **WHEN** a change é concluída
- **THEN** a galeria contém uma página do widget com os exemplos mínimos exigidos por sua spec

### Requirement: Convenções de nomenclatura e de eventos da API pública
Tipos públicos MUST usar o prefixo `GJA`. Callbacks SHALL seguir o padrão `on<Evento>`, com o nome do evento do SAPUI5 (`onPress`, `onChange`, `onSelectionChange`). O componente desabilitado SHALL ser `enabled: false`, como no SAPUI5; um callback nulo MUST significar só que não há ação. Variantes visuais SHALL ser enums e configuração visual SHALL vir do tema, não de parâmetros soltos.

#### Scenario: Botão desabilitado por enabled
- **GIVEN** um `GjaButton` criado com `enabled: false` e um `onPress`
- **WHEN** o usuário toca, clica ou pressiona Enter sobre ele
- **THEN** `onPress` não é chamado e o botão é exposto como desabilitado à semântica de acessibilidade

#### Scenario: Revisão de API inconsistente
- **WHEN** uma change propõe um callback público chamado `pressHandler`
- **THEN** a revisão exige renomeá-lo para seguir o padrão `on<Evento>`

### Requirement: Estado semântico de valor
Componentes de entrada e de status SHALL usar um único conjunto de estados semânticos compartilhado — `none`, `success`, `warning`, `error` e `information` — definido nos fundamentos e com mensagem associada opcional.

#### Scenario: Campo com erro
- **GIVEN** um campo de entrada com estado semântico `error` e mensagem "Obrigatório"
- **WHEN** o campo é renderizado
- **THEN** ele usa as cores de erro do tema e a mensagem é anunciada pelo leitor de tela junto com o rótulo

### Requirement: Densidade de conteúdo
O framework SHALL suportar as densidades de conteúdo do Fiori `cozy` (alvo de toque) e `compact` (alvo de ponteiro), selecionadas pelo tema ou por subárvore, e todos os widgets interativos MUST ajustar dimensões apenas via tokens de densidade.

#### Scenario: Subárvore compacta
- **GIVEN** uma tabela envolvida por configuração de densidade `compact` em uma aplicação `cozy`
- **WHEN** a tela é renderizada
- **THEN** apenas os widgets da subárvore usam as dimensões compactas
