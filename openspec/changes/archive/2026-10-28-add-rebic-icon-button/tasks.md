# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs `rebic/widgets/rebic-icon-button` (19 cenários) e
`rebic/widgets/rebic-tooltip` (cenário novo "Dica fora da semântica").

## 1. Dica

- [x] 1.1 Adicionar `excludeFromSemantics` ao `RebicTooltip` (D3), com dartdoc, e o teste "[Acessibilidade] Semântica e contraste — Dica fora da semântica". Atualizar a rastreabilidade da dica para 22 cenários. Verificação: os testes da dica passam.

## 2. Widget

- [x] 2.1 Extrair o mapeamento de tipo para família para `rebic_button_family.dart` (interno) e usá-lo no `RebicButton` (D1). Verificação: os testes do botão passam sem mudança.
- [x] 2.2 Criar `RebicIconButton` (D1, D2) em `packages/rebic_widgets/lib/src/acoes_navegacao/icon_button/`, com dartdoc e exportado. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Semântica`, `[Responsividade]`, `[Integração]` (exceto scaffold e página) e `[Restrições]`; `rebic_checks tokens` passa.
- [x] 2.3 Adicionar os testes de acessibilidade num arquivo sem a fonte Inter (D5). Verificação: teste "[Acessibilidade] Contraste e alvo — Contraste e alvo do botão de ícone".
- [x] 2.4 Gerar os goldens (D5) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do botão de ícone".

## 3. Scaffold e página

- [x] 3.1 Trocar o botão interno por `RebicIconButton` no `RebicScaffold` e na `RebicPage`, e remover `lib/src/fundacao_layout/action/` (D4). Verificação: teste "[Integração] Dependências — Scaffold e página usam o botão de ícone"; os testes do scaffold e da página passam; os goldens deles passam ou são regenerados após a verificação visual descrita em D4.
- [x] 3.2 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do botão de ícone", com os 19 cenários.

## 4. Galeria

- [x] 4.1 Adicionar a página "RebicIconButton" (D5). Verificação: teste "[Documentação] Exemplos mínimos — Página RebicIconButton na galeria".

## 5. Catálogo, changelog e verificação final

- [x] 5.1 Atualizar `docs/catalog.yaml` (`rebic-icon-button` → `implemented` com as dependências do `[Integração]`; `rebic-scaffold` e `rebic-page` com `rebic-icon-button`) e o `CHANGELOG.md` de `rebic_widgets`. Verificação: `dart run rebic_checks catalog` passa, com a pasta `acoes_navegacao/icon_button`.
- [x] 5.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-icon-button`) após a revisão. As specs `rebic-tooltip`, `rebic-scaffold` e `rebic-page` recebem MODIFIED: mesclar os requisitos, não copiar.
- Próximo widget, pela ordem do design da Fase 0: `RebicLink`.
