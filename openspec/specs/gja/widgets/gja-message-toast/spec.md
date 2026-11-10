# gja/widgets/gja-message-toast Specification

## Purpose

`GjaMessageToast` mostra uma confirmação curta que some sozinha, como o `sap.m.MessageToast` do SAPUI5: uma caixa escura com o texto, centralizada na parte de baixo da tela, que não recebe foco nem toques e é anunciada pelo leitor de tela.

## Requirements

### Requirement: [API] Propriedades
`GjaMessageToast.show(context, message, {duration})` SHALL mostrar `message` sobre a tela, como o `MessageToast.show` do UI5. `duration` SHALL ter o padrão de 3 segundos, o `duration` padrão do UI5.

#### Scenario: Aviso mínimo
- **GIVEN** uma tela de 800 por 600
- **WHEN** `GjaMessageToast.show(context, 'Pedido salvo')` é chamado
- **THEN** o texto "Pedido salvo" aparece centralizado na horizontal, perto da borda de baixo

### Requirement: [API] Callbacks e controlador
`GjaMessageToast` SHALL NOT ter callbacks nem controlador: o aviso some sozinho. `message` MUST NOT ser vazio, ou `show` MUST falhar em modo debug.

#### Scenario: Aviso vazio
- **WHEN** `GjaMessageToast.show` é chamado com `message` vazio
- **THEN** a chamada falha em modo debug

### Requirement: [Comportamento] Duração e substituição
O aviso SHALL aparecer e sumir com um esmaecimento de `motion.medium` (imediato com movimento reduzido) e sumir depois de `duration`. Um novo `show` MUST substituir o aviso visível.

#### Scenario: Aviso some sozinho
- **GIVEN** um aviso mostrado com a duração padrão
- **WHEN** o tempo avança 3 segundos e o esmaecimento
- **THEN** o aviso não está mais na tela

#### Scenario: Novo aviso substitui
- **GIVEN** o aviso "Primeiro" visível
- **WHEN** `show` é chamado com "Segundo"
- **THEN** só "Segundo" aparece

### Requirement: [Aparência] Tokens de componente
A caixa SHALL usar o fundo `colors.text`, o texto `typography.base` com `colors.contrastText`, o raio `radius.element`, o espaço interno `spacing.l` e a largura máxima de 5 passos `spacing.xxxl`, a `spacing.xxxl` da borda de baixo. Nenhum valor MUST ser literal.

#### Scenario: Cores do aviso
- **WHEN** um aviso é mostrado no tema claro
- **THEN** o fundo é `colors.text`, o texto `colors.contrastText`, e a caixa mede no máximo 5 × `spacing.xxxl` de largura

### Requirement: [Estados] Sem interação
O aviso SHALL NOT receber o foco nem toques: os toques passam para o conteúdo abaixo, como no UI5.

#### Scenario: Toque passa pelo aviso
- **GIVEN** um botão sob o aviso visível
- **WHEN** o ponto do aviso é tocado
- **THEN** a ação do botão é chamada, e o foco não vai ao aviso

### Requirement: [Acessibilidade] Semântica e contraste
O aviso SHALL ser exposto como região viva com o texto da mensagem. O texto MUST ter o contraste de texto sobre o fundo, nos temas claro e escuro.

#### Scenario: Semântica do aviso
- **WHEN** a árvore de semântica é lida com um aviso "Pedido salvo" visível
- **THEN** há um nó "Pedido salvo" marcado como região viva

#### Scenario: Contraste do aviso
- **WHEN** a diretriz de contraste de texto é aplicada a um aviso nos temas claro e escuro
- **THEN** é atendida

### Requirement: [Responsividade] Largura
Mensagens longas SHALL quebrar em várias linhas dentro da largura máxima; numa tela mais estreita, a caixa MUST caber na largura da tela menos `spacing.l` de cada lado.

#### Scenario: Aviso em tela estreita
- **GIVEN** uma tela de 200 de largura
- **WHEN** um aviso longo é mostrado
- **THEN** a caixa mede no máximo 200 − 2 × `spacing.l`, e não há estouro

### Requirement: [Integração] Dependências
`GjaMessageToast` SHALL depender somente de `gja/foundation/color`, `gja/foundation/typography`, `gja/foundation/spacing`, `gja/foundation/radius`, `gja/foundation/design-tokens`, `gja/foundation/theming` e `gja/foundation/accessibility`, e do `Overlay` do Flutter.

#### Scenario: Aviso sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um aviso é mostrado e some
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaMessageToast` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `gja/foundation/accessibility`.

#### Scenario: Rastreabilidade do aviso
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do aviso
- **WHEN** os goldens de um aviso curto e de um longo são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaMessageToast` SHALL ter dartdoc em toda API pública e uma página "GjaMessageToast" na galeria com um botão que mostra um aviso.

#### Scenario: Página GjaMessageToast na galeria
- **GIVEN** a página "GjaMessageToast" aberta na galeria
- **WHEN** o botão "Salvar" é tocado
- **THEN** o aviso "Pedido salvo" aparece

### Requirement: [Restrições] Fora do escopo
`GjaMessageToast` SHALL NOT aceitar cores ou larguras literais, nem posição (`my`, `at`, `offset`), `autoClose` desligado, ação ou empilhamento de avisos.

#### Scenario: Aviso sem valor literal
- **WHEN** a API pública de `GjaMessageToast` é inspecionada
- **THEN** `show` não tem parâmetro do tipo `double` ou `Color`
