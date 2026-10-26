# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec modificada.

## 1. Elevação

- [x] 1.1 Renomear os primitivos para `none`, `shadow0`…`shadow3` e adicionar `header` (D1, D2), com o mapa `shadows`. Verificação: testes "Profundidade crescente" e "Fatores de opacidade válidos".
- [x] 1.2 Renomear os níveis de `RebicElevationTokens` e adicionar os papéis `dragged` e `header` (D3). Verificação: testes "Papéis do mapeamento de referência", "Sombra com a cor do modo", "Nível sem sombra", "Contrato verificado" e "Interpolação a partir de nível sem sombra".

## 2. Tema, galeria e documentação

- [x] 2.1 Atualizar o teste de tema e a página "Elevação" da galeria com o teste dela. Verificação: `flutter test` em `rebic_foundation` e `apps/rebic_gallery` passa, e nenhum arquivo fora das changes usa `level0`…`level4` ou `elevation0`…`elevation4`.
- [x] 2.2 Atualizar o `CHANGELOG.md` de `rebic_foundation` com a tabela de/para.
- [x] 2.3 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar esta change e `update-rebic-foundation-color-fiori-parameters`.
- Em seguida: `add-rebic-core-localization`.
