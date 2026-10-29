## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicIcon` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `icon` (posicional) | `IconData` | obrigatória |
| `size` | `RebicIconSize` | `control` |
| `tone` | `RebicIconTone` | `standard` |
| `semanticLabel` | `String?` | nulo (decorativo) |

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `RebicApp` e o tema claro
- **WHEN** `RebicIcon(RebicIcons.search)` é criado
- **THEN** o ícone tem o tamanho `control` e a cor `text` do tema, e fica fora da árvore de semântica

### Requirement: [Comportamento] Espelhamento em RTL
`RebicIcon` SHALL espelhar os ícones direcionais do catálogo quando a direção do texto é da direita para a esquerda e manter os demais, conforme `rebic/foundation/iconography`.

#### Scenario: Direcional em RTL
- **GIVEN** a direção de texto da direita para a esquerda
- **WHEN** `RebicIcon(RebicIcons.slimArrowRight)` e `RebicIcon(RebicIcons.accept)` são renderizados
- **THEN** o primeiro é desenhado espelhado, e o segundo não

### Requirement: [Acessibilidade] Semântica e contraste
Sem `semanticLabel`, `RebicIcon` MUST ficar fora da árvore de semântica (decorativo). Com `semanticLabel`, MUST ser anunciado como imagem com esse rótulo. As cores de `tone` MUST ter contraste ≥ 3:1 sobre `base` e `background` nos dois temas, conforme `rebic/foundation/accessibility` para elementos não textuais.

#### Scenario: Ícone decorativo
- **WHEN** um leitor de tela percorre uma página com `RebicIcon(RebicIcons.search)` sem rótulo
- **THEN** nada é anunciado para o ícone

#### Scenario: Ícone com significado
- **WHEN** um leitor de tela percorre `RebicIcon(RebicIcons.warning, tone: warning, semanticLabel: 'Aviso')`
- **THEN** anuncia "Aviso" como imagem

#### Scenario: Contraste dos tons
- **WHEN** a razão de contraste de cada cor de `tone` é calculada sobre `base` e `background`, nos temas claro e escuro
- **THEN** todas são ≥ 3:1
