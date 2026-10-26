# Design: Fundamento de tipografia

## Context

- O contrato de tokens, as bibliotecas de primitivos e o teste de nível documentado já existem (design-tokens,
  color, spacing). `rebic_checks tokens` já rejeita `TextStyle(...fontSize|height|letterSpacing...: <número>)` nos widgets.
- O design da Fase 0 deixou a família tipográfica em aberto (questão 3: Inter ou Noto Sans) e exige fonte empacotada
  para goldens estáveis. O responsável aceitou a **Inter** como escolha provisória do protótipo.
- A release oficial `https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip` (cerca de 34 MB) estava
  acessível durante esta proposta.

## Goals / Non-Goals

**Goals:**

- Uma fonte idêntica em web, Windows e testes, sem download em tempo de execução.
- Estilos completos e sem cor, combináveis com qualquer papel de cor.

**Non-Goals:**

- Subconjunto de glifos (*subsetting*) e otimização do bundle web. Pode ser avaliada na Fase 5, com as medições de desempenho.
- Fonte variável. Os arquivos são estáticos, porque o Flutter não mapeia `fontWeight` para o eixo `wght` sem
  `FontVariation` explícita.

## Decisions

### D1. Origem e verificação da fonte

Na implementação:

1. Baixar o zip da release v4.1 para um diretório temporário isolado, fora do repositório.
2. Extrair só `extras/ttf/Inter-Regular.ttf`, `Inter-Medium.ttf`, `Inter-SemiBold.ttf`, `Inter-Bold.ttf` e `LICENSE.txt`.
3. Copiar esses arquivos para `packages/rebic_foundation/fonts/inter/`, com `LICENSE.txt` salvo como `OFL.txt`.
4. Registrar em `fonts/inter/README.md` a origem (URL e versão), a licença e o SHA-256 de cada arquivo.

Se a estrutura do zip for diferente, a tarefa pausa para revisão, e nenhum caminho é adivinhado.

- **Alternativa:** pacote `google_fonts`. Foi rejeitada porque baixa a fonte em tempo de execução (quebra uso
  offline e goldens) e adiciona dependência.
- **Alternativa:** Noto Sans. Viável, mas o responsável escolheu a Inter.

### D2. Declaração no pacote e tamanho do bundle

`packages/rebic_foundation/pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: fonts/inter/Inter-Regular.ttf
        - asset: fonts/inter/Inter-Medium.ttf
          weight: 500
        - asset: fonts/inter/Inter-SemiBold.ttf
          weight: 600
        - asset: fonts/inter/Inter-Bold.ttf
          weight: 700
```

São 4 pesos, com cerca de 1,6 MB no total. Itálico não entra, porque nenhum estilo semântico o usa. O tamanho
será medido na Fase 5. Se for um problema na web, a mitigação será *subsetting*, sem mudar a API.

### D3. Família com prefixo explícito

`TextStyle(package: 'rebic_foundation')` também prefixa os fallbacks (`packages/rebic_foundation/Segoe UI`),
e isso quebra a resolução das fontes do sistema. Por isso os estilos usam
`fontFamily: 'packages/rebic_foundation/Inter'`, sem o parâmetro `package`, e `fontFamilyFallback` sem prefixo.
O valor fica no primitivo `RebicTypographyPrimitives.fontFamily`, e o nome curto `Inter` fica em `familyName`.

### D4. Primitivos

`RebicTypographyPrimitives` (`lib/src/typography/primitives/typography_primitives.dart`):

- `familyName = 'Inter'`, `fontFamily = 'packages/rebic_foundation/Inter'` e
  `fontFamilyFallback = ['Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', 'sans-serif']`;
- tamanhos `size12`, `size14`, `size16`, `size18`, `size20`, `size24`, `size28`, `size32` e `size40`;
- alturas de linha `lineHeight16`, `20`, `24`, `28`, `32`, `36`, `40` e `48`;
- pesos `regular` (w400), `medium` (w500), `semibold` (w600) e `bold` (w700);
- mapas ordenados `sizes` e `lineHeights` para os testes.

### D5. `RebicTypographyTokens.fallback()`

| Estilo | Tamanho | Altura (px) | Peso |
|---|---|---|---|
| display | 40 | 48 | semibold |
| headline | 32 | 40 | semibold |
| title | 24 | 32 | semibold |
| subtitle | 18 | 24 | semibold |
| body | 14 | 20 | regular |
| bodyStrong | 14 | 20 | semibold |
| label | 14 | 20 | medium |
| caption | 12 | 16 | regular |

Cada estilo é um `TextStyle` com `fontFamily`, `fontFamilyFallback`, `fontSize`, `height = alturaPx / tamanho`,
`fontWeight` e `leadingDistribution: TextLeadingDistribution.even`, sem `color` e sem `backgroundColor`.
Um helper interno `_style(size, lineHeight, weight)` monta os oito estilos. Como `height` é calculado, `fallback()`
continua `const` só se o quociente for uma expressão constante. Divisão de `double` é constante em Dart, então isso funciona.

Os testes de "múltiplo de 4" comparam `fontSize * height` com tolerância de 1e-9, por causa da aritmética de ponto flutuante.

### D6. Interpolação

`lerp` usa `TextStyle.lerp` por estilo. Ele interpola tamanho e altura e troca família e peso conforme o SDK
(o peso usa `FontWeight.lerp`). Todos os estilos têm `inherit: true`, o que evita a asserção do SDK entre estilos
com `inherit` diferente.

### D7. Testes da fonte

- **Pacote `rebic_foundation`:** o teste "Licença distribuída" lê o `pubspec.yaml` e verifica que cada `asset:`
  da família existe em disco e que `fonts/inter/OFL.txt` existe.
- **Galeria (aplicação consumidora):** o teste "Fonte disponível na aplicação consumidora" carrega
  `packages/rebic_foundation/fonts/inter/Inter-*.ttf` por `rootBundle`, prova que o asset chega à aplicação e
  registra a família com `FontLoader`, para que a página renderize com Inter no teste.

### D8. Galeria

A página "Tipografia" (`pages/typography_page.dart`) tem uma linha por estilo: o nome, as medidas
(`14/20 · 400`) e a frase de amostra no próprio estilo. A cor vem de `RebicColorTokens.light().onSurface`,
e os espaçamentos de `RebicSpacingTokens.fallback()`.

## Risks / Trade-offs

- [O download da fonte falha ou a estrutura do zip muda] → A tarefa pausa (D1). O SHA-256 fica registrado para auditoria.
- [Aumento de cerca de 1,6 MB no bundle] → Só 4 pesos, sem itálico. *Subsetting* fica para a Fase 5.
- [Inter, mesmo provisória, pode ser trocada pela fonte da marca] → Família e fallbacks ficam só nos primitivos. Trocar a fonte não muda a API dos estilos.
- [Fallback inexistente em alguma plataforma] → A lista cobre Windows, Android, macOS/iOS e web, com `sans-serif` genérico no fim.

## Migration Plan

Não há consumidores de estilos. As páginas da galeria com `TextStyle(fontSize:)` provisório podem migrar aos
poucos; só a página nova nasce com os tokens. O rollback é reverter a change e remover os assets.
