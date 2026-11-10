# Proposal: GjaPage (`gja/widgets/gja-page`)

## Why

`GjaScaffold` estrutura a aplicação, mas cada tela ainda monta o próprio título, a rolagem e as ações finais. A
galeria repete um `ListView` com um "← Voltar" em texto em todas as páginas.

O design da Fase 0 previu `GjaPage` com cabeçalho, conteúdo e rodapé de ações, no papel do `sap.m.Page` e do
`sap.f.DynamicPage` do SAPUI5:
- uma área de título com o botão de voltar (`showNavButton`/`navButtonPress`), o título, o subtítulo e as ações da
  página;
- o conteúdo, que rola entre o título e o rodapé;
- o rodapé fixo com as ações finais (Salvar, Cancelar), alinhadas ao fim.

Com ela, a Fase 1 (fundação e layout) fica completa.

## What Changes

- Widget `GjaPage` em `gja_widgets`:
  - `title` (obrigatório) e `subtitle`, com o título anunciado como cabeçalho;
  - `onBack`: quando informado, mostra o botão de voltar no início da área de título;
  - `actions`: ações da página, no fim da área de título;
  - `body`: o conteúdo, com a margem `pageMargin` do tema (`padded`, padrão `true`). Ele rola verticalmente entre o
    título e o rodapé, ou recebe a altura disponível quando `scrollable` é `false`, para listas e tabelas com
    rolagem própria;
  - `footerActions`: rodapé fixo com as ações alinhadas ao fim, mostrado só quando há ações.
- A área de título e o rodapé ficam na superfície `base`, separados do conteúdo por divisores.
- Em `gja/core/localization`, o texto novo `back` ("Voltar" / "Back"), rótulo do botão de voltar.
- Refatoração interna, sem mudança de comportamento: o botão de ícone da família `transparent` do `GjaScaffold`
  passa a ser um widget interno compartilhado com o botão de voltar. Ele não é exportado; o `GjaIconButton` da
  Fase 2 o substituirá.
- Página "GjaPage" na galeria.

Fora do escopo:
- Cabeçalho expansível que recolhe ao rolar (`DynamicPage` com `headerExpanded`) e título fixo com variante
  recolhida.
- Margem do conteúdo por classe de tela (`sapUiResponsivePadding`).
- Os botões das ações (`GjaButton`, Fase 2): `actions` e `footerActions` são slots.
- Migrar as páginas existentes da galeria para `GjaPage`. Só a página nova a usa.

## Capabilities

### New Capabilities

- `gja/widgets/gja-page`: página com área de título (voltar, título, subtítulo, ações), conteúdo rolável ou de
  altura limitada, e rodapé fixo de ações.

### Modified Capabilities

- `gja/core/localization`: o requisito "Textos do framework" ganha o texto `back`.

## Impact

- **Código:**
  - `packages/gja_widgets/lib/src/fundacao_layout/page/` e testes, com goldens;
  - o botão interno extraído do `GjaScaffold`. Os testes e goldens do scaffold devem continuar passando sem
    mudança;
  - `packages/gja_core/lib/src/localization/localizations.dart`: novo getter abstrato `back`. A única subclasse
    própria, a do teste de extensão, é atualizada. Isso segue o precedente de `navigation`, aceito por ser um
    protótipo sem consumidores externos.
- **Galeria:** nova página "GjaPage".
- **Catálogo:** `gja/widgets/gja-page` → `implemented`, com as dependências usadas de fato.
  `gja/widgets/gja-scaffold` continua na lista, como a estrutura em que a página é usada, verificada por um
  cenário de integração.
- **Portal existente:** sem impacto.
