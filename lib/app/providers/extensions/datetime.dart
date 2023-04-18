import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  DateTime fromtimeofday(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}
