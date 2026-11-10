# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs alteradas.

## 1. Fundamento

- [x] 1.1 Renomear as constantes de `GjaIcons` conforme D1, remover `moreVertical` (D3), atualizar `lucideNames`, `all` e o dartdoc (com o `sap-icon://` de cada ícone), e criar `iconPoolNames` (D2). Verificação: "Catálogo semântico de ícones — Códigos conferem com o mapa oficial", "— Catálogo completo e sem repetição" e "— Nomes do IconPool"; "Espelhamento de ícones direcionais — Ícone direcional em RTL"; "Uso de ícones fora do catálogo — Ícone extra da aplicação".
- [x] 1.2 `GjaIconTokens.fallback().control` = `size16` (D4). Verificação: "Passos e papéis de tamanho de ícone — Mapeamento de referência" e "— Tamanho inválido rejeitado"; o contrato do conjunto continua passando.

## 2. Widgets

- [x] 2.1 Aplicar os nomes novos em `GjaScaffold`, `GjaPage`, `GjaDropdown` e `GjaAvatar` e nos testes de `gja_widgets`. Verificação: "[Aparência] Tokens de componente — Cores da barra e da navegação" (scaffold); "[Comportamento] Ordem e fallback — Avatar sem conteúdo mostra o ícone padrão"; "[Comportamento] Espelhamento em RTL — Direcional em RTL" (ícone); "[Responsividade] Direção — Ícone direcional em RTL" (botão de ícone); `flutter test --exclude-tags golden` em `packages/gja_widgets` sem falhas.
- [x] 2.2 Regerar no Windows (tag `golden`) os goldens que mudarem com o ícone de controle de 16, nos dois temas e nas duas densidades, conferindo por amostragem botões e o scaffold. Verificação: `flutter test` em `packages/gja_widgets`, com e sem a tag `golden`, sem falhas.

## 3. Galeria

- [x] 3.1 Página "Ícones" com o nome do catálogo e o `sap-icon://`, e os nomes novos nas demais páginas e testes (D5). Verificação: "Testes e documentação dos ícones — Página na galeria" e `gallery_dark_theme_test.dart`.

## 4. Documentação, changelog e verificação final

- [x] 4.1 Acrescentar à ADR 0009 as linhas de D6, e atualizar os CHANGELOGs de `gja_foundation` (tabela de/para, `iconPoolNames`, `control` 16, **BREAKING**) e `gja_widgets`.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-foundation-iconography-fiori-iconpool`) após a revisão.
- Última change de realinhamento da fundação: breakpoints (primitivos sem uso).
