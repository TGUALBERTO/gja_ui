import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../fundacao_layout/text/rebic_text.dart';
import '../../fundacao_layout/title/rebic_title.dart';

/// Situação de uma [RebicIllustratedMessage], como o `IllustratedMessageType`
/// do SAPUI5; define o ícone da ilustração.
enum RebicIllustrationType {
  /// Não há dados para mostrar.
  noData,

  /// A lista ainda não tem itens.
  noEntries,

  /// A busca não encontrou resultados.
  noSearchResults,

  /// Os filtros não deixaram resultados.
  noFilterResults,

  /// Algo deu errado.
  error,

  /// A operação terminou com sucesso.
  success,
}

/// Tamanho de uma [RebicIllustratedMessage], como o `IllustratedMessageSize`
/// do SAPUI5.
enum RebicIllustrationSize {
  /// Pequena, para cartões e áreas estreitas.
  spot,

  /// Média, para diálogos e painéis.
  dialog,

  /// Grande, para páginas inteiras.
  scene,
}

/// Mensagem com ilustração para uma área sem conteúdo, como o
/// `sap.m.IllustratedMessage` do SAPUI5.
///
/// Mostra, centralizados, a ilustração do [illustrationType] (ou
/// [illustration]), o [title], a [description] e as ações de
/// [additionalContent]. [illustrationSize] define o tamanho da ilustração e
/// o estilo do título. As ilustrações da SAP não são reproduzidas: sem
/// [illustration], a ilustração é um ícone grande do catálogo.
///
/// ```dart
/// RebicIllustratedMessage(
///   illustrationType: RebicIllustrationType.noSearchResults,
///   title: 'Nenhum pedido encontrado',
///   description: 'Tente outros termos de busca.',
///   additionalContent: [RebicButton(text: 'Limpar busca', onPress: limpar)],
/// )
/// ```
class RebicIllustratedMessage extends StatelessWidget {
  /// Cria a mensagem com [title].
  const RebicIllustratedMessage({
    required this.title,
    this.description,
    this.illustrationType = RebicIllustrationType.noData,
    this.illustrationSize = RebicIllustrationSize.dialog,
    this.illustration,
    this.titleLevel = RebicTitleLevel.auto,
    this.additionalContent = const [],
    super.key,
  }) : assert(title != '', 'title não pode ser vazio');

  /// Título da mensagem.
  final String title;

  /// Texto que explica a situação e o que fazer.
  final String? description;

  /// Situação, que define o ícone da ilustração.
  final RebicIllustrationType illustrationType;

  /// Tamanho da ilustração e do título.
  final RebicIllustrationSize illustrationSize;

  /// Ilustração própria, no lugar do ícone do tipo.
  final Widget? illustration;

  /// Nível do título para leitores de tela.
  final RebicTitleLevel titleLevel;

  /// Ações abaixo da descrição, em geral botões.
  final List<Widget> additionalContent;

  IconData get _icon => switch (illustrationType) {
    RebicIllustrationType.noData => RebicIcons.document,
    RebicIllustrationType.noEntries => RebicIcons.folderBlank,
    RebicIllustrationType.noSearchResults => RebicIcons.search,
    RebicIllustrationType.noFilterResults => RebicIcons.filter,
    RebicIllustrationType.error => RebicIcons.error,
    RebicIllustrationType.success => RebicIcons.sysEnter2,
  };

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final (double factor, RebicTitleLevel style) = switch (illustrationSize) {
      RebicIllustrationSize.spot => (1, RebicTitleLevel.h4),
      RebicIllustrationSize.dialog => (2, RebicTitleLevel.h3),
      RebicIllustrationSize.scene => (4, RebicTitleLevel.h2),
    };
    final description = this.description;
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing.m,
      children: [
        ExcludeSemantics(
          child:
              illustration ??
              Icon(
                _icon,
                size: theme.icons.xLarge * factor,
                color: theme.colors.brand,
              ),
        ),
        RebicTitle(
          title,
          level: titleLevel,
          titleStyle: style,
          wrapping: true,
          textAlign: TextAlign.center,
        ),
        if (description != null)
          RebicText(description, textAlign: TextAlign.center),
        if (additionalContent.isNotEmpty)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: theme.spacing.s,
            runSpacing: theme.spacing.s,
            children: additionalContent,
          ),
      ],
    );
  }
}
