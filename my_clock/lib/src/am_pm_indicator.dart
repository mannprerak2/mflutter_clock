import 'package:flutter/material.dart';
import 'package:my_clock/src/digit.dart';
import 'package:my_clock/src/time_model.dart';
import 'package:provider/provider.dart';

/// Shows AM/PM if format isn't 24 hr
class AmPmIndicator extends StatelessWidget {
  final bool show;

  const AmPmIndicator(this.show, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (show) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 8.0),
        child: Row(
          children: <Widget>[
            Selector<TimeModel, bool>(
              selector: (_, b) => b.isPm,
              builder: (_, isPm, child) => SizedBox(
                width: MediaQuery.of(context).size.width / 10,
                child: Digit(
                  null,
                  simpleString: isPm ? 'P' : 'A',
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 10,
              child: Digit(
                null,
                simpleString: 'M',
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
