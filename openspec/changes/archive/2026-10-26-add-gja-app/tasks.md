# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/widgets/gja-app` (20 cenários).

## 1. GjaApp

- [x] 1.1 Criar `GjaThemeMode` e `GjaApp`/`GjaApp.router` (D1, D2, D3) em `packages/gja_widgets/lib/src/fundacao_layout/app/`, com dartdoc (incluindo uma aplicação mínima) e exportados em `gja_widgets.dart`. Verificação: testes de "[API] Propriedades" (2), "[API] Tema, densidade e idioma", "[API] Callbacks e controlador", "[Comportamento] Tema e modo do sistema" (2), "[Comportamento] Densidade da aplicação" (2), "[Comportamento] Localização da aplicação", "[Aparência] Fundo da aplicação", "[Estados] Sem estados visuais", "[Acessibilidade] Teclado e foco", "[Acessibilidade] Semântica, escala e movimento", "[Responsividade] Escopo de tela e plataformas", "[Integração] Dependências" e "[Restrições] Fora do escopo".
- [x] 1.2 Criar a rota de página `GjaPageRoute` (D4) e usá-la no `pageRouteBuilder`. Verificação: testes "[Comportamento] Transição de página — Meio da transição" e "— Movimento reduzido", em LTR e RTL.
- [x] 1.3 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade", que confere os 20 cenários da spec contra os nomes das suítes de `gja_widgets` e da galeria.

## 2. Galeria

- [x] 2.1 Migrar `apps/gja_gallery/lib/main.dart` para `GjaApp`, com a escolha de modo de tema e densidade no índice (D5). Verificação: teste "[Documentação] Exemplos mínimos — Página na galeria" e os testes existentes da galeria passando.

## 3. Catálogo, changelog e verificação final

- [x] 3.1 Atualizar `docs/catalog.yaml` (D6) e o `CHANGELOG.md` de `gja_widgets`. Verificação: `dart run gja_checks catalog` passa, incluindo a pasta `fundacao_layout/app`.
- [x] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-app`) após a revisão.
- Próximos widgets P0 da Fase 1, pela ordem do design da Fase 0: `GjaText` e `GjaIcon`, depois `GjaSpacing` e `GjaContainer`.
