## MODIFIED Requirements

### Requirement: Movimento reduzido
O fundamento SHALL definir o modo de animação com `full`, `basic`, `minimal` e `none`, como `sap.ui.core.AnimationMode`. O movimento é reduzido quando o modo efetivo é `minimal` ou `none`, e então todas as durações de movimento MUST ser resolvidas como zero, mantendo as curvas. Com `full` ou `basic`, os tokens MUST ser usados sem alteração. Com animações desligadas na plataforma, o modo efetivo MUST ser `none`.

#### Scenario: Animações desativadas
- **WHEN** os tokens de movimento de referência são resolvidos com o modo `minimal` e com o modo `none`
- **THEN** nos dois casos `instant`, `short`, `medium` e `long` valem zero, e as curvas são as originais

#### Scenario: Animações ativas
- **WHEN** os tokens são resolvidos com o modo `full` e com o modo `basic`
- **THEN** nos dois casos o resultado é igual aos tokens de entrada

#### Scenario: Modo efetivo
- **WHEN** o modo efetivo é calculado para cada modo pedido, com e sem animações desligadas na plataforma
- **THEN** sem o pedido da plataforma ele é o modo pedido, e com o pedido ele é `none`

### Requirement: Testes e documentação da acessibilidade
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível. A galeria SHALL ter uma página "Acessibilidade" com os limites, uma demonstração do movimento em cada modo de animação e uma amostra de texto que acompanha a escala do sistema.

#### Scenario: Página na galeria
- **WHEN** a página "Acessibilidade" é aberta
- **THEN** ela exibe a meta WCAG 2.2 AA, os limites de contraste, escala e alvo, e as durações de movimento nos modos `full`, `basic`, `minimal` e `none`
