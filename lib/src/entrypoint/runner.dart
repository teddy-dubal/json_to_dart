// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

// import 'base_command' show lineLength;

final lineLength = stdout.hasTerminal ? stdout.terminalColumns : 80;

/// Unified command runner for all build_runner commands.
class BuildCommandRunner extends CommandRunner<int> {
  @override
  final argParser = ArgParser(usageLineLength: lineLength);

  // final List<BuilderApplication> builderApplications;

  BuildCommandRunner(List<dynamic> builderApplications)
      : /* builderApplications = List.unmodifiable(builderApplications),*/
        super('json_to_dart', 'Generate model from json file') {}

  // CommandRunner._usageWithoutDescription is private – this is a reasonable
  // facsimile.
  /// Returns [usage] with [description] removed from the beginning.
  String get usageWithoutDescription => LineSplitter.split(usage)
      .skipWhile((line) => line == description || line.isEmpty)
      .join('\n');
}
