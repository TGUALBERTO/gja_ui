# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/foundation/theming`. Esta change não entrega
widget público, então não há goldens. A propagação do tema pela árvore fica com `add-rebic-theme`.

## 1. Catálogo

- [x] 1.1 Confirmar que as dependências de `rebic/foundation/theming` em `docs/catalog.yaml` já incluem os onze fundamentos, inclusive `iconography` e `accessibility` (D5). Verificação: `dart run rebic_checks catalog` passa com a spec desta change.

## 2. Tema

- [x] 2.1 Implementar `RebicThemeData` (D1, D2, D4) em `lib/src/theming/theme_data.dart`, com o construtor `const`, `light`/`dark` com densidade, `spacing`, `withDensity`, `copyWith`, `lerp`, `==`/`hashCode`, `debugFillProperties` e dartdoc `Nível: semântico.`, e exportá-lo. O teste de nível documentado passa a varrer `lib/src/theming`. Verificação: testes "Tema centralizado — Tema completo"; "Temas de referência claro e escuro — Claro e escuro diferem só na cor" e "— Densidade no tema"; "Troca de densidade — Tema compacto a partir do confortável"; "Tokens de componente e extensões — Componente registrado e ausente"; "Interpolação entre temas — Troca animada de claro para escuro" e "— Contrato verificado"; e um teste que altera cada campo isoladamente.
- [x] 2.2 Implementar `accessibilityIssues()` e `resolve(disableAnimations:)` (D3). Verificação: testes "Personalização controlada — Tema de marca válido" e "— Tema de marca inválido", e "Movimento reduzido no tema — Tema resolvido com redução".

## 3. Galeria

- [x] 3.1 Adicionar a página "Tema" (`pages/theme_page.dart`) ao índice (D6). Verificação: teste "Testes e documentação do tema — Página na galeria", que troca o brilho e confere a cor `surface` da prévia, e confirma que a marca de exemplo não tem problemas de acessibilidade.

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (`rebic/foundation/theming` → `implemented`) e a seção "Não lançado" do `CHANGELOG.md` de `rebic_foundation`. Verificação: `dart run rebic_checks catalog` passa.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-foundation-theming`) após a revisão. Com isso, os 12 fundamentos da Fase 1 ficam concluídos.
- Próximas changes da ordem sugerida: o núcleo (`add-rebic-core-interaction`, `-localization`, `-responsive`, depois `-overlay`) e o widget `add-rebic-theme`.
