// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_devicelab/framework/devices.dart';
import 'package:flutter_devicelab/framework/framework.dart';
import 'package:flutter_devicelab/tasks/integration_tests.dart';

Future<void> main() async {
  deviceOperatingSystem = DeviceOperatingSystem.linux;
  await task(() async {
    Process? wmProcess;
    try {
      wmProcess = await Process.start('openbox', const <String>[]);
      wmProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((String line) => print('[openbox stdout] $line'));
      wmProcess.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((String line) => print('[openbox stderr] $line'));
      print('Started openbox window manager (pid: ${wmProcess.pid}).');
      await Future<void>.delayed(const Duration(milliseconds: 500));
    } on ProcessException catch (e) {
      print('Could not start openbox: $e');
    }
    try {
      return await createWindowingDriverTest()();
    } finally {
      wmProcess?.kill();
    }
  });
}
