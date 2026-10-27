# Como contribuir com o framework Rebic

O Rebic é desenvolvido por **specs** com o [OpenSpec](https://github.com/Fission-AI/OpenSpec) (CLI 1.14.3, schema `spec-driven`).
Todo comportamento novo começa com uma change, é implementado nela e só então é arquivado como spec principal.

Leitura obrigatória:

- specs [`rebic/framework-architecture`](../openspec/specs/rebic/framework-architecture/spec.md) e
  [`rebic/spec-governance`](../openspec/specs/rebic/spec-governance/spec.md);
- [ADRs](adr/README.md);
- [catálogo de componentes](catalog.yaml).

## Fluxo de uma change

1. **Escolher o item** em [`catalog.yaml`](catalog.yaml).
   Todas as dependências (`depends_on`) já precisam ter spec em `openspec/specs/`.
   A exceção são widgets inseparáveis propostos na mesma change.
2. **Propor:** `/opsx:propose` (ou `openspec new change <nome>`). São gerados `proposal.md`, a spec,
   `design.md` (quando houver decisão técnica) e `tasks.md`.
   - Spec de widget: copiar [`specs/widget-spec-template.md`](specs/widget-spec-template.md).
   - Validar: `openspec validate <change> --strict` e `dart run rebic_checks specs`.
3. **Revisar a proposta** antes de implementar: spec, dependências, prioridade e impacto.
4. **Implementar:** `/opsx:apply`. Cada tarefa entrega o código **com** seus testes e sua documentação.
5. **Verificar:** `tool/ci.sh` (ou `tool\ci.ps1` no Windows) deve terminar com código 0.
6. **Arquivar:** `/opsx:archive`. A spec da change vira spec principal. Atualize o status no catálogo.

## Nomenclatura

| Tipo | Nome da change | Caminho da spec |
|---|---|---|
| Novo widget | `add-rebic-<widget>` | `rebic/widgets/rebic-<widget>` |
| Novo fundamento | `add-rebic-foundation-<x>` | `rebic/foundation/<x>` |
| Nova infraestrutura do núcleo | `add-rebic-core-<x>` | `rebic/core/<x>` |
| Alteração | `update-rebic-<item>-<assunto>` | caminho existente (delta MODIFIED/ADDED) |
| Remoção | `remove-rebic-<item>` | caminho existente (delta REMOVED com migração) |

O widget `RebicTextField` tem a change `add-rebic-text-field` e a spec `rebic/widgets/rebic-text-field`.
O código fica em `packages/rebic_widgets/lib/src/<categoria>/text_field/`, onde a categoria vem do catálogo, em snake_case.

## Granularidade

- **Uma change por widget público.** Até três specs na mesma change só para widgets inseparáveis
  (por exemplo, `RebicForm` + `RebicFormField`), com justificativa na proposta. Cada widget mantém a sua spec.
- Uma correção que não muda comportamento especificado (refactor, bug fix fiel à spec) pode usar
  `skip_specs: true` no `.openspec.yaml` da change.

## Critérios de revisão

Uma change só é aprovada quando:

- [ ] `openspec validate <change> --strict` e `tool/ci` passam;
- [ ] a spec segue o template (Purpose + as 10 etiquetas) e as seções não aplicáveis são decisões explícitas;
- [ ] as dependências estão declaradas em `[Integração]`, existem e batem com `docs/catalog.yaml`;
- [ ] a API pública segue as convenções (prefixo `Rebic`, `on<Evento>`, callback nulo = desabilitado, variantes como enum,
      `RebicValueState`, densidade via tema) e não expõe tipos Material/Cupertino;
- [ ] não há valores visuais literais nos widgets, ou cada exceção está justificada em `tool/rebic_checks/token_exceptions.yaml`;
- [ ] cada cenário tem teste nomeado `<requisito> — <cenário>`, e há goldens (claro/escuro × densidades) e testes de acessibilidade;
- [ ] os goldens têm a etiqueta `golden` e foram regenerados e conferidos no Windows
      (`flutter test --update-goldens --tags golden` no pacote; ver [ADR 0008](adr/0008-golden-reference-windows.md));
- [ ] o widget aparece na galeria e toda a API pública tem dartdoc;
- [ ] o catálogo e o `CHANGELOG.md` do pacote foram atualizados;
- [ ] nenhum arquivo do portal existente foi alterado.

## Versionamento e depreciação

- Versionamento semântico por pacote. As versões ficam sincronizadas na série `0.x` até o fim da Fase 3,
  e a `1.0.0` sai ao fim da Fase 5.
- Na série `0.x`, uma quebra de API pode ocorrer em versão menor e **deve** constar no `CHANGELOG.md`.
- A partir da `1.0.0`, remover ou alterar API pública exige antes uma versão menor com `@Deprecated('<migração>')`.
  A remoção só acontece na versão maior seguinte.
- Mudanças nas restrições de SDK seguem a [ADR 0001](adr/0001-sdk-baseline.md).
  Exigir SDK mais novo que o do portal depende de aprovação explícita.

## Exceções à arquitetura

- **Material/Cupertino interno:** exige uma ADR nova e o marcador `// rebic-adr: NNNN` na linha do import
  ([ADR 0004](adr/0004-no-material-public-api.md)).
- **Valor visual literal:** exige uma entrada justificada em `tool/rebic_checks/token_exceptions.yaml`
  ([ADR 0005](adr/0005-design-tokens-three-levels.md)).
- **Render object próprio:** exige justificativa no `design.md` da change.

## Comandos úteis

```sh
flutter pub get                      # resolve o workspace inteiro
dart analyze .                       # lints compartilhados
dart run rebic_checks all            # verificações de conformidade (ver tool/rebic_checks/README.md)
openspec list --specs                # specs existentes
openspec validate --all --strict     # valida specs e changes
tool/ci.sh                           # pipeline completo (tool\ci.ps1 no Windows)
```
