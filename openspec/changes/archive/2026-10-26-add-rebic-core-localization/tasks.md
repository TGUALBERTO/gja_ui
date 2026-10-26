# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/core/localization`. É infraestrutura do núcleo; a
galeria demonstra o comportamento.

## 1. Dependência e textos

- [x] 1.1 Adicionar `intl: ^0.20.2` a `packages/rebic_core/pubspec.yaml` e rodar `flutter pub get`. Verificação: `dart run rebic_checks architecture` passa.
- [x] 1.2 Criar `RebicLocalizations`, `RebicLocalizationsPtBr` e `RebicLocalizationsEn` (D1, D4) em `packages/rebic_core/lib/src/localization/`, com dartdoc, exportados em `rebic_core.dart`. Verificação: testes "Textos do framework — Textos em pt-BR", "— Textos em en", "— Contagem de selecionados" e "— Estado sem texto".

## 2. Delegate, acesso e extensão

- [x] 2.1 Implementar o delegate e `of(context)` (D2). Verificação: testes "Idiomas e resolução — Região sem tradução própria", "Acesso sem delegate — Árvore sem o delegate" e "Extensão por idioma da aplicação — Idioma da aplicação".

## 3. Formatação

- [x] 3.1 Implementar `formatDecimal`, `formatInteger`, `formatDate`, `formatTime` e `formatDateTime` (D3). Verificação: testes "Formatação de números e datas — Números" e "— Datas e horas".

## 4. Galeria

- [x] 4.1 Registrar o delegate em `apps/rebic_gallery/lib/main.dart` e adicionar a página "Localização" (D5). Verificação: teste "Testes e documentação da localização — Página na galeria".

## 5. Catálogo, changelog e verificação final

- [x] 5.1 Atualizar `docs/catalog.yaml` (`rebic/core/localization` → `implemented`) e o `CHANGELOG.md` de `rebic_core`. Verificação: `dart run rebic_checks catalog` passa.
- [x] 5.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-core-localization`) após a revisão.
- Próxima change do núcleo: `add-rebic-core-responsive`.
