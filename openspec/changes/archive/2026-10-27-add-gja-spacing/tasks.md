# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/widgets/gja-spacing` (17 cenários).

## 1. Widget

- [x] 1.1 Criar `GjaSpace` e `GjaSpacing` com `horizontal`, `vertical`, `padding` e `resolve` (D1, D2) em `packages/gja_widgets/lib/src/fundacao_layout/spacing/`, com dartdoc e exportados. Verificação: testes de "[API] Propriedades", "[API] Valores de espaço", "[API] Callbacks e controlador", "[Comportamento] Separadores", "[Comportamento] Padding direcional" (2), "[Aparência] Tokens de componente" (2), "[Estados] Sem estados visuais", "[Acessibilidade] Teclado e foco", "[Acessibilidade] Semântica e escala" (2), "[Responsividade] Densidade", "[Integração] Dependências" e "[Restrições] Fora do escopo".
- [x] 1.2 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade", com os 17 cenários.

## 2. Galeria

- [x] 2.1 Adicionar a página "GjaSpacing" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página GjaSpacing na galeria".

## 3. Catálogo, changelog e verificação final

- [x] 3.1 Atualizar `docs/catalog.yaml` (D4) e o `CHANGELOG.md` de `gja_widgets`. Verificação: `dart run gja_checks catalog` e `tokens` passam, incluindo a pasta `fundacao_layout/spacing`.
- [x] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-spacing`) após a revisão.
- Próximo widget, pela ordem do design da Fase 0: `GjaContainer`.
