# Spec Delta

## ADDED Requirements

### Requirement: Meses e anos do calendário
Os textos SHALL fornecer os nomes completos dos doze meses na forma independente (`monthNames`), o ano de uma data sem separador de milhar (`formatYear`) e o texto `today`, tudo do CLDR.

#### Scenario: Meses, ano e hoje
- **WHEN** `monthNames`, `formatYear` de 5 de março de 2026 e `today` são lidos em pt-BR e em en
- **THEN** o primeiro mês é "janeiro" em pt-BR e "January" em en, o ano é "2026" nos dois, e `today` é "Hoje" e "Today"
