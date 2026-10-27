# Proposal: RebicScaffold (`rebic/widgets/rebic-scaffold`)

## Why

Toda aplicação Rebic precisa da mesma moldura: uma barra superior com a identidade e as ações globais, uma área
de navegação lateral e o conteúdo da página. Hoje cada tela da galeria monta isso à mão, com `ListView` e um
"← Voltar" em texto, e não há um lugar comum para a navegação se adaptar ao tamanho da tela.

O design da Fase 0 previu `RebicScaffold` como a barra superior com a navegação lateral, no papel do
`sap.tnt.ToolPage` do SAPUI5, que tem `header`, `sideContent`, `mainContents` e `sideExpanded`:
- no desktop, a navegação fica expandida ao lado do conteúdo;
- no tablet, ela fica recolhida (só ícones) ao lado do conteúdo;
- no celular, ela fica oculta e, quando expandida, ocupa a área do conteúdo.

O botão de menu da barra alterna esse estado, como no `ToolHeader`/`ShellBar`. `RebicSideNavigation` (Fase 2) e
`RebicPage` (próxima change) dependem desta estrutura.

## What Changes

- Widget `RebicScaffold` em `rebic_widgets`:
  - `body` (obrigatório): o conteúdo principal;
  - barra superior na superfície `shell`, com sombra `header`: `logo`, `title` e `actions`, e o botão de
    navegação no início quando há `navigation`. A barra só aparece quando ao menos um desses é informado;
  - `navigation`: o conteúdo da área lateral, com a largura que ele mesmo define e um separador até o corpo;
  - `navigationExpanded` (`bool?`) e `onNavigationExpandedChanged`: estado controlado quando informado. Sem ele,
    o estado é automático: expandido em `large` e `extraLarge`, recolhido em `small` e `medium`. O botão alterna
    o estado, e uma mudança de classe da tela restaura o automático;
  - em `small`, a navegação recolhida fica oculta e a expandida ocupa a área do corpo, que é preservado fora da tela;
  - `RebicScaffold.navigationExpandedOf(context)` informa à navegação se ela deve se desenhar expandida ou
    recolhida.
- Em `rebic/core/localization`, um texto novo `navigation` ("Navegação" / "Navigation"), rótulo do botão.
- Página "RebicScaffold" na galeria.

Fora do escopo:
- O widget de navegação lateral (`RebicSideNavigation`, Fase 2) e os botões de ação (`RebicButton`,
  `RebicIconButton`, Fase 2): aqui, `navigation` e `actions` são slots.
- Cabeçalho, conteúdo rolável e rodapé de ações da página, que são do `RebicPage`.
- Pesquisa, perfil e notificações embutidos na barra, como no `ShellBar` completo.
- Fechar a navegação com Esc ou com toque fora dela.
- Migrar as páginas existentes da galeria para o scaffold. Só a página nova o usa.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-scaffold`: estrutura da aplicação com barra superior, navegação lateral adaptável à classe da
  tela e corpo, com estado de navegação controlado ou automático.

### Modified Capabilities

- `rebic/core/localization`: o requisito "Textos do framework" ganha o texto `navigation`.

## Impact

- **Código:**
  - `packages/rebic_widgets/lib/src/fundacao_layout/scaffold/` e testes, com goldens;
  - `packages/rebic_core/lib/src/localization/localizations.dart`: novo getter abstrato `navigation`, com pt-BR
    e en. Subclasses próprias de `RebicLocalizations` precisam implementá-lo. No repositório só existe a do
    teste de extensão, que é atualizada. Como o projeto é um protótipo sem consumidores externos, a mudança não
    afeta ninguém fora dele.
- **Galeria:** nova página "RebicScaffold".
- **Catálogo:** `rebic/widgets/rebic-scaffold` → `implemented`. As dependências passam a ser as usadas de fato:
  - `rebic/widgets/rebic-app`, `rebic-container`, `rebic-divider`, `rebic-icon`, `rebic-text`;
  - `rebic/core/responsive`, `rebic/core/interaction`, `rebic/core/localization`;
  - os fundamentos `color`, `elevation`, `spacing`, `density`, `iconography`, `interaction-states`,
    `design-tokens` (movimento), `theming` e `accessibility`.

  `rebic/widgets/rebic-responsive-layout` sai da lista, porque o scaffold usa a classe da tela diretamente, pelo
  núcleo.
- **Portal existente:** sem impacto.
