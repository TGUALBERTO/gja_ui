# Design: Framework de UI corporativa Rebic

## Context

- O repositório `projeto-sapmaterial` estava vazio no início desta change. O único conteúdo é a configuração do OpenSpec (schema `spec-driven`, artefatos em pt-BR).
- Ambiente verificado em 2026-10-24: **Flutter 3.32.6 (stable) / Dart 3.8.1**, **OpenSpec 1.14.3**.
- O portal existente **não está neste repositório**. Sua versão de Flutter/Dart, suas plataformas-alvo e suas dependências ainda precisam ser levantadas (Fase 0). Até lá, as decisões abaixo têm um caminho alternativo para SDKs mais antigos.
- A motivação está em `proposal.md` (seção Why). Os requisitos normativos estão em `specs/rebic/framework-architecture` e `specs/rebic/spec-governance`.

### Capacidades do OpenSpec instalado que moldam a estratégia

Verificadas na CLI 1.14.3:

- Uma change do schema `spec-driven` pode conter **várias** specs (`specs/**/spec.md`), e caminhos aninhados como `rebic/widgets/rebic-button` são aceitos.
- Seções `##` fora de `Purpose`/`Requirements` geram aviso em `--strict` e **não são levadas para a spec principal no archive**. Por isso as 12 seções obrigatórias são codificadas como requisitos etiquetados (ver D9), e não como seções livres.
- Cenários com `GIVEN`/`WHEN`/`THEN` em bullets e tabelas no corpo do requisito são aceitos. A descrição do requisito deve ter até 500 caracteres no modo estrito.
- `openspec/config.yaml` aceita `rules` por artefato. Essas regras são entregues ao agente em `openspec instructions specs`, o que permite impor o template de widget sem extensões nem comandos inventados.
- `openspec validate --all --strict` valida todas as specs e changes e pode ser usado na integração contínua.

## Goals / Non-Goals

**Goals:**
- Fixar a arquitetura de pacotes e as regras de dependência antes do primeiro widget.
- Tornar verificáveis por automação as regras de modularidade, tokens e governança de specs, em vez de depender apenas de revisão manual.
- Entregar um roteiro de changes pequenas, ordenadas por dependência, em que cada widget tem a sua própria change e a sua própria spec.

**Non-Goals:**
- Implementar widgets, tokens ou temas nesta change.
- Escrever agora as specs de fundamentos, núcleo ou widgets. Cada uma terá a sua change.
- Definir a identidade visual final (cores de marca, fonte, ícones). Ela será decidida na change `add-rebic-foundation-color` e nas seguintes.
- Integrar o framework ao portal.
- Replicar a API ou o código do SAPUI5. Ele serve apenas como referência conceitual.

## Decisions

### D1. Workspace com pacotes por camada

```
projeto-sapmaterial/
├── pubspec.yaml                 # raiz do workspace (pub workspaces)
├── analysis_options.yaml        # lints compartilhados
├── packages/
│   ├── rebic_foundation/        # tokens, RebicThemeData, breakpoints, densidade, estados semânticos
│   ├── rebic_core/              # interação/foco, overlay, localização, validação, data source, responsivo
│   ├── rebic_widgets/           # widgets públicos (lib/src/<categoria>/<widget>/)
│   └── rebic_ui/                # agregador: só reexporta as camadas
├── apps/
│   └── rebic_gallery/           # aplicação de demonstração
├── tool/
│   └── rebic_checks/            # verificações de arquitetura, tokens, specs e catálogo (Dart CLI)
├── docs/
│   ├── catalog.yaml             # catálogo de componentes (fonte da verdade)
│   └── specs/widget-spec-template.md
└── openspec/
```

Direção das dependências: `rebic_foundation` ← `rebic_core` ← `rebic_widgets` ← `rebic_ui`. A galeria depende só de `rebic_ui`. Ciclos entre pacotes são impossíveis por construção, porque o `pubspec` não aceita dependência de volta. Dentro de cada pacote, a verificação de imports (D7) impede ciclos entre bibliotecas.

