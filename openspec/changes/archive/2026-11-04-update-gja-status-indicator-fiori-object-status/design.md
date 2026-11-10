# Design: Status no nome do SAPUI5

## Decisions

### D1. Só o nome

A API já é a do `sap.m.ObjectStatus` (`text`, `icon`, `title`, `state`, `inverted`, `onPress`); a change só troca o
nome da classe, do arquivo, da pasta, da capability e da página da galeria. Os requisitos e cenários são copiados
com o novo nome, para que os testes mantenham os mesmos nomes de cenário.

### D2. Capability retirada

Como na troca de `GjaDivider` por `GjaSeparator`, a change declara `retire_capabilities`: o delta da capability
antiga remove todos os requisitos, e a spec principal antiga é apagada no arquivamento.
