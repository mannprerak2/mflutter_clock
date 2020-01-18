import 'package:flutter/material.dart';
import 'package:my_clock/digit.dart';
import 'package:my_clock/time_model.dart';
import 'package:provider/provider.dart';

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
              builder: (_, b, child) => SizedBox(
                width: MediaQuery.of(context).size.width / 10,
                child: Digit(
                  null,
                  simpleString: b ? 'P' : 'A',
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
