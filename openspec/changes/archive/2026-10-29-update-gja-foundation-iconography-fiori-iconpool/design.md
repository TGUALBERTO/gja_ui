# Design: Ícones no modelo do IconPool

## Context

`GjaIcons` (em `gja_foundation/lib/src/iconography/icons.dart`) declara 38 constantes `IconData` da fonte Lucide
empacotada. Ele também tem um mapa `lucideNames` (nome do catálogo → nome Lucide), que o teste usa para conferir os
códigos com `fonts/lucide/codepoints.json`, e uma lista `all`. Os ícones direcionais têm `matchTextDirection: true`.

Usos dos nomes:
- widgets: `GjaScaffold` (`menu`), `GjaPage` (`arrowLeft`), `GjaDropdown` (`chevronDown`), `GjaAvatar`
  (`user`);
- galeria: cerca de 60 usos;
- testes de foundation e widgets.

`GjaIconTokens.control` vale 20 e é usado por `GjaIcon` (`size: control`), `GjaButton` e `GjaIconButton`.

## Goals / Non-Goals

**Goals:**
- Nomes do IconPool para todos os ícones do catálogo.
- Ícone de controle de 16, como `sapContent_IconHeight`.

**Non-Goals:**
- Trocar os desenhos por glifos SAP. Sem assets da SAP: a fonte Lucide continua, decisão provisória do protótipo.
- Acrescentar ícones novos ao catálogo.

## Decisions

### D1. Nomes

Cada constante tem o nome do IconPool em camelCase, conforme a tabela do proposal.md. Onde o IconPool tem mais de uma
opção, vale a usada pelos controles do SAPUI5:
- `menu2` é o hambúrguer do `sap.f.ShellBar`;
- `navBack` é o voltar do `sap.m.Page`;
- `sysEnter2` é o sucesso do `sap.m.MessageStrip`;
- `pending` é o relógio de status pendente;
- `popupWindow` é "abrir em nova janela".

O desenho Lucide de cada ícone não muda. `lucideNames` passa a ter as chaves novas.

### D2. `iconPoolNames`

Novo mapa constante `GjaIcons.iconPoolNames` (`Map<String, String>`), do nome do catálogo para o nome exato do
IconPool (ex.: `'slimArrowDown': 'slim-arrow-down'`). O IconPool não segue uma regra única de hifenização: `menu2` não
tem hífen, e `sys-enter-2` tem. Por isso o mapa traz o nome exato, e o teste confere a conversão no sentido inverso:
o nome do IconPool, sem hífens e com a letra seguinte maiúscula, é o nome do catálogo.

### D3. `moreVertical`

`moreVertical` é removido do catálogo e de `lucideNames`. O código Lucide continua disponível para aplicações pelo
requisito "Uso de ícones fora do catálogo".

### D4. Tamanho de controle

`GjaIconTokens.fallback().control` passa a `size16`, e `inline` continua 16. Os passos não mudam.
- `GjaButton` e `GjaIconButton` passam a ter ícones de 16.
- `GjaAvatar` dimensiona por `xLarge`, então não muda.

### D5. Galeria e testes

- A página "Ícones" lista `GjaIcons.all` com o nome do catálogo e o nome `sap-icon://` abaixo.
- As demais páginas e os testes passam aos nomes novos por substituição direta, conforme a tabela.

### D6. ADR 0009

Novas linhas provisórias:
- `control` = 16 (`sapContent_IconHeight`, valor do Horizon não confirmado);
- as escolhas de nome de D1 onde há mais de uma opção no IconPool.

## Risks / Trade-offs

- **[Nomes do IconPool não conferidos com a versão atual]** O protótipo não tem acesso ao IconPool atual. → Os nomes
  escolhidos são os usados pelos controles do SAPUI5 conhecidos. Uma divergência é corrigida por uma change
  `update-gja-…`, e a ADR 0009 registra a pendência.
- **[Ícones menores em botões]** Os ícones de botão passam de 20 a 16. É o tamanho do Horizon. → Os goldens de botão,
  botão de ícone, página, scaffold, menu, dropdown e avatar são conferidos por amostragem.
- **[Quebra de API 0.x]** Todos os nomes mudam. → O CHANGELOG traz a tabela de/para.
