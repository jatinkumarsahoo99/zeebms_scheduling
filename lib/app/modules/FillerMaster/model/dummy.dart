import 'package:bms_scheduling/app/providers/Aes.dart';

main() {
  print(Uri.encodeComponent(Aes.encrypt('DateWise Fillers').toString()));
}
