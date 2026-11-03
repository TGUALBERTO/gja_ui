# Spec Delta

## MODIFIED Requirements

### Requirement: Semântica e cursor
O elemento MUST expor ao leitor de tela o papel de botão (ou de link, quando assim indicado), o rótulo recebido, o estado habilitado e o selecionado, e a ação de toque quando habilitado. Quando o elemento informa um estado de marcação (`checked`, `mixed`) ou de alternância (`toggled`), MUST expor esse estado no lugar do papel de botão, e, com `inMutuallyExclusiveGroup`, o pertencimento a um grupo exclusivo. Com ação, o cursor do ponteiro MUST ser o de clique.

#### Scenario: Semântica de botão
- **WHEN** a árvore semântica de um elemento habilitado e selecionado, com rótulo "Salvar", é inspecionada
- **THEN** ele é botão, tem o rótulo "Salvar", está habilitado e selecionado e tem a ação de toque

#### Scenario: Semântica de link
- **WHEN** a árvore semântica de um elemento habilitado indicado como link, com rótulo "Ver pedido", é inspecionada
- **THEN** ele tem o papel de link e não o de botão, tem o rótulo "Ver pedido", está habilitado e tem a ação de toque

#### Scenario: Semântica de marcação e alternância
- **WHEN** a árvore semântica de um elemento com `checked` verdadeiro, de um com `mixed`, de um com `toggled` e de um com `checked` e `inMutuallyExclusiveGroup` é inspecionada
- **THEN** nenhum é botão; o primeiro está marcado, o segundo misto, o terceiro alternado, e o quarto marcado num grupo exclusivo
