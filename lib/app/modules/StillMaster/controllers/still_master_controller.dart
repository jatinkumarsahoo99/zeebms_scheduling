import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:get/get.dart';

class StillMasterController extends GetxController {
  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  DropDownValue? selectedChannel, selectedLocation;
  @override
  void onReady() {
    super.onReady();
  }

  clearPage() {
    selectedChannel = null;
    selectedLocation = null;
    locationList.refresh();
    channelList.refresh();
  }

  formHandler(String string) {}
}
