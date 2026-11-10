# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/core/responsive`. É infraestrutura do núcleo; a
galeria demonstra o comportamento.

## 1. Classe da tela e do contêiner

- [x] 1.1 Criar `GjaResponsive.screenSizeClassOf` e `GjaScreenSizeScope` (D1) em `packages/gja_core/lib/src/responsive/`, com dartdoc, exportados em `gja_core.dart`. Verificação: testes "Classe de tamanho da tela — Largura da janela", "— Mudança que não troca a classe" (contagem de builds) e "— Limiares recebidos".
- [x] 1.2 Criar `GjaResponsiveBuilder` (D2). Verificação: testes "Classe de tamanho do contêiner — Contêiner menor que a tela" e "— Largura sem limite".

## 2. Valores e densidade

- [x] 2.1 Criar `GjaResponsiveValue<T>` (D3). Verificação: testes "Valores por classe de tamanho — Herança da classe menor" e "— Resolução pela tela e pelo contêiner", e um teste de igualdade por valor.
- [x] 2.2 Criar `GjaResponsive.recommendedDensity` (D4). Verificação: teste "Densidade recomendada — Plataformas".

## 3. Galeria

- [x] 3.1 Envolver as rotas da galeria em `GjaScreenSizeScope` e adicionar a página "Responsividade" (D5). Verificação: teste "Testes e documentação da responsividade — Página na galeria".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (`gja/core/responsive` → `implemented`, com `gja/foundation/density` nas dependências, D6) e o `CHANGELOG.md` de `gja_core`. Verificação: `dart run gja_checks catalog` passa.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-core-responsive`) após a revisão.
- Próxima change do núcleo: `add-gja-core-overlay`.
