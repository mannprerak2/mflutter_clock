import 'dart:io';

import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_clock/src/time_model.dart';
import 'package:my_clock/src/my_clock.dart';
import 'package:provider/provider.dart';
// TODO: submit project, screenshot, video

void main() {
  if (!kIsWeb && Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TimeModel(),
        )
      ],
      child: ClockCustomizer((ClockModel model) => MyClock(model)),
    ),
  );
}
