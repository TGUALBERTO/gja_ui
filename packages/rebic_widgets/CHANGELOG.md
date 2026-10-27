# Changelog

## Não lançado

- `RebicText` (`add-rebic-text`, spec `rebic/widgets/rebic-text`): texto com `variant` (escala tipográfica), `tone`
  (texto, rótulo ou estado de valor), `maxLines` com reticências, `textAlign` e semântica de cabeçalho nas variantes
  de título.
- Infraestrutura de goldens: fonte Inter nos testes, etiqueta `golden` e referência gerada no Windows (ADR 0008).
- `RebicApp` (`add-rebic-app`, spec `rebic/widgets/rebic-app`): raiz da aplicação sobre `WidgetsApp`, sem Material,
  com navegação por rotas ou `RebicApp.router`, `theme`/`darkTheme` e `RebicThemeMode` (segue o brilho do sistema),
  densidade recomendada pela plataforma, localização do Rebic, escopo de tela, fundo `background` e transição de
  página deslizando do lado final (imediata com movimento reduzido).
- `RebicTheme` (`add-rebic-theme`, spec `rebic/widgets/rebic-theme`), primeiro widget público: aplica o tema à
  subárvore com troca animada, `RebicTheme.density` troca a densidade de uma subárvore, e o texto e o ícone padrão
  seguem o tema.

## 0.0.1

- Estrutura inicial do pacote (Fase 0). Sem API pública.
