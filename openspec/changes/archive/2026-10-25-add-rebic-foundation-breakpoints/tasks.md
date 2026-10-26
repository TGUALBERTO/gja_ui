# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/foundation/breakpoints`. Esta change não entrega
widget público, então não há goldens nem testes de acessibilidade.

## 1. Primitivos e classes de tamanho

- [x] 1.1 Criar `lib/src/breakpoints/primitives/breakpoint_primitives.dart` (D1), com dartdoc `Nível: primitivo.`, e reexportá-lo em `rebic_primitives.dart`. O teste de nível documentado passa a varrer `lib/src/breakpoints`. Verificação: teste "Escala primitiva de larguras — Escala em ordem".
- [x] 1.2 Criar `RebicSizeClass` com `isAtLeast`/`isAtMost` (D2) e exportá-lo. Verificação: teste "Classes de tamanho — Comparação de classes".

## 2. Conjunto semântico e classificação

- [x] 2.1 Implementar `RebicBreakpointTokens` (D2, D3, D4) com `fallback()` constante, `classify`, `minWidthOf`, `copyWith` com `assert` de ordem, `lerp`, `==`/`hashCode` e `debugFillProperties`, e exportá-lo. Verificação: testes "Limiares semânticos — Mapeamento de referência" e "— Limiares fora de ordem rejeitados"; "Classificação de uma largura — Larguras nas bordas", "— Largura sem limite", "— Largura inválida" e "— Limiares personalizados"; "Contrato do conjunto de breakpoints — Contrato verificado" e "— Interpolação de limiar"; e um teste que altera cada limiar isoladamente.

## 3. Galeria

- [x] 3.1 Adicionar a página "Breakpoints" (`pages/breakpoints_page.dart`) ao índice (D5). Verificação: teste "Testes e documentação dos breakpoints — Página na galeria", com janelas de 500, 800, 1200 e 1600 px.

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (`rebic/foundation/breakpoints` → `implemented`) e a seção "Não lançado" do `CHANGELOG.md` de `rebic_foundation`. Verificação: `dart run rebic_checks catalog` passa.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-foundation-breakpoints`) após a revisão.
- Próximas changes, na ordem combinada: `add-rebic-foundation-iconography` (Lucide) e depois `-density`.
