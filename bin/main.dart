import 'dart:io';
import 'package:args/args.dart';
import 'package:json_to_dart/json_to_dart.dart';
import 'package:path/path.dart';

String _scriptPath() {
  var script = Platform.script.toString();
  if (script.startsWith("file://")) {
    script = script.substring(7);
  } else {
    final idx = script.indexOf("file:/");
    script = script.substring(idx + 5);
  }
  return script;
}

// dart run bin/main.dart ../example/sample2.json

main(List<String> arguments) {
  final parser = ArgParser()..addOption('classname', abbr: 'c');
  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;
  final currentDirectory = dirname(_scriptPath());
  final classGenerator = new ModelGenerator(argResults['classname']);
  final filePath = normalize(join(currentDirectory, paths[0]));
  final jsonRawData = new File(filePath).readAsStringSync();
  DartCode dartCode = classGenerator.generateDartClasses(jsonRawData);
  print(dartCode.code);
}
