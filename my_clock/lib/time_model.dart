import 'package:flutter/material.dart';

class TimeModel extends ChangeNotifier {
  int _h1 = 0, _h2 = 0, _m1 = 0, _m2 = 0, _s1 = 0, _s2 = 0;

  int get h1 => _h1;
  set h1(int a) {
    if (_h1 != a) {
      _h1 = a;
      notifyListeners();
    }
  }

  get h2 => _h2;
  set h2(int a) {
    if (_h2 != a) {
      _h2 = a;
      notifyListeners();
    }
  }

  get m1 => _m1;
  set m1(int a) {
    if (_m1 != a) {
      _m1 = a;
      notifyListeners();
    }
  }

  get m2 => _m2;
  set m2(int a) {
    if (_m2 != a) {
      _m2 = a;
      notifyListeners();
    }
  }

  get s1 => _s1;
  set s1(int a) {
    if (_s1 != a) {
      _s1 = a;
      notifyListeners();
    }
  }

  get s2 => _s2;
  set s2(int a) {
    if (_s2 != a) {
      _s2 = a;
      notifyListeners();
    }
  }

  void updateTime(DateTime d) {
    h1 = d.hour ~/ 10;
    h2 = d.hour % 10;
    m1 = d.minute ~/ 10;
    m2 = d.minute % 10;
    s1 = d.second ~/ 10;
    s2 = d.second % 10;
  }
}
