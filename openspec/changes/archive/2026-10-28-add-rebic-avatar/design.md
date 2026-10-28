# Design: RebicAvatar

## Context

- **Tamanhos:** o UI5 define 2/3/4/5/7 rem (32/48/64/80/112 px). O tema não tem tokens de tamanho de avatar. O
  `icons.xLarge` vale 32 nos tokens de referência e é a base natural, porque corresponde ao `xs`.
- **Contraste das iniciais**, calculado sobre as primitivas de referência: `brand` sobre `selectionBackground` dá
  6,33:1 no tema claro e 5,28:1 no escuro; sobre `selectionHoverBackground`, 5,56:1 no claro. Todos ficam acima de
  4,5:1.
- **Componentes disponíveis:**
  - `RebicText` tem as variantes `label`, `subtitle`, `title`, `headline` e `display`, mas só tons fixos, sem
    `brand` para texto. Para as iniciais na cor da marca, o avatar usa `Text` com o estilo do token e `colors.brand`,
    como o `RebicButton`.
  - `RebicIcon` tem o tom `brand`.
- **Interação:** `RebicInteractable` dá estados, ativação, alvo, anel e semântica de botão.

## Goals / Non-Goals

**Goals:**
- imagem, iniciais e ícone com fallback;
- círculo e quadrado;
- cinco tamanhos;
- avatar ativo;
- semântica de imagem ou de botão.

**Non-Goals:**
- cores de acento;
- badge;
- grupos;
- placeholder animado.

## Decisions

### D1. API

```dart
enum RebicAvatarSize { xs, s, m, l, xl }
enum RebicAvatarShape { circle, square }

class RebicAvatar extends StatefulWidget {
  const RebicAvatar({this.image, this.initials, this.icon, this.size = RebicAvatarSize.s,
      this.shape = RebicAvatarShape.circle, this.semanticLabel, this.onPressed, super.key})
    : assert(initials == null || (initials.length >= 1 && initials.length <= 3),
             'initials deve ter de 1 a 3 caracteres: $initials');
}
```

É um `StatefulWidget` para guardar a falha da imagem: `_imageFailed`, reiniciada quando `image` muda.

### D2. Lado e conteúdo

- **Lado:** `icons.xLarge × _sideFactor[size]`, com fatores nomeados `{xs: 1, s: 1.5, m: 2, l: 2.5, xl: 3.5}`. Isso
  reproduz exatamente os tamanhos do UI5 nos tokens de referência. São constantes nomeadas, não dimensões literais.
- **Iniciais:** o estilo do token por tamanho, em `colors.brand` e maiúsculas. Elas ficam dentro de
  `MediaQuery.withNoTextScaling` e de um `FittedBox(fit: scaleDown)`, para nunca estourar o lado.
- **Ícone:** `Icon(icon ?? RebicIcons.user, size: lado / 2, color: colors.brand)`.
- **Imagem:**
  `Image(image: image, fit: cover, width: lado, height: lado, errorBuilder: (…) { agenda _imageFailed = true; return
  fallback; })`. O `errorBuilder` devolve o fallback no mesmo quadro, e o estado evita tentar de novo nas
  reconstruções.

### D3. Forma, cor e interação

```
Semantics(container: true, image: true (só inativo), label: semanticLabel ?? initials)
└─ ExcludeSemantics → ClipRRect/ClipOval → ColoredBox(selectionBackground ou selectionHoverBackground no hover)
                       → SizedBox.square(lado) → Center(conteúdo)
```

- **Inativo:** sem `RebicInteractable`.
- **Ativo:** `MergeSemantics → RebicInteractable(semanticLabel: rótulo, onPressed, focusRingBorderRadius: raio da
  forma)`, e o `builder` escolhe o fundo pelo estado `hovered`.
- **Forma:** o círculo usa `ClipOval` e raio `radius.full` no anel de foco. O quadrado usa `ClipRRect` com
  `radius.s`.

### D4. Testes, galeria e catálogo

- **Imagem válida:** um `MemoryImage` com um PNG 1×1 embutido no teste, carregado com `tester.runAsync` e
  `precacheImage`.
- **Imagem com erro:** um `MemoryImage` com bytes inválidos. O teste aguarda a notificação de erro com `runAsync` e
  `pump`.
- **Cores e forma:** pelo `ColoredBox` e pelo tipo de recorte (`ClipOval`/`ClipRRect` e o raio).
- **Acessibilidade:** um arquivo sem a Inter, com contraste e alvos nos temas claro e escuro e nas duas densidades,
  sobre `background`.
- **Goldens:** 480 × 280, com os cinco tamanhos circulares com iniciais, os cinco quadrados e avatares só com ícone.
  São gerados nos temas claro e escuro × confortável e compacto.
- **Galeria:** página "RebicAvatar" (`rebic_avatar_page.dart`), com `RebicPage`:
  - os tamanhos;
  - as formas;
  - iniciais e ícone;
  - "Maria Barros" ativo, que mostra "Perfil de Maria Barros".

  O cenário se chama "Página RebicAvatar na galeria".
- **Catálogo:** `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [Fatores sobre `icons.xLarge` em vez de tokens próprios] → Se um tema mudar `icons.xLarge`, os avatares acompanham
  proporcionalmente. Tokens de avatar entram numa change do fundamento, se surgirem necessidades de tema.
- [Imagens de rede não são testadas] → O widget recebe qualquer `ImageProvider`. O fallback cobre falhas de rede da
  mesma forma.

## Migration Plan

Widget novo; nada a migrar.
