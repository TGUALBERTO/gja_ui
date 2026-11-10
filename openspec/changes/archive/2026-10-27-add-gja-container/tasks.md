# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/widgets/gja-container` (18 cenários).

## 1. Widget

- [x] 1.1 Criar `GjaSurface`, `GjaRadius`, `GjaElevation` e `GjaContainer` (D1, D2) em `packages/gja_widgets/lib/src/fundacao_layout/container/`, com dartdoc e exportados. Verificação: testes de "[API] Propriedades", "[API] Valores dos papéis", "[API] Callbacks e controlador", "[Comportamento] Recorte nos cantos" (2), "[Aparência] Tokens de componente" (3), "[Estados] Sem estados de interação", "[Acessibilidade] Teclado e foco", "[Acessibilidade] Semântica e contraste" (2), "[Responsividade] Densidade", "[Integração] Dependências" e "[Restrições] Fora do escopo"; `gja_checks tokens` passa.

## 2. Goldens e rastreabilidade

- [x] 2.1 Criar os goldens de `GjaContainer` no Windows e conferi-los visualmente (D3). Verificação: teste "[Testes] Cobertura exigida — Goldens das superfícies", com as quatro imagens.
- [x] 2.2 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade", com os 18 cenários.

## 3. Galeria

- [x] 3.1 Adicionar a página "GjaContainer" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página GjaContainer na galeria".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (D4) e o `CHANGELOG.md` de `gja_widgets`. Verificação: `dart run gja_checks catalog` passa, incluindo a pasta `fundacao_layout/container`.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0, com os goldens executados.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-container`) após a revisão.
- Próximos widgets, pela ordem do design da Fase 0: `GjaRow` e `GjaColumn` (exceção de até três specs numa change, ADR 0007), depois `GjaDivider`.
