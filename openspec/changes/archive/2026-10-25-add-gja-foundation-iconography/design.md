# Design: Fundamento de ícones

## Context

- Os padrões já usados nos fundamentos anteriores valem aqui:
  - primitivos em `abstract final class`;
  - conjunto semântico com `fallback()` constante e `assert` no `copyWith`;
  - teste de nível documentado;
  - fonte empacotada com README de origem e hashes, como a Inter.
- `IconData` e `Icon` ficam em `package:flutter/widgets.dart`, então não há dependência de Material.
  `Icons` (Material) não pode ser usado (ADR 0004).
- Pesquisa feita durante esta proposta:
  - `lucide-static@1.61.0` é a versão atual no npm, com licença ISC (a parte derivada do Feather está sob MIT, no mesmo `LICENSE`);
  - o tarball tem `package/font/lucide.ttf` (932.460 bytes), `package/font/codepoints.json` (2.191 ícones, nome → código) e `package/LICENSE`.

## Goals / Non-Goals

**Goals:**

- Ícones `const` com significado estável. Trocar a biblioteca de ícones muda só o mapeamento dos códigos.
- Verificação automática de que cada ícone do catálogo existe na fonte empacotada.

**Non-Goals:**

- O widget `GjaIcon` (rótulo semântico, cor do tema e tamanho por papel).
- Ícones em SVG ou multicoloridos.

## Decisions

### D1. Origem e verificação

Na implementação:

1. Baixar `https://registry.npmjs.org/lucide-static/-/lucide-static-1.61.0.tgz` para um diretório temporário isolado.
2. Conferir o SHA-512 do tarball com o campo `dist.integrity` do registro npm.
3. Extrair só `font/lucide.ttf`, `font/codepoints.json` e `LICENSE` para `packages/gja_foundation/fonts/lucide/`.
4. Registrar origem, versão e SHA-256 em `fonts/lucide/README.md`.

Se a integridade não conferir, a tarefa pausa.

- **Alternativa:** pacote Dart `lucide_icons`. Foi rejeitada porque adiciona dependência de terceiros com versão
  própria e expõe nomes da forma, e não do significado.
- **Alternativa:** Phosphor. Viável, mas o responsável escolheu a Lucide.

### D2. Declaração e `IconData`

`pubspec.yaml` declara a família `Lucide` com o asset `fonts/lucide/lucide.ttf`. Cada ícone é
`IconData(código, fontFamily: 'Lucide', fontPackage: 'gja_foundation', matchTextDirection: <direcional>)`.
Diferente da tipografia, aqui `fontPackage` não causa problema, porque ícones não usam fallback. Os primitivos
expõem `GjaIconPrimitives.fontFamily = 'Lucide'` e `fontPackage = 'gja_foundation'`.

### D3. Catálogo semântico → nomes Lucide

| GJA | Lucide | GJA | Lucide |
|---|---|---|---|
| add | plus | calendar | calendar |
| close | x | clock | clock |
| search | search | user | user |
| check | check | filter | funnel (ou filter) |
| chevronUp/Down/Left/Right | chevron-up/down/left/right | sort | arrow-up-down |
| arrowLeft/Right | arrow-left/right | upload / download | upload / download |
| menu | menu | refresh | refresh-cw |
| moreHorizontal / moreVertical | ellipsis / ellipsis-vertical | settings | settings |
| edit | pencil | home | house |
| delete | trash-2 | externalLink | external-link |
| info | info | visibility / visibilityOff | eye / eye-off |
| warning | triangle-alert | copy | copy |
| error | circle-x | logout | log-out |
| success | circle-check | notification | bell |
| help | circle-question-mark (ou circle-help) | file / folder | file / folder |

Alguns nomes mudaram entre versões da Lucide (por exemplo, `filter` → `funnel` e `help-circle` → `circle-help`).
Por isso, a implementação confere cada nome no `codepoints.json` empacotado e registra no código o nome Lucide
usado. Se um significado não tiver equivalente razoável, a tarefa pausa.

Os códigos ficam como literais inteiros no código-fonte (por exemplo, `0xE1B2`), com o nome Lucide no dartdoc.
Um teste compara cada literal com o `codepoints.json`, o que cobre o cenário "Códigos conferem com o mapa oficial".
A geração de código foi descartada para um catálogo de cerca de 40 entradas.

`matchTextDirection: true` só para `chevronLeft`, `chevronRight`, `arrowLeft`, `arrowRight`, `logout` e `externalLink`.

### D4. *Tree shaking* e o mapa `all`

Os ícones são `static const IconData`, e isso permite o *tree shaking* de ícones nos builds de release. Também há um mapa
`static const all = <String, IconData>{...}`, usado pela galeria e pelos testes. Como ele referencia todos os ícones,
as aplicações que o importarem mantêm o catálogo inteiro, que é pequeno (cerca de 40 glifos). Ícones fora do
catálogo só entram no build se a aplicação os declarar.

### D5. `GjaIconTokens.fallback()`

| Passo | Valor | Papel | Valor |
|---|---|---|---|
| small | size16 | inline | size16 (= small) |
| medium | size20 | control | size20 (= medium) |
| large | size24 | | |
| xLarge | size32 | | |

A escala primitiva também tem `size12`, `size40` e `size48`, para estados vazios e para a densidade.
`copyWith` faz `assert` de valores finitos e `> 0`, e `lerp` usa `lerpDouble`.

### D6. Testes

- **Pacote:**
  - "Licença e mapa distribuídos" lê o `pubspec.yaml` e verifica os três arquivos;
  - "Códigos conferem…" e "Catálogo completo…" leem `fonts/lucide/codepoints.json`;
  - "Ícone direcional em RTL" monta `Icon(GjaIcons.chevronRight)` em `Directionality(rtl)` e verifica o
    `Transform` de espelhamento que o `Icon` insere. O mesmo teste confirma a ausência dele em `check`.
- **Galeria:** "Fonte disponível…" carrega `packages/gja_foundation/fonts/lucide/lucide.ttf` por `rootBundle` e
  registra a família com `FontLoader('packages/gja_foundation/Lucide')`.

### D7. Galeria

A página "Ícones" (`pages/icons_page.dart`) é uma grade com um ícone por entrada de `GjaIcons.all`, no tamanho
`large` e com o nome embaixo. Os valores visuais vêm dos tokens.

## Risks / Trade-offs

- [Nomes Lucide mudam entre versões] → A versão fica fixa (1.61.0), e o teste contra o `codepoints.json` empacotado falha em qualquer divergência.
- [Fonte de cerca de 0,9 MB em debug e web] → O *tree shaking* de ícones resolve em release. A medição fica para a Fase 5.
- [Lucide provisória, a ser trocada por ícones da marca] → Os nomes semânticos isolam a troca, que muda só o primitivo e os códigos.

## Migration Plan

Não há consumidores. O rollback é reverter a change e remover os assets.
