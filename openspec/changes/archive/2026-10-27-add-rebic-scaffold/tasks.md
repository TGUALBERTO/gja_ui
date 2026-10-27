# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs `rebic/widgets/rebic-scaffold` (23 cenários) e
`rebic/core/localization` (cenário novo "Texto da navegação").

## 1. Localização

- [x] 1.1 Adicionar `String get navigation` a `RebicLocalizations`, com "Navegação" (pt-BR) e "Navigation" (en), e implementar o getter na subclasse `_Es` do teste de extensão (D5). Verificação: teste "Textos do framework — Texto da navegação" em `rebic_core/test/localization`; os demais testes do núcleo passam.

## 2. Widget

- [x] 2.1 Criar `RebicScaffold` com `navigationExpandedOf`, o estado automático (D1, D2) e o layout das classes (D3), em `packages/rebic_widgets/lib/src/fundacao_layout/scaffold/`, com dartdoc e exportado. Verificação: os testes de `[API]`, `[Comportamento]`, `[Responsividade]` e `[Integração]`; `rebic_checks tokens` passa.
- [x] 2.2 Implementar a barra e o botão de navegação (D3, D4): superfície `shell`, sombra `header`, família `transparent`, ícone `menu`, semântica expandida, e o movimento da largura. Verificação: os testes de `[Aparência]`, `[Estados]` e `[Acessibilidade] Teclado e foco`.
- [x] 2.3 Adicionar os testes de acessibilidade num arquivo sem a fonte Inter: semântica do botão e do título, contraste do texto sobre `shell` e alvo mínimo, nos temas claro e escuro. Verificação: testes de `[Acessibilidade] Semântica e contraste`.
- [x] 2.4 Gerar os goldens do scaffold (1200 × 480, barra, navegação expandida e corpo) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do scaffold".
- [x] 2.5 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do scaffold", com os 23 cenários.

## 3. Galeria

- [x] 3.1 Adicionar a página "RebicScaffold" (D6), com o scaffold de demonstração. Verificação: teste "[Documentação] Exemplos mínimos — Página RebicScaffold na galeria".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml`: `rebic-scaffold` passa a `implemented`, com as dependências dos requisitos `[Integração]` e sem `rebic-responsive-layout`. Atualizar também o `CHANGELOG.md` de `rebic_widgets` e o de `rebic_core`. Verificação: `dart run rebic_checks catalog` passa, com a pasta `fundacao_layout/scaffold`.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-scaffold`) após a revisão. A spec `rebic/core/localization` recebe um MODIFIED: mesclar o requisito, não copiar.
- Próximo widget, pela ordem do design da Fase 0: `RebicPage`, que fecha a Fase 1.
