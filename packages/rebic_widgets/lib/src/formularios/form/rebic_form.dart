import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../fundacao_layout/label/rebic_label.dart';
import '../../fundacao_layout/title/rebic_title.dart';

/// Elemento de um [RebicFormContainer], como o `sap.ui.layout.form.FormElement`
/// do SAPUI5: um rótulo e os campos que ele descreve.
///
/// É uma configuração, não um widget: use em
/// [RebicFormContainer.formElements].
@immutable
class RebicFormElement {
  /// Cria o elemento com [fields].
  const RebicFormElement({
    required this.fields,
    this.label,
    this.required = false,
  });

  /// Texto do rótulo.
  final String? label;

  /// Se o rótulo mostra o asterisco de obrigatório.
  final bool required;

  /// Campos do elemento, lado a lado; cada um mantém o próprio estado.
  final List<Widget> fields;
}

/// Grupo de elementos de um [RebicForm], como o
/// `sap.ui.layout.form.FormContainer` do SAPUI5.
///
/// É uma configuração, não um widget: use em [RebicForm.formContainers].
@immutable
class RebicFormContainer {
  /// Cria o contêiner com [formElements].
  const RebicFormContainer({required this.formElements, this.title});

  /// Título do contêiner.
  final String? title;

  /// Elementos, de cima para baixo.
  final List<RebicFormElement> formElements;
}

/// Formulário, como o `sap.ui.layout.form.Form` com o `ColumnLayout` do
/// SAPUI5.
///
/// Mostra [title] e os [formContainers] distribuídos em colunas pela
/// largura do próprio formulário (não da tela): 1 coluna no S e [columnsM],
/// [columnsL] ou [columnsXL] nas outras classes de tamanho, no máximo uma
/// por contêiner. Os rótulos ficam ao lado dos campos, com
/// [labelCellsLarge] partes de 12 da coluna, no L e no XL, e no M com uma
/// coluna; nos outros casos, acima.
///
/// O formulário não tem estado: cada campo mantém o próprio valor e os
/// próprios eventos.
///
/// ```dart
/// RebicForm(
///   title: 'Fornecedor',
///   formContainers: [
///     RebicFormContainer(
///       formElements: [
///         RebicFormElement(
///           label: 'Nome',
///           required: true,
///           fields: [RebicInput(value: nome, placeholder: 'Nome', onLiveChange: ...)],
///         ),
///       ],
///     ),
///   ],
/// )
/// ```
class RebicForm extends StatelessWidget {
  /// Cria o formulário com [formContainers].
  const RebicForm({
    required this.formContainers,
    this.title,
    this.columnsM = 1,
    this.columnsL = 2,
    this.columnsXL = 2,
    this.labelCellsLarge = 4,
    super.key,
  });

  /// Título do formulário.
  final String? title;

  /// Contêineres, na ordem das colunas.
  final List<RebicFormContainer> formContainers;

  /// Colunas no M, de 1 a 2.
  final int columnsM;

  /// Colunas no L, de 1 a 3.
  final int columnsL;

  /// Colunas no XL, de 1 a 4.
  final int columnsXL;

  /// Partes de 12 da coluna ocupadas pelo rótulo ao lado, de 1 a 11.
  final int labelCellsLarge;

  void _validate() {
    assert(formContainers.isNotEmpty, 'formContainers não pode ser vazia');
    assert(
      formContainers.every(
        (c) =>
            c.formElements.isNotEmpty &&
            c.formElements.every((e) => e.fields.isNotEmpty),
      ),
      'formElements e fields não podem ser vazias',
    );
    assert(columnsM >= 1 && columnsM <= 2, 'columnsM deve estar entre 1 e 2');
    assert(columnsL >= 1 && columnsL <= 3, 'columnsL deve estar entre 1 e 3');
    assert(
      columnsXL >= 1 && columnsXL <= 4,
      'columnsXL deve estar entre 1 e 4',
    );
    assert(
      labelCellsLarge >= 1 && labelCellsLarge <= 11,
      'labelCellsLarge deve estar entre 1 e 11',
    );
  }

  @override
  Widget build(BuildContext context) {
    _validate();
    final theme = RebicThemeData.of(context);
    final spacing = theme.spacing;
    final text = title;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final sizeClass = theme.breakpoints.classify(constraints.maxWidth);
          final wanted = switch (sizeClass) {
            RebicSizeClass.small => 1,
            RebicSizeClass.medium => columnsM,
            RebicSizeClass.large => columnsL,
            RebicSizeClass.extraLarge => columnsXL,
          };
          final columns = wanted < formContainers.length
              ? wanted
              : formContainers.length;
          final beside =
              sizeClass.isAtLeast(RebicSizeClass.large) ||
              (sizeClass == RebicSizeClass.medium && columns == 1);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: spacing.l,
            children: [
              if (text != null)
                RebicTitle(text, titleStyle: RebicTitleLevel.h4),
              for (var i = 0; i < formContainers.length; i += columns)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: spacing.l,
                  children: [
                    for (var j = i; j < i + columns; j++)
                      Expanded(
                        child: j < formContainers.length
                            ? _Container(
                                container: formContainers[j],
                                beside: beside,
                                labelCells: labelCellsLarge,
                              )
                            : const SizedBox.shrink(),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Container extends StatelessWidget {
  const _Container({
    required this.container,
    required this.beside,
    required this.labelCells,
  });

  final RebicFormContainer container;
  final bool beside;
  final int labelCells;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final text = container.title;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.s,
      children: [
        if (text != null) RebicTitle(text, titleStyle: RebicTitleLevel.h5),
        for (final element in container.formElements)
          _Element(element: element, beside: beside, labelCells: labelCells),
      ],
    );
  }
}

class _Element extends StatelessWidget {
  const _Element({
    required this.element,
    required this.beside,
    required this.labelCells,
  });

  final RebicFormElement element;
  final bool beside;
  final int labelCells;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final spacing = theme.spacing;
    final text = element.label;
    final label = text == null
        ? null
        : RebicLabel(text, required: element.required, wrapping: true);
    final fields = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing.s,
      children: [for (final field in element.fields) Expanded(child: field)],
    );
    if (!beside) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: spacing.xs,
        children: [?label, fields],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: labelCells,
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: spacing.s),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: theme.density.minTargetSize,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: 1,
                child: label,
              ),
            ),
          ),
        ),
        Expanded(flex: 12 - labelCells, child: fields),
      ],
    );
  }
}
