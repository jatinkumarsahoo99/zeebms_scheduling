import 'package:bms_scheduling/app/providers/Aes.dart';

main() {
  // print(Uri.encodeComponent(Aes.encrypt('Release Order Booking').toString()));
  print("Nitish User ID:${Uri.encodeComponent('scL134pM4e0EQtJCjv7r5Q==')}");
  print(
      "Nitish Personal No:${Uri.encodeComponent(Aes.encrypt("99990122") ?? '')}");
}
