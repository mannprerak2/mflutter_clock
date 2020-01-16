import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:my_clock/backgroud_animation.dart';
import 'package:my_clock/digit.dart';
import 'package:my_clock/time_model.dart';
import 'package:my_clock/weather_icon.dart';
import 'package:provider/provider.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

class MyClock extends StatefulWidget {
  static Color darkBlue = Color(0xFF001a33);
  static Color lessDarkBlue = Color(0xFF004280);
  final ClockModel model;
  const MyClock(
    this.model, {
    Key key,
  }) : super(key: key);
  @override
  _MyClockState createState() => _MyClockState();
}

class _MyClockState extends State<MyClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  int oh1, oh2, om1, om2;
  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);

    _updateModel();

    //because context is required by provider..
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    _dateTime = DateTime.now();
    //update once a second
    _timer = Timer(
      Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      _updateTime,
    );

    // update digits now
    Provider.of<TimeModel>(context, listen: false).updateTime(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? MyClock.lessDarkBlue
              : Colors.white),
      child: Container(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : MyClock.darkBlue,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            BackgroundAnimation(),
            Row(
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
            Positioned(
              left: 0,
              bottom: 0,
              child: DefaultTextStyle(
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).brightness == Brightness.light
                        ? MyClock.lessDarkBlue
                        : Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.model.location),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                              "${widget.model.temperatureString} (${widget.model.lowString} - ${widget.model.highString}) "),
                          WeatherIcon(widget.model.weatherCondition),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
