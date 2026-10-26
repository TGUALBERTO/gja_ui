# Proposal: Fundamento de breakpoints (`rebic/foundation/breakpoints`)

## Why

O framework precisa de um vocabulário único de classes de tamanho de tela, para que layouts, grade, navegação e
tabelas mudem de forma coerente entre celular, tablet e desktop, sem que cada widget escolha larguras próprias.
`core/responsive`, `RebicResponsiveLayout`, `RebicGrid` e `RebicScaffold` dependem deste item, e a seção
`[Responsividade]` do template de spec de widget referencia os breakpoints dos fundamentos.

## What Changes

- Escala primitiva de larguras em pixels lógicos (`RebicBreakpointPrimitives`), em `rebic_primitives.dart`.
- Enum `RebicSizeClass` (`small`, `medium`, `large` e `extraLarge`), com comparação de ordem (`isAtLeast`, `isAtMost`).
- Conjunto semântico `RebicBreakpointTokens`, com as larguras mínimas de `medium`, `large` e `extraLarge`.
  - O mapeamento de referência `fallback()` usa 600, 1024 e 1440.
  - O conjunto classifica qualquer largura disponível em uma classe de tamanho, com regras de borda definidas
    (limite inclusivo, largura zero, largura ilimitada e valores inválidos).
- Página "Breakpoints" na galeria, que mostra a classe da largura atual da janela.

Fora do escopo:
- Medir a largura disponível na árvore de widgets (`MediaQuery`/`LayoutBuilder`) e reconstruir ao mudar de classe
  (`add-rebic-core-responsive`).
- Colunas e espaçamentos por classe (`add-rebic-grid`, `add-rebic-responsive-layout`).
- Orientação e tipo de dispositivo: a classe depende só da largura.

## Capabilities

### New Capabilities

- `rebic/foundation/breakpoints`: escala primitiva de larguras, classes de tamanho, limiares semânticos, regra de
  classificação de uma largura e mapeamento de referência.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_foundation/lib/src/breakpoints/`, exportações em `rebic_foundation.dart` e em
  `rebic_primitives.dart`, e testes em `packages/rebic_foundation/test/breakpoints/`.
- **Galeria:** nova página "Breakpoints".
- **Catálogo:** `rebic/foundation/breakpoints` → `implemented`.
- **Dependências:** apenas `rebic/foundation/design-tokens` (já é spec principal), P0 e fase 1, coerente com o
  catálogo. Nenhum pacote novo.
- **Portal existente:** sem impacto.
