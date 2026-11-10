# Spec Delta

## MODIFIED Requirements

### Requirement: [Restrições] Fora do escopo
`GjaShellBar` SHALL NOT oferecer campo de pesquisa (`searchManager`), Joule (`showCopilot`), larguras, alturas nem cores literais.

#### Scenario: Barra sem valor literal
- **WHEN** a API pública de `GjaShellBar` é inspecionada
- **THEN** não há parâmetro do tipo `double` nem `Color`, nem de pesquisa gerenciada ou Joule

### Requirement: [Integração] Dependências de widgets e núcleo
Dos widgets e do núcleo, `GjaShellBar` SHALL depender somente de `gja/widgets/gja-button`, `gja/widgets/gja-menu`, `gja/widgets/gja-popover`, `gja/widgets/gja-avatar`, `gja/widgets/gja-badge`, `gja/widgets/gja-tooltip`, `gja/widgets/gja-title`, `gja/widgets/gja-container`, `gja/core/interaction`, `gja/core/localization` e `gja/core/responsive`.

#### Scenario: Barra sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** a barra completa é renderizada e seus botões são tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Documentação] Exemplos mínimos
`GjaShellBar` SHALL ter dartdoc em toda API pública e uma página "GjaShellBar" na galeria com a barra completa (com menu no título), a barra só com título e uma barra estreita com títulos truncados e o menu "mais".

#### Scenario: Página GjaShellBar na galeria
- **WHEN** a página "GjaShellBar" é aberta
- **THEN** ela exibe a barra completa, a barra só com título e a barra estreita, e tocar o botão de menu da barra completa mostra uma mensagem

## ADDED Requirements

### Requirement: [Comportamento] Menu mais
Na classe de largura S, as notificações e os `GjaButton` de `additionalContent` SHALL sair da barra para um menu "mais" (botão `GjaIcons.overflow` com a dica `more`), como o `OverflowToolbar` do `sap.f.ShellBar`: as notificações viram o item `notifications`, com o contador entre parênteses, e cada botão um item com o texto (ou a dica), o ícone, o `enabled` e o `onPress` dele. Os outros elementos ficam na barra.

#### Scenario: Notificações no menu mais
- **GIVEN** uma barra de 360 em pt-BR com notificações (4) e o botão adicional "Ajuda"
- **WHEN** o botão "Mais" é tocado, e depois o item "Notificações (4)"
- **THEN** o sino e "Ajuda" não estão na barra, o menu mostra "Notificações (4)" e "Ajuda", e `onNotificationsPressed` é chamado

### Requirement: [Comportamento] Menu do título
Com `menu` (`List<GjaMenuItem>`, padrão vazia), o título SHALL ser um botão com a seta `slimArrowDown` que abre um `GjaMenu` com esses itens, como o `menu` do `sap.f.ShellBar`, anunciado como botão com o título.

#### Scenario: Menu do título
- **GIVEN** uma barra com o título "Compras" e o menu com "Pedidos" e "Contratos"
- **WHEN** o título é tocado, e depois "Contratos"
- **THEN** o menu mostra os dois itens, e o `onPress` de "Contratos" é chamado
