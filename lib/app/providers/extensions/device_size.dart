import 'package:flutter/material.dart' show BuildContext, MediaQuery;

extension DeviceSize on BuildContext {
  double get devicewidth => MediaQuery.of(this).size.width;
  double get deviceheight => MediaQuery.of(this).size.height;
}