- **Por quê:** os limites entre camadas ficam garantidos pelo resolvedor de pacotes, e não por convenção. Uma aplicação pode usar só os tokens (`rebic_foundation`), por exemplo para alinhar telas legadas.
- **Alternativas:** (a) um único pacote com pastas, mais simples mas com limites garantidos só por lint; (b) um pacote por widget, com overhead excessivo de versionamento e publicação para cerca de 60 itens; (c) Melos, que adiciona uma ferramenta externa sem necessidade.
- **Caminho alternativo:** pub workspaces exigem Dart ≥ 3.6. Se o portal usar um SDK anterior, os pacotes passam a usar dependências `path:` sem `resolution: workspace`, com a mesma estrutura de pastas. As specs não mudam.

### D2. Só `package:flutter/widgets.dart` na API pública

Os widgets são compostos a partir de `widgets.dart` e de `rendering`/`services`/`semantics` quando necessário. Material e Cupertino não podem aparecer em nenhum tipo exportado.

Exceções internas exigem registro de decisão (ADR em `docs/adr/`). Os pontos de atenção conhecidos são os controles de seleção de texto em `RebicTextField`/`RebicTextArea`. Para eles, a preferência é usar `EditableText` com `TextSelectionControls` próprios, e o uso de controles do pacote `material` só pode ocorrer se não exigir ancestral `Material`/`MaterialLocalizations`.

- **Alternativa:** construir sobre Material com tema customizado. Foi rejeitada porque acopla a API e a aparência às decisões do Material e contraria o princípio 1 da solicitação.

### D3. Design tokens em três níveis

1. **Primitivos:** escala de cores, escala tipográfica, escala de espaçamento, raios, sombras e durações. São valores brutos e não são usados diretamente pelos widgets.
2. **Semânticos:** papéis como `surface`, `onSurface`, `primary`, `border`, `focus`, os estados de valor (`success`, `warning`, `error`, `information`) e `textBody`/`textTitle`. Cada tema mapeia os primitivos para esses papéis.
3. **De componente:** derivados dos semânticos (por exemplo, `button.emphasized.background`) e agrupados por widget dentro de `RebicThemeData`.

Os widgets leem apenas os níveis 2 e 3. A personalização da identidade visual (princípio 4) acontece pela troca dos primitivos ou do mapeamento semântico em um único `RebicThemeData`, com `copyWith`, e por extensões tipadas para tokens específicos da aplicação.

- **Por quê:** é o mesmo princípio dos *theming parameters* do Fiori. Uma marca nova muda dezenas de valores, não centenas.
- **Alternativa:** um nível único de tokens. Foi rejeitada porque dificulta o tema escuro e a personalização sem efeitos colaterais.

### D4. Conceitos do SAPUI5/Fiori adotados (reinterpretados)

| Conceito público de referência | Adoção no Rebic |
|---|---|
| Value State (None/Success/Warning/Error/Information) | `RebicValueState` compartilhado por entradas e status |
| Content density (Cozy/Compact) | `RebicDensity.comfortable`/`compact` por tema ou subárvore |
| Button types (Emphasized, Default, Transparent, Accept, Reject, Attention) | Enum de variantes do `RebicButton` |
| Models + data binding | Contrato `RebicDataSource<T>` em `rebic_core` (D6), sem binding por strings |
| Shell bar / Dynamic page | `RebicScaffold` (barra superior + navegação lateral) e `RebicPage` (cabeçalho, conteúdo, rodapé de ações) |
| Responsive grid (L/M/S) | `RebicGrid` com 12 colunas e breakpoints dos fundamentos |
| i18n model | `RebicLocalizations` via `Localizations` do Flutter, com pt-BR como padrão e en |

Nenhum código, fonte (por exemplo, a família "72") ou fonte de ícones da SAP é usado.

### D5. Estado: controlado primeiro, controlador opcional

Os componentes com valor seguem o padrão `value` + `onChanged`. Os componentes complexos (Table, DataGrid, Tree, Tabs, Form) oferecem um controlador público (`ChangeNotifier`) opcional, e o framework não depende de Provider, Riverpod, Bloc ou similares.

