# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/widgets/rebic-container` (18 cenários).

## 1. Widget

- [x] 1.1 Criar `RebicSurface`, `RebicRadius`, `RebicElevation` e `RebicContainer` (D1, D2) em `packages/rebic_widgets/lib/src/fundacao_layout/container/`, com dartdoc e exportados. Verificação: testes de "[API] Propriedades", "[API] Valores dos papéis", "[API] Callbacks e controlador", "[Comportamento] Recorte nos cantos" (2), "[Aparência] Tokens de componente" (3), "[Estados] Sem estados de interação", "[Acessibilidade] Teclado e foco", "[Acessibilidade] Semântica e contraste" (2), "[Responsividade] Densidade", "[Integração] Dependências" e "[Restrições] Fora do escopo"; `rebic_checks tokens` passa.

## 2. Goldens e rastreabilidade

- [x] 2.1 Criar os goldens de `RebicContainer` no Windows e conferi-los visualmente (D3). Verificação: teste "[Testes] Cobertura exigida — Goldens das superfícies", com as quatro imagens.
- [x] 2.2 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade", com os 18 cenários.

## 3. Galeria

- [x] 3.1 Adicionar a página "RebicContainer" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página RebicContainer na galeria".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (D4) e o `CHANGELOG.md` de `rebic_widgets`. Verificação: `dart run rebic_checks catalog` passa, incluindo a pasta `fundacao_layout/container`.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0, com os goldens executados.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-container`) após a revisão.
- Próximos widgets, pela ordem do design da Fase 0: `RebicRow` e `RebicColumn` (exceção de até três specs numa change, ADR 0007), depois `RebicDivider`.
