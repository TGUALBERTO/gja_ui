# Proposal: Framework de UI corporativa Rebic (Flutter)

## Why

Os sistemas internos da empresa, incluindo o portal existente, não compartilham uma biblioteca de componentes: cada aplicação reimplementa botões, formulários, tabelas e diálogos com aparência, comportamento e acessibilidade divergentes. Precisamos de um framework próprio em Flutter/Dart — inspirado nos conceitos públicos de arquitetura do SAPUI5 e nas diretrizes visuais do SAP Fiori, mas com identidade, implementação e API próprias — e precisamos definir **antes de implementar** a arquitetura e a forma de especificar cada componente, para que o desenvolvimento ocorra em changes pequenos, revisáveis e rastreáveis.

## What Changes

- Estabelece o framework **Rebic** como conjunto de pacotes Dart/Flutter consumível por mais de uma aplicação, com camadas separadas: fundamentos (design tokens e tema), núcleo (comportamentos compartilhados e infraestrutura), widgets e pacote agregador, além de uma aplicação de demonstração.
- Define regras de modularidade: direção única de dependências, ausência de ciclos, nenhuma exposição de tipos Material/Cupertino na API pública e nenhum valor visual codificado diretamente nos widgets.
- Define a regra de **uma spec OpenSpec por widget público** (e por fundamento compartilhado), com estrutura obrigatória de 12 seções, convenção de nomes de specs e changes e referências explícitas entre specs.
- Publica o inventário inicial de 58 widgets (mais 2 adições propostas: `RebicText` e `RebicIcon`), agrupado por categoria, prioridade (P0–P3) e fase, com o grafo de dependências.
- Define o plano em fases (0 a 5). Nesta change **nenhum widget é implementado**: as tarefas cobrem apenas a Fase 0 (descoberta, estrutura do repositório, convenções e automação de conformidade).
- Não altera o portal de produção. A integração com o portal só ocorrerá em changes futuras, com aprovação explícita.

## Capabilities

### New Capabilities

- `rebic/framework-architecture`: limites dos módulos, direção de dependências, compatibilidade de SDK, independência de Material/Cupertino, consumo por múltiplas aplicações e política de versionamento do framework.
- `rebic/spec-governance`: regras para especificar o framework no OpenSpec — uma spec por widget, estrutura obrigatória, nomenclatura de specs e changes, declaração de dependências, catálogo de componentes e granularidade das changes.

As specs de fundamentos (`rebic/foundation/*`), de núcleo (`rebic/core/*`) e de cada widget (`rebic/widgets/rebic-*`) **não** fazem parte desta change. Cada uma será criada em uma change própria, conforme o roteiro descrito em `design.md`.

### Modified Capabilities

Nenhuma. O projeto não possui specs anteriores.

## Impact

- **Repositório**: o diretório do projeto estava vazio. Esta change adiciona apenas a configuração do OpenSpec. A Fase 0 criará a estrutura do workspace de pacotes, a configuração de lint e testes, o template de spec de widget e o catálogo.
- **SDK**: o ambiente local usa Flutter 3.32.6 / Dart 3.8.1. A versão usada pelo portal **ainda não foi verificada**, porque o portal não está neste repositório. As restrições de SDK só serão fixadas após essa verificação (Fase 0).
- **Dependências**: apenas o SDK Flutter (`package:flutter/widgets.dart`) e `flutter_test`/`flutter_lints` para desenvolvimento. Qualquer dependência de terceiros exige registro de decisão.
- **Portal existente**: nenhum impacto nesta change.
- **Propriedade intelectual**: nenhum código, fonte de ícones ou asset proprietário da SAP será usado. Apenas conceitos públicos servem de referência.
