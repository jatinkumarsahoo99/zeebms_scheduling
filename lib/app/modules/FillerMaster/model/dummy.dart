import 'package:bms_scheduling/app/providers/Aes.dart';

main() {
  print(Uri.encodeComponent(Aes.encrypt('D-Series Specification').toString()));
}
