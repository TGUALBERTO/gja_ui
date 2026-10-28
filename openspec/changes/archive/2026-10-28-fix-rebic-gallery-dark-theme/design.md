# Design: Galeria no tema escuro

## Context

- `RebicApp` resolve o tema pelo modo escolhido (sistema, claro, escuro) e pela densidade, e aplica `RebicTheme`
  acima do `Navigator`. O fundo da aplicação já é o `background` do tema ativo.
- As 12 páginas dos fundamentos montam a própria aparência com tokens fixos:
  - `ColoredBox(color: light.base)`;
  - `DefaultTextStyle(color: light.text)`;
  - espaçamentos `fallback()`.

  Por isso, no tema escuro, a página inteira aparece clara.
- Comparações intencionais, que devem continuar mostrando os dois modos ou as duas densidades:
  - "Cor": `_ModePanel(Claro)` e `_ModePanel(Escuro)`;
  - "Estados": `_ModeStrip(claro)` e `_ModeStrip(escuro)`;
  - "Densidade": `_DensityColumn` com os tokens de cada densidade;
  - "Tema": a prévia montada por `ThemePage.themeFor(...)`.
- Os testes `elevation_page_test`, `gallery_app_test`, `rebic_spacing_page_test`, `rebic_theme_page_test`,
  `states_page_test` e `theme_page_test` usam tokens claros nas comparações. Nos testes, o tema padrão é claro e
  confortável, e por isso os valores esperados continuam válidos onde a página passa a ler o tema. Só os testes que
  dependem da cor do cromo precisam de ajuste.

## Goals / Non-Goals

**Goals:**
- todas as páginas seguem o tema e a densidade escolhidos;
- comparações explícitas preservadas;
- um teste que impede a regressão.

**Non-Goals:**
- redesenho das páginas;
- mudanças no framework.

## Decisions

### D1. Origem dos tokens

Cada página faz `final theme = RebicThemeData.of(context);` e usa:
- `theme.colors` no fundo (`base`), no texto (`text`), nos rótulos (`label`) e nas superfícies de amostra
  (`background`, `headerBackground`);
- `theme.spacing`, `theme.typography`, `theme.radius`, `theme.motion`, `theme.icons`, `theme.breakpoints` e
  `theme.elevation` nas escalas mostradas.

Assim, as páginas de escala mostram os valores da densidade e do tema escolhidos: em compacto, o espaçamento compacto.

**Alternativa:** migrar as páginas para `RebicPage` e `RebicText`. Foi descartada por ser um redesenho maior. A troca
da origem dos tokens resolve o problema com mudanças pequenas e mantém os testes das páginas.

### D2. Comparações

Os painéis que comparam modos ou densidades ficam dentro do widget `GalleryComparison`
(`lib/pages/gallery_comparison.dart`), que só marca o painel. Eles continuam recebendo tokens fixos, sempre rotulados ("Claro", "Escuro",
"Confortável", "Compacto"). Só o que está em volta deles, como o fundo da página, os títulos e o "← Voltar", passa a
seguir o tema.

Na página "Tema", a variável `page` passa a ser `RebicThemeData.of(context)`, e a prévia continua usando o tema
configurado pelos botões.

### D3. Teste de regressão

`apps/rebic_gallery/test/gallery_dark_theme_test.dart`, com o cenário "[Documentação] Exemplos mínimos — Páginas da
galeria no tema escuro". Para cada página de `galleryPages`, o teste:
1. abre a galeria, escolhe "Tema: escuro" e abre a página;
2. busca o primeiro `ColoredBox` e o primeiro `DefaultTextStyle` abaixo do `Navigator`, fora dos painéis de
   comparação, e exige as cores do tema escuro. Os painéis são reconhecidos pelo ancestral `GalleryComparison`.

   Uma `ValueKey` repetida em painéis irmãos, como "Claro" e "Escuro", seria uma chave duplicada, e por isso foi
   trocada pelo widget marcador;
3. volta ao índice.

As páginas dos widgets, que não pintam fundo próprio, passam pela regra porque não têm `ColoredBox` na raiz.

O teste de rastreabilidade do `RebicApp` em `rebic_widgets` passa de 20 para 21 cenários.

## Risks / Trade-offs

- [Testes das páginas comparam com tokens fixos] → No tema padrão dos testes, claro e confortável, os valores são os
  mesmos. Só os que verificam o cromo são ajustados.
- [Nova página dos fundamentos voltar a usar tokens fixos] → O teste de regressão percorre `galleryPages`, e
  qualquer página nova entra nele automaticamente.

## Migration Plan

Só a galeria muda; nada a migrar.
