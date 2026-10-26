# Proposal: Localização (`rebic/core/localization`)

## Why

Os widgets do framework vão exibir e anunciar textos próprios, como "Cancelar", "Sem dados", "Carregando", o texto
do estado de valor para leitores de tela e a contagem de itens selecionados. Também vão formatar números e datas
nas tabelas, nos campos e nos seletores de data. No SAPUI5, isso vem dos *resource bundles* da biblioteca, com uma
cadeia de idiomas de reserva, e das classes de formatação por idioma. O Rebic precisa do equivalente antes do
primeiro widget com texto. Sem ele, cada widget fixaria strings em português e formatos próprios.

O design da Fase 0 já decidiu o modelo: `RebicLocalizations` via `Localizations` do Flutter, com pt-BR como padrão
e en. `RebicApp`, `core/validation`, `core/data-source` e os seletores de data e hora dependem desta capacidade.

## What Changes

- Classe `RebicLocalizations` em `rebic_core`, com:
  - textos tipados do framework: ações comuns, estados de carga e vazio, campo obrigatório, texto de cada estado de
    valor e contagem de selecionados com plural;
  - implementações pt-BR (padrão) e en;
  - `delegate` e `supportedLocales` para o `WidgetsApp`, com a resolução nativa de idioma do Flutter;
  - `of(context)`, que retorna o pt-BR quando o delegate não está registrado.
- Formatação por idioma em `RebicLocalizations`: decimal, inteiro, data, hora e data e hora, com `package:intl`.
- Ponto de extensão: a aplicação adiciona um idioma ou troca textos com uma subclasse e o próprio delegate, como os
  *resource bundles* personalizados do UI5.
- A galeria registra o delegate e ganha a página "Localização", que alterna entre pt-BR e en.

Fora do escopo:
- Idiomas da direita para a esquerda. Os idiomas fornecidos são LTR, e a direção continua vindo de `Directionality`.
- Análise de números e datas digitados, que entra com `core/validation`.
- Textos da aplicação: o Rebic não impõe solução de i18n para a aplicação.

## Capabilities

### New Capabilities

- `rebic/core/localization`: textos do framework por idioma, idiomas suportados e resolução, acesso sem delegate,
  extensão por idioma da aplicação e formatação de números e datas.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_core/lib/src/localization/`, exportação em `rebic_core.dart` e testes em
  `packages/rebic_core/test/localization/`.
- **Dependências:** `intl` (pacote do time Dart, sem Material) em `rebic_core`, na versão fixada pelo Flutter SDK
  (0.20.2). Sem `flutter_localizations`, que traz as localizações do Material e do Cupertino.
- **Galeria:** registro do delegate em `main.dart` e nova página "Localização".
- **Catálogo:** `rebic/core/localization` → `implemented`, sem dependências (coerente com o catálogo).
- **Portal existente:** sem impacto.
