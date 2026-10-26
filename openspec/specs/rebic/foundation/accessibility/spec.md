# rebic/foundation/accessibility Specification

## Purpose

Define as convenções de acessibilidade do Rebic: a meta WCAG 2.2 AA, os limites de contraste, escala de texto e alvo de interação, o movimento reduzido, a semântica exigida dos widgets e a bateria mínima de testes. Reúne e referencia `rebic/foundation/color`, `rebic/foundation/typography` e `rebic/foundation/density`, sem duplicar valores.

## Requirements

### Requirement: Meta de conformidade
O framework SHALL ter como meta o WCAG 2.2 nível AA para todos os widgets públicos. A API de convenções MUST expor a meta e os limites derivados dela: contraste de texto 4,5, contraste não textual 3, escala de texto suportada 2,0 e alvo mínimo de interação de 24 px lógicos.

#### Scenario: Limites declarados
- **WHEN** a API de convenções é inspecionada
- **THEN** ela informa WCAG 2.2 AA e os limites 4,5, 3, 2,0 e 24

### Requirement: Contraste pelos papéis de cor
Os widgets MUST pintar texto e elementos não textuais somente com pares de papéis de cor de contraste garantido. Os mínimos de contraste da API de convenções MUST ser os mesmos valores usados pela verificação de contraste do fundamento de cor, sem cópia independente.

#### Scenario: Mesmos mínimos do fundamento de cor
- **WHEN** os mínimos de contraste da API de convenções são comparados com os da verificação de contraste de cor
- **THEN** eles são iguais, e os mapeamentos de cor de referência passam nessa verificação

### Requirement: Escala de texto
Os widgets MUST respeitar a escala de texto do sistema e MUST NOT limitá-la abaixo de 2,0. Com escala 2,0, eles MUST ser renderizados sem estouro de layout, quebrando linhas ou crescendo em altura conforme a tipografia.

#### Scenario: Conteúdo em 200%
- **GIVEN** a página "Acessibilidade" da galeria com escala de texto 2,0
- **WHEN** a página é renderizada em uma janela de 400 px de largura
- **THEN** não há erro de estouro de layout, e a amostra de texto usa o tamanho do estilo multiplicado por 2

### Requirement: Alvo mínimo de interação por densidade
A área de interação de cada widget interativo MUST ter, em largura e altura, pelo menos o alvo mínimo da densidade ativa. A API de convenções SHALL fornecer esse valor a partir do conjunto de densidade.

#### Scenario: Alvo por densidade
- **WHEN** o alvo mínimo é pedido para os mapeamentos de densidade de referência
- **THEN** o confortável retorna 48 e o compacto, 24

### Requirement: Movimento reduzido
Quando a plataforma pede redução de animações, todas as durações de movimento MUST ser resolvidas como zero, mantendo as curvas. Sem esse pedido, os tokens de movimento MUST ser usados sem alteração.

#### Scenario: Animações desativadas
- **WHEN** os tokens de movimento de referência são resolvidos com redução de animações
- **THEN** `instant`, `short`, `medium` e `long` valem zero, e as curvas são as originais

#### Scenario: Animações ativas
- **WHEN** os tokens são resolvidos sem redução de animações
- **THEN** o resultado é igual aos tokens de entrada

### Requirement: Semântica dos widgets interativos
Todo widget interativo MUST expor ao leitor de tela rótulo, papel, estado (habilitado, selecionado, marcado, expandido, conforme o caso) e valor, quando houver. Ícones decorativos MUST ficar fora da árvore semântica. Um erro de estado de valor MUST ser anunciado junto com o rótulo do campo.

#### Scenario: Convenção no template de spec
- **WHEN** o template de spec de widget é inspecionado
- **THEN** o requisito de acessibilidade exige rótulo, papel, estado e valor, e o requisito de testes lista a bateria mínima de acessibilidade

### Requirement: Bateria mínima de testes de acessibilidade
Cada widget interativo MUST ter testes que apliquem `textContrastGuideline`, `labeledTapTargetGuideline` e uma diretriz de alvo mínimo com o tamanho da densidade (nas duas densidades), além de render com escala de texto 2,0 sem estouro, verificação de semântica e operação por teclado.

#### Scenario: Diretriz de alvo pela densidade
- **GIVEN** uma superfície tocável de 48 × 48 px com rótulo semântico
- **WHEN** a diretriz de alvo mínimo é aplicada com o alvo de cada densidade de referência
- **THEN** ela passa nas duas densidades, e uma superfície de 20 × 20 px falha nas duas

### Requirement: Testes e documentação da acessibilidade
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível. A galeria SHALL ter uma página "Acessibilidade" com os limites, uma demonstração do movimento reduzido e uma amostra de texto que acompanha a escala do sistema.

#### Scenario: Página na galeria
- **WHEN** a página "Acessibilidade" é aberta
- **THEN** ela exibe a meta WCAG 2.2 AA, os limites de contraste, escala e alvo, e as durações de movimento com e sem redução de animações
