# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/widgets/gja-menu` (21 cenários).

## 1. Lista compartilhada

- [x] 1.1 Extrair a lista do `GjaDropdown` para `GjaOptionList` (interna, não exportada), com divisores de seção e papéis semânticos opcionais (D2, D3). Verificação: todos os testes do dropdown passam sem mudança, e os goldens do dropdown não mudam.

## 2. Widget

- [x] 2.1 Criar `GjaMenuItem` e `GjaMenu` (D1–D3) em `packages/gja_widgets/lib/src/acoes_navegacao/menu/`, com dartdoc e exportados. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Teclado` e `Semântica`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `gja_checks tokens` passa.
- [x] 2.2 Adicionar os testes de contraste e alvo num arquivo sem a fonte Inter (D4). Verificação: teste "[Acessibilidade] Contraste e alvo — Contraste e alvo do menu".
- [x] 2.3 Gerar os goldens (D4) nos temas claro e escuro × confortável e compacto, com a tag `golden`, conferindo que os compactos diferem dos confortáveis. Verificação: teste "[Testes] Cobertura exigida — Goldens do menu".
- [x] 2.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do menu", com os 21 cenários.

## 3. Galeria

- [x] 3.1 Adicionar a página "GjaMenu" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página GjaMenu na galeria"; o teste de tema escuro da galeria continua passando.

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências do `[Integração]`) e o `CHANGELOG.md` de `gja_widgets`. Verificação: `dart run gja_checks catalog` passa, com a pasta `acoes_navegacao/menu`.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-menu`) após a revisão.
- Pendentes: `update-gja-grid-row-height`, `update-gja-gallery-pages` e, mais adiante, `update-gja-menu-submenu`.
- Próximo widget, pela ordem do design da Fase 0: ver `docs/catalog.yaml` (Fase 2).
