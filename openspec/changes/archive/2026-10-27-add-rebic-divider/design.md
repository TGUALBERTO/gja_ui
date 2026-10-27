# Design: RebicDivider

## Context

O tema ativo (`RebicThemeData.of`) oferece:
- **Cores:** `colors.separator`, decorativa e isenta de contraste, e `colors.fieldBorder`, verificada a ≥ 3:1 sobre
  `background`, `base` e `headerBackground`.
- **Espaçamento:** `spacing`, da densidade.

`RebicSpace` e `RebicSpacing.resolve` vêm de `add-rebic-spacing`.

A verificação de tokens rejeita literais em `width`, `height` e `thickness` (com exceção de 0). Não há token semântico
de espessura de linha. `RebicContainer` usa `Border.all(color:)`, cuja espessura padrão é a linha fina de 1 px.

`RebicRow` com `crossAlignment: stretch` estica os filhos até a altura da linha (`add-rebic-row-column`).

## Goals / Non-Goals

**Goals:**
- linha fina horizontal e vertical;
- cor por papel;
- espaço e recuo por passos;
- recuo direcional.

**Non-Goals:**
- divisores automáticos;
- linha tracejada;
- texto na linha;
- espessuras maiores.

## Decisions

### D1. API

```dart
enum RebicDividerTone { subtle, strong }

class RebicDivider extends StatelessWidget {
  const RebicDivider({super.key, this.tone = RebicDividerTone.subtle, this.spacing = RebicSpace.none,
      this.indent, this.endIndent}) : _axis = Axis.horizontal;
  const RebicDivider.vertical({super.key, this.tone = RebicDividerTone.subtle, this.spacing = RebicSpace.none,
      this.indent, this.endIndent}) : _axis = Axis.vertical;
}
```

O enum de tom tem dois valores:
- `subtle`: listas e grupos de um mesmo bloco;
- `strong`: separar estruturas, como cabeçalho e conteúdo.

### D2. Construção

```dart
final t = RebicThemeData.of(context);
final line = const BorderSide().width;            // linha fina padrão do Flutter (1 px), sem literal
final color = tone == subtle ? t.colors.separator : t.colors.fieldBorder;
double v(RebicSpace? s) => s == null ? 0 : RebicSpacing.resolve(t.spacing, s);
final pad = v(spacing);
```

- **Horizontal:**

  ```dart
  Padding(
    padding: EdgeInsetsDirectional.only(top: pad, bottom: pad, start: v(indent), end: v(endIndent)),
    child: SizedBox(height: line, width: double.infinity, child: ColoredBox(color: color)),
  )
  ```

- **Vertical:**

  ```dart
  Padding(
    padding: EdgeInsets.only(left: pad, right: pad, top: v(indent), bottom: v(endIndent)),
    child: SizedBox(width: line, height: double.infinity, child: ColoredBox(color: color)),
  )
  ```

- O resultado fica dentro de `ExcludeSemantics`.

A espessura vem de `const BorderSide().width`. É a mesma linha fina que `Border.all` usa no `RebicContainer`, e por
isso as linhas do framework ficam coerentes, sem literal. Se um dia houver um token semântico de espessura, as duas
passam a usá-lo.

`double.infinity` no eixo da linha faz o divisor ocupar a extensão disponível. Num eixo sem limite, como um
`RebicRow` sem altura definida, o divisor vertical depende de `stretch` ou de altura definida pelo pai. O dartdoc
explica isso, e é o mesmo comportamento do `VerticalDivider` nativo.

### D3. Testes e goldens

- **Medidas:** os testes usam `getRect` e leem a cor do `ColoredBox`.
- **Recuo:** o teste verifica LTR e RTL.
- **Semântica:** o teste conta os nós com rótulo.
- **Contraste do tom forte:** é verificado por valor, com `rebicContrastRatioOver`.
- **Goldens:** quatro imagens, `rebic_divider_{light,dark}_{comfortable,compact}.png`, com:
  - uma lista de três itens com divisor `subtle`;
  - um bloco com divisor `strong` e recuo;
  - uma barra (`RebicRow` com `stretch`) com divisores verticais.
- **Rastreabilidade:** 16 cenários, com o suporte comum `test/support/traceability.dart`.

### D4. Galeria e catálogo

- A página "RebicDivider" (`rebic_divider_page.dart`) usa `RebicColumn`, `RebicRow`, `RebicContainer` e
  `RebicText`.
- O cenário da galeria se chama "Página RebicDivider na galeria".
- No catálogo, as dependências do `[Integração]` entram.

## Risks / Trade-offs

- [Espessura derivada de `BorderSide().width`, e não de um token] → É a mesma decisão implícita da borda do
  `RebicContainer`. Um token `stroke` semântico pode ser proposto quando surgir a primeira necessidade de outra
  espessura.
- [Divisor vertical sem altura definida pelo pai] → O mesmo do nativo. O dartdoc e a galeria mostram o uso com
  `stretch`.

## Migration Plan

Widget novo; nada a migrar.
