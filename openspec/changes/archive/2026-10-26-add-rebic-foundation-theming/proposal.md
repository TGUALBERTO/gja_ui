# Proposal: Fundamento de tema (`rebic/foundation/theming`)

## Why

Os onze fundamentos já existem como conjuntos de tokens separados, mas nenhum objeto os reúne. O `RebicTheme`
(o widget que propaga o tema), todos os widgets e as duas exigências da spec `rebic/framework-architecture`
("Troca de tema altera todos os componentes" e "Duas aplicações com temas diferentes") precisam de um tema
centralizado, com variantes claro e escuro, densidade e personalização de marca controlada. Este é o último
fundamento da Fase 1.

## What Changes

- `RebicThemeData`: um objeto imutável que reúne o brilho (claro ou escuro) e os conjuntos de cor, tipografia,
  densidade (com espaçamento), raios, elevação, movimento, ícones, estados de interação e breakpoints.
  - Também traz as coleções tipadas `components` (tokens de componente dos widgets) e `extensions` (tokens da aplicação).
- Temas de referência `RebicThemeData.light()` e `.dark()`, com parâmetro de densidade, e `withDensity`.
- Resolução de acessibilidade do tema: `resolve(disableAnimations:)` aplica o movimento reduzido, e
  `accessibilityIssues()` lista os problemas de um tema personalizado (pares de contraste abaixo do mínimo e alvo abaixo de 24).
- Interpolação entre temas (troca animada claro ↔ escuro), igualdade por valor e `copyWith` por conjunto.
- Página "Tema" na galeria, com controles de brilho, densidade e marca de exemplo, mostrando uma prévia montada só com o `RebicThemeData`.

Fora do escopo:
- Propagar o tema pela árvore e trocá-lo por subárvore (`add-rebic-theme`).
- Detectar o brilho e o movimento reduzido da plataforma (`RebicTheme`/`RebicApp`).
- Tokens de componente de cada widget, que entram na change de cada widget, nesta coleção.

## Capabilities

### New Capabilities

- `rebic/foundation/theming`: tema centralizado, temas de referência claro e escuro, densidade no tema, personalização
  controlada com verificação de acessibilidade, movimento reduzido, tokens de componente e extensões, e interpolação entre temas.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_foundation/lib/src/theming/`, exportação em `rebic_foundation.dart` e testes em
  `packages/rebic_foundation/test/theming/`.
- **Catálogo:** `rebic/foundation/theming` → `implemented`. As onze dependências, incluindo `iconography` e `accessibility`, já estão no catálogo.
- **Galeria:** nova página "Tema".
- **Dependências:** todos os onze fundamentos (já são specs principais), P0 e fase 1. Nenhum pacote novo.
- **Portal existente:** sem impacto.
