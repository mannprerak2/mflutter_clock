import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:my_clock/src/am_pm_indicator.dart';
import 'package:my_clock/src/backgroud_animation.dart';
import 'package:my_clock/src/digit.dart';
import 'package:my_clock/src/time_model.dart';
import 'package:my_clock/src/weather_icon.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_clock/src/constants.dart';

/// Root Clock Widget (below ClockCustomiser)
class MyClock extends StatefulWidget {
  // static Color darkBlue = Color(0xFF001a33);
  // static Color lessDarkBlue = Color(0xFF004280);
  // static Color lessDarkBlueWithOpacity = Color(0xB0004280);
  // static Color backgroudPatternBlue = Color(0x5004280);
  // static Color backgroudCirclePatternBlue = Color(0x10004280);
  // static Color backgroudPatternBlueDark = Color(0x05FFFFFF);
  // static Color backgroudCirclePatternBlueDark = Color(0x10FFFFFF);
  final ClockModel model;
  static DateTime dateTime = DateTime.now();

  const MyClock(
    this.model, {
    Key key,
  }) : super(key: key);
  @override
  _MyClockState createState() => _MyClockState();
}

class _MyClockState extends State<MyClock> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    //because context is required by provider..
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // initial model params
      widget.model.is24HourFormat = false;
      _updateTime();
    });
  }

  @override
  void didUpdateWidget(MyClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() => setState(() {});

  void _updateTime() {
    MyClock.dateTime = DateTime.now();
    //update once a second
    _timer = Timer(
      Duration(seconds: 1) -
          Duration(milliseconds: MyClock.dateTime.millisecond),
      _updateTime,
    );
    // update digits now
    Provider.of<TimeModel>(context, listen: false)
        .updateTime(MyClock.dateTime, widget.model.is24HourFormat);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? Constants.lessDarkBlue
              : Constants.digitColor),
      child: Container(
        color: Theme.of(context).brightness == Brightness.light
            ? Constants.digitColor
            : Constants.darkBlue,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                right: 0,
                child: BackgroundAnimation()),
            TimeWidget(widget: widget),
            Positioned(
              left: 0,
              bottom: 0,
              child: WeatherWidget(widget: widget),
            ),
            Positioned(
              top: 0,
              child: DateWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class DateWidget extends StatelessWidget {
  const DateWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 20,
          fontWeight: FontWeight.w900,
          color: Theme.of(context).brightness == Brightness.light
              ? Constants.lessDarkBlueWithOpacity
              : Constants.opacityWhite),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Selector<TimeModel, int>(
          selector: (_, model) => model.day,
          builder: (_, day, child) {
            return Text(DateFormat('E, d MMM').format(MyClock.dateTime));
          },
        ),
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final MyClock widget;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 32,
          fontWeight: FontWeight.w900,
          color: Theme.of(context).brightness == Brightness.light
              ? Constants.lessDarkBlueWithOpacity
              : Constants.opacityWhite),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Semantics(
                  enabled: true,
                  label: 'Temperature is ${widget.model.temperatureString}',
                  readOnly: true,
                  container: true,
                  child: Text("${widget.model.temperatureString} "),
                ),
                Semantics(
                  enabled: true,
                  label:
                      'Weather is ${widget.model.weatherCondition.toString().split('.').last}',
                  readOnly: true,
                  container: true,
                  child: WeatherIcon(widget.model.weatherCondition),
                ),
              ],
            ),
            Text(widget.model.location),
          ],
        ),
      ),
    );
  }
}

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final MyClock widget;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      enabled: true,
      label: getTimeLabel(widget),
      readOnly: true,
      container: true,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(flex: 2, child: Digit((_, model) => model.h1)),
          Expanded(flex: 2, child: Digit((_, model) => model.h2)),
          Expanded(
            flex: 1,
            child: Digit(
              null,
              simpleString: ":",
            ),
          ),
          Expanded(flex: 2, child: Digit((_, model) => model.m1)),
          Expanded(flex: 2, child: Digit((_, model) => model.m2)),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 20,
                    child: Digit((_, model) => model.s1),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 20,
                    child: Digit((_, model) => model.s2),
                  ),
                ],
              ),
              AmPmIndicator(!widget.model.is24HourFormat),
            ],
          ),
        ],
      ),
    );
  }

  String getTimeLabel(MyClock widget) {
    DateFormat formatter;
    if (widget.model.is24HourFormat) {
      formatter = DateFormat('Hms');
    } else {
      formatter = DateFormat('jms');
    }
    return 'Time is ${formatter.format(MyClock.dateTime)}';
  }
}
