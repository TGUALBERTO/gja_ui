import 'package:rebic_foundation/rebic_foundation.dart';

import 'rebic_button.dart';

/// Família de controle de cada [RebicButtonType], interna ao pacote (não
/// exportada), compartilhada pelo `RebicButton` e pelo `RebicIconButton`.
RebicControlFamily rebicButtonFamily(RebicButtonType type) => switch (type) {
  RebicButtonType.standard => RebicControlFamily.standard,
  RebicButtonType.emphasized => RebicControlFamily.emphasized,
  RebicButtonType.transparent => RebicControlFamily.transparent,
  RebicButtonType.accept => RebicControlFamily.accept,
  RebicButtonType.reject => RebicControlFamily.reject,
  RebicButtonType.attention => RebicControlFamily.attention,
};
