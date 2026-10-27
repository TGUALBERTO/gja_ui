import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../container/rebic_container.dart';
import '../divider/rebic_divider.dart';
import '../icon/rebic_icon.dart';
import '../row/rebic_row.dart';
import '../spacing/rebic_spacing.dart';
import '../text/rebic_text.dart';

/// Estrutura da aplicação, como o `sap.tnt.ToolPage` do SAPUI5: barra
/// superior, navegação lateral e corpo.
///
/// A barra fica na superfície `shell`, com a sombra `header`, e mostra o botão
/// de navegação (quando há [navigation]), o [logo], o [title] e as [actions].
/// Ela só aparece quando ao menos um deles é informado.
///
/// A navegação se adapta à classe da tela:
/// - `medium` e acima: ao lado do corpo, na borda inicial, com a largura que o
///   próprio [navigation] define, expandido ou recolhido;
/// - `small`: oculta quando recolhida e, expandida, ocupa a área do corpo, que
///   sai da tela sem perder o estado.
///
/// Com [navigationExpanded], o estado é controlado: o botão só chama
/// [onNavigationExpandedChanged]. Sem ele, o estado é automático (expandido
/// em `large` e `extraLarge`), o botão o alterna, e uma mudança de classe da
/// tela restaura o padrão. O conteúdo da navegação lê o estado em vigor com
/// [navigationExpandedOf].
///
/// ```dart
/// RebicApp(
///   home: RebicScaffold(
///     logo: const RebicIcon(RebicIcons.home, tone: RebicIconTone.brand),
///     title: 'Compras',
///     actions: [PerfilButton()],
///     navigation: const MenuLateral(),
///     body: const PedidosPage(),
///   ),
/// )
/// ```
class RebicScaffold extends StatefulWidget {
  /// Cria a estrutura com [body] e, opcionalmente, barra e navegação.
  const RebicScaffold({
    required this.body,
    this.title,
    this.logo,
    this.actions = const [],
    this.navigation,
    this.navigationExpanded,
    this.onNavigationExpandedChanged,
    super.key,
  });

  /// Conteúdo principal.
  final Widget body;

  /// Título da aplicação na barra, anunciado como cabeçalho.
  final String? title;

  /// Logo ou marca, antes do título.
  final Widget? logo;

  /// Ações globais, na borda final da barra.
  final List<Widget> actions;

  /// Conteúdo da área de navegação lateral; define a própria largura.
  final Widget? navigation;

  /// Estado controlado da navegação; nulo usa o estado automático pela classe
  /// da tela.
  final bool? navigationExpanded;

  /// Chamado com o novo estado quando o botão de navegação é acionado.
  final ValueChanged<bool>? onNavigationExpandedChanged;

  /// Estado da navegação em vigor no [RebicScaffold] mais próximo, ou nulo
  /// fora de um.
  static bool? navigationExpandedOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_RebicScaffoldScope>()
      ?.expanded;

  @override
  State<RebicScaffold> createState() => _RebicScaffoldState();
}

class _RebicScaffoldState extends State<RebicScaffold> {
  /// Mantém o estado do corpo quando a estrutura em volta dele muda.
  final _bodyKey = GlobalKey();

  /// Alternância feita pelo botão no modo automático.
  bool? _override;

  late RebicSizeClass _sizeClass;
  bool _measured = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sizeClass = RebicResponsive.screenSizeClassOf(context);
    if (_measured && sizeClass != _sizeClass) _override = null;
    _sizeClass = sizeClass;
    _measured = true;
  }

  void _toggle(bool expanded) {
    final next = !expanded;
    if (widget.navigationExpanded == null) setState(() => _override = next);
    widget.onNavigationExpandedChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final expanded =
        widget.navigationExpanded ??
        _override ??
        _sizeClass.isAtLeast(RebicSizeClass.large);
    final body = KeyedSubtree(key: _bodyKey, child: widget.body);
    final navigation = widget.navigation;

    final Widget area;
    if (navigation == null) {
      area = body;
    } else if (_sizeClass == RebicSizeClass.small) {
      area = Stack(
        fit: StackFit.expand,
        children: [
          Visibility(visible: !expanded, maintainState: true, child: body),
          if (expanded)
            RebicContainer(surface: RebicSurface.base, child: navigation),
        ],
      );
    } else {
      final side = RebicContainer(
        surface: RebicSurface.base,
        child: navigation,
      );
      final duration = theme.motion.medium;
      area = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Com movimento reduzido a duração é zero, e o `AnimatedSize` com
          // duração zero se marca para layout dentro do próprio layout.
          if (duration == Duration.zero)
            side
          else
            AnimatedSize(
              duration: duration,
              curve: theme.motion.standard,
              alignment: AlignmentDirectional.centerStart,
              child: side,
            ),
          const RebicDivider.vertical(),
          Expanded(child: body),
        ],
      );
    }

    final title = widget.title;
    final logo = widget.logo;
    final hasBar =
        navigation != null ||
        logo != null ||
        title != null ||
        widget.actions.isNotEmpty;
    final Widget content;
    if (!hasBar) {
      content = area;
    } else {
      final bar = RebicContainer(
        surface: RebicSurface.shell,
        elevation: RebicElevation.header,
        child: RebicSpacing.padding(
          horizontal: RebicSpace.m,
          vertical: RebicSpace.xs,
          child: RebicRow(
            gap: RebicSpace.s,
            children: [
              if (navigation != null)
                _NavigationButton(
                  expanded: expanded,
                  onPressed: () => _toggle(expanded),
                ),
              ?logo,
              // O título ocupa o espaço livre e leva as ações à borda final.
              if (title != null)
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: RebicText(
                      title,
                      variant: RebicTextVariant.title,
                      maxLines: 1,
                    ),
                  ),
                )
              else
                const Spacer(),
              ...widget.actions,
            ],
          ),
        ),
      );
      // A barra vem por último para ser pintada sobre a área, com a sombra
      // visível; `up` a mantém no topo. Foco e semântica seguem a geometria.
      content = Column(
        verticalDirection: VerticalDirection.up,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: area),
          bar,
        ],
      );
    }

    return _RebicScaffoldScope(
      expanded: expanded,
      child: RebicContainer(surface: RebicSurface.background, child: content),
    );
  }
}

class _RebicScaffoldScope extends InheritedWidget {
  const _RebicScaffoldScope({required this.expanded, required super.child});

  final bool expanded;

  @override
  bool updateShouldNotify(_RebicScaffoldScope oldWidget) =>
      expanded != oldWidget.expanded;
}

/// Botão que expande e recolhe a navegação, na família `transparent`.
class _NavigationButton extends StatelessWidget {
  const _NavigationButton({required this.expanded, required this.onPressed});

  final bool expanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final colors = RebicControlColors.of(
      RebicControlFamily.transparent,
      theme.colors,
    );
    // Um só nó: botão, rótulo e estado expandido.
    return MergeSemantics(
      child: Semantics(
        expanded: expanded,
        child: RebicInteractable(
          semanticLabel: RebicLocalizations.of(context).navigation,
          onPressed: onPressed,
          builder: (context, states) {
            final c = colors.resolve(states);
            return SizedBox.square(
              dimension: theme.density.controlHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: c.background,
                  borderRadius: BorderRadius.circular(theme.radius.control),
                ),
                // O ícone toma a cor de texto do estado (ex.: contraste no
                // pressionado), que os tons de `RebicIcon` não cobrem.
                child: Center(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(c.text, BlendMode.srcIn),
                    child: const RebicIcon(RebicIcons.menu),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
