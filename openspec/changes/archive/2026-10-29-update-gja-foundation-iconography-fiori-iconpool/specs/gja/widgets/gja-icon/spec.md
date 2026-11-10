## MODIFIED Requirements

### Requirement: [API] Propriedades
`GjaIcon` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `icon` (posicional) | `IconData` | obrigatória |
| `size` | `GjaIconSize` | `control` |
| `tone` | `GjaIconTone` | `standard` |
| `semanticLabel` | `String?` | nulo (decorativo) |

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `GjaApp` e o tema claro
- **WHEN** `GjaIcon(GjaIcons.search)` é criado
- **THEN** o ícone tem o tamanho `control` e a cor `text` do tema, e fica fora da árvore de semântica

### Requirement: [Comportamento] Espelhamento em RTL
`GjaIcon` SHALL espelhar os ícones direcionais do catálogo quando a direção do texto é da direita para a esquerda e manter os demais, conforme `gja/foundation/iconography`.

#### Scenario: Direcional em RTL
- **GIVEN** a direção de texto da direita para a esquerda
- **WHEN** `GjaIcon(GjaIcons.slimArrowRight)` e `GjaIcon(GjaIcons.accept)` são renderizados
- **THEN** o primeiro é desenhado espelhado, e o segundo não

### Requirement: [Acessibilidade] Semântica e contraste
Sem `semanticLabel`, `GjaIcon` MUST ficar fora da árvore de semântica (decorativo). Com `semanticLabel`, MUST ser anunciado como imagem com esse rótulo. As cores de `tone` MUST ter contraste ≥ 3:1 sobre `base` e `background` nos dois temas, conforme `gja/foundation/accessibility` para elementos não textuais.

#### Scenario: Ícone decorativo
- **WHEN** um leitor de tela percorre uma página com `GjaIcon(GjaIcons.search)` sem rótulo
- **THEN** nada é anunciado para o ícone

#### Scenario: Ícone com significado
- **WHEN** um leitor de tela percorre `GjaIcon(GjaIcons.warning, tone: warning, semanticLabel: 'Aviso')`
- **THEN** anuncia "Aviso" como imagem

#### Scenario: Contraste dos tons
- **WHEN** a razão de contraste de cada cor de `tone` é calculada sobre `base` e `background`, nos temas claro e escuro
- **THEN** todas são ≥ 3:1
