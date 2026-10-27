import 'dart:io';

/// Raiz do repositório, a partir do diretório do pacote.
Directory get repoRoot => Directory.current.parent.parent;

/// Nomes no formato `<requisito> — <cenário>` da spec [id]: a principal, ou
/// a da change [change] enquanto ela não foi arquivada.
List<String> scenarioNames(String id, String change) {
  final spec = [
    File('${repoRoot.path}/openspec/specs/$id/spec.md'),
    File('${repoRoot.path}/openspec/changes/$change/specs/$id/spec.md'),
  ].firstWhere((f) => f.existsSync());
  final names = <String>[];
  String? requirement;
  for (final line in spec.readAsLinesSync()) {
    final req = RegExp(r'^### Requirement: (.+)$').firstMatch(line);
    if (req != null) requirement = req.group(1)!.trim();
    final scen = RegExp(r'^#### Scenario: (.+)$').firstMatch(line);
    if (scen != null) names.add('$requirement — ${scen.group(1)!.trim()}');
  }
  return names;
}

/// Cenários de [names] sem teste de mesmo nome nas suítes de `rebic_widgets`
/// e da galeria.
List<String> untestedScenarios(List<String> names) {
  final tests = [
    for (final dir in [
      Directory('${repoRoot.path}/packages/rebic_widgets/test'),
      Directory('${repoRoot.path}/apps/rebic_gallery/test'),
    ])
      for (final f in dir.listSync(recursive: true).whereType<File>())
        if (f.path.endsWith('_test.dart')) f.readAsStringSync(),
  ].join('\n');
  return [
    for (final name in names)
      if (!tests.contains("'$name'")) name,
  ];
}
