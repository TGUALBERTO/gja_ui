# Proposal: GjaRow e GjaColumn (`gja/widgets/gja-row`, `gja/widgets/gja-column`)

## Why

Quase toda tela organiza itens lado a lado ou empilhados, com espaço uniforme entre eles. Hoje isso pede `Row` ou
`Column` com um `GjaSpacing` inserido à mão entre cada par de filhos, como fazem as páginas da galeria. O código
fica repetido, o espaço pode faltar ou sobrar nas pontas, e o espaçamento não tem um padrão.

No SAPUI5, `sap.m.HBox` e `sap.m.VBox` (sobre `sap.m.FlexBox`) cobrem esse papel:
- `justifyContent` alinha no eixo principal;
- `alignItems` alinha no eixo cruzado;
- `wrap` quebra a linha.

O espaço entre itens vem das classes de margem do tema. `GjaRow` e `GjaColumn` são o equivalente, com o espaço
entre filhos dado por um `GjaSpace`.

**Por que numa change só:** é a exceção do ADR 0007, citada no próprio design da Fase 0
(`GjaRow` + `GjaColumn`). Os dois widgets têm a mesma regra de espaço, os mesmos alinhamentos e a mesma
implementação, mudando só o eixo. Specificá-los em separado duplicaria a decisão e permitiria que divergissem.

## What Changes

- Enums de alinhamento:
  - `GjaMainAlignment`: `start`, `center`, `end`, `spaceBetween`;
  - `GjaCrossAlignment`: `start`, `center`, `end`, `stretch`.
- `GjaRow` (horizontal) e `GjaColumn` (vertical), com:
  - `children`;
  - `gap` (`GjaSpace`): padrão `inlineGap` na linha e `stackGap` na coluna. O espaço entra só entre filhos, nunca
    nas pontas;
  - `mainAlignment`, `crossAlignment`;
  - `shrinkWrap`: ocupar só o necessário no eixo principal;
  - `Expanded`/`Flexible` nativos funcionam entre os filhos.
- `GjaRow.wrap`: quebra a linha quando falta largura, com `gap` também entre as linhas. Nesse modo, filhos
  expansíveis não são aceitos.
- Página "GjaRow e GjaColumn" na galeria.

Fora do escopo:
- Grade responsiva (`GjaGrid`) e layout por classe de tamanho (`GjaResponsiveLayout`).
- Divisores entre filhos (`GjaDivider`, próxima change).
- Rolagem.
- Coluna com quebra.

## Capabilities

### New Capabilities

- `gja/widgets/gja-row`: linha com espaço nomeado entre filhos, alinhamentos, ajuste ao conteúdo e quebra
  opcional.
- `gja/widgets/gja-column`: coluna com espaço nomeado entre filhos, alinhamentos e ajuste ao conteúdo.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:**
  - `packages/gja_widgets/lib/src/fundacao_layout/row/` e `column/`;
  - lógica comum interna em `fundacao_layout/flex/`, não exportada;
  - testes.
- **Galeria:** nova página "GjaRow e GjaColumn".
- **Catálogo:** `gja/widgets/gja-row` e `gja/widgets/gja-column` → `implemented`. Às dependências
  (`gja-spacing`) somam-se `spacing`, `density` e `theming`.
- **Portal existente:** sem impacto.
