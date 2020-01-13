import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:my_clock/time_model.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

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
  final ClockModel model;
  static bool isLight = true;
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

    // Update once per minute
    // _timer = Timer(
    //   Duration(minutes: 1) -
    //       Duration(seconds: _dateTime.second) -
    //       Duration(milliseconds: _dateTime.millisecond),
    //   _updateTime,
    // );

    // update digits now
    Provider.of<TimeModel>(context, listen: false).updateTime(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    MyClock.isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      child: ColorFiltered(
        colorFilter: !MyClock.isLight
            ? ColorFilter.matrix([
                //R  G   B    A  Const
                -1, 0, 0, 0, 255, //
                0, -1, 0, 0, 255, //
                0, 0, -1, 0, 255, //
                0, 0, 0, 1, 0, //
              ])
            : ColorFilter.matrix([
                //R  G   B    A  Const
                1, 0, 0, 0, 0,
                0, 1, 0, 0, 0,
                0, 0, 1, 0, 0,
                0, 0, 0, 1, 0,
              ]),
        child: PaintHandler(),
      ),
    );
  }
}

class PaintHandler extends StatefulWidget {
  @override
  _PaintHandlerState createState() => _PaintHandlerState();
}

class _PaintHandlerState extends State<PaintHandler> {
  ui.Image _image;
  @override
  void initState() {
    _loadImage();
    super.initState();
  }

  _loadImage() async {
    ByteData bd = await rootBundle.load("assets/words.jpg");
    final Uint8List bytes = Uint8List.view(bd.buffer);
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.Image image = (await codec.getNextFrame()).image;
    setState(() => _image = image);
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _image.width.toDouble(),
          height: _image.height.toDouble(),
          child: CustomPaint(
            painter: MyPainter(_image),
          ),
        ),
      );
    }
    return Container();
  }
}

class MyPainter extends CustomPainter {
  final TextPainter textPainter;
  final ui.Image image;

  MyPainter(this.image)
      : textPainter = TextPainter(
            text: TextSpan(
              text: "8",
              style: TextStyle(
                fontSize: 800,
                color: Colors.white,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center),
        super();

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset(0, 0) & size;
    canvas.drawImage(image, Offset.zero, Paint());
    canvas.saveLayer(rect, Paint()..blendMode = BlendMode.dstATop);
    textPainter
      ..layout(minWidth: size.width)
      ..paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;
}
