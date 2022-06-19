// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:io/io.dart';
import 'package:json_to_dart/model_generator.dart';
import 'package:json_to_dart/src/entrypoint/runner.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

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

class Fields extends Command<int> {
  @override
  final argParser = ArgParser(usageLineLength: lineLength);

  @override
  String get description => 'Get field type from json model ';

  @override
  String get name => 'fields';

  @override
  bool get hidden => true;

  Fields() {
    // we can add command specific arguments here.
    // [argParser] is automatically created by the parent class.
    argParser.addOption('classname', abbr: 'c');
    argParser.addOption('source', abbr: 's');
  }

  @override
  Future<int> run() async {
    Logger.root.clearListeners();
    // print(p.absolute(scriptLocation));
    if (argResults?['source'] == null || argResults?['classname'] == null) {
      return ExitCode.usage.code;
    }
    final currentDirectory = p.dirname(_scriptPath());
    // final sourcePath = p.normalize(p.join(
    //     currentDirectory, '..', '..', '..', '..', argResults?['source']));
    final sourcePath =
        p.normalize(p.join(Directory.current.path, argResults?['source']));
    final classGenerator = new ModelGenerator(argResults?['classname']);
    final jsonRawData = new File(sourcePath).readAsStringSync();
    classGenerator.generateDartClasses(jsonRawData);
    print(classGenerator.allClasses.first.getFields());
    return 0;
  }
}
