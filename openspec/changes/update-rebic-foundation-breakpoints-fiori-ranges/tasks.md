# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs alteradas.

## 1. Fundamento

- [ ] 1.1 Remover `width360`, `width840`, `width1280` e `width1920` de `RebicBreakpointPrimitives` e de `values` (D1), e citar as faixas do SAPUI5 no dartdoc dos primitivos, de `RebicSizeClass` e de `RebicBreakpointTokens.fallback` (D2). Verificação: "Escala primitiva de larguras — Escala em ordem" e "— Faixas do SAPUI5"; "Classes de tamanho — Comparação de classes"; os demais cenários de breakpoints continuam passando.

## 2. Documentação e verificação final

- [ ] 2.1 Atualizar o CHANGELOG de `rebic_foundation` (**BREAKING**: primitivos removidos).
- [ ] 2.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-rebic-foundation-breakpoints-fiori-ranges`) após a revisão.
- Com isso termina o realinhamento da fundação. Próximo bloco: núcleo (modal e posicionamento).
