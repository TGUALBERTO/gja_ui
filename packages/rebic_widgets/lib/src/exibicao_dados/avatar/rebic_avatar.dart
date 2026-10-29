import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Tamanho de um [RebicAvatar], como o `displaySize` do SAPUI5.
enum RebicAvatarSize {
  /// 1 × `icons.xLarge` (32 nos tokens de referência).
  xs,

  /// 1,5 × `icons.xLarge` (48).
  s,

  /// 2 × `icons.xLarge` (64).
  m,

  /// 2,5 × `icons.xLarge` (80).
  l,

  /// 3,5 × `icons.xLarge` (112).
  xl,
}

/// Forma de um [RebicAvatar], como o `displayShape` do SAPUI5.
enum RebicAvatarShape {
  /// Círculo.
  circle,

  /// Quadrado com raio `radius.s`.
  square,
}

/// Representa uma pessoa ou um objeto, como o `sap.m.Avatar` do SAPUI5.
///
/// Mostra, nesta ordem de preferência, a [image], as [initials] (de 1 a 3
/// caracteres, em maiúsculas), o [icon] ou o ícone `personPlaceholder`. Se a imagem falha
/// ao carregar, mostra as iniciais ou o ícone. O fundo é
/// `colors.selectionBackground`, e as iniciais e o ícone `colors.brand`. O
/// lado vem do [size] e não muda com a escala de texto. Com [onPressed], o
/// avatar fica ativo e é anunciado como botão; senão, como imagem, com o
/// rótulo [semanticLabel] ou as iniciais.
///
/// ```dart
/// RebicAvatar(
///   initials: 'MB',
///   semanticLabel: 'Maria Barros',
///   onPressed: abrirPerfil,
/// )
/// ```
class RebicAvatar extends StatefulWidget {
  /// Cria o avatar.
  const RebicAvatar({
    this.image,
    this.initials,
    this.icon,
    this.size = RebicAvatarSize.s,
    this.shape = RebicAvatarShape.circle,
    this.semanticLabel,
    this.onPressed,
    super.key,
  }) : assert(
         initials == null || (initials.length >= 1 && initials.length <= 3),
         'initials deve ter de 1 a 3 caracteres: $initials',
       );

  /// Imagem da pessoa ou do objeto.
  final ImageProvider? image;

  /// Iniciais, de 1 a 3 caracteres, mostradas em maiúsculas.
  final String? initials;

  /// Ícone usado sem imagem e sem iniciais; nulo usa o ícone `personPlaceholder`.
  final IconData? icon;

  /// Tamanho do avatar.
  final RebicAvatarSize size;

  /// Forma do avatar.
  final RebicAvatarShape shape;

  /// Rótulo do leitor de tela (ex.: o nome); nulo usa as iniciais.
  final String? semanticLabel;

  /// Ação do avatar ativo; nula torna o avatar apenas informativo.
  final VoidCallback? onPressed;

  @override
  State<RebicAvatar> createState() => _RebicAvatarState();
}

/// Lado de cada tamanho em múltiplos de `icons.xLarge`: os 2/3/4/5/7 rem do
/// UI5 nos tokens de referência.
const _sideFactor = {
  RebicAvatarSize.xs: 1.0,
  RebicAvatarSize.s: 1.5,
  RebicAvatarSize.m: 2.0,
  RebicAvatarSize.l: 2.5,
  RebicAvatarSize.xl: 3.5,
};

/// Fração do lado ocupada pelo ícone.
const _iconFraction = 0.5;

class _RebicAvatarState extends State<RebicAvatar> {
  bool _imageFailed = false;

  @override
  void didUpdateWidget(RebicAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) _imageFailed = false;
  }

  TextStyle _initialsStyle(RebicTypographyTokens t) => switch (widget.size) {
    RebicAvatarSize.xs => t.small,
    RebicAvatarSize.s => t.header4,
    RebicAvatarSize.m => t.header3,
    RebicAvatarSize.l => t.header2,
    RebicAvatarSize.xl => t.header1,
  };

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final colors = theme.colors;
    final side = theme.icons.xLarge * _sideFactor[widget.size]!;
    final circle = widget.shape == RebicAvatarShape.circle;
    final corners = BorderRadius.circular(
      circle ? theme.radius.full : theme.radius.s,
    );
    final initials = widget.initials;

    Widget fallback() {
      if (initials != null) {
        // O avatar tem tamanho fixo: as iniciais não seguem a escala de
        // texto e encolhem para caber.
        return MediaQuery.withNoTextScaling(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              initials.toUpperCase(),
              style: _initialsStyle(
                theme.typography,
              ).copyWith(color: colors.brand),
              maxLines: 1,
            ),
          ),
        );
      }
      return Icon(
        widget.icon ?? RebicIcons.personPlaceholder,
        size: side * _iconFraction,
        color: colors.brand,
      );
    }

    final image = widget.image;
    final Widget content = image != null && !_imageFailed
        ? Image(
            image: image,
            width: side,
            height: side,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Guarda a falha para não tentar de novo nas reconstruções.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_imageFailed) {
                  setState(() => _imageFailed = true);
                }
              });
              return Center(child: fallback());
            },
          )
        : Center(child: fallback());

    Widget avatar(bool hovered) {
      final body = ColoredBox(
        color: hovered
            ? colors.selectionHoverBackground
            : colors.selectionBackground,
        child: SizedBox.square(dimension: side, child: content),
      );
      // O rótulo é anunciado pelo nó do avatar; o conteúdo é visual.
      return ExcludeSemantics(
        child: circle
            ? ClipOval(child: body)
            : ClipRRect(borderRadius: corners, child: body),
      );
    }

    final label = widget.semanticLabel ?? initials ?? '';
    final onPressed = widget.onPressed;
    if (onPressed == null) {
      return Semantics(
        container: true,
        image: true,
        label: label,
        child: avatar(false),
      );
    }
    // Um só nó: o foco e o toque do detector se juntam ao avatar rotulado.
    return MergeSemantics(
      child: RebicInteractable(
        semanticLabel: label,
        onPressed: onPressed,
        focusRingBorderRadius: corners,
        builder: (context, states) =>
            avatar(states.contains(RebicInteractionState.hovered)),
      ),
    );
  }
}