- **Por quê:** o framework precisa ser consumível por aplicações com arquiteturas de estado diferentes.

### D6. Integração com dados por contrato

`rebic_core` define `RebicDataSource<T>`: busca paginada com ordenação, filtros e termo de busca, total de itens opcional, cancelamento e estados `loading`/`empty`/`error`. List, Table, DataGrid, Tree, SearchField e MultiSelect consomem esse contrato.

Os adaptadores para backends corporativos (REST, OData) ficam fora do núcleo e serão um pacote opcional na Fase 4. A paginação e a filtragem no servidor são o padrão, e a implementação em memória é fornecida para testes e listas pequenas.

### D7. Conformidade automatizada (`tool/rebic_checks`)

É um CLI em Dart executado localmente e na integração contínua, com quatro verificações:

- **arquitetura:** imports entre camadas, imports de `material`/`cupertino` sem ADR e símbolos exportados que referenciam esses pacotes.
- **tokens:** literais de `Color(`, `EdgeInsets`, `BorderRadius`, `Duration` e números de dimensão em `rebic_widgets/lib`, com uma lista de exceções justificadas.
- **specs:** presença das 10 etiquetas e do `## Purpose` em `rebic/widgets/*`, referências de spec existentes, grafo de dependências acíclico e coerência de prioridade.
- **catálogo:** comparação de `docs/catalog.yaml` com `openspec/specs/rebic/**` e com a pasta de cada widget.

Complementos: `openspec validate --all --strict`, `dart analyze` com `flutter_lints` + `public_member_api_docs`, e `flutter test`.

- **Alternativa:** `custom_lint`/plugins de análise. Foram adiados porque adicionam dependência de terceiros e o feedback no IDE não é essencial nas primeiras fases.

### D8. Estratégia de testes

- **Unitários:** tokens, `RebicThemeData`, validadores, data source e lógica de controladores.
- **De widget:** um `group` por requisito e um `testWidgets` por cenário, com o nome do cenário no título, o que dá a rastreabilidade exigida.
- **Golden:** estados visuais × tema claro/escuro × densidade, executados em um único sistema operacional na integração contínua e com fonte empacotada para evitar variação.
- **Acessibilidade:** `meetsGuideline` (`textContrastGuideline`, `labeledTapTargetGuideline`, `androidTapTargetGuideline`/`iOSTapTargetGuideline` conforme a densidade), `matchesSemantics` e navegação por teclado com `sendKeyEvent`.
- **Integração (Fase 5):** fluxos da galeria com `integration_test` nas plataformas-alvo.

### D9. Formato das specs de widget

As 12 seções obrigatórias são mapeadas no formato nativo do OpenSpec:

| Seção da solicitação | Onde fica na spec |
|---|---|
| 1. Objetivo e escopo | `## Purpose` (1–2 frases) |
| 2. API pública | Requisitos `[API] …`, um por grupo de propriedades, callbacks ou controlador. Tabela de props (nome, tipo, padrão) no corpo, respeitando 500 caracteres. |
| 3. Comportamento funcional | `[Comportamento] …` |
| 4. Aparência | `[Aparência] …`, que cita os tokens de componente usados, sem valores literais |
| 5. Estados | `[Estados] …` (normal, hover, foco, pressionado, desabilitado, carregando, erro, selecionado, conforme o caso) |
| 6. Acessibilidade | `[Acessibilidade] …` |
| 7. Responsividade | `[Responsividade] …` |
| 8. Integração | `[Integração] Dependências`, que lista os caminhos das specs das quais o widget depende |
| 9. Critérios de aceitação | Os cenários `#### Scenario:` de todos os requisitos |
| 10. Testes | `[Testes] …` (tipos de teste exigidos e cobertura de goldens) |
| 11. Documentação | `[Documentação] …` (exemplos mínimos na galeria e no dartdoc) |
| 12. Restrições | `[Restrições] …` (fora do escopo e decisões que não podem ser violadas) |

