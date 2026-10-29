## REMOVED Requirements

### Requirement: Escala primitiva de sombras
**Reason**: o fundamento passa a se chamar `rebic/foundation/shadows`, como os parâmetros `sapContent_Shadow*` do Fiori.
**Migration**: requisito "Escala primitiva de sombras" de `rebic/foundation/shadows`; `RebicElevationPrimitives` → `RebicShadowPrimitives`.

### Requirement: Níveis e papéis de elevação
**Reason**: "elevação" é vocabulário do Material, e os papéis passam aos do Horizon (popover `shadow2`, diálogo `shadow3`).
**Migration**: requisito "Sombras e papéis" de `rebic/foundation/shadows`; `RebicElevationTokens` → `RebicShadowTokens`.

### Requirement: Sombras com a cor do tema
**Reason**: o fundamento passa a se chamar `rebic/foundation/shadows`.
**Migration**: requisito "Sombras com a cor do tema" de `rebic/foundation/shadows`; `shadowsFor` → `boxShadows`.

### Requirement: Uso de elevação sem literais nos widgets
**Reason**: o fundamento passa a se chamar `rebic/foundation/shadows`.
**Migration**: requisito "Uso de sombras sem literais nos widgets" de `rebic/foundation/shadows`.

### Requirement: Contrato do conjunto de elevação
**Reason**: o fundamento passa a se chamar `rebic/foundation/shadows`.
**Migration**: requisito "Contrato do conjunto de sombras" de `rebic/foundation/shadows`.

### Requirement: Testes e documentação da elevação
**Reason**: o fundamento passa a se chamar `rebic/foundation/shadows`, e a página da galeria passa a "Sombras".
**Migration**: requisito "Testes e documentação das sombras" de `rebic/foundation/shadows`.
