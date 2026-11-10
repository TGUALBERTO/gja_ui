# Proposal: Sobreposições no modelo do Popup do SAPUI5 (`update-gja-core-overlay-fiori-popup`)

## Why

Com a fundação realinhada, o plano de 2026-10-28 passa ao núcleo, com o modal e o posicionamento. A análise de
`gja/core/overlay` achou estes desvios:

- **Modal dispensável pela camada.** Um toque na camada de bloqueio fecha o modal, e a camada tem o rótulo "Fechar"
  para leitores de tela. É o `barrierDismissible` do Material. No SAPUI5, o `sap.m.Dialog` fecha com Esc
  (`escapeHandler`), e a *block layer* (`sapUiBLy`) não é interativa.
- **Vocabulário.** O parâmetro do modal chama-se `barrierColor`, termo do Material. No SAPUI5 a camada é a block
  layer.
- **Posição.** A sobreposição ancorada usa `side` com `below`, `above`, `start` e `end`. O Popover do SAPUI5 usa
  `placement`, e o dos UI5 Web Components usa os valores `Bottom`, `Top`, `Start` e `End`, que já respeitam RTL.
- **Âncora que muda de tamanho.** O conteúdo só acompanha a âncora na rolagem. Quando a âncora muda de tamanho ou de
  lugar sem rolar, por exemplo numa troca de densidade, o popover fica na posição antiga. O bug foi achado na change
  de movimento. O Popup do SAPUI5 segue o opener.
- **Posição efetiva.** O conteúdo não sabe se houve inversão. O Popover do SAPUI5 usa a posição efetiva para
  desenhar a seta, e a change de popover de 2026-10-28 deixou a seta de fora por falta dessa informação.

## What Changes

- **BREAKING (comportamento)** `GjaModal.show(dismissible: true)` fecha só com Esc. O toque na camada é ignorado
  sempre, e a camada não tem rótulo nem ação na semântica.
- **BREAKING** `GjaModal.show(barrierColor:)` passa a `blockLayerColor:`.
- **BREAKING** `GjaOverlaySide` (`below`, `above`, `start`, `end`) passa a `GjaPlacement` (`bottom`, `top`,
  `start`, `end`), e a propriedade `side` passa a `placement` em:
  - `GjaAnchoredOverlay`;
  - `GjaPopover`;
  - `GjaMenu`;
  - `GjaDropdown`;
  - `GjaTooltip`.

  `GjaOverlayAlignment` não muda.
- `GjaAnchoredOverlay` passa a acompanhar a âncora quando ela muda de posição ou de tamanho, e não só na rolagem.
- `GjaAnchoredOverlay.placementOf(context)` informa ao conteúdo a posição efetiva, depois da inversão.
- A página "Sobreposições" da galeria passa a ter a escolha de `placement`, e o modal dispensável fecha só com Esc.

Fora do escopo:
- A seta do popover, que fica para a change de realinhamento de `GjaPopover`. Esta change só entrega a informação
  de que ela precisa.
- Os padrões de `placement` de cada widget, como o `End` do Popover dos UI5 Web Components. Os widgets mantêm
  `bottom` até as changes de cada um.
- O diálogo (`sap.m.Dialog`) como widget, previsto na Fase 2.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/core/overlay`:
  - dispensa do modal só por Esc, sem camada interativa;
  - posições `bottom`, `top`, `start` e `end`;
  - acompanha a âncora que se move ou muda de tamanho;
  - posição efetiva informada ao conteúdo;
  - página da galeria com a escolha da posição.
- `gja/widgets/gja-popover`, `gja/widgets/gja-menu`, `gja/widgets/gja-dropdown` e
  `gja/widgets/gja-tooltip`: a propriedade `side` (`GjaOverlaySide`, `below`) passa a `placement`
  (`GjaPlacement`, `bottom`).

A change toca quatro specs de widget, acima do limite de `gja/spec-governance`. A exceção se justifica como nas
changes anteriores da série: renomear o tipo de posição do núcleo quebra todas as referências a ele, e só o nome muda
nesses widgets.

## Impact

- `packages/gja_core`: `modal.dart` e `anchored_overlay.dart`, os testes de sobreposição e o CHANGELOG.
- `packages/gja_widgets`: `GjaPopover`, `GjaMenu`, `GjaDropdown`, `GjaTooltip` e a lista de opções interna
  (renomeação), os testes e o CHANGELOG.

  Os goldens não devem mudar: as posições padrão continuam as mesmas.
- `apps/gja_gallery`: página "Sobreposições" e seu teste.
- Sem efeito em `gja_foundation`, no catálogo e no portal.
