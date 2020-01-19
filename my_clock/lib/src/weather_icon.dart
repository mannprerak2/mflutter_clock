import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:my_clock/src/constants.dart';

class WeatherIcon extends StatelessWidget {
  final WeatherCondition weatherCondition;

  const WeatherIcon(this.weatherCondition, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).brightness == Brightness.light
        ? Constants.lessDarkBlueWithOpacity
        : Constants.opacityWhite;
    switch (weatherCondition) {
      case WeatherCondition.cloudy:
        return Icon(
          Icons.cloud,
          color: color,
        );
      case WeatherCondition.sunny:
        return Icon(
          Icons.wb_sunny,
          color: color,
        );
      default:
        return Text("--");
    }
  }
}
