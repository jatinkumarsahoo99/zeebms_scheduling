import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/modules/ImportDigitextRunOrder/bindings/digitex_run_order_data.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/DropDownValue.dart';

class ImportDigitextRunOrderController extends GetxController {
  //TODO: Implement ImportDigitextRunOrderController
  List<String> radiofilters = ["Missing Clients", "New Brands", "NewClocks", "Missing Agencies", "Missing Links", "My Data"];

  var selectedradiofilter = "Missing Clients".obs;
  RxList<DropDownValue> locations = <DropDownValue>[].obs;
  RxList<DropDownValue> channels = <DropDownValue>[].obs;
  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  DigitexRunOrderData? digitexRunOrderData;
  var importedFile = Rxn<PlatformFile>();
  TextEditingController fileController = TextEditingController();
  PageController pageController = PageController();
  final count = 0.obs;
  @override
  void onInit() {
    getLocation();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  importfile() async {
    dio.FormData formData = dio.FormData.fromMap({
      'ImportFile': dio.MultipartFile.fromBytes(
        importedFile.value!.bytes!.toList(),
        filename: importedFile.value!.name,
      )
    });

    Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
        api: ApiFactory.IMPORT_DIGITEX_RUN_ORDER_IMPORT(selectedLocation!.key, selectedChannel!.key),
        json: formData,
        fun: (value) {
          try {
            if (value is Map<String, dynamic>) {
              digitexRunOrderData = DigitexRunOrderData.fromJson(value);
              update(["data"]);
            }
            if (digitexRunOrderData!.message != null && digitexRunOrderData!.message!.isNotEmpty) {
              LoadingDialog.callErrorMessage1(msg: digitexRunOrderData!.message!);
            }
          } catch (e) {
            LoadingDialog.callErrorMessage1(msg: "Failed To Import File");
          }
        });
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single != null) {
      importedFile.value = result.files.single;
      fileController.text = result.files.single.name;
      importfile();
    } else {
      // User canceled the pic5ker
    }
  }

  getLocation() {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.IMPORT_DIGITEX_RUN_ORDER_LOCATION,
          fun: (data) {
            if (data is List) {
              locations.value = data.map((e) => DropDownValue(key: e["locationCode"], value: e["locationName"])).toList();
            } else {
              LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }

  getChannel(locationCode) {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.IMPORT_DIGITEX_RUN_ORDER_CHANNEL(locationCode),
          fun: (data) {
            if (data is List) {
              channels.value = data.map((e) => DropDownValue(key: e["channelCode"], value: e["channelName"])).toList();
            } else {
              LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }
}
