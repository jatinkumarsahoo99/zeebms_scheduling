import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/modules/ImportDigitextRunOrder/bindings/digitex_run_order_data.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/user_data_settings_model.dart';

class ImportDigitextRunOrderController extends GetxController {
  //TODO: Implement ImportDigitextRunOrderController
  List<String> radiofilters = [
    "Missing Clients",
    "New Brands",
    "NewClocks",
    "Missing Agencies",
    "Missing Links",
    "My Data"
  ];
  DateFormat df1 = DateFormat("dd-MMM-yyyy");
  DateFormat df2 = DateFormat("yyyy-MM-dd");
  var selectedradiofilter = "Missing Clients".obs;
  RxList<DropDownValue> locations = <DropDownValue>[].obs;
  RxList<DropDownValue> channels = <DropDownValue>[].obs;
  TextEditingController scheduleDate = TextEditingController();
  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  DigitexRunOrderData? digitexRunOrderData;
  var importedFile = Rxn<PlatformFile>();
  TextEditingController fileController = TextEditingController();
  PageController pageController = PageController();
  PlutoGridStateManager? clientGridStateManager;
  PlutoGridStateManager? agencyGridStateManager;
  final count = 0.obs;
  var allowSave = RxBool(true);

  @override
  void onInit() {
    getLocation();
    // scheduleDate.text = df1.format(DateTime.now());
    super.onInit();
  }

  UserDataSettings? userDataSettings;

