# rebic/spec-governance Specification

## Purpose

Define como o framework Rebic é especificado no OpenSpec: uma spec independente por widget público e por fundamento compartilhado, estrutura obrigatória, nomenclatura, dependências explícitas e granularidade das changes.

## Requirements

### Requirement: Uma spec por widget público
Cada widget público do framework SHALL possuir exatamente uma spec própria no caminho `rebic/widgets/<nome-do-widget-em-kebab-case>` (por exemplo, `RebicButton` em `rebic/widgets/rebic-button`). Uma spec MUST NOT conter requisitos de mais de um widget público.

#### Scenario: Widget com spec própria
- **GIVEN** o widget público `RebicButton`
- **WHEN** a lista de specs do projeto é consultada
- **THEN** existe a spec `rebic/widgets/rebic-button` e nenhuma outra spec define requisitos de `RebicButton`

#### Scenario: Spec agrupando widgets é rejeitada
- **WHEN** uma change propõe uma spec que define requisitos para `RebicCheckbox` e `RebicSwitch`
- **THEN** a revisão rejeita a change e exige uma spec separada para cada widget

### Requirement: Specs próprias para fundamentos e núcleo
Cada fundamento compartilhado SHALL ter spec própria em `rebic/foundation/<fundamento>`, e cada infraestrutura compartilhada do núcleo SHALL ter spec própria em `rebic/core/<infraestrutura>`. Os fundamentos obrigatórios são: design-tokens, color, typography, spacing, radius, shadows, iconography, theming, density, interaction-states, breakpoints e accessibility.

#### Scenario: Fundamento especificado antes do consumidor
- **GIVEN** um widget que consome tokens de tipografia
- **WHEN** a change do widget é proposta
- **THEN** a spec `rebic/foundation/typography` já existe em `openspec/specs/` ou está incluída em change aplicada anteriormente

### Requirement: Mapeamento das seções obrigatórias
Toda spec de widget MUST cobrir as 12 seções obrigatórias: Objetivo e escopo no `## Purpose`; API pública, Comportamento, Aparência, Estados, Acessibilidade, Responsividade, Integração, Testes, Documentação e Restrições como requisitos prefixados pela etiqueta da seção; Critérios de aceitação como cenários.

#### Scenario: Spec completa
- **GIVEN** uma spec de widget
- **WHEN** a verificação de conformidade de specs é executada
- **THEN** a spec possui `## Purpose` e ao menos um requisito com cada etiqueta: `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade]`, `[Responsividade]`, `[Integração]`, `[Testes]`, `[Documentação]` e `[Restrições]`

#### Scenario: Seção ausente
- **GIVEN** uma spec de widget sem requisito com a etiqueta `[Acessibilidade]`
- **WHEN** a verificação de conformidade de specs é executada
- **THEN** a verificação falha e indica a spec e a etiqueta ausente

### Requirement: Aspectos não aplicáveis declarados explicitamente
Quando uma seção não se aplica ao widget, a spec MUST conter um requisito com a etiqueta da seção que declare a decisão de forma verificável (por exemplo, "SHALL NOT receber foco"), com cenário próprio. Omitir silenciosamente a seção MUST NOT ser aceito.

#### Scenario: Widget sem foco
- **GIVEN** a spec de `RebicDivider`
- **WHEN** a seção de acessibilidade é lida
- **THEN** existe um requisito `[Acessibilidade]` declarando que o divisor não recebe foco e é ignorado por leitores de tela, com cenário verificável

### Requirement: Formato verificável dos requisitos e cenários
Os requisitos SHALL usar SHALL/MUST, ter descrição de até 500 caracteres e ao menos um cenário `#### Scenario:` no formato GIVEN (opcional), WHEN e THEN. Toda change MUST passar em `openspec validate --strict` antes da revisão.

#### Scenario: Validação estrita
- **WHEN** uma change de widget é submetida para revisão
- **THEN** `openspec validate <change> --strict` termina sem erros nem avisos

### Requirement: Rastreabilidade entre cenários e testes
Cada cenário de uma spec de widget MUST corresponder a pelo menos um teste automatizado ou, quando a automação não for viável, a uma verificação manual documentada. O teste SHALL referenciar o nome do requisito e do cenário.

