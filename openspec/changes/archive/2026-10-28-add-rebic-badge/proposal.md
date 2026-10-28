# Proposal: RebicBadge (`rebic/widgets/rebic-badge`)

## Why

Barras de navegação, navegação lateral, abas e notificações mostram contadores: "3" sobre o sino de notificações, "12"
ao lado da aba "Pedidos". No SAPUI5, isso é:
- o badge dos controles (`BadgeEnabler`, em `Button` e `Avatar`), um número no canto superior final do controle, com
  limite (`badgeMaxValue`) e oculto quando o valor está abaixo do mínimo;
- o `count` do `IconTabFilter`.

O Rebic ainda não tem esse indicador. `RebicNavigationBar`, `RebicSideNavigation`, `RebicTabs`, `RebicMultiSelect`
e `RebicNotification` dependem dele no catálogo. O design da Fase 0 o previu sobre `RebicText`, na etapa
"Badge, StatusIndicator, Avatar, Card".

## What Changes

- Widget `RebicBadge` em `rebic_widgets` (categoria `exibicao-dados`):
  - `count` (`int`), obrigatório; contadores menores que 1 não aparecem, como no `BadgeEnabler`;
  - `max` (padrão 999): acima dele, mostra `<max>+`;
  - `state` (`RebicValueState`), com padrão `error`, que é a cor de destaque dos badges Fiori. O fundo, a borda e o
    texto vêm das cores do estado. Em `none`, o texto usa o tom padrão;
  - `child` opcional:
    - sem ele, o contador aparece sozinho, por exemplo ao lado do texto de uma aba;
    - com ele, aparece sobre o canto superior final do `child`, sem mudar o tamanho do `child`, por exemplo num
      botão de ícone;
  - `semanticLabel` opcional, para dar sentido ao número (por exemplo, "3 notificações"). Sem ele, o leitor de tela
    anuncia o número.
- **Forma:** pílula com raio `full`, texto `label`, lado mínimo `icons.small` (círculo para um dígito) e espaço
  horizontal `spacing.xs`. O número é formatado no idioma.
- Página "RebicBadge" na galeria.

Fora do escopo:
- Indicador só de ponto, sem número.
- Animação de entrada e de mudança do contador.
- Badge em posições diferentes do canto superior final.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-badge`: contador por estado de valor, avulso ou sobre um elemento, com limite, ocultação de
  zero e semântica.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_widgets/lib/src/exibicao_dados/badge/` e testes, com goldens.
- **Galeria:** nova página "RebicBadge".
- **Catálogo:** `rebic/widgets/rebic-badge` → `implemented`. Além de `rebic-text`, as dependências passam a incluir:
  - `core/localization` (formatação);
  - os fundamentos `color`, `typography`, `spacing`, `radius`, `iconography`, `theming` e `accessibility`.
- **Portal existente:** sem impacto.
