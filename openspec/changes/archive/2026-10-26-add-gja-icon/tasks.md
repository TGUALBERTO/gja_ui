# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/widgets/gja-icon` (17 cenários).

## 1. Widget

- [x] 1.1 Criar `GjaIconSize`, `GjaIconTone` e `GjaIcon` (D1, D2) em `packages/gja_widgets/lib/src/fundacao_layout/icon/`, com dartdoc e exportados. Verificação: testes de "[API] Propriedades", "[API] Callbacks e controlador", "[Comportamento] Espelhamento em RTL", "[Aparência] Tokens de componente" (2), "[Estados] Sem estados de interação", "[Acessibilidade] Teclado e foco", "[Acessibilidade] Semântica e contraste" (3), "[Responsividade] Escala de texto e densidade" (2), "[Integração] Dependências" e "[Restrições] Fora do escopo".

## 2. Goldens

- [x] 2.1 Carregar a Lucide em `test/support/fonts.dart` e criar os goldens de `GjaIcon` no Windows (D3). Verificação: teste "[Testes] Cobertura exigida — Goldens dos tamanhos e tons", com as quatro imagens conferidas visualmente.
- [x] 2.2 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade", com os 17 cenários.

## 3. Galeria

- [x] 3.1 Adicionar a página "GjaIcon" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página GjaIcon na galeria".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (D4) e o `CHANGELOG.md` de `gja_widgets`. Verificação: `dart run gja_checks catalog` passa, incluindo a pasta `fundacao_layout/icon`.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0, com os goldens executados.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-icon`) após a revisão.
- Próximo widget, pela ordem do design da Fase 0: `GjaSpacing`.
