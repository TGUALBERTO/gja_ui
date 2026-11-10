# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs alteradas.

## 1. Fundamento

- [x] 1.1 Trocar `control` e `container` de `GjaRadiusTokens` pelos papéis de D1, com dartdoc citando os parâmetros Fiori, e atualizar os testes de raio. Verificação: "Passos e papéis semânticos de raio" (quatro cenários, incluindo "— Papéis do Fiori"); "Contrato do conjunto de raios" (três cenários); "Formato de pílula" e "Escala primitiva de raios" continuam passando.

## 2. Núcleo

- [x] 2.1 `GjaInteractable`: raio padrão do anel de foco `button`, com o teste de valores do tema e o CHANGELOG de `gja_core`. Verificação: "Valores do tema ativo" (dois cenários).

## 3. Widgets

- [x] 3.1 Aplicar D2 em `GjaContainer` (enum `GjaRadius`), `GjaButton`, `GjaIconButton`, `GjaLink`, `GjaCard` e `GjaPopover`, e atualizar os testes. Verificação: "[API] Valores dos papéis — Papéis do fundamento", "[Comportamento] Recorte nos cantos — Filho recortado" e "[Aparência] Tokens de componente — Raio e sombra" de `gja-container`; "Superfície do cartão"; "Superfície do popover"; "Medidas da densidade compacta"; "Botão de ícone na densidade compacta"; "Cor do link nos temas"; `flutter test --exclude-tags golden` em `packages/gja_widgets` sem falhas.
- [x] 3.2 Regerar no Windows (tag `golden`) os goldens que mudarem, nos dois temas e nas duas densidades, conferindo por amostragem os botões com cantos de 8 e o cartão com 16. Verificação: `flutter test` em `packages/gja_widgets`, com e sem a tag `golden`, sem falhas.

## 4. Galeria

- [x] 4.1 Atualizar a página "Raios" e as páginas que citam `radius.control` ou `radius.container` (D3), com os testes. Verificação: "Testes e documentação dos raios — Página na galeria", "[Documentação] Exemplos mínimos — Página GjaContainer na galeria" e `gallery_dark_theme_test.dart`.

## 5. Documentação, changelog e verificação final

- [x] 5.1 Acrescentar à ADR 0009 a linha de D4, e atualizar os CHANGELOGs de `gja_foundation` e `gja_widgets` com o de/para de D1 e D2 (**BREAKING**).
- [x] 5.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-foundation-radius-fiori-roles`) após a revisão.
- Próxima change de realinhamento da fundação: ícones (nomes do IconPool, `sapContent_IconHeight`).
