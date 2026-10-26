# Proposal: Fundamento de tipografia (`rebic/foundation/typography`)

## Why

Todo texto dos widgets precisa de tamanho, altura de linha e peso vindos do design system. `rebic_checks tokens`
já rejeita `TextStyle(fontSize: 14)` nos widgets, mas ainda não existe o conjunto de estilos que o substitui.
A densidade, a acessibilidade, o tema e os widgets `RebicText`/`RebicButton` dependem deste item. Além disso,
os goldens previstos no design da Fase 0 exigem uma fonte empacotada, igual em todos os sistemas operacionais.

## What Changes

- Fonte **Inter 4.1** (SIL Open Font License 1.1) empacotada em `rebic_foundation`, nos pesos 400, 500, 600 e 700,
  com o arquivo de licença. É a escolha **provisória** do protótipo para a questão em aberto 3 do design da Fase 0.
  Não é uma fonte SAP.
- Primitivos tipográficos (`RebicTypographyPrimitives`) em `rebic_primitives.dart`: família e fontes de fallback,
  escala de tamanhos (12 a 40), escala de alturas de linha em pixels (16 a 48) e pesos.
- Conjunto semântico `RebicTypographyTokens` com os estilos `display`, `headline`, `title`, `subtitle`, `body`,
  `bodyStrong`, `label` e `caption`, e o mapeamento de referência `fallback()`. Os estilos não definem cor,
  que vem dos papéis de cor.
- Página "Tipografia" na galeria, com uma amostra de cada estilo, renderizada com a Inter empacotada.

Fora do escopo:
- Tamanhos por densidade (`add-rebic-foundation-density`).
- Escala de texto do sistema e tamanho mínimo de alvo (`add-rebic-foundation-accessibility`).
- Números tabulares e outros estilos derivados por componente (por exemplo, tabela).
- Fonte monoespaçada.

## Capabilities

### New Capabilities

- `rebic/foundation/typography`: fonte empacotada e licenciada, escalas tipográficas primitivas, estilos semânticos
  de texto, regras de ritmo vertical e tamanho mínimo, e o mapeamento de referência.

### Modified Capabilities

Nenhuma.

## Impact

- **Código e assets:**
  - `packages/rebic_foundation/lib/src/typography/`;
  - `packages/rebic_foundation/fonts/inter/`: 4 arquivos TTF, com cerca de 1,6 MB no total, e o `OFL.txt`;
  - a seção `flutter: fonts:` do `pubspec.yaml` do pacote;
  - as exportações em `rebic_foundation.dart` e em `rebic_primitives.dart`;
  - os testes.
- **Distribuição:** toda aplicação que depende de `rebic_ui` passa a incluir a fonte no bundle. Isso aumenta o
  bundle web em cerca de 1,6 MB, mitigado no design (D2).
- **Galeria:** nova página "Tipografia".
- **Catálogo:** `rebic/foundation/typography` → `implemented`.
- **Dependências:** apenas `rebic/foundation/design-tokens` (já é spec principal), P0 e fase 1, coerente com o
  catálogo. Nenhum pacote Dart novo.
- **Portal existente:** sem impacto.
