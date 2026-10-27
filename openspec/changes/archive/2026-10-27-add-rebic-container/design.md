# Design: RebicContainer

## Context

O tema ativo (`RebicThemeData.of`) oferece tudo o que o contêiner precisa:
- **Cores:** as superfícies `background`, `base`, `headerBackground` e `shell`, além de `separator` e `shadow`.
- **Raio:** os passos `none`, `xs`, `s`, `m`, `l`, `xl` e `full`, e os papéis `control` e `container`.
- **Elevação:** `shadowsFor(papel, cor)`, com os papéis `card`, `popover`, `dialog`, `dragged` e `header`, e o nível
  `none`.
- **Espaçamento:** `spacing` da densidade, com `RebicSpace` e `RebicSpacing.resolve` de `add-rebic-spacing`.

A verificação de tokens rejeita literais em `rebic_widgets/lib`. Não existe token semântico de espessura de borda,
mas `Border.all(color:)` usa a linha fina de 1 px por padrão, sem literal.

A infraestrutura de goldens, com Inter e Lucide e o ADR 0008, já existe. O contraste de texto usa a diretriz em
arquivo sem a fonte real, como em `RebicText`.

## Goals / Non-Goals

**Goals:**
- superfície só com papéis;
- recorte nos cantos;
- sombra com a cor do modo;
- espaço interno por densidade.

**Non-Goals:**
- tamanho próprio;
- interação;
- cabeçalho e rodapé;
- cores livres e gradientes.

## Decisions

### D1. API

```dart
enum RebicSurface { none, background, base, header, shell }
enum RebicRadius { none, xs, s, m, l, xl, full, control, container }
enum RebicElevation { none, card, popover, dialog, dragged, header }

class RebicContainer extends StatelessWidget {
  const RebicContainer({super.key, this.child, this.surface = RebicSurface.none, this.border = false,
      this.radius = RebicRadius.none, this.elevation = RebicElevation.none, this.padding});
}
```

Os nomes de `RebicRadius` são os dos tokens de raio.

Em `RebicElevation`, só os papéis entram, sem as sombras `shadow0…3`. O uso é sempre por intenção (cartão,
popover…), como no Fiori, em que cada controle escolhe o seu `sapContent_Shadow` por papel.

`header` em `RebicSurface` corresponde a `colors.headerBackground`. O nome curto acompanha o papel `header` de
`RebicElevation`.

`padding` é um único `RebicSpace` para todos os lados. Espaço direcional se faz com `RebicSpacing.padding` dentro do
contêiner, para não duplicar a API.

### D2. Construção

```dart
final t = RebicThemeData.of(context);
final r = BorderRadius.circular(<radius>);
Widget content = padding == null ? child ?? empty : Padding(EdgeInsets.all(RebicSpacing.resolve(t.spacing, padding)), child);
if (radius != none) content = ClipRRect(borderRadius: r, child: content);
return DecoratedBox(
  decoration: BoxDecoration(
    color: <surface ou null>,
    border: border ? Border.all(color: t.colors.separator) : null,
    borderRadius: radius == none ? null : r,
    boxShadow: t.elevation.shadowsFor(<papel>, t.colors.shadow),
  ),
  child: content,
);
```

O `DecoratedBox` pinta a sombra fora do recorte, porque o `ClipRRect` fica só no conteúdo. A borda é pintada sobre o
fundo, com o mesmo raio.

`RebicRadius.full` usa o valor de `radius.full`, que o fundamento define como "pílula". Num retângulo, ele gera os
cantos máximos.

### D3. Testes e goldens

- **Fundo, borda, raio e sombra:** os testes leem o `BoxDecoration` do `DecoratedBox` e o `borderRadius` do
  `ClipRRect`.
- **"Papéis do fundamento":** compara os nomes de `RebicRadius` com as propriedades do diagnóstico de
  `RebicRadiusTokens.fallback()`, e os de `RebicElevation` com o diagnóstico de `RebicElevationTokens.fallback()`.
- **Contraste do texto sobre as superfícies:** fica em `rebic_container_contrast_test.dart`, sem a Inter, porque a
  diretriz mede pixels.
- **Goldens:** quatro imagens, `rebic_container_{light,dark}_{comfortable,compact}.png`, numa grade com:
  - as quatro superfícies com fundo;
  - borda;
  - os raios `control`, `container` e `full`;
  - os cinco papéis de sombra;
  - o exemplo de cartão.

  O fundo dos goldens é `background`, para que as superfícies `base` e as sombras apareçam.
- O teste "Sem valores literais" inspeciona o construtor.
- **Rastreabilidade:** 18 cenários.

### D4. Galeria e catálogo

- A página "RebicContainer" (`rebic_container_page.dart`) mostra superfícies, raios, elevações e o cartão de exemplo,
  com rótulos feitos com `RebicText`.
- O cenário da galeria se chama "Página RebicContainer na galeria".
- No catálogo, as dependências do `[Integração]` entram, e `rebic/widgets/rebic-spacing` (P0, fase 1) passa a ser
  dependência.

## Risks / Trade-offs

- [`padding` só uniforme] → O caso direcional se faz com `RebicSpacing.padding` dentro do contêiner. Cartões e
  painéis usam padding uniforme na grande maioria dos casos.
- [Recorte sempre que há raio custa uma camada de clip] → O custo é pequeno, e o recorte evita que conteúdo com fundo
  próprio vaze pelos cantos, como fazem as superfícies do Fiori.

## Migration Plan

Widget novo; nada a migrar.
