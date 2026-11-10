# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Botão

- [x] 1.1 `GjaButton` com `text`, `icon`, `tooltip`, `type`, `enabled`, `onPress` e `busy`, nos formatos com texto e
  só com ícone, com a asserção de conteúdo, a dica e a semântica (D1, D2, D3), e dartdoc; `acoes_navegacao/icon_button/`
  sai, com a exportação. Verificação: um teste por cenário de `gja-button`, incluindo a bateria de acessibilidade,
  e a rastreabilidade da spec.
- [x] 1.2 Goldens do botão regerados com a amostra nova (seis tipos com texto, com ícone e texto e só com ícone,
  desabilitado e ocupado), conferidos à vista; os goldens do botão de ícone saem (D6).

## 2. Migração

- [x] 2.1 `GjaPage` e `GjaShellBar` com `GjaButton` só com ícone e `type: transparent` (D4), e o dartdoc de barra,
  menu, dropdown, popover, badge e ícone. Verificação: "[Integração] Dependências do núcleo e de widgets — Barra e
  página usam o botão", os testes de página e ShellBar, e os goldens deles sem diferença.
- [x] 2.2 Migrar os usos nos testes de `gja_widgets` com o script (D5), convertendo à mão os `onPressed` com
  expressão nula. Verificação: `dart analyze` sem erros e `flutter test -j 2` e `--tags golden` em
  `packages/gja_widgets`, com mudança só nos goldens do botão.
- [x] 2.3 CHANGELOG de `gja_widgets` com o de/para.

## 3. Galeria, catálogo e regra de nomes

- [x] 3.1 Migrar a galeria e juntar as páginas em "GjaButton", com a barra de ações só com ícone; a página
  "GjaIconButton" sai, com o teste (D6). Verificação: "[Documentação] Exemplos mínimos — Página GjaButton na
  galeria" e `flutter test -j 2` em `apps/gja_gallery`.
- [x] 3.2 `docs/catalog.yaml`: sai `gja/widgets/gja-icon-button`; quem dependia dele passa a
  `gja/widgets/gja-button` (sem repetir), que ganha `gja/widgets/gja-tooltip`. Verificação:
  `dart run gja_checks all` sem erros.

## 4. Verificação final

- [x] 4.1 Executar as etapas de `tool/ci` (com `flutter test -j 2`) e `flutter test -j 2 --tags golden` em
  `packages/gja_widgets`. Verificação: código de saída 0 em todas.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-button-fiori-button`) após a revisão, com a retirada de
  `gja/widgets/gja-icon-button`.
- Próxima change: `enabled`/`onPress` (e `text` no item de menu) em `GjaLink`, `GjaMenuItem`, `GjaAvatar` e
  `GjaStatusIndicator`, que até lá divergem da regra de nomes revisada em `gja/framework-architecture`.
