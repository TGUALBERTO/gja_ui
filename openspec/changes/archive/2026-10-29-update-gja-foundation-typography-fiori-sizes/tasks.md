# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs alteradas.

## 1. Fundamento

- [x] 1.1 Adicionar `size48` e `lineHeight60` aos primitivos de tipografia, e atualizar o teste "Escalas tipográficas primitivas — Escalas em ordem" se ele listar os valores.
- [x] 1.2 Reescrever `GjaTypographyTokens` com os onze estilos de D1 (construtor, `fallback`, `styles`, `copyWith`, `lerp`, `==`, `hashCode`, diagnóstico), com dartdoc citando o parâmetro Fiori de cada estilo. Verificação: testes "Estilos semânticos de texto — Estilo completo e sem cor", "— Hierarquia de tamanhos", "— Pesos do texto base" e "— Sem nomes do Material"; "Contrato do conjunto tipográfico — Contrato verificado", "— Interpolação de tamanho" e "— Valores vêm dos primitivos"; "Ritmo vertical e legibilidade" (dois cenários) e "Fontes de fallback do sistema" continuam passando.
- [x] 1.3 Atualizar `theme_data_test.dart` e demais testes de `gja_foundation` que citam estilos pelo nome.

## 2. Widgets

- [x] 2.1 `GjaText`: mapear as variantes conforme D2 e citar o estilo Fiori no dartdoc de cada variante. Verificação: "[Aparência] Tokens de componente — Variantes e tons" e "— Troca de tema".
- [x] 2.2 `GjaButton` (`baseSemibold`), `GjaLink` (`base`/`baseBold`), `GjaStatusIndicator`, `GjaTheme` e lista de opções (`base`), `GjaBadge` (variante `caption`) e `GjaAvatar` (D3). Verificação: os testes dos cenários alterados de `gja-button`, `gja-link`, `gja-status-indicator`, `gja-badge` e `gja-avatar`, e o teste de cartão estreito de `GjaCard` sem estouro (risco de D5).
- [x] 2.3 Regerar os goldens afetados no Windows (tag `golden`), nos temas claro e escuro e nas duas densidades, e conferir por amostragem as diferenças esperadas de D5.

## 3. Galeria

- [x] 3.1 Atualizar a página "Tipografia" e as páginas que usam estilos pelo nome. Verificação: "Testes e documentação da tipografia — Página na galeria" (onze estilos) e o teste de tema escuro da galeria.

## 4. Documentação, changelog e verificação final

- [x] 4.1 Criar `docs/adr/0009-provisional-horizon-values.md` (D4) e a linha no índice `docs/adr/README.md`.
- [x] 4.2 Atualizar os CHANGELOGs de `gja_foundation` e `gja_widgets` com a tabela de/para (**BREAKING**). O catálogo não muda: os itens continuam `implemented`; confirmar com `dart run gja_checks catalog`.
- [x] 4.3 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-foundation-typography-fiori-sizes`) após a revisão.
- Próximas changes de realinhamento da fundação, uma por fundamento: estados de interação (`dragged`, opacidades de state layer, hover/ativo de Accept/Reject/Attention), sombras (renomear elevação, popover → Shadow2, dialog → Shadow3), movimento (curvas e `AnimationMode`), densidade (`cozy`, alturas de elemento, alvo 44), espaçamento (margens Fiori, margem de página por breakpoint), raios (papéis por controle), ícones (nomes do IconPool, `sapContent_IconHeight`) e breakpoints (primitivos sem uso).
- Depois: core (modal, placement), layout (`GjaText` → Title/Text/Label, ToolPage + ShellBar, Page, Card, Separator, FlexBox, Grid) e ações/dados.
