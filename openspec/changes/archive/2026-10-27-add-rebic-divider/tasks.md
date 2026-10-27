# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/widgets/rebic-divider` (16 cenários).

## 1. Widget

- [x] 1.1 Criar `RebicDividerTone` e `RebicDivider` com `RebicDivider.vertical` (D1, D2) em `packages/rebic_widgets/lib/src/fundacao_layout/divider/`, com dartdoc e exportados. Verificação: testes de "[API] Propriedades", "[API] Callbacks e controlador", "[Comportamento] Orientação", "[Comportamento] Recuo direcional", "[Aparência] Tokens de componente" (2), "[Estados] Sem estados de interação", "[Acessibilidade] Teclado e foco", "[Acessibilidade] Semântica e contraste" (2), "[Responsividade] Densidade", "[Integração] Dependências" e "[Restrições] Fora do escopo"; `rebic_checks tokens` passa.

## 2. Goldens e rastreabilidade

- [x] 2.1 Criar os goldens de `RebicDivider` no Windows e conferi-los visualmente (D3). Verificação: teste "[Testes] Cobertura exigida — Goldens do divisor", com as quatro imagens.
- [x] 2.2 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do divisor", com os 16 cenários.

## 3. Galeria

- [x] 3.1 Adicionar a página "RebicDivider" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página RebicDivider na galeria".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (D4) e o `CHANGELOG.md` de `rebic_widgets`. Verificação: `dart run rebic_checks catalog` passa, com a pasta `fundacao_layout/divider`.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0, com os goldens executados.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-divider`) após a revisão.
- Próximo widget, pela ordem do design da Fase 0: `RebicResponsiveLayout`.
