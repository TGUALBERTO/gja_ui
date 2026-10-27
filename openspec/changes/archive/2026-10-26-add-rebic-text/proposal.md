# Proposal: RebicText (`rebic/widgets/rebic-text`)

## Why

Todo widget com texto (botões, campos, cabeçalhos de página, células de tabela, mensagens) precisa exibir texto com um
estilo da escala tipográfica, uma cor de papel do tema, truncamento consistente e semântica correta. Hoje a galeria
monta isso à mão com `Text` e `typography.<estilo>.copyWith(color: …)`. Se cada widget fizer o mesmo, a escolha de cor,
o truncamento e a marcação de títulos para leitores de tela vão divergir.

No SAPUI5, `sap.m.Text` (texto com `maxLines` e quebra), `sap.m.Title` (título com nível semântico) e as cores de
estado de `sap.m.ObjectStatus` cobrem esse papel. O Rebic precisa de um widget de texto que use só os tokens do tema.
`RebicText` foi acrescentado no design da Fase 0 (★) porque `RebicPage`, `RebicCard`, `RebicButton` e `RebicLink`
dependem dele.

Este é o primeiro widget com aparência própria. Por isso a change também cria a infraestrutura de goldens, que o
template de widget exige.

## What Changes

- Widget `RebicText` em `rebic_widgets`:
  - `variant` escolhe o estilo da escala tipográfica (`display` a `caption`, padrão `body`);
  - `tone` escolhe a cor de papel: texto (`standard`), rótulo (`muted`) ou um estado de valor (`success`,
    `warning`, `error`, `information`);
  - `maxLines` limita as linhas e trunca com reticências; sem limite, o texto quebra livremente;
  - `textAlign`;
  - as variantes de título (`display`, `headline`, `title`) são marcadas como cabeçalho para leitores de tela, com
    troca possível por `heading`;
  - o leitor de tela lê o texto completo, mesmo truncado;
  - respeita a escala de texto do sistema sem limite.
- Infraestrutura de goldens em `rebic_widgets`:
  - carregamento da fonte Inter nos testes;
  - goldens com a etiqueta `golden`;
  - referência gerada no Windows. O pipeline Linux pula essa etiqueta até existir uma referência Linux, e o ADR 0008
    registra a decisão provisória.
- Página "RebicText" na galeria.

Fora do escopo:
- Texto selecionável, texto rico (vários estilos num texto) e realce de busca.
- Links (`RebicLink`, spec própria) e rótulos de formulário com obrigatoriedade (`RebicFormField`).
- Indicador de vazio (o `emptyIndicator` do UI5), que pede um texto novo em `core/localization`.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-text`: texto com estilo tipográfico, cor de papel, limite de linhas com reticências,
  alinhamento e semântica de cabeçalho, só com tokens do tema.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:**
  - `packages/rebic_widgets/lib/src/fundacao_layout/text/`;
  - `packages/rebic_widgets/test/` com testes, goldens e o suporte de fonte;
  - `dart_test.yaml` em `rebic_widgets` com a etiqueta `golden`.
- **Pipeline:** `tool/ci.sh` executa `flutter test --exclude-tags golden`, e `tool/ci.ps1` executa tudo.
- **Documentação:** ADR 0008 (goldens com referência no Windows, provisório) e o índice de ADRs.
- **Galeria:** nova página "RebicText".
- **Catálogo:** `rebic/widgets/rebic-text` → `implemented`, com as dependências do `[Integração]`.
- **Portal existente:** sem impacto.