Um aspecto que não se aplica ao widget deve aparecer como requisito explícito, por exemplo "`[Estados]` SHALL NOT exibir estado hover". O template completo está no Apêndice A e será copiado para `docs/specs/widget-spec-template.md`. As regras correspondentes serão adicionadas a `openspec/config.yaml` em `rules.specs`.

### D10. Uma change por widget

O CLI aceita várias specs por change, mas a regra é **uma change por widget** (`add-rebic-<widget>`). Exceção: até 3 specs quando os widgets são inseparáveis, como `RebicForm` + `RebicFormField`, `RebicList` + `RebicListTile` e `RebicRow` + `RebicColumn`.

Cada change de widget já contém a spec, o design (quando necessário), as tarefas, a implementação, os testes, a página na galeria e a atualização do catálogo. A spec passa a ser a spec principal no archive.

- **Por quê:** revisão pequena, rastreabilidade direta entre spec, change e PR, e archive independente.
- **Alternativa:** escrever todas as specs antes de implementar qualquer widget. Foi rejeitada porque as specs ficariam desatualizadas antes do uso e o lote de revisão seria grande demais.

### D11. Versionamento e distribuição

Versionamento semântico por pacote, com versões sincronizadas na série `0.x` até o fim da Fase 3. A versão `1.0.0` sai ao final da Fase 5. O canal de distribuição (git privado com tag ou servidor pub privado) será decidido na Fase 0 (ver Open Questions). Ele não altera as specs.

## Inventário de componentes

**Legenda:**

- **Prioridade:** P0 = núcleo mínimo · P1 = essenciais · P2 = dados · P3 = avançados.
- **F** = fase.
- **Dependências:** abreviadas. `fnd/*` = `rebic/foundation/*`, `core/*` = `rebic/core/*`, `Rebic*` = `rebic/widgets/rebic-*`.
- Todo widget depende implicitamente de `fnd/theming`, `fnd/accessibility` e `RebicTheme`, o que é omitido nas tabelas.
- ★ = adição proposta, fora da lista original.

### Fundamentos e núcleo (pré-requisitos)

