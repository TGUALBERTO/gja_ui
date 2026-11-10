# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/foundation/iconography`. Esta change não entrega
widget público, então não há goldens nem testes de acessibilidade.

## 1. Fonte de ícones

- [x] 1.1 Baixar `lucide-static@1.61.0` para um diretório temporário isolado, conferir o SHA-512 com o `dist.integrity` do registro e copiar `lucide.ttf`, `codepoints.json` e `LICENSE` para `packages/gja_foundation/fonts/lucide/` (D1). Registrar a origem, a versão e os SHA-256 em `README.md`. Verificação: a integridade confere, e os hashes do README conferem com `sha256sum`. Se a integridade divergir, pausar.
- [x] 1.2 Declarar a família `Lucide` no `pubspec.yaml` de `gja_foundation` (D2). Verificação: `flutter pub get` conclui, e o teste "Fonte de ícones empacotada e licenciada — Licença e mapa distribuídos" passa.

## 2. Primitivos e catálogo

- [x] 2.1 Criar `GjaIconPrimitives` (família, pacote e tamanhos 12–48), com dartdoc `Nível: primitivo.`, e reexportá-lo em `gja_primitives.dart`. O teste de nível documentado passa a varrer `lib/src/iconography`. Verificação: teste "Escala primitiva de tamanhos de ícone — Escala em ordem".
- [x] 2.2 Criar `GjaIcons` (D3, D4), com os ícones `const`, `matchTextDirection` nos direcionais e o mapa `all`, e exportá-lo. Verificação: testes "Catálogo semântico de ícones — Códigos conferem com o mapa oficial" e "— Catálogo completo e sem repetição"; "Espelhamento de ícones direcionais — Ícone direcional em RTL"; e "Uso de ícones fora do catálogo — Ícone extra da aplicação". Se algum significado não tiver equivalente na Lucide, pausar.

## 3. Tamanhos

- [x] 3.1 Implementar `GjaIconTokens` (D5) com `fallback()` constante, `copyWith` com `assert`, `lerp`, `==`/`hashCode` e `debugFillProperties`, e exportá-lo. Verificação: testes "Passos e papéis de tamanho de ícone — Mapeamento de referência" e "— Tamanho inválido rejeitado"; "Contrato do conjunto de tamanhos de ícone — Contrato verificado"; e um teste que altera cada campo isoladamente.

## 4. Galeria

- [x] 4.1 Escrever o teste "Fonte de ícones empacotada e licenciada — Fonte disponível na aplicação consumidora" na galeria (D6). Verificação: o teste passa sem a galeria declarar fontes.
- [x] 4.2 Adicionar a página "Ícones" (`pages/icons_page.dart`) ao índice (D7). Verificação: teste "Testes e documentação dos ícones — Página na galeria", que encontra um ícone e o nome para cada entrada de `GjaIcons.all`.

## 5. Catálogo, changelog e verificação final

- [x] 5.1 Atualizar `docs/catalog.yaml` (`gja/foundation/iconography` → `implemented`) e a seção "Não lançado" do `CHANGELOG.md` de `gja_foundation`, mencionando a fonte e a licença. Verificação: `dart run gja_checks catalog` passa.
- [x] 5.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-foundation-iconography`) após a revisão.
- Próxima change da ordem combinada: `add-gja-foundation-density`, que depende de `spacing` e `typography`, ambas já prontas.
