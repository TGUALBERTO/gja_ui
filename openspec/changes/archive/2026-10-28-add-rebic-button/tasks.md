# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs `rebic/widgets/rebic-button` (23 cenários) e
`rebic/foundation/interaction-states` (cenário novo "Famílias accept, reject e attention").

## 1. Fundamento e indicador

- [x] 1.1 Adicionar `accept`, `reject` e `attention` a `RebicControlFamily` e a `RebicControlColors.of` (D1), com dartdoc. Verificação: teste "Famílias de controle — Famílias accept, reject e attention" em `rebic_foundation/test/interaction_states`; o teste de contraste dos estados passa com as novas famílias.
- [x] 1.2 Extrair a animação e a pintura do `RebicProgressIndicator` para o widget interno `RebicProgressView` (D4). Verificação: os testes e os goldens do indicador passam sem atualização.

## 2. Widget

- [x] 2.1 Criar `RebicButtonType` e `RebicButton` (D2, D3) em `packages/rebic_widgets/lib/src/acoes_navegacao/button/`, com dartdoc e exportados. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Semântica`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `rebic_checks tokens` passa.
- [x] 2.2 Adicionar os testes de acessibilidade num arquivo sem a fonte Inter: contraste, rótulo do alvo e alvo mínimo por tipo, e escala 2,0. Verificação: testes de `[Acessibilidade] Contraste, alvo e escala`.
- [x] 2.3 Gerar os goldens (D5) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do botão".
- [x] 2.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do botão", com os 23 cenários.

## 3. Galeria

- [x] 3.1 Adicionar a página "RebicButton" (D5). Verificação: teste "[Documentação] Exemplos mínimos — Página RebicButton na galeria"; o teste da página "Estados" continua passando com as novas famílias.

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências dos requisitos `[Integração]`) e os `CHANGELOG.md` de `rebic_widgets` e `rebic_foundation`. Verificação: `dart run rebic_checks catalog` passa, com a pasta `acoes_navegacao/button`.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-button`) após a revisão. A spec `rebic/foundation/interaction-states` recebe um MODIFIED: mesclar o requisito, não copiar.
- Próximo widget, pela ordem do design da Fase 0: `RebicIconButton`, que substitui o botão interno do scaffold e da página.
