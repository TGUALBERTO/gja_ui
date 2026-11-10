# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/foundation/accessibility`. Esta change não entrega
widget público, então não há goldens.

## 1. API de convenções

- [x] 1.1 Criar `GjaAccessibility` (D1, D2) em `lib/src/accessibility/accessibility.dart`, com dartdoc `Nível: semântico.`, e exportá-lo em `gja_foundation.dart`. O teste de nível documentado passa a varrer `lib/src/accessibility`. Verificação: testes "Meta de conformidade — Limites declarados", "Contraste pelos papéis de cor — Mesmos mínimos do fundamento de cor", "Alvo mínimo de interação por densidade — Alvo por densidade", "Movimento reduzido — Animações desativadas" e "— Animações ativas".
- [x] 1.2 Escrever o teste "Bateria mínima de testes de acessibilidade — Diretriz de alvo pela densidade" (D4). Verificação: o teste passa com a superfície de 48 × 48 e confirma a falha com 20 × 20 nas duas densidades.

## 2. Template de spec de widget

- [x] 2.1 Atualizar `docs/specs/widget-spec-template.md` (D3): o requisito de acessibilidade cita rótulo, papel, estado e valor, e o requisito `[Testes]` lista a bateria mínima. Verificação: teste "Semântica dos widgets interativos — Convenção no template de spec", e `gja_checks specs` continua passando.

## 3. Galeria

- [x] 3.1 Adicionar a página "Acessibilidade" (`pages/accessibility_page.dart`) ao índice (D5) e corrigir o que estourar na galeria em escala 2,0. Verificação: testes "Escala de texto — Conteúdo em 200%" e "Testes e documentação da acessibilidade — Página na galeria".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (`gja/foundation/accessibility` → `implemented`) e a seção "Não lançado" do `CHANGELOG.md` de `gja_foundation`. Verificação: `dart run gja_checks catalog` passa.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-foundation-accessibility`) após a revisão.
- Próximo e último fundamento: `add-gja-foundation-theming`, que reúne todos os conjuntos em `GjaThemeData` (claro, escuro e marca).
