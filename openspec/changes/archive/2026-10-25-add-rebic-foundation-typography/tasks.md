# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/foundation/typography`. Esta change não entrega
widget público, então não há goldens. A fonte empacotada é o pré-requisito para eles.

## 1. Fonte

- [x] 1.1 Baixar a release Inter v4.1 para um diretório temporário isolado e copiar os 4 TTF e a licença para `packages/rebic_foundation/fonts/inter/` (D1). Registrar a origem, a versão e os SHA-256 em `fonts/inter/README.md`. Verificação: os 5 arquivos existem, e os hashes no README conferem com `sha256sum`. Se a estrutura do zip for diferente da esperada, pausar.
- [x] 1.2 Declarar a família em `flutter: fonts:` no `pubspec.yaml` de `rebic_foundation` (D2). Verificação: `flutter pub get` na raiz conclui, e o teste "Fonte empacotada e licenciada — Licença distribuída" passa.

## 2. Primitivos

- [x] 2.1 Criar `RebicTypographyPrimitives` (D3, D4), com dartdoc `Nível: primitivo.`, e reexportá-lo em `rebic_primitives.dart`. O teste de nível documentado passa a varrer `lib/src/typography`. Verificação: teste "Escalas tipográficas primitivas — Escalas em ordem".

## 3. Estilos semânticos

- [x] 3.1 Implementar `RebicTypographyTokens` (D5, D6) com `fallback()` constante, `copyWith`, `lerp`, `==`/`hashCode` e `debugFillProperties`, e exportá-lo. Verificação: testes "Fontes de fallback do sistema — Fallback sem prefixo de pacote"; "Estilos semânticos de texto — Estilo completo e sem cor" e "— Hierarquia de tamanhos"; "Ritmo vertical e legibilidade — Altura de linha na grade" e "— Tamanho mínimo"; "Contrato do conjunto tipográfico — Contrato verificado", "— Interpolação de tamanho" e "— Valores vêm dos primitivos"; e um teste que altera cada estilo isoladamente.

## 4. Galeria

- [x] 4.1 Escrever o teste "Fonte empacotada e licenciada — Fonte disponível na aplicação consumidora" na galeria (D7). Verificação: os quatro TTF são carregados por `rootBundle` com o prefixo `packages/rebic_foundation/`, e o teste passa.
- [x] 4.2 Adicionar a página "Tipografia" (`pages/typography_page.dart`) ao índice (D8). Verificação: teste "Testes e documentação da tipografia — Página na galeria", que encontra os oito nomes de estilo com suas medidas.

## 5. Catálogo, changelog e verificação final

- [x] 5.1 Atualizar `docs/catalog.yaml` (`rebic/foundation/typography` → `implemented`) e a seção "Não lançado" do `CHANGELOG.md` de `rebic_foundation`, mencionando a fonte e a licença. Verificação: `dart run rebic_checks catalog` passa.
- [x] 5.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-foundation-typography`) após a revisão.
- Próximas changes, na ordem combinada: `add-rebic-foundation-radius`, `-breakpoints`, `-iconography` (Lucide) e depois `-density`.
