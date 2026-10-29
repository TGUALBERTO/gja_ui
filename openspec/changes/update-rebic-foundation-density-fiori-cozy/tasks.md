# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs alteradas.

## 1. Fundamento

- [x] 1.1 Criar `RebicDensityPrimitives` (D2), exportado por `rebic_primitives.dart`, renomear `comfortable` para `cozy` (D1) e aplicar os mapeamentos de D3, com dartdoc citando os parâmetros `sapElement_*`. Verificação: "Modos de densidade — Mapeamento por modo" e "— Nomes do Fiori"; "Dimensões de controle por densidade — Valores de referência", "— Compacto não maior que confortável" e "— Escala primitiva de densidade"; "Alvo mínimo de interação" (dois cenários); "Espaçamento por densidade" (dois cenários); "Contrato do conjunto de densidade — Interpolação entre densidades" (31).
- [x] 1.2 Reescrever o teste "Tipografia preservada — Rótulo cabe no controle" com `base` e `xxs` (D4), e atualizar os testes de tema e de acessibilidade. Verificação: "Tipografia preservada" (dois cenários); "Temas de referência claro e escuro — Densidade padrão" e os demais cenários do tema; "Alvo mínimo de interação por densidade — Alvo por densidade" (44 e 32).

## 2. Núcleo

- [x] 2.1 `RebicResponsive.recommendedDensity`: `cozy` para Android, iOS e Fuchsia, e CHANGELOG de `rebic_core`. Verificação: "Densidade recomendada — Plataformas".

## 3. Widgets

- [x] 3.1 Renomear `RebicDensity.comfortable` nos testes e no código de `rebic_widgets`, e trocar medidas literais por tokens onde houver (D6). Verificação: "[Comportamento] Densidade da aplicação — Densidade recomendada" e "— Densidade informada" de `rebic-app`; `flutter test --exclude-tags golden` em `packages/rebic_widgets` sem falhas.
- [x] 3.2 Apagar os `*_comfortable.png` com `git rm`, regerar todos os goldens no Windows (tag `golden`) e conferir por amostragem o botão cozy (36 em 44), o compacto (26 em 32) e os itens de dropdown e menu (D5). Verificação: `flutter test` em `packages/rebic_widgets`, com e sem a tag `golden`, sem falhas, e nenhum `*_comfortable.png` no repositório.

## 4. Galeria

- [x] 4.1 Renomear `comfortable` na galeria (`main.dart`, páginas de espaçamento, tema e `RebicTheme`) e atualizar a página "Densidade" com `cozy` e `compact`, com seus testes. Verificação: "Testes e documentação da densidade — Página na galeria" e `gallery_dark_theme_test.dart`.

## 5. Documentação, changelog e verificação final

- [x] 5.1 Acrescentar à ADR 0009 a linha de D7.
- [x] 5.2 Atualizar os CHANGELOGs de `rebic_foundation` (**BREAKING**: `comfortable` → `cozy`, medidas novas, `RebicDensityPrimitives`), `rebic_core` e `rebic_widgets` (medidas novas, goldens renomeados).
- [x] 5.3 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-rebic-foundation-density-fiori-cozy`) após a revisão.
- Próxima change de realinhamento da fundação: espaçamento (margens Fiori, margem de página por breakpoint).
