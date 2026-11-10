# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs alteradas.

## 1. Fundamento

- [x] 1.1 Acrescentar `pageMarginMedium`, `pageMarginLarge`, `pageMarginExtraLarge` e `pageMarginFor` a `GjaSpacingTokens` (D1), com os valores de referência e o dartdoc dos passos citando as classes de margem do Fiori. Verificação: "Papéis de layout — Papéis apontam para passos", "— Hierarquia dos papéis" e "— Margem de página por classe de tamanho"; "Classes de margem do Fiori — Passos e classes de margem"; os cenários de contrato do espaçamento continuam passando.
- [x] 1.2 Apagar `_compactSpacing` e usar o espaçamento de referência no compacto (D2), ajustando `density_test.dart`. Verificação: "Espaçamento por densidade — Espaçamento confortável" e "— Espaçamento compacto"; "Contrato do conjunto de densidade" (dois cenários).

## 2. Widgets

- [x] 2.1 `GjaPage`: margem do conteúdo, da área de título e do rodapé pela classe de tamanho da largura da página (D3). Verificação: "[Comportamento] Margem do conteúdo — Conteúdo sem margem" e "— Margem pela largura da página"; "[Aparência] Tokens de componente — Margem da densidade compacta".
- [x] 2.2 Revisar os testes de densidade por subárvore (coluna, linha, contêiner, divisor, `GjaSpacing`, página, tema) que exigem espaço compacto menor (D4). Verificação: `flutter test --exclude-tags golden` em `packages/gja_widgets` sem falhas.
- [x] 2.3 Regerar no Windows (tag `golden`) os goldens que mudarem, nas duas densidades e nos dois temas, conferindo por amostragem que os compactos ganharam os espaços do cozy. Verificação: `flutter test` em `packages/gja_widgets`, com e sem a tag `golden`, sem falhas.

- [x] 2.4 Atualizar os testes dos cenários de densidade de `gja-column`, `gja-row`, `gja-container`, `gja-divider` e `gja-spacing` conforme os deltas: igualdade dentro e fora da subárvore compacta, e troca para um tema com outro espaçamento nos cenários de troca de densidade. Verificação: "[Aparência] Tokens de componente — Troca de densidade da coluna" e "— Troca de densidade da linha"; "[Responsividade] Direção e densidade — Densidade compacta na coluna" e "— Densidade compacta na linha"; "[Responsividade] Densidade — Densidade compacta" (contêiner e `GjaSpacing`) e "— Densidade compacta do divisor"; "[Aparência] Tokens de componente — Troca de densidade" (`GjaSpacing`).

## 3. Galeria

- [x] 3.1 Página "Espaçamentos" com a margem de página de S a XL, e seu teste. Verificação: "Testes e documentação dos espaçamentos — Página na galeria".

## 4. Catálogo, documentação e verificação final

- [x] 4.1 `docs/catalog.yaml`: acrescentar `gja/foundation/breakpoints` às dependências de `gja/widgets/gja-page`. Verificação: `dart run gja_checks catalog`.
- [x] 4.2 Acrescentar à ADR 0009 a linha de D5, e atualizar os CHANGELOGs de `gja_foundation` (margens por classe; compacto com o espaçamento de referência, **BREAKING** visual) e `gja_widgets` (`GjaPage` responsiva; compactos mais espaçados).
- [x] 4.3 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-foundation-spacing-fiori-margins`) após a revisão. No arquivamento, corrigir também o `## Purpose` da spec principal de densidade, que ainda cita `comfortable` (pendência da change de densidade).
- Próxima change de realinhamento da fundação: raios (papéis por controle).
