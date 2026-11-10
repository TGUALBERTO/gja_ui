## MODIFIED Requirements

### Requirement: Semântica e cursor
O elemento MUST expor ao leitor de tela o papel de botão (ou de link, quando assim indicado), o rótulo recebido, o estado habilitado e o selecionado, e a ação de toque quando habilitado. Com ação, o cursor do ponteiro MUST ser o de clique.

#### Scenario: Semântica de botão
- **WHEN** a árvore semântica de um elemento habilitado e selecionado, com rótulo "Salvar", é inspecionada
- **THEN** ele é botão, tem o rótulo "Salvar", está habilitado e selecionado e tem a ação de toque

#### Scenario: Semântica de link
- **WHEN** a árvore semântica de um elemento habilitado indicado como link, com rótulo "Ver pedido", é inspecionada
- **THEN** ele tem o papel de link e não o de botão, tem o rótulo "Ver pedido", está habilitado e tem a ação de toque
