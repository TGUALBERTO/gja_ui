# Tasks

Escopo: **somente a Fase 0** (descoberta, estrutura e automação de conformidade). Nenhum widget, token ou tema é implementado aqui. Cada fundamento, infraestrutura e widget terá change própria, conforme `design.md` (Inventário e Ordem sugerida).

## 1. Descoberta (somente leitura do portal)

- [x] 1.1 Levantar no portal existente, sem alterar nenhum arquivo dele, as versões de Flutter/Dart (`pubspec.yaml`, `pubspec.lock`, versão do SDK do pipeline), as plataformas-alvo e as dependências de UI. Registrar em `docs/adr/0001-sdk-baseline.md`. Verificação: a ADR contém as versões, as plataformas e a origem de cada informação.
- [x] 1.2 Decidir entre pub workspace e dependências `path:` com base na 1.1 (D1) e registrar em `docs/adr/0002-package-layout.md`. Verificação: a ADR cita a versão mínima de Dart e a alternativa descartada.
- [x] 1.3 Registrar as ADRs das decisões D2 (sem Material na API pública), D3 (tokens em três níveis), D5/D6 (estado e dados) e D10 (uma change por widget) em `docs/adr/`. Verificação: existe um arquivo por decisão, com contexto, decisão e alternativas.
- [x] 1.4 Registrar as respostas às Open Questions 2 e 6 do `design.md` (canal de distribuição e plataforma de integração contínua) em `docs/adr/0003-distribution-and-ci.md`. Verificação: a ADR existe. Questões não respondidas ficam marcadas como pendentes, com responsável.

## 2. Estrutura do repositório

- [x] 2.1 Inicializar o controle de versão do repositório (`git init`, `.gitignore` para Flutter). Verificação: `git status` funciona e ignora `.dart_tool/` e `build/`.
- [x] 2.2 Criar os pacotes `packages/rebic_foundation`, `rebic_core`, `rebic_widgets` e `rebic_ui` e o app `apps/rebic_gallery`, com bibliotecas vazias, restrições de SDK da 1.1 e dependências na direção de D1. Verificação: `flutter pub get` na raiz conclui sem erros.
- [x] 2.3 Criar o `analysis_options.yaml` compartilhado (`flutter_lints`, `public_member_api_docs`, `strict-casts`, `strict-raw-types`). Verificação: `dart analyze` na raiz termina sem issues.
- [x] 2.4 Fazer a galeria inicializar com `WidgetsApp` provisório, sem Material, e escrever um teste de fumaça. Verificação: `flutter test apps/rebic_gallery` passa.

## 3. Verificações automatizadas (`tool/rebic_checks`)

- [x] 3.1 Implementar a verificação **arquitetura** (imports entre camadas, `material`/`cupertino` sem ADR, símbolos exportados de Material/Cupertino), conforme `rebic/framework-architecture`. Verificação: os testes com fixtures válidas e inválidas passam, e a execução na raiz retorna código 0.
- [x] 3.2 Implementar a verificação **tokens** (literais visuais em `rebic_widgets/lib`, com lista de exceções justificadas). Verificação: os testes com fixtures cobrem `Color(`, `EdgeInsets`, `BorderRadius` e `Duration` e passam.
- [x] 3.3 Implementar a verificação **specs** (`## Purpose` e as 10 etiquetas em `rebic/widgets/*`, referências de spec existentes, grafo acíclico), conforme `rebic/spec-governance`. Verificação: os testes com specs-fixture completas, incompletas e cíclicas passam.
- [x] 3.4 Implementar a verificação **catálogo** (coerência entre `docs/catalog.yaml` e `openspec/specs/rebic/**` e coerência de prioridades). Verificação: os testes com catálogo coerente, item sem spec e prioridade invertida passam.
- [x] 3.5 Documentar o uso do CLI em `tool/rebic_checks/README.md`. Verificação: os comandos documentados executam como descrito.

## 4. Governança das specs

- [x] 4.1 Criar `docs/specs/widget-spec-template.md` a partir do Apêndice A do `design.md`. Verificação: uma spec de exemplo gerada pelo template passa em `openspec validate --strict` (em change temporária, descartada em seguida) e em `rebic_checks specs`.
- [x] 4.2 Adicionar ao `openspec/config.yaml` regras em `rules.specs` (template, etiquetas, caminhos, dependências), `rules.proposal` (nome da change, justificativa de change conjunta) e `rules.tasks` (teste por cenário, página na galeria, atualização do catálogo). Verificação: `openspec instructions specs --change <change> --json` retorna as regras no campo `rules`.
- [x] 4.3 Criar `docs/catalog.yaml` com todos os itens do inventário do `design.md` (situação `planned`, prioridade, fase, caminho da spec e dependências). Verificação: `rebic_checks catalog` passa e o grafo é acíclico.
- [x] 4.4 Escrever `docs/CONTRIBUTING.md` com o fluxo propose → apply → archive, nomenclatura de changes, granularidade, critérios de revisão e política de versionamento/depreciação. Verificação: revisão do documento por um mantenedor e links para as ADRs e para o template funcionando.

## 5. Pipeline de qualidade

- [x] 5.1 Criar o script `tool/ci` (bash e PowerShell), que executa `dart analyze`, `flutter test`, `openspec validate --all --strict` e `rebic_checks all`. Verificação: o script termina com código 0 no repositório limpo e com código diferente de 0 ao introduzir um import proibido.
- [x] 5.2 Configurar o pipeline na plataforma definida na 1.4 para executar `tool/ci` em todo PR. Verificação: um PR de teste mostra o pipeline verde. Se a plataforma ainda não estiver definida, a tarefa fica bloqueada e isso é registrado na ADR 0003.

## 6. Verificação de compatibilidade (sem tocar o portal)

- [x] 6.1 Criar, fora do repositório do portal, um app descartável com as mesmas restrições de SDK e dependências de UI do portal (da 1.1), dependendo de `rebic_ui` por `path:`. Verificação: `flutter pub get` e `flutter build` nas plataformas-alvo concluem sem conflitos. O resultado é registrado na ADR 0001.

## Workflow follow-up

- Arquivar esta change (`openspec archive propose-rebic-ui-framework`) após a revisão. Isso cria as specs principais `rebic/framework-architecture` e `rebic/spec-governance`.
- Iniciar a Fase 1 com a change `add-rebic-foundation-design-tokens`, seguindo a ordem sugerida no `design.md`.
