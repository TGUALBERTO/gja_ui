# Design: Botão no modelo do SAPUI5

## Context

- `RebicButton` (`acoes_navegacao/button/rebic_button.dart`): `label`, `onPressed` (nulo desabilita), `type`, `icon`,
  `busy`; `MergeSemantics` + `Semantics(value: loading)` + `RebicInteractable` + `Row` com indicador ou ícone e o
  texto. As cores vêm de `rebicButtonFamily(type)` (`rebic_button_family.dart`, interno).
- `RebicIconButton` (`acoes_navegacao/icon_button/rebic_icon_button.dart`): `icon`, `tooltip`, `onPressed`, `type`
  (padrão `transparent`); `RebicTooltip(excludeFromSemantics: true)` + `MergeSemantics` + `RebicInteractable` +
  quadrado `SizedBox.square(controlHeight)`.
- Usos internos de `RebicIconButton`: `RebicPage` (voltar) e `RebicShellBar` (voltar, menu, pesquisa, notificações,
  seletor de produtos), todos `transparent` por padrão. `RebicButton` só aparece em dartdoc no framework.
- Testes: `test/acoes_navegacao/button/` e `test/acoes_navegacao/icon_button/` (widget, a11y e goldens).

## Goals / Non-Goals

**Goals:**
- Um só `RebicButton` com a API do `sap.m.Button` (`text`, `icon`, `tooltip`, `type`, `enabled`, `onPress`, `busy`).
- Nenhuma mudança visual nos usos internos (página e ShellBar).

**Non-Goals:**
- `RebicLink`, `RebicMenuItem`, `RebicAvatar` e `RebicStatusIndicator` (próxima change).
- As propriedades e tipos listados como fora do escopo em proposal.md.

## Decisions

### D1. Um widget, dois formatos

`build` escolhe o formato por `text`:
- com `text`: o formato atual do `RebicButton` (altura mínima `controlHeight`, `spacing.m` nas laterais, `Row` com
  indicador/ícone e texto);
- sem `text`: o formato atual do `RebicIconButton` (`SizedBox.square(controlHeight)` com o ícone, ou o indicador
  quando `busy`, centrado).

O mesmo `DecoratedBox` (família, borda fina, `radius.button`) e o mesmo `Opacity` envolvem os dois. A asserção do
construtor exige `text` não vazio ou `icon`, e `tooltip` não vazia sem `text`.

### D2. `enabled` e `onPress`

`RebicInteractable` desabilita quando recebe `onPressed: null`. O botão passa:

```dart
onPressed: !enabled ? null : (busy || onPress == null ? () {} : onPress)
```

Assim `enabled: false` desabilita, e `onPress` nulo com `enabled` `true` mantém o foco e os estados sem ação, como um
`sap.m.Button` sem tratador.

### D3. Dica e semântica

Com `tooltip`, o botão fica dentro de `RebicTooltip(message: tooltip)`:
- sem `text`, `excludeFromSemantics: true` e `semanticLabel: tooltip`, como hoje no botão de ícone (a mensagem aparece
  uma vez, como rótulo);
- com `text`, `semanticLabel: text`, e a dica fica na semântica como `tooltip` do nó, pelo próprio `RebicTooltip`.

O valor `loading` do estado ocupado continua no `Semantics` externo, nos dois formatos.

### D4. Tipo padrão

O padrão é `standard`, o `Default` do UI5, nos dois formatos. `RebicPage` e `RebicShellBar` passam
`type: RebicButtonType.transparent` explicitamente, o que mantém os goldens deles.

### D5. Migração

Um script que casa parênteses (como na change de HBox/VBox) troca, só nos argumentos do próprio construtor:
- `RebicIconButton(` → `RebicButton(`, acrescentando `type: RebicButtonType.transparent` quando não há `type`;
- `label:` → `text:` e `onPressed:` → `onPress:` em `RebicButton(`;
- `onPressed: null` → `enabled: false`.

Os casos em que `onPressed` recebe uma expressão que pode ser nula (por exemplo `cond ? f : null`) são listados pelo
script e convertidos à mão em `enabled: cond, onPress: f`. `dart analyze` e os goldens de página e ShellBar sem
diferença confirmam a migração.

### D6. Testes, goldens e galeria

- `test/acoes_navegacao/icon_button/` sai; os casos dele passam a `test/acoes_navegacao/button/`, com os nomes dos
  cenários novos. Os goldens do botão são regerados com a amostra nova (com uma linha só com ícone), e os do botão de
  ícone saem.
- A galeria junta as páginas: "RebicButton" ganha a barra de ações só com ícone e os tipos só com ícone; a página e a
  rota "RebicIconButton" saem, com o teste dela.

## Risks / Trade-offs

- **[Regra de nomes revisada antes dos demais widgets]** → Link, MenuItem, Avatar e StatusIndicator ficam fora da regra
  até a próxima change; a tarefa de acompanhamento registra isso.
- **[`onPressed: cond ? f : null` migrado errado]** → o script lista esses casos para conversão manual; os testes de
  desabilitado de cada widget pegam o erro.
- **[Botão só com ícone fora de barra muda de aparência]** → só a galeria e os testes usam o botão de ícone fora de
  `RebicPage`/`RebicShellBar`; a migração acrescenta `transparent` onde não havia `type`, então nada muda.