| Spec | Prioridade | F | Dependências |
|---|---|---|---|
| fnd/design-tokens | P0 | 1 | — |
| fnd/color | P0 | 1 | fnd/design-tokens |
| fnd/typography | P0 | 1 | fnd/design-tokens |
| fnd/spacing | P0 | 1 | fnd/design-tokens |
| fnd/radius | P0 | 1 | fnd/design-tokens |
| fnd/elevation | P0 | 1 | fnd/design-tokens, fnd/color |
| fnd/density | P0 | 1 | fnd/spacing, fnd/typography |
| fnd/breakpoints | P0 | 1 | fnd/design-tokens |
| fnd/interaction-states | P0 | 1 | fnd/color, fnd/elevation |
| fnd/iconography | P0 | 1 | fnd/design-tokens |
| fnd/accessibility | P0 | 1 | fnd/color, fnd/typography, fnd/density |
| fnd/theming (claro/escuro, personalização) | P0 | 1 | todos os fnd/* acima |
| core/interaction (foco, hover, pressionado, atalhos, anel de foco) | P0 | 1 | fnd/interaction-states, fnd/accessibility |
| core/localization | P0 | 1 | — |
| core/responsive | P0 | 1 | fnd/breakpoints |
| core/overlay (ancoragem, camadas, dismiss, foco preso) | P0 | 1 | core/interaction |
| core/validation | P1 | 2 | core/localization |
| core/data-source | P2 | 3 | core/localization |

### Fundação e layout

| Widget | Prioridade | F | Dependências |
|---|---|---|---|
| RebicTheme | P0 | 1 | fnd/theming |
| RebicApp | P0 | 1 | RebicTheme, core/localization, core/interaction, core/overlay |
| RebicText ★ | P0 | 1 | fnd/typography |
| RebicIcon ★ | P0 | 1 | fnd/iconography |
| RebicSpacing | P0 | 1 | fnd/spacing, fnd/density |
| RebicContainer | P0 | 1 | fnd/color, fnd/radius, fnd/elevation, fnd/spacing |
| RebicRow | P0 | 1 | RebicSpacing |
| RebicColumn | P0 | 1 | RebicSpacing |
| RebicDivider | P0 | 1 | fnd/color |
| RebicResponsiveLayout (básico; avançado na F4) | P0 | 1 | core/responsive |
| RebicGrid | P0 | 1 | core/responsive, RebicSpacing |
| RebicScaffold | P0 | 1 | RebicApp, RebicResponsiveLayout |
| RebicPage | P0 | 1 | RebicScaffold, RebicText |
| RebicCard | P1 | 2 | RebicContainer, RebicText |

### Ações e navegação

| Widget | Prioridade | F | Dependências |
|---|---|---|---|
| RebicButton | P1 | 2 | core/interaction, RebicText, RebicIcon, RebicProgressIndicator |
| RebicIconButton | P1 | 2 | core/interaction, RebicIcon, RebicTooltip |
| RebicLink | P1 | 2 | core/interaction, RebicText |
| RebicMenu | P1 | 2 | RebicDropdown, RebicIcon |
| RebicToolbar | P1 | 2 | RebicButton, RebicIconButton, RebicMenu (overflow) |
| RebicNavigationBar | P1 | 2 | core/interaction, RebicIcon, RebicText, RebicBadge |
| RebicSideNavigation | P1 | 2 | core/interaction, RebicIcon, RebicText, RebicBadge, RebicScaffold |
| RebicBreadcrumbs | P1 | 2 | RebicLink, RebicMenu (overflow) |
| RebicTabs | P1 | 2 | core/interaction, RebicText, RebicIcon, RebicBadge |
| RebicPagination | P2 | 3 | RebicButton, RebicIconButton, RebicSelect |

### Formulários e entrada de dados

| Widget | Prioridade | F | Dependências |
|---|---|---|---|
| RebicFormField | P1 | 2 | core/validation, RebicText |
| RebicForm | P1 | 2 | core/validation, RebicFormField (change conjunta) |
| RebicTextField | P1 | 2 | core/interaction, RebicFormField, RebicIcon |
| RebicTextArea | P1 | 2 | RebicTextField |
| RebicCheckbox | P1 | 2 | core/interaction, RebicFormField |
| RebicRadioGroup | P1 | 2 | core/interaction, RebicFormField |
| RebicSwitch | P1 | 2 | core/interaction, RebicFormField |
| RebicSelect | P1 | 2 | RebicDropdown, RebicFormField |
| RebicSearchField | P2 | 3 | RebicTextField, RebicDropdown, core/data-source |
| RebicMultiSelect | P2 | 3 | RebicSelect, RebicCheckbox, RebicBadge |
| RebicDatePicker | P3 | 4 | RebicTextField, RebicPopover, core/localization |
| RebicDateRangePicker | P3 | 4 | RebicDatePicker |
| RebicTimePicker | P3 | 4 | RebicTextField, RebicPopover, core/localization |
| RebicFileUpload | P3 | 4 | RebicButton, RebicProgressIndicator, RebicList |

### Exibição de dados

| Widget | Prioridade | F | Dependências |
|---|---|---|---|
| RebicProgressIndicator | P1 | 2 | fnd/color |
| RebicBadge | P1 | 2 | RebicText |
| RebicStatusIndicator | P1 | 2 | RebicIcon, RebicText |
| RebicAvatar | P1 | 2 | RebicIcon, RebicText |
| RebicTooltip | P1 | 2 | core/overlay, RebicText |
| RebicSkeleton | P2 | 3 | fnd/color |
| RebicEmptyState | P2 | 3 | RebicIcon, RebicText, RebicButton |
| RebicErrorState | P2 | 3 | RebicIcon, RebicText, RebicButton |
| RebicListTile | P2 | 3 | core/interaction, RebicText, RebicIcon, RebicAvatar |
| RebicList | P2 | 3 | RebicListTile (change conjunta), core/data-source, RebicEmptyState, RebicSkeleton |
| RebicTable | P2 | 3 | core/data-source, RebicCheckbox, RebicEmptyState, RebicSkeleton, RebicPagination |
| RebicDataGrid | P3 | 4 | RebicTable, RebicTextField, RebicSelect |
| RebicTree | P3 | 4 | RebicListTile, core/data-source |

### Feedback e sobreposições

| Widget | Prioridade | F | Dependências |
|---|---|---|---|
| RebicPopover | P1 | 2 | core/overlay, RebicContainer |
| RebicDropdown | P1 | 2 | RebicPopover |
| RebicDialog | P1 | 2 | core/overlay, RebicButton, RebicText |
| RebicConfirmationDialog | P1 | 2 | RebicDialog |
| RebicAlert | P1 | 2 | RebicStatusIndicator, RebicIconButton |
| RebicSnackbar | P1 | 2 | core/overlay, RebicButton |
| RebicDrawer | P2 | 3 | core/overlay |
| RebicLoadingOverlay | P2 | 3 | core/overlay, RebicProgressIndicator |
| RebicNotification | P3 | 4 | RebicPopover, RebicList, RebicBadge, RebicSnackbar |

O grafo é acíclico e respeita a regra "nenhum item é mais urgente que suas dependências". Isso será verificado automaticamente por `rebic_checks` a partir de `docs/catalog.yaml`.

### Ordem sugerida das changes nas Fases 1–2

```
fnd/design-tokens → color, typography, spacing, radius, breakpoints, iconography
  → elevation, density → interaction-states → accessibility → theming
  → core/interaction, core/localization, core/responsive → core/overlay
  → RebicTheme → RebicApp → RebicText, RebicIcon → RebicSpacing → RebicContainer
  → RebicRow+RebicColumn, RebicDivider → RebicResponsiveLayout → RebicGrid
  → RebicScaffold → RebicPage                                    (fim da Fase 1)
  → RebicProgressIndicator, RebicTooltip → RebicButton, RebicIconButton, RebicLink
  → RebicBadge, RebicStatusIndicator, RebicAvatar, RebicCard
  → RebicPopover → RebicDropdown → RebicMenu
  → core/validation → RebicForm+RebicFormField → RebicTextField → TextArea,
    Checkbox, RadioGroup, Switch, Select
  → RebicDialog → ConfirmationDialog, RebicAlert, RebicSnackbar
  → RebicToolbar, RebicTabs, RebicBreadcrumbs, NavigationBar, SideNavigation (fim da Fase 2)
```

## Plano de fases

| Fase | Entrega | Critério de saída |
|---|---|---|
| 0. Descoberta e arquitetura | Esta change: versão de SDK do portal, workspace, lints, `rebic_checks`, template, catálogo e regras no `config.yaml` | `tasks.md` concluído e `openspec validate --all --strict` e `rebic_checks` passando na integração contínua |
| 1. Fundação | 12 fundamentos, 4 infraestruturas de núcleo e 13 widgets P0 | Galeria com tema claro/escuro e as duas densidades, renderizando layouts responsivos sem Material |
| 2. Essenciais | Widgets P1 e `core/validation` | Formulário completo com validação, diálogos e navegação na galeria, aprovado na auditoria de acessibilidade por widget |
| 3. Dados | `core/data-source` e widgets P2 | Lista e tabela paginadas no servidor com busca, filtro, estados vazio, erro e carregando |
| 4. Avançados | Widgets P3, layout responsivo avançado (colunas flexíveis), personalização de temas (tema de marca), pacote opcional de adaptadores de dados | Segunda aplicação de exemplo com tema próprio consumindo o framework sem alterar seu código |
| 5. Validação | Testes de integração na galeria, auditoria de acessibilidade consolidada, benchmarks (tabela com 10 mil linhas, tempo de build e de frame), verificação de compatibilidade de SDK, piloto no portal **somente com aprovação** | Release `1.0.0` |

Os testes e a documentação **não** ficam para a Fase 5. Cada change de widget entrega os seus. A Fase 5 consolida apenas integração, desempenho e compatibilidade entre componentes.

## Risks / Trade-offs

- [O SDK do portal é anterior a Dart 3.6 e não suporta pub workspaces] → Usar o caminho alternativo de D1 (dependências `path:`), sem efeito nas specs. Restrições de SDK só são fixadas após a tarefa 1.1.
- [Campos de texto sem Material exigem reimplementar seleção, menu de contexto e handles] → Gerar um protótipo (spike) na change `add-rebic-text-field` antes da spec final. Se necessário, abrir uma ADR para uso interno limitado (D2).
- [Volume de cerca de 75 changes gera sobrecarga de processo] → Template, regras no `config.yaml` e `rebic_checks` reduzem o custo por change. Pares inseparáveis podem compartilhar change (D10).
- [Goldens instáveis entre sistemas operacionais] → Executá-los em um único sistema operacional na integração contínua, com fontes empacotadas e tolerância configurada.
- [Semelhança visual excessiva com o Fiori e risco de propriedade intelectual] → Identidade própria (fonte, ícones e paleta não SAP) e revisão de assets na change de cada fundamento.
- [Tabela e DataGrid com desempenho insuficiente em web] → Virtualização com slivers nativos, paginação no servidor por padrão (D6) e benchmark na Fase 5 com metas definidas na spec da tabela.
- [Regras de governança muito rígidas atrasam correções simples] → Correções que não mudam comportamento (refactor, bug fix sem mudança de requisito) podem usar `skip_specs: true`, conforme o OpenSpec.
- [Verificação de literais com falsos positivos] → Lista de exceções versionada e justificada em `tool/rebic_checks`.

## Migration Plan

Não há migração: o projeto é novo. O framework não toca o portal. A adoção pelo portal será uma change separada, com aprovação explícita, começando por um piloto isolado (uma tela) na Fase 5. O rollback consiste em remover a dependência do pacote na aplicação piloto.

## Open Questions

Nenhuma destas questões altera as specs desta change, a abordagem ou a divisão de tarefas. Todas têm tarefa de levantamento na Fase 0 ou são decididas na change do fundamento correspondente.

1. Versão exata de Flutter/Dart e plataformas-alvo do portal (web, desktop, mobile). Ver tarefa 1.1.
2. Canal de distribuição: git privado com tags ou servidor pub privado.
3. Família tipográfica com licença aberta (candidatas: Inter, Noto Sans), a definir em `add-rebic-foundation-typography`.
4. Conjunto de ícones com licença compatível (candidatas: Lucide, Phosphor), a definir em `add-rebic-foundation-iconography`.
5. Paleta da marca e se a primeira identidade segue o manual de marca da empresa.
6. Plataforma de integração contínua disponível (GitHub Actions, Azure DevOps, GitLab).

## Apêndice A — Template de spec de widget

```markdown
# Spec Delta

## Purpose

<Objetivo e escopo: problema que o widget resolve e suas responsabilidades. 1–2 frases.>

## ADDED Requirements

### Requirement: [API] Propriedades
`RebicX` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| ... | ... | ... |

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `RebicApp`
- **WHEN** `RebicX(...)` é criado apenas com os parâmetros obrigatórios
- **THEN** ...

### Requirement: [API] Callbacks e controlador
### Requirement: [Comportamento] <interação/transição/validação/erro>
### Requirement: [Aparência] Tokens de componente
### Requirement: [Estados] <normal|hover|foco|pressionado|desabilitado|carregando|erro|selecionado>
### Requirement: [Acessibilidade] Teclado e foco
### Requirement: [Acessibilidade] Semântica e contraste
### Requirement: [Responsividade] <breakpoints/densidade/plataformas>
### Requirement: [Integração] Dependências
`RebicX` SHALL depender somente de: `rebic/foundation/...`, `rebic/core/...`, `rebic/widgets/...`.
### Requirement: [Testes] Cobertura exigida
### Requirement: [Documentação] Exemplos mínimos
### Requirement: [Restrições] Fora do escopo

(cada requisito com ao menos um `#### Scenario:`)
```
