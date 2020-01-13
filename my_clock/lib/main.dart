import 'dart:io';

import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_clock/time_model.dart';
import 'my_clock.dart';
import 'package:provider/provider.dart';

void main() {
  if (!kIsWeb && Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_)=> TimeModel(),
        )
      ],
      child: ClockCustomizer((ClockModel model) => MyClock(model)),
    ),
  );
}
