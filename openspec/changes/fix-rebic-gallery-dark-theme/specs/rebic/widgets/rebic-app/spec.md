## MODIFIED Requirements

### Requirement: [Documentação] Exemplos mínimos
`RebicApp` SHALL ter dartdoc em toda API pública, com um exemplo de aplicação mínima. A galeria SHALL usar `RebicApp` como raiz e permitir escolher o modo de tema (sistema, claro, escuro) e a densidade no índice. Toda página da galeria MUST seguir o tema e a densidade escolhidos; comparações entre modos ou densidades ficam em painéis rotulados.

#### Scenario: Página na galeria
- **WHEN** a galeria é aberta e o modo de tema escuro é escolhido no índice
- **THEN** o fundo da galeria passa a ser o `background` do tema escuro

#### Scenario: Páginas da galeria no tema escuro
- **GIVEN** a galeria com o modo de tema escuro escolhido no índice
- **WHEN** cada página da galeria é aberta
- **THEN** o fundo e o texto da página são os do tema escuro, fora dos painéis de comparação
