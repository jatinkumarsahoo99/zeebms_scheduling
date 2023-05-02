import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/DropDownValue.dart';

class ImportDigitextRunOrderController extends GetxController {
  //TODO: Implement ImportDigitextRunOrderController
  List<String> radiofilters = [
    "Missing Chart",
    "New Brands",
    "NewClocks",
    "Missing Links",
    "My Data"
  ];
  String selectedradiofilter = "Missing Chart";
  RxList<DropDownValue> locations = <DropDownValue>[].obs;
  RxList<DropDownValue> channels = <DropDownValue>[].obs;
  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  var importedFile = Rxn<PlatformFile>();
  TextEditingController fileController = TextEditingController();

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
        api: ApiFactory.IMPORT_DIGITEX_RUN_ORDER_IMPORT(
            selectedLocation!.key, selectedChannel!.key),
        json: formData,
        fun: (value) {
          print(value);
        });
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single != null) {
      importedFile.value = result.files.single;
      fileController.text = result.files.single.name;
      importfile();
    } else {
      // User canceled the picker
    }
  }

  getLocation() {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.IMPORT_DIGITEX_RUN_ORDER_LOCATION,
          fun: (data) {
            if (data is List) {
              locations.value = data
                  .map((e) => DropDownValue(
                      key: e["locationCode"], value: e["locationName"]))
                  .toList();
            } else {
              LoadingDialog.callErrorMessage1(
                  msg: "Failed To Load Initial Data");
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
              channels.value = data
                  .map((e) => DropDownValue(
                      key: e["channelCode"], value: e["channelName"]))
                  .toList();
            } else {
              LoadingDialog.callErrorMessage1(
                  msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }
}
