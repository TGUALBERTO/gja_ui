# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs `gja/widgets/gja-page` (21 cenários) e
`gja/core/localization` (cenário novo "Texto de voltar").

## 1. Localização e botão interno

- [x] 1.1 Adicionar `String get back` a `GjaLocalizations`, com "Voltar" (pt-BR) e "Back" (en), e implementar o getter na subclasse `_Es` do teste de extensão (D4). Verificação: teste "Textos do framework — Texto de voltar"; os demais testes do núcleo passam.
- [x] 1.2 Extrair o botão do `GjaScaffold` para o widget interno `GjaTransparentIconAction` (D3), não exportado, e usá-lo no scaffold. Verificação: os testes e os goldens do scaffold passam sem atualização.

## 2. Widget

- [x] 2.1 Criar `GjaPage` (D1, D2) em `packages/gja_widgets/lib/src/fundacao_layout/page/`, com dartdoc e exportado. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Teclado e foco`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `gja_checks tokens` passa.
- [x] 2.2 Adicionar os testes de acessibilidade num arquivo sem a fonte Inter: semântica do título e do botão de voltar, contraste e alvo mínimo, nos temas claro e escuro e nas duas densidades. Verificação: testes de `[Acessibilidade] Semântica e contraste`.
- [x] 2.3 Gerar os goldens da página (800 × 600) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens da página".
- [x] 2.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade da página", com os 21 cenários.

## 3. Galeria

- [x] 3.1 Adicionar a página "GjaPage" construída com `GjaPage` (D5). Verificação: teste "[Documentação] Exemplos mínimos — Página GjaPage na galeria".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml`: `gja-page` passa a `implemented`, com as dependências dos requisitos `[Integração]`. Atualizar também o `CHANGELOG.md` de `gja_widgets` e o de `gja_core`. Verificação: `dart run gja_checks catalog` passa, com a pasta `fundacao_layout/page`.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-page`) após a revisão. A spec `gja/core/localization` recebe um MODIFIED: mesclar o requisito, não copiar.
- Com `GjaPage`, a Fase 1 termina. A próxima etapa, pela ordem do design da Fase 0, é `GjaProgressIndicator` e `GjaTooltip` (Fase 2).
