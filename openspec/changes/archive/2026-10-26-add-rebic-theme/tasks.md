# Tasks

Os testes seguem o nome `<requisito> — <cenário>` de cada spec da change (`theming`, `rebic-theme`, `interaction`,
`overlay` e `responsive`).

## 1. Foundation

- [x] 1.1 Criar `RebicThemeScope` e `RebicThemeData.of`/`maybeOf` (D1), com dartdoc e exportados. Verificação: testes "Tema na árvore de widgets — Tema mais próximo", "— Árvore sem tema", "— Animações desligadas pelo sistema" e "— Reconstrução na troca".

## 2. Widget RebicTheme

- [x] 2.1 Criar `RebicTheme`, `RebicTheme.density` e `RebicTheme.of` (D2) em `packages/rebic_widgets/lib/src/fundacao_layout/theme/`, exportados em `rebic_widgets.dart`. Verificação: testes "[API] Propriedades — Uso mínimo", "[API] Callbacks e controlador — Troca por reconstrução", "[Comportamento] Troca animada de tema — Meio da transição" e "— Movimento reduzido", "[Comportamento] Densidade por subárvore — Subárvore compacta", "[Aparência] Texto e ícone padrão — Troca de tema", "[Estados] Sem estados visuais — Não recebe foco", "[Acessibilidade] Teclado e foco — Ordem de foco preservada", "[Acessibilidade] Semântica, escala e movimento — Semântica inalterada", "[Integração] Dependências — Funciona sem Material", "[Restrições] Fora do escopo — Sem estado global" e "[Testes] Cobertura exigida — Rastreabilidade" (um teste que confere a lista de cenários da spec contra os nomes da suíte).

## 3. Núcleo lê o tema

- [x] 3.1 Tornar opcionais os parâmetros visuais de `RebicInteractable` e resolvê-los pelo tema (D3). Verificação: testes "Área mínima de interação — Conteúdo menor que o alvo" (existente, continua passando), "Valores do tema ativo — Tema com densidade compacta e marca própria" e "— Valor recebido vence o tema".
- [x] 3.2 Fazer o mesmo em `RebicModal.show` e `RebicAnchoredOverlay` (D3). Verificação: testes "Valores do tema ativo nas sobreposições — Camada no tema escuro" e "— Espaçamentos da densidade compacta", com os testes existentes de sobreposição passando.
- [x] 3.3 Fazer o mesmo na responsividade (D3). Verificação: teste "Limiares do tema ativo — Tema com limiares próprios", com os testes existentes passando.
- [x] 3.4 Adicionar o teste "[Responsividade] Densidade e plataformas — Densidade compacta" em `rebic_widgets` (elemento interativo do núcleo sob `RebicTheme.density`).

## 4. Galeria

- [x] 4.1 Envolver as rotas em `RebicTheme`, fazer as páginas do núcleo lerem o tema e adicionar a página "RebicTheme" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página na galeria" e os testes existentes da galeria passando.

## 5. Catálogo, changelog e verificação final

- [x] 5.1 Atualizar `docs/catalog.yaml` (D5) e os `CHANGELOG.md` de `rebic_foundation`, `rebic_core` e `rebic_widgets`. Verificação: `dart run rebic_checks catalog` passa, incluindo a pasta do widget.
- [x] 5.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-theme`) após a revisão. O sync cria `rebic/widgets/rebic-theme` e aplica os MODIFIED/ADDED em `theming`, `interaction`, `overlay` e `responsive`.
- Próxima change: `add-rebic-app`.
