import 'package:flutter/widgets.dart';

/// Leva o foco ao primeiro elemento focável de [child] quando nenhum
/// elemento dele já tem o foco (por `autofocus`, por exemplo), e agrupa o
/// percurso de foco do conteúdo.
///
/// Uso interno das sobreposições; não exportado.
class RebicInitialFocus extends StatefulWidget {
  /// Envolve [child].
  const RebicInitialFocus({required this.child, super.key});

  /// Conteúdo da sobreposição.
  final Widget child;

  @override
  State<RebicInitialFocus> createState() => _RebicInitialFocusState();
}

class _RebicInitialFocusState extends State<RebicInitialFocus> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final scope = FocusScope.of(context);
      final focused = FocusManager.instance.primaryFocus;
      final inside =
          focused != null &&
          focused != scope &&
          focused.ancestors.contains(scope);
      if (!inside) scope.nextFocus();
    });
  }

  @override
  Widget build(BuildContext context) =>
      FocusTraversalGroup(child: widget.child);
}
