import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:json_to_dart/src/entrypoint/options.dart';
import 'package:json_to_dart/src/entrypoint/runner.dart';
import 'package:logging/logging.dart';

import 'src/commands/fields.dart';
import 'src/commands/generate.dart';

// dart run bin/main.dart ../example/sample2.json

Future<void> main(List<String> args) async {
  var localCommands = [Generate(), Fields()];
  var localCommandNames = localCommands.map((c) => c.name).toSet();
  var commandRunner = BuildCommandRunner([]);

  for (var command in localCommands) {
    commandRunner.addCommand(command);
    // This flag is added to each command individually and not the top level.
    command.argParser.addFlag(verboseOption,
        abbr: 'v',
        defaultsTo: false,
        negatable: false,
        help: 'Enables verbose logging.');
  }

  ArgResults parsedArgs;
  try {
    parsedArgs = commandRunner.parse(args);
  } on UsageException catch (e) {
    print(red.wrap(e.message));
    print('');
    print(e.usage);
    exitCode = ExitCode.usage.code;
    return;
  }
  var commandName = parsedArgs.command?.name;

  if (parsedArgs.rest.isNotEmpty) {
    print(
        yellow.wrap('Could not find a command named "${parsedArgs.rest[0]}".'));
    print('');
    print(commandRunner.usageWithoutDescription);
    exitCode = ExitCode.usage.code;
    return;
  }

  if (commandName == 'help' ||
      parsedArgs.wasParsed('help') ||
      (parsedArgs.command?.wasParsed('help') ?? false)) {
    await commandRunner.runCommand(parsedArgs);
    return;
  }

  if (commandName == null) {
    commandRunner.printUsage();
    exitCode = ExitCode.usage.code;
    return;
  }
  StreamSubscription logListener;
  var verbose = parsedArgs.command!['verbose'] as bool? ?? false;
  if (verbose) Logger.root.level = Level.ALL;
  //logListener = Logger.root.onRecord.listen(stdIOLogListener(verbose: verbose));

  if (localCommandNames.contains(commandName)) {
    exitCode = await commandRunner.runCommand(parsedArgs) ?? 1;
  }
}
