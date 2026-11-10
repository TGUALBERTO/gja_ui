# Design: GjaIconButton

## Context

O que já existe:
- **`GjaButton`** resolve as cores com `GjaControlColors.of(family).resolve(states)`, aplica a opacidade de
  desabilitado e desenha um `DecoratedBox`, com borda fina e raio `control`, dentro do `GjaInteractable`. O conteúdo
  visual fica em `ExcludeSemantics`, porque o rótulo já está no nó do botão. O enum `GjaButtonType` é público e
  mapeia para as famílias.
- **`GjaTransparentIconAction`** (interno) desenha:
  - um quadrado de lado `controlHeight`, sem borda;
  - o ícone em `ColorFiltered`;
  - a semântica em `MergeSemantics`, com `expanded` opcional.

  É usado pelo `GjaScaffold` (navegação, com `expanded`) e pela `GjaPage` (voltar).
- **`GjaTooltip`** sempre acrescenta `Semantics(tooltip: message)` ao filho. Num botão cujo rótulo é a própria
  mensagem, isso duplica o anúncio.

## Goals / Non-Goals

**Goals:**
- botão de ícone com dica obrigatória;
- tipos, estados e desabilitado, como o `GjaButton`;
- semântica sem duplicação;
- substituir o botão interno no scaffold e na página.

**Non-Goals:**
- ocupado;
- alternância;
- tamanhos de ícone;
- badge.

## Decisions

### D1. API

```dart
class GjaIconButton extends StatelessWidget {
  const GjaIconButton({required this.icon, required this.tooltip, required this.onPressed,
      this.type = GjaButtonType.transparent, super.key})
    : assert(tooltip != '', 'tooltip não pode ser vazia');
}
```

O padrão é `transparent`, como os botões de ícone de barras e cabeçalhos Fiori. O mapeamento de tipo para família
vem de uma função interna compartilhada com o `GjaButton` (`gjaButtonFamily`, em
`acoes_navegacao/button/gja_button_family.dart`, não exportada), para que os dois não divirjam.

### D2. Estrutura

```
GjaTooltip(message: tooltip, excludeFromSemantics: true)
└─ GjaInteractable(semanticLabel: tooltip, onPressed, focusRingBorderRadius: radius.control)
   └─ builder → ExcludeSemantics → Opacity(interaction.opacity(states))
      └─ SizedBox.square(controlHeight) → DecoratedBox(color: c.background,
                                                       border: Border.all(c.border, hairline), radius)
         └─ Center(Icon(icon, size: icons.control, color: c.text))
```

- O `Icon` desenha o ícone direto na cor do estado. Ele respeita `matchTextDirection` dos ícones do catálogo (RTL)
  e não escala com o texto, porque `applyTextScaling` é falso por padrão.
- A dica abre no foco do teclado: o `Focus` observador do `GjaTooltip` vê o foco do `GjaInteractable`
  descendente.

### D3. `excludeFromSemantics` no `GjaTooltip`

Com `excludeFromSemantics`, o `GjaTooltip` não envolve o filho em `Semantics(tooltip:)`. O restante não muda: a
bolha já é `ExcludeSemantics`.

O teste de rastreabilidade da dica passa de 21 para 22 cenários.

### D4. Scaffold e página

- **Scaffold:** o botão de navegação vira
  `MergeSemantics(Semantics(expanded: expanded, child: GjaIconButton(icon: menu, tooltip: localizations.navigation,
  onPressed: …)))`. O `MergeSemantics` externo junta o estado expandido ao nó do botão, como antes.
- **Página:** o botão de voltar vira `GjaIconButton(icon: arrowLeft, tooltip: localizations.back,
  onPressed: onBack)`.
- **Remoção:** `lib/src/fundacao_layout/action/` é removida.
- **Diferenças visuais:** o tamanho, o raio e as cores são os mesmos. A borda nova é transparente na família
  `transparent`. A única diferença possível é o antialiasing do ícone (cor direta em vez de `ColorFiltered`). Os
  goldens do scaffold e da página são executados primeiro. Se falharem, as imagens são comparadas visualmente e
  regeneradas só se a diferença for essa.

### D5. Testes, galeria e catálogo

- **Cores e estados:** pela `BoxDecoration` e pelo `Icon.color`.
- **Escala:** com `MediaQuery(textScaler: 2)`, verificando o tamanho.
- **RTL:** `Icon` com `matchTextDirection`. Os goldens verificam o espelhamento visual. O teste verifica a direção
  efetiva (`Directionality`) e o `IconData.matchTextDirection`.
- **Acessibilidade:** um arquivo sem a Inter, com:
  - `labeledTapTargetGuideline` e alvo mínimo por tipo, nos temas claro e escuro e nas duas densidades;
  - o contraste do ícone calculado com `gjaContrastRatioOver(c.text, fundo)`. Quando o fundo é transparente,
    medido sobre `base` e `background`.
- **Goldens:** 480 × 160, com os seis tipos e um desabilitado (ícone `edit`), nos temas claro e escuro ×
  confortável e compacto.
- **Galeria:** página "GjaIconButton" (`gja_icon_button_page.dart`), com `GjaPage`:
  - uma barra de ações (editar, excluir, baixar, mais);
  - um botão de cada tipo;
  - um desabilitado.

  O cenário se chama "Página GjaIconButton na galeria".
- **Catálogo:**
  - `gja-icon-button` → `implemented`, com as dependências do `[Integração]`;
  - `gja-scaffold` e `gja-page` ganham `gja/widgets/gja-icon-button`.

### D6. Reclassificação de fase

A regra do catálogo impede que um item P0/Fase 1 dependa de um P1/Fase 2. Com o scaffold e a página usando o
`GjaIconButton`, a cadeia `gja-icon-button` → `gja-tooltip`, `gja-button` → `gja-progress-indicator` passa
a P0/Fase 1. As dependências dessa cadeia já são de Fase 1, o que a mantém válida.

**Alternativa:** reverter a troca e manter o botão interno no scaffold e na página. Foi descartada por decisão do
usuário. Ela preservaria a classificação antiga, mas manteria um botão privado sem dica, diferente do modelo do
SAPUI5, em que a barra e a página reutilizam o `sap.m.Button` público.

## Risks / Trade-offs

- [Goldens do scaffold e da página podem mudar no antialiasing do ícone] → Verificação visual antes de regenerar,
  registrada no relato da implementação.
- [Roadmap da Fase 0 alterado retroativamente] → Só a classificação muda. Os quatro widgets já existem, e a ordem de
  implementação não é afetada.
- [`GjaIconButton` depende de `GjaButtonType`] → É uma dependência entre widgets da mesma categoria, declarada no
  `[Integração]`. O enum é a fonte única dos tipos Fiori.
- [Dica abre no foco em barras com muitos botões] → É o comportamento do `GjaTooltip` e atende à WCAG 1.4.13.

## Migration Plan

O widget é novo, e o parâmetro da dica é aditivo. O botão interno é removido sem impacto público.
