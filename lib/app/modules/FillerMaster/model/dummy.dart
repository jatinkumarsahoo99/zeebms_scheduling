import 'package:bms_scheduling/app/providers/Aes.dart';

main() {
  // print(Uri.encodeComponent(Aes.encrypt('Release Order Booking').toString()));
  print(
      "Nitish User ID:${Uri.encodeComponent(Aes.encrypt("scL134pM4e0EQtJCjv7r5Q==") ?? '')}");
  print(
      "Nitish Personal No:${Uri.encodeComponent(Aes.encrypt("e7ScQlP7tXxBxRizIrkQIA==") ?? '')}");
}
