# Design: Painel

## Decisions

### D1. Controlado

Como os outros widgets do Rebic, `expanded` é do pai: acionar o cabeçalho chama `onExpand(!expanded)`, como o evento
`expand` do UI5, e o painel não muda sozinho. Sem `onExpand`, o cabeçalho de um painel expansível fica desabilitado.

### D2. Montagem

`Semantics(container)` com uma `Column`: o cabeçalho (altura `density.listItemHeight`, borda inferior
`colors.separator` quando o conteúdo aparece) e o conteúdo (`spacing.l` em volta, itens de `content` empilhados). No
painel expansível, o cabeçalho é um `RebicInteractable` dentro de `Semantics(expanded:)`, com a seta `slimArrowRight`
no início, girada um quarto de volta quando aberto (`AnimatedRotation`, sentido trocado em RTL), e o título
`typography.header6`. O fundo é `colors.base` (`solid`) ou nenhum (`transparent`).

### D3. Abrir e fechar

O conteúdo fica num `AnimatedSize` (`motion.medium`, curva `motion.standard`) com `Visibility(maintainState:)`:
recolhido, ocupa altura zero, sai da semântica e do foco, mas mantém o estado dos campos. Com movimento reduzido, as
durações do tema valem zero e a troca é imediata.

### D4. Acordeão

Não há widget de acordeão: a página da galeria empilha `RebicPanel` expansíveis num `RebicVBox`, e quem quiser só um
aberto controla isso pelo `expanded` de cada um.
