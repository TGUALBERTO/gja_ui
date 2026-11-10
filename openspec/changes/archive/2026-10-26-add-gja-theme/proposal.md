# Proposal: GjaTheme (`gja/widgets/gja-theme`)

## Why

`GjaThemeData` reúne todos os fundamentos, mas ainda não chega à árvore de widgets. Por isso, `GjaInteractable`,
`GjaModal`, `GjaAnchoredOverlay` e as consultas de responsividade recebem os valores visuais por parâmetro, com o
mapeamento claro de referência como padrão. A galeria também monta cada página com `GjaThemeData.light()` fixo. Uma
aplicação não consegue, por exemplo, trocar para o tema escuro ou para a densidade compacta e ver o framework inteiro
acompanhar.

No SAPUI5, o tema é aplicado à aplicação inteira (`sap_horizon`, `sap_horizon_dark`) e a densidade vem de uma classe
num contêiner (`sapUiSizeCompact`), que vale para a subárvore. O GJA precisa do mesmo: um tema ativo na árvore, uma
troca de densidade por subárvore e componentes do núcleo que leem o tema quando o valor não é passado. Esta change é
o primeiro widget público e o último pré-requisito de `GjaApp`.

## What Changes

- **Foundation (`gja/foundation/theming`):** o tema passa a ser publicado na árvore por um escopo herdado, e
  `GjaThemeData.of(context)` lê o tema mais próximo. Sem tema na árvore, a leitura usa o tema claro de referência,
  e o movimento é reduzido quando o sistema pede. A consulta fica na `foundation` porque o `gja_core` não pode
  depender de `gja_widgets`, e a arquitetura já põe o tema nessa camada.
- **Widget `GjaTheme` (`gja_widgets`):**
  - aplica um `GjaThemeData` à subárvore e anima a troca de tema com a duração `medium` do movimento (sem animação
    quando o movimento é reduzido);
  - `GjaTheme.density` troca só a densidade de uma subárvore, como o `sapUiSizeCompact`;
  - define o estilo de texto padrão (`body`, cor `text`) e o ícone padrão (cor `text`, tamanho `control`) da subárvore.
- **Núcleo, compatível:** os parâmetros visuais de `GjaInteractable`, `GjaModal`, `GjaAnchoredOverlay`,
  `GjaScreenSizeScope`, `GjaResponsive.screenSizeClassOf` e `GjaResponsiveBuilder` passam a ser opcionais. Sem
  eles, os valores vêm do tema ativo. Os valores passados continuam tendo precedência.
- **Galeria:** envolve as rotas em `GjaTheme` com o tema claro, e as páginas do núcleo (interação, localização,
  responsividade e sobreposições) passam a ler o tema ativo. A nova página "GjaTheme" alterna claro/escuro com a
  troca animada e mostra uma subárvore compacta ao lado de uma confortável. As páginas de fundamento continuam
  mostrando claro e escuro lado a lado, como já fazem.

Fora do escopo:
- `GjaApp` (próxima change), que vai combinar `WidgetsApp`, `GjaTheme`, localização e o escopo de tela.
- Seguir automaticamente o brilho do sistema operacional, que fica com `GjaApp` (`theme`/`darkTheme`).
- Tokens de componente de widgets que ainda não existem.

## Capabilities

### New Capabilities

- `gja/widgets/gja-theme`: widget que aplica e anima o tema na subárvore, troca a densidade por subárvore e
  define o texto e o ícone padrão.

### Modified Capabilities

- `gja/foundation/theming`: o tema é publicado na árvore e lido com `GjaThemeData.of`, com reserva e movimento
  reduzido.
- `gja/core/interaction`: o alvo mínimo, o anel de foco e a cor de foco vêm do tema ativo quando não são passados.
- `gja/core/overlay`: a cor da camada e os espaçamentos da sobreposição ancorada vêm do tema ativo quando não são
  passados.
- `gja/core/responsive`: os limiares vêm do tema ativo quando não são passados.

## Impact

- **Código:**
  - `gja_foundation`: `theming/theme_scope.dart`;
  - `gja_widgets`: `lib/src/fundacao_layout/theme/` (primeiro widget);
  - `gja_core`: parâmetros opcionais nos componentes citados.
- **Galeria:** `main.dart`, páginas de interação, sobreposições e responsividade, e a nova página "GjaTheme".
- **Catálogo:** `gja/widgets/gja-theme` → `implemented`, com as dependências do `[Integração]`.
- **Compatibilidade:** sem quebra. Os parâmetros passam de obrigatórios com padrão a opcionais. Sem tema na árvore,
  o resultado é igual ao atual.
- **Portal existente:** sem impacto.
