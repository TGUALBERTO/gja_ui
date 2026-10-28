# Proposal: Largura padrão do RebicPopover (`rebic/widgets/rebic-popover`)

## Why

Hoje a largura do `RebicPopover` segue o conteúdo, entre 4 e 8 passos `spacing.xxxl`. Na página da galeria, isso dá
popovers de larguras bem diferentes lado a lado:
- "Filtros" fica com ~205 px, porque usa a largura mínima;
- "Detalhes do pedido" fica com ~340 px, porque segue o texto.

Além disso, nada impede o popover de ficar mais estreito que a âncora. Isso vai pesar no `RebicDropdown`, cuja lista
deve ter ao menos a largura do campo, como no `sap.m.Select`.

No Fiori, os popovers de um app usam larguras padronizadas (`contentWidth`), e só conteúdos largos, como tabelas,
pedem uma largura maior. A largura passa a ser uma escolha do tema, igual entre popovers, com uma exceção explícita.

## What Changes

- Novo enum `RebicPopoverWidth`, com dois valores:
  - `standard` (padrão): 8 passos `spacing.xxxl`, 384 nos tokens de referência;
  - `wide`: 12 passos, 576 nos tokens de referência, para conteúdos largos como tabelas e listas com colunas.
- Nova propriedade `width` no `RebicPopover`, com padrão `standard`.
- A largura do popover passa a ser a maior entre a largura escolhida e a largura da âncora. Ela continua limitada à
  área da sobreposição menos as margens de `rebic/core/overlay`. Ela não segue mais o conteúdo: textos longos quebram
  em linhas, e conteúdos curtos ficam na mesma largura dos demais popovers.
- Os requisitos `[API] Propriedades` e `[Comportamento] Posição, tamanho e rolagem` mudam. Entra o requisito
  `[API] Posição e largura`, com `side`, `alignment` e `width`.
- Os goldens e a página da galeria são atualizados. Os dois popovers da página passam a ter a mesma largura.

**Compatibilidade:** quebra para popovers que hoje ficam mais estreitos ou mais largos que 384. O Rebic é um
protótipo, o portal não usa o `RebicPopover`, e o widget saiu nesta mesma versão não lançada.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/widgets/rebic-popover`:
  - largura padrão do tema, com a exceção `wide`;
  - largura mínima igual à da âncora;
  - fim da largura pelo conteúdo.

## Impact

- **Código:** `packages/rebic_widgets/lib/src/feedback_sobreposicoes/popover/rebic_popover.dart` e testes, com os
  goldens regenerados.
- **Galeria:** a página "RebicPopover" passa a mostrar os dois popovers na largura padrão.
- **Catálogo:** sem mudança de status nem de dependências.
- **Portal existente:** sem impacto.
