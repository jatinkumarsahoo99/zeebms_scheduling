import 'package:get/get.dart';
import '../controllers/event_secondary_controller.dart';

class EventSecondaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventSecondaryController>(
      () => EventSecondaryController(),
    );
  }
}
