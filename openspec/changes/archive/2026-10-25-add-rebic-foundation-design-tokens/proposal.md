# Proposal: Fundamento de design tokens (`rebic/foundation/design-tokens`)

## Why

Todos os outros fundamentos (cores, tipografia, espaçamento, raios, elevação, breakpoints, ícones) e todos os widgets
dependem de um modelo comum de tokens. A ADR 0005 decidiu os três níveis (primitivo, semântico e de componente),
mas ainda não existe contrato que diga como um conjunto de tokens é declarado, comparado, interpolado entre temas e
estendido pela aplicação. Sem esse contrato, cada fundamento inventaria o seu formato. Este é o primeiro item P0 da
Fase 1 e não tem dependências.

## What Changes

- Novo contrato `RebicTokenSet<T>` em `rebic_foundation`. Todo conjunto de tokens dos níveis semântico e de componente
  é imutável, tem construtor `const`, `copyWith`, `lerp`, igualdade por valor e diagnóstico (`Diagnosticable`).
- Classificação explícita dos três níveis, com nomenclatura de cada um:
  - primitivos por posição na escala;
  - semânticos por papel;
  - de componente por `<widget>.<variante>.<propriedade>`.
- Biblioteca separada `package:rebic_foundation/rebic_primitives.dart` para os primitivos. Ela não é reexportada por
  `rebic_foundation.dart` nem por `rebic_ui.dart`, e a camada `widgets` não pode importá-la.
- Tokens de movimento (durações e curvas), primitivos e semânticos. Nenhum outro fundamento do catálogo cobre
  "durações de animação", que a spec `rebic/framework-architecture` exige vindas dos tokens.
- Extensões tipadas (`RebicTokenExtension<T>`) para tokens próprios da aplicação, com busca por tipo e interpolação
  junto com o restante do tema.
- `rebic_checks architecture` passa a rejeitar import de `rebic_primitives.dart` em `packages/rebic_widgets/lib`
  e em `packages/rebic_core/lib`.
- Página "Design tokens" na galeria, com o catálogo de primitivos de movimento e a demonstração de interpolação.

Fora do escopo: a paleta, as escalas de tipografia, espaçamento, raios e elevação, os breakpoints e os ícones,
cada um com change própria. Também ficam de fora o `RebicThemeData`, os temas claro e escuro e o widget
`RebicTheme`, que pertencem a `add-rebic-foundation-theming` e `add-rebic-theme`.

## Capabilities

### New Capabilities

- `rebic/foundation/design-tokens`: modelo de tokens em três níveis, contrato dos conjuntos de tokens (imutabilidade,
  `copyWith`, `lerp`, igualdade), nomenclatura, isolamento dos primitivos, tokens de movimento e extensões tipadas da
  aplicação.

### Modified Capabilities

Nenhuma. A regra de que os widgets não leem primitivos (ADR 0005) entra como requisito desta capacidade. A verificação
dessa regra reforça o requisito "Aparência centralizada no design system" de `rebic/framework-architecture` sem
alterar o seu texto.

## Impact

- **Código:** `packages/rebic_foundation/lib/src/tokens/`, as novas bibliotecas públicas `rebic_foundation.dart`
  (atualizada) e `rebic_primitives.dart`, e os testes em `packages/rebic_foundation/test/`.
- **Ferramentas:** nova regra em `tool/rebic_checks` (verificação de arquitetura), com fixtures e testes.
- **Galeria:** primeira página (`apps/rebic_gallery`), ainda sobre o `WidgetsApp` provisório.
- **Catálogo:** `rebic/foundation/design-tokens` passa de `planned` para `implemented`.
- **Dependências:** nenhuma nova. Só o SDK Flutter (`widgets`/`foundation`/`animation`), dentro da baseline da ADR 0001.
- **Dependências de catálogo:** nenhuma (`depends_on: []`), prioridade P0, fase 1. É coerente com o catálogo.
- **Portal existente:** sem impacto. Nenhum arquivo do portal é lido ou alterado, e a adoção continua dependendo de
  change dedicada com aprovação explícita.
