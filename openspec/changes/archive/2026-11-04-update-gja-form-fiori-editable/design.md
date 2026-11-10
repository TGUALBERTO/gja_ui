# Design: Formulário de exibição

## Decisions

### D1. Só o alinhamento do rótulo

`editable` chega ao elemento: com `true`, o rótulo ao lado fica num `ConstrainedBox` de altura mínima
`density.minTargetSize`, centrado, como hoje; com `false`, o rótulo fica no topo, sem altura mínima, alinhado ao
primeiro texto dos campos. Os rótulos acima dos campos não mudam.
