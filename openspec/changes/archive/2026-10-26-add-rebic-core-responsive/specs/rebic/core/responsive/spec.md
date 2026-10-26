## Purpose

Define a responsividade do núcleo do Rebic: a classe de tamanho da tela e do espaço disponível de um widget, os valores por classe com herança da classe menor e a densidade recomendada por plataforma, aplicando os limiares de `rebic/foundation/breakpoints` e os modos de `rebic/foundation/density`.

## ADDED Requirements

### Requirement: Classe de tamanho da tela
O núcleo SHALL informar a classe de tamanho da tela, classificando a largura da janela com os limiares recebidos (o mapeamento de referência por padrão). O núcleo SHALL fornecer um escopo que publica essa classe à subárvore. Sob o escopo, quem lê a classe MUST ser reconstruído quando ela muda, e MUST NOT ser reconstruído por mudanças que não a alteram. Sem o escopo, a leitura MUST retornar a mesma classe.

#### Scenario: Largura da janela
- **GIVEN** uma janela de 800 de largura
- **WHEN** a classe da tela é lida e a janela passa a 1200 de largura
- **THEN** a classe lida é `medium` e depois `large`, com e sem o escopo

#### Scenario: Mudança que não troca a classe
- **GIVEN** um widget sob o escopo que lê a classe da tela, em uma janela de 800 por 600
- **WHEN** a janela passa a 900 por 600 e depois a 900 por 400
- **THEN** o widget não é reconstruído

#### Scenario: Limiares recebidos
- **GIVEN** limiares com `medium` = 480 e uma janela de 500 de largura
- **WHEN** a classe da tela é lida com esses limiares
- **THEN** ela é `medium`

### Requirement: Classe de tamanho do contêiner
O núcleo SHALL fornecer um construtor que entrega ao conteúdo a classe de tamanho da largura máxima disponível para ele, e não a da janela. Largura sem limite MUST resultar em `extraLarge`, como na classificação dos fundamentos.

#### Scenario: Contêiner menor que a tela
- **GIVEN** uma janela de 1500 de largura e um painel de 500 de largura
- **WHEN** o construtor é usado dentro do painel
- **THEN** a classe entregue é `small`, enquanto a classe da tela é `extraLarge`

#### Scenario: Largura sem limite
- **WHEN** o construtor está em um eixo horizontal sem limite de largura, como uma lista com rolagem horizontal
- **THEN** a classe entregue é `extraLarge`

### Requirement: Valores por classe de tamanho
O núcleo SHALL fornecer um valor responsivo com um valor obrigatório para `small` e valores opcionais para `medium`, `large` e `extraLarge`. Para uma classe sem valor próprio, o valor MUST ser o da maior classe menor que tenha valor. O valor responsivo MUST ter igualdade por valor.

#### Scenario: Herança da classe menor
- **GIVEN** um valor responsivo com `small` = 12 e `large` = 4
- **WHEN** ele é resolvido para `small`, `medium`, `large` e `extraLarge`
- **THEN** os resultados são 12, 12, 4 e 4

#### Scenario: Resolução pela tela e pelo contêiner
- **GIVEN** um valor responsivo com `small` = 1 e `medium` = 2
- **WHEN** ele é resolvido com a classe da tela de uma janela de 800 e com a classe de um painel de 500 na mesma janela
- **THEN** os resultados são 2 e 1

### Requirement: Densidade recomendada
O núcleo SHALL recomendar a densidade inicial pela plataforma: compacta em Windows, macOS e Linux (entrada por ponteiro), e confortável em Android, iOS e Fuchsia (entrada por toque). A recomendação MUST ser só um padrão: a aplicação escolhe a densidade que usa.

#### Scenario: Plataformas
- **WHEN** a densidade recomendada é pedida para cada plataforma
- **THEN** Windows, macOS e Linux recebem `compact`, e Android, iOS e Fuchsia recebem `comfortable`

### Requirement: Testes e documentação da responsividade
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública MUST ter dartdoc. A galeria SHALL ter uma página "Responsividade" que mostra a classe da tela, a classe de um painel mais estreito, um valor responsivo resolvido e a densidade recomendada.

#### Scenario: Página na galeria
- **GIVEN** a janela da galeria com 1200 de largura
- **WHEN** a página "Responsividade" é aberta e a janela passa a 500 de largura
- **THEN** a classe da tela exibida passa de `large` para `small`
