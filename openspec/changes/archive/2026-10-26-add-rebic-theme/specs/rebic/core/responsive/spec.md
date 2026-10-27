## MODIFIED Requirements

### Requirement: Classe de tamanho da tela
O núcleo SHALL informar a classe de tamanho da tela, classificando a largura da janela com os limiares recebidos ou, sem eles, com os do tema ativo de `rebic/foundation/theming`. O núcleo SHALL fornecer um escopo que publica essa classe à subárvore. Sob o escopo, quem lê a classe MUST ser reconstruído quando ela muda, e MUST NOT ser reconstruído por mudanças que não a alteram. Sem o escopo, a leitura MUST retornar a mesma classe.

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

## ADDED Requirements

### Requirement: Limiares do tema ativo
Sem limiares recebidos, o escopo da tela, a leitura da classe da tela e o construtor do contêiner MUST usar os limiares do tema ativo. Limiares recebidos MUST ter precedência sobre os do tema.

#### Scenario: Tema com limiares próprios
- **GIVEN** um tema ativo com `medium` = 480, uma janela de 500 de largura e um painel de 500 de largura
- **WHEN** a classe da tela e a classe do painel são lidas sem limiares recebidos
- **THEN** as duas são `medium`
