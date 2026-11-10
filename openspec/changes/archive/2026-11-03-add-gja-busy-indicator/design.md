# Design: Indicador de ocupado

## Decisions

### D1. Pontos

Um `StatefulWidget` com um `AnimationController` de duração `4 × motion.long`, repetido. Cada ponto `i` tem a
opacidade e a escala de uma onda deslocada em `i / 3` do ciclo. Com `motion.long` zero (movimento reduzido), o
controlador não roda, e os pontos ficam com opacidade e escala cheias.

### D2. Sobre o conteúdo

`Stack` com o `child` em `ExcludeSemantics`, `ExcludeFocus`, `IgnorePointer` e `Opacity(disabledOpacity)` enquanto
`busy`, e os pontos centrados por cima. O `Stack` tem o tamanho do conteúdo.

### D3. Semântica

`Semantics(liveRegion: true, label: text ?? loading)` em volta dos pontos, com os pontos e o texto visual em
`ExcludeSemantics`.
