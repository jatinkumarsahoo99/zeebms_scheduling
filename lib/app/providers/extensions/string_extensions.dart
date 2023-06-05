import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String fromdMyToyMd() => DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(this));

  String pascalCaseToNormal() {
    return split(RegExp(r"(?=(?!^)[A-Z])")).map((e) => e.capitalize()).toList().join(" ");
  }
}
