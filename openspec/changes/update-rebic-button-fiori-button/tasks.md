# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Botão

- [ ] 1.1 `RebicButton` com `text`, `icon`, `tooltip`, `type`, `enabled`, `onPress` e `busy`, nos formatos com texto e
  só com ícone, com a asserção de conteúdo, a dica e a semântica (D1, D2, D3), e dartdoc; `acoes_navegacao/icon_button/`
  sai, com a exportação. Verificação: um teste por cenário de `rebic-button`, incluindo a bateria de acessibilidade,
  e a rastreabilidade da spec.
- [ ] 1.2 Goldens do botão regerados com a amostra nova (seis tipos com texto, com ícone e texto e só com ícone,
  desabilitado e ocupado), conferidos à vista; os goldens do botão de ícone saem (D6).

## 2. Migração

- [ ] 2.1 `RebicPage` e `RebicShellBar` com `RebicButton` só com ícone e `type: transparent` (D4), e o dartdoc de barra,
  menu, dropdown, popover, badge e ícone. Verificação: "[Integração] Dependências do núcleo e de widgets — Barra e
  página usam o botão", os testes de página e ShellBar, e os goldens deles sem diferença.
- [ ] 2.2 Migrar os usos nos testes de `rebic_widgets` com o script (D5), convertendo à mão os `onPressed` com
  expressão nula. Verificação: `dart analyze` sem erros e `flutter test -j 2` e `--tags golden` em
  `packages/rebic_widgets`, com mudança só nos goldens do botão.
- [ ] 2.3 CHANGELOG de `rebic_widgets` com o de/para.

## 3. Galeria, catálogo e regra de nomes

- [ ] 3.1 Migrar a galeria e juntar as páginas em "RebicButton", com a barra de ações só com ícone; a página
  "RebicIconButton" sai, com o teste (D6). Verificação: "[Documentação] Exemplos mínimos — Página RebicButton na
  galeria" e `flutter test -j 2` em `apps/rebic_gallery`.
- [ ] 3.2 `docs/catalog.yaml`: sai `rebic/widgets/rebic-icon-button`; quem dependia dele passa a
  `rebic/widgets/rebic-button` (sem repetir), que ganha `rebic/widgets/rebic-tooltip`. Verificação:
  `dart run rebic_checks all` sem erros.

## 4. Verificação final

- [ ] 4.1 Executar as etapas de `tool/ci` (com `flutter test -j 2`) e `flutter test -j 2 --tags golden` em
  `packages/rebic_widgets`. Verificação: código de saída 0 em todas.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-rebic-button-fiori-button`) após a revisão, com a retirada de
  `rebic/widgets/rebic-icon-button`.
- Próxima change: `enabled`/`onPress` (e `text` no item de menu) em `RebicLink`, `RebicMenuItem`, `RebicAvatar` e
  `RebicStatusIndicator`, que até lá divergem da regra de nomes revisada em `rebic/framework-architecture`.
