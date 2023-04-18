extension IntExtension on int {
  String toTimeString() {
    return Duration(seconds: this).toString().split(".")[0];
  }
}
