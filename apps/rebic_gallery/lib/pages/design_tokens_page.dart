import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "Design tokens": papéis de movimento e interpolação entre conjuntos.
///
/// Usa literais visuais provisórios (cores, espaçamentos) até existirem os
/// fundamentos de cor e espaçamento; a galeria é aplicação, fora da
/// verificação de tokens.
class DesignTokensPage extends StatefulWidget {
  /// Cria a página.
  const DesignTokensPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'Design tokens';

  /// Rota nomeada.
  static const route = '/design-tokens';

  @override
  State<DesignTokensPage> createState() => _DesignTokensPageState();
}

class _DesignTokensPageState extends State<DesignTokensPage>
    with SingleTickerProviderStateMixin {
  static const _fallback = RebicMotionTokens.fallback();

  /// Conjunto "lento": o dobro das durações do `fallback()`.
  static final _slow = _fallback.copyWith(
    short: _fallback.short * 2,
    medium: _fallback.medium * 2,
    long: _fallback.long * 2,
  );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _fallback.long,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_controller.status == AnimationStatus.completed ||
        _controller.status == AnimationStatus.forward) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFFFFFFF),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final motion = _fallback.lerp(_slow, t);
          final roles = <String, Duration>{
            'instant': motion.instant,
            'short': motion.short,
            'medium': motion.medium,
            'long': motion.long,
          };
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Semantics(button: true, child: const Text('← Voltar')),
              ),
              const SizedBox(height: 16),
              const Text(
                DesignTokensPage.title,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                'Movimento — fallback → lento (t = ${t.toStringAsFixed(2)})',
              ),
              const SizedBox(height: 16),
              for (final MapEntry(key: role, value: duration) in roles.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      SizedBox(width: 96, child: Text(role)),
                      SizedBox(
                        width: 72,
                        child: Text('${duration.inMilliseconds} ms'),
                      ),
                      Container(
                        height: 12,
                        width: duration.inMilliseconds / 2,
                        color: const Color(0xFF0A6ED1),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggle,
                child: Semantics(
                  button: true,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xFFE5F0FA),
                    child: const Text('Alternar conjunto (interpolação)'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
