// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dart_style.test.command_line;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:scheduled_test/descriptor.dart' as d;
import 'package:scheduled_test/scheduled_process.dart';
import 'package:scheduled_test/scheduled_test.dart';
import 'package:unittest/compact_vm_config.dart';

const unformattedSource = 'void  main()  =>  print("hello") ;';
const formattedSource = 'void main() => print("hello");\n';

ScheduledProcess runFormatter([List<String> args]) {
  if (args == null) args = [];

  var formatterPath = p.join(
      p.dirname(p.fromUri(Platform.script)), "..", "bin", "format.dart");

  args.insertAll(0, [formatterPath, d.defaultRoot]);
  return new ScheduledProcess.start(Platform.executable, args);
}

/// Set up the scheduled test suite.
///
/// Configures the unit test output and makes a sandbox directory for the
/// scheduled tests to run in.
void setUpTestSuite() {
  // Tidy up the unittest output.
  filterStacks = true;
  formatStacks = true;
  useCompactVMConfiguration();

  // Make a sandbox directory for the scheduled tests to run in.
  setUp(() {
    var tempDir = Directory.systemTemp.createTempSync('dart_style.test.');
    d.defaultRoot = tempDir.path;

    currentSchedule.onComplete.schedule(() {
      d.defaultRoot = null;
      return tempDir.delete(recursive: true);
    });
  });
}