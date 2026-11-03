# Design: Aviso breve

## Decisions

### D1. Overlay

`show` insere um `OverlayEntry` no `Overlay` raiz (`Overlay.of(context, rootOverlay: true)`), guardado numa variável
estática: um novo `show` remove o anterior. O conteúdo é um widget interno com estado, que esmaece de entrada com
`motion.medium`, espera `duration` (`Timer`), esmaece de saída e remove a entrada. Com movimento reduzido, as
durações do tema são zero, e a troca é imediata.

### D2. Caixa

`IgnorePointer` + `ExcludeFocus`, alinhada embaixo e centralizada, com `Padding` inferior `spacing.xxxl`; um
`ConstrainedBox` de largura máxima `min(5 × spacing.xxxl, largura − 2 × spacing.l)` com um `DecoratedBox` (`colors.text`,
`radius.element`) e o texto (`typography.base`, `colors.contrastText`), dentro de `Semantics(liveRegion: true)`.

### D3. Duração

O padrão de 3 segundos é o `duration` do UI5, um valor de comportamento, não de aparência; fica como constante
`RebicMessageToast.defaultDuration`.