  @override
  void onReady() {
    super.onReady();
    fetchUserSetting1();
  }

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    update(['data']);
  }

  @override
  void onClose() {
    super.onClose();
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

  importfile() {
    LoadingDialog.call();
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
          Get.back();
          try {
            if (value is Map<String, dynamic>) {
              digitexRunOrderData = DigitexRunOrderData.fromJson(value);
              update(["data"]);
              checkSave();
            }
            if (digitexRunOrderData!.message != null &&
                digitexRunOrderData!.message!.isNotEmpty) {
              LoadingDialog.callErrorMessage1(
                  msg: digitexRunOrderData!.message!);
            }
          } catch (e) {
            LoadingDialog.callErrorMessage1(msg: "Failed To Import File");
          }
        });
  }

  pickFile() async {
    if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.callErrorMessage1(msg: "Please Select Location & Channel.");
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          // initialDirectory: "*08/08/2023 00:00:00*",
          allowedExtensions: ["txt"]);

      if (result != null && result.files.single != null) {
        importedFile.value = result.files.single;
        fileController.text = result.files.single.name;
        importfile();
      } else {
        // User canceled the pic5ker
      }
    }
  }

  updateClientData(
      PlutoGridOnRowDoubleTapEvent tapEvent, DropDownValue client) {
    clientGridStateManager!.changeCellValue(
        clientGridStateManager!.rows[tapEvent.rowIdx].cells["clientName"]!,
        client.value.toString(),
        force: true,
        callOnChangedEvent: false);
    clientGridStateManager!.changeCellValue(
        clientGridStateManager!.rows[tapEvent.rowIdx].cells["clientCode"]!,
        client.key.toString(),
        force: true,
        callOnChangedEvent: false);
    digitexRunOrderData!.missingClients![tapEvent.rowIdx].clientCode =
        client.key.toString();
    digitexRunOrderData!.missingClients![tapEvent.rowIdx].clientName =
        client.value.toString();
    checkSave();
  }

  clearClientData(PlutoGridOnRowDoubleTapEvent tapEvent, DropDownValue client) {
    clientGridStateManager!.changeCellValue(
        clientGridStateManager!.rows[tapEvent.rowIdx].cells["clientName"]!, "",
        force: true, callOnChangedEvent: false);
    clientGridStateManager!.changeCellValue(
        clientGridStateManager!.rows[tapEvent.rowIdx].cells["clientCode"]!, "",
        force: true, callOnChangedEvent: false);
    digitexRunOrderData!.missingClients![tapEvent.rowIdx].clientCode = "";
    digitexRunOrderData!.missingClients![tapEvent.rowIdx].clientName = "";
    checkSave();
  }

  updateAgencyData(
      PlutoGridOnRowDoubleTapEvent tapEvent, DropDownValue agency) {
    clientGridStateManager!.changeCellValue(
        clientGridStateManager!.rows[tapEvent.rowIdx].cells["agencyName"]!,
        agency.value.toString(),
        force: true,
        callOnChangedEvent: false);
    clientGridStateManager!.changeCellValue(
        clientGridStateManager!.rows[tapEvent.rowIdx].cells["agencyCode"]!,
        agency.key.toString(),
        force: true,
        callOnChangedEvent: false);
    digitexRunOrderData!.missingClients![tapEvent.rowIdx].clientCode =
        agency.key.toString();
    digitexRunOrderData!.missingClients![tapEvent.rowIdx].clientName =
        agency.value.toString();
    checkSave();
  }

  clearAgencyData(PlutoGridOnRowDoubleTapEvent tapEvent, DropDownValue agency) {
    agencyGridStateManager!.changeCellValue(
        agencyGridStateManager!.rows[tapEvent.rowIdx].cells["agencyName"]!, "",
        force: true, callOnChangedEvent: false);
    agencyGridStateManager!.changeCellValue(
        agencyGridStateManager!.rows[tapEvent.rowIdx].cells["agencyCode"]!, "",
        force: true, callOnChangedEvent: false);
    digitexRunOrderData!.missingAgencies![tapEvent.rowIdx].agenciesCode = "";
    digitexRunOrderData!.missingAgencies![tapEvent.rowIdx].agenciesName = "";
    checkSave();
  }

  mapClients() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
        api: ApiFactory.IMPORT_DIGITEX_RUN_ORDER_MAP_CLIENT,
        json: digitexRunOrderData!.missingClients!
            .map((e) => e.toJson())
            .toList(),
        fun: (value) {
          Get.back();
          try {
            print(value.toString());
          } catch (e) {
            LoadingDialog.callErrorMessage1(msg: "Failed To Map Clients");
          }
        });
  }

  mapAgencies() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
        api: ApiFactory.IMPORT_DIGITEX_RUN_ORDER_MAP_AGENCY,
        json: digitexRunOrderData!.missingAgencies!
            .map((e) => e.toJson())
            .toList(),
        fun: (value) {
          Get.back();
          try {
            print(value.toString());
          } catch (e) {
            LoadingDialog.callErrorMessage1(msg: "Failed To Map Agencies");
          }
        });
  }

  checkSave() {
    bool _allowSave = true;
    if (digitexRunOrderData!.missingAgencies!.any((element) =>
        element.agenciesCode!.isEmpty || element.agenciesCode!.isEmpty)) {
      _allowSave = false;
    }
    if (digitexRunOrderData!.missingClients!.any((element) =>
        element.clientCode!.isEmpty || element.clientName!.isEmpty)) {
      _allowSave = false;
    }
    allowSave.value = _allowSave;
  }

  saveRunOrder() {
    if (importedFile.value == null || importedFile.value?.bytes == null) {
      LoadingDialog.callErrorMessage1(msg: "Empty path name is legal.");
    } else if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.callErrorMessage1(msg: "Please Select Location & Channel.");
    } else {
      LoadingDialog.call();
      dio.FormData formData = dio.FormData.fromMap({
        'ImportFile': dio.MultipartFile.fromBytes(
          importedFile.value?.bytes?.toList() ?? [],
          filename: importedFile.value?.name ?? '',
        )
      });

      Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
          api: ApiFactory.IMPORT_DIGITEX_RUN_ORDER_SAVE(
            selectedLocation?.key ?? '',
            selectedChannel?.key ?? '',
            DateFormat('yyyy-MM-dd')
                .format(DateFormat('dd-MM-yyyy').parse(scheduleDate.text)),
          ),
          json: formData,
          fun: (value) {
            Get.back();
            try {
              LoadingDialog.callErrorMessage1(msg: value.toString());
            } catch (e) {
              LoadingDialog.callErrorMessage1(msg: "Failed To Import File");
            }
          });
    }
  }
}
