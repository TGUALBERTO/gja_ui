# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/widgets/gja-text` (18 cenários).

## 1. Widget

- [x] 1.1 Criar `GjaTextVariant`, `GjaTextTone` e `GjaText` (D1, D2) em `packages/gja_widgets/lib/src/fundacao_layout/text/`, com dartdoc e exportados. Verificação: testes de "[API] Propriedades" (2), "[API] Callbacks e controlador", "[Comportamento] Limite de linhas" (2), "[Aparência] Tokens de componente" (2), "[Estados] Sem estados de interação", "[Acessibilidade] Teclado e foco", "[Acessibilidade] Semântica e contraste" (3), "[Responsividade] Tamanhos de tela e densidade", "[Integração] Dependências" e "[Restrições] Fora do escopo".

## 2. Goldens

- [x] 2.1 Criar o suporte de fontes e goldens e o `dart_test.yaml` com a etiqueta `golden` (D3). Gerar a referência no Windows com `--update-goldens`. Verificação: teste "[Testes] Cobertura exigida — Goldens das variantes", com as quatro imagens.
- [x] 2.2 Fazer `tool/ci.sh` excluir a etiqueta `golden` e escrever o ADR 0008, com o índice de ADRs atualizado (D3). Verificação: `bash -n tool/ci.sh` sem erro; o ADR tem Status, Data, Contexto, Decisão, Alternativas e Consequências.
- [x] 2.3 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade", com os 18 cenários contra as suítes de `gja_widgets` e da galeria.

## 3. Galeria

- [x] 3.1 Adicionar a página "GjaText" (D5). Verificação: teste "[Documentação] Exemplos mínimos — Página GjaText na galeria".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (D5), o `CHANGELOG.md` de `gja_widgets` e o checklist de goldens em `docs/CONTRIBUTING.md` (comando de atualização e etiqueta). Verificação: `dart run gja_checks catalog` passa, incluindo a pasta `fundacao_layout/text`.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0, com os goldens executados.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-text`) após a revisão.
- Próximo widget: `add-gja-icon`.