#### Scenario: Cenário sem teste
- **GIVEN** uma change de implementação de widget concluída
- **WHEN** a revisão compara os cenários da spec com os testes
- **THEN** cada cenário tem um teste identificado pelo nome do requisito e do cenário ou uma verificação manual registrada nas tarefas

### Requirement: Dependências explícitas entre specs
A spec de um widget MUST listar, em requisito `[Integração]`, os caminhos das specs de fundamentos, núcleo e outros widgets de que depende. Requisitos de outra spec MUST NOT ser copiados: a spec dependente SHALL referenciá-los pelo caminho e nome do requisito.

#### Scenario: Dependência declarada
- **GIVEN** a spec de `RebicSelect`, que usa `RebicDropdown`
- **WHEN** a seção de integração é lida
- **THEN** ela referencia `rebic/widgets/rebic-dropdown` e não repete os requisitos de posicionamento do dropdown

#### Scenario: Dependência não especificada
- **WHEN** uma spec referencia um caminho de spec que não existe em `openspec/specs/` nem em change aplicada anteriormente
- **THEN** a verificação de conformidade falha e indica a referência inexistente

### Requirement: Grafo de dependências acíclico
As dependências declaradas entre specs de widgets MUST formar um grafo acíclico. Um widget MUST NOT ser implementado antes de todas as specs das quais depende estarem arquivadas em `openspec/specs/` ou incluídas na mesma change.

#### Scenario: Ciclo entre widgets
- **WHEN** a spec de `RebicMenu` depende de `RebicDropdown` e uma change propõe que `RebicDropdown` dependa de `RebicMenu`
- **THEN** a verificação de conformidade rejeita a change por introduzir um ciclo

### Requirement: Nomenclatura de changes
Os nomes de changes SHALL seguir os padrões `add-rebic-<widget>`, `add-rebic-foundation-<fundamento>`, `add-rebic-core-<infraestrutura>`, `update-rebic-<item>-<assunto>` e `remove-rebic-<item>`, em kebab-case, usando o mesmo identificador do caminho da spec.

#### Scenario: Change de novo widget
- **WHEN** a spec de `RebicTextField` é proposta
- **THEN** a change se chama `add-rebic-text-field` e cria `specs/rebic/widgets/rebic-text-field/spec.md`

### Requirement: Granularidade das changes
Cada change SHALL introduzir ou modificar no máximo um widget público. Uma change MAY incluir até três specs somente quando os widgets formam uma unidade inseparável declarada na proposta (por exemplo, `RebicForm` e `RebicFormField`), mantendo uma spec por widget.

#### Scenario: Par inseparável
- **GIVEN** a change `add-rebic-form` que inclui `RebicForm` e `RebicFormField`
- **WHEN** a change é revisada
- **THEN** a proposta justifica a inseparabilidade e a change contém duas specs distintas

#### Scenario: Change com widgets independentes
- **WHEN** uma change inclui as specs de `RebicBadge` e `RebicAvatar`
- **THEN** a revisão exige dividi-la em duas changes

### Requirement: Catálogo de componentes
O repositório SHALL manter um catálogo com, para cada widget, fundamento e infraestrutura: nome, categoria, prioridade (P0 a P3), fase, situação, caminho da spec e dependências. Toda change que cria, altera ou remove um item MUST atualizar o catálogo.

#### Scenario: Catálogo coerente com as specs
- **WHEN** a verificação de conformidade compara o catálogo com `openspec/specs/rebic/`
- **THEN** todo item marcado como especificado possui spec no caminho informado e toda spec existente aparece no catálogo

### Requirement: Prioridade e ordem de implementação
Os itens do catálogo SHALL ser priorizados em P0 (núcleo mínimo), P1 (essenciais), P2 (dados) e P3 (avançados). Um item MUST NOT ter prioridade mais urgente que qualquer item do qual dependa.

#### Scenario: Prioridade incoerente
- **GIVEN** `RebicSelect` com prioridade P1 e dependência de `RebicDropdown`
- **WHEN** `RebicDropdown` está classificado como P2
- **THEN** a verificação de conformidade aponta a inconsistência de prioridade
