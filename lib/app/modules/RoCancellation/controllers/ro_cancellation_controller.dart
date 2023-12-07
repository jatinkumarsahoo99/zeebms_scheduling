import 'dart:convert';

import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/modules/RoCancellation/bindings/ro_cancellation_data.dart';
import 'package:bms_scheduling/app/modules/RoCancellation/bindings/ro_cancellation_doc.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/providers/ExportData.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:dio/dio.dart' as dio;
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/user_data_settings_model.dart';
import '../../CommonDocs/controllers/common_docs_controller.dart';
import '../../CommonDocs/views/common_docs_view.dart';

class RoCancellationController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    update(['cancelData']);
  }

  UserDataSettings? userDataSettings;

  PlatformFile? importedFile;
  DateFormat df2 = DateFormat("yyyy-MM-dd");
  RxList<DropDownValue> locations = <DropDownValue>[].obs;
  RxList<DropDownValue> channels = <DropDownValue>[].obs;
  TextEditingController cancelDatectrl = TextEditingController();
  DropDownValue? selectedLocation;
  FocusNode locFN = FocusNode();
  DropDownValue? selectedChannel;
  TextEditingController effDatectrl = TextEditingController();
  TextEditingController refNumberctrl = TextEditingController();

  TextEditingController bookingNumberctrl = TextEditingController();

  TextEditingController cancelNumberctrl = TextEditingController();

  TextEditingController cancelMonthctrl = TextEditingController();
  TextEditingController clientctrl = TextEditingController();
  TextEditingController agencyctrl = TextEditingController();
  TextEditingController brandctrl = TextEditingController();
  FocusNode bookingNumberFocus = FocusNode();
  FocusNode cancelNumberFocus = FocusNode();
  FocusNode selectAllFocus = FocusNode();
  List<RoCancellationDocuments> documents = [];

  RoCancellationData? roCancellationData;
  PlutoGridStateManager? roCancellationGridManager;
  var intTotalCount = RxnInt();
  var intTotalDuration = RxnInt();
  var intTotalAmount = RxnDouble();
  var intTotalValuationAmount = RxnDouble();
  var enableCancelMonth = RxBool(true);
  var enableCancelNumber = RxBool(true);
  var enableCancelDate = RxBool(true);
  var enableEffDate = RxBool(true);
  var enableBrandClientAgent = RxBool(true);
  var selectAll = RxBool(false);
  bool cancelFetchData = false;
  double widthratio = .22;

  @override
  void onReady() {
    super.onReady();
    getLocation();
    fetchUserSetting1();
    bookingNumberFocus.addListener(() {
      if (!bookingNumberFocus.hasFocus &&
          bookingNumberctrl.text != "" &&
          !cancelFetchData) {
        onBookingNoLeave(bookingNumberctrl.text);
      }
    });
    cancelNumberFocus.addListener(() {
      if (!cancelNumberFocus.hasFocus &&
          (cancelNumberctrl.text.isNotEmpty && !cancelFetchData) &&
          cancelMonthctrl.text.isNotEmpty) {
        onCancelNoLeave();
      }
    });
  }

  // formHandler(String btnName) {
  //   if (btnName == "Save") {
  //     save();
  //   } else if (btnName == "Clear") {
  //     // Get.delete<RoCancellationController>();
  //     Get.find<HomeController>().clearPage1();
  //   } else if (btnName == "Docs") {
  //     docs();
  //   }
  // }

  getLocation() {
    LoadingDialog.call();
    locations.value = [];
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.RO_CANCELLATION_LOCATION,
          fun: (data) {
            Get.back();
            if ((data as Map).containsKey("lstLocation") &&
                data["lstLocation"] is List) {
              for (var e in data["lstLocation"]) {
                locations.add(DropDownValue(
                    key: e["locationCode"], value: e["locationName"]));
              }
              locations.refresh();
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
    LoadingDialog.call();
    // selectedChannel = DropDownValue(key: "ZAZEE00001", value: "Zee TV");
    channels.value = [];
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.RO_CANCELLATION_CHANNNEL(locationCode),
          fun: (data) {
            Get.back();
            if ((data as Map).containsKey("lstChannel") &&
                data["lstChannel"] is List) {
              for (var e in data["lstChannel"]) {
                channels.add(DropDownValue(
                    key: e["channelcode"], value: e["channelName"]));
              }
              channels.refresh();
            } else {
              LoadingDialog.callErrorMessage1(
                  msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }

  onBookingNoLeave(bookingNo) {
    // print("ON BOOKING NUMBER LEAVE CALLED>>>");
    if (selectedChannel == null || selectedLocation == null) {
      return;
    }
    LoadingDialog.call();
    try {
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_CANCELLATION_BOOKINGNO_LEAVE,
          json: {
            "locationCode": selectedLocation!.key,
            "channelCode": selectedChannel!.key,
            "bookingNo": bookingNo,
            "cancelMonth": 0,
            "cancelNumber": 0
          },
          fun: (data) {
            Get.back();
            try {
              roCancellationData = RoCancellationData.fromJson(data);
              if (roCancellationData != null &&
                  roCancellationData!.cancellationData != null) {
                parseCancellationData();
              }
            } catch (e) {
              LoadingDialog.callErrorMessage1(
                  msg: "Failed To Load Cancellation Data");
            }
          });
    } catch (e) {
      Get.back();
      // LoadingDialog.callErrorMessage1(msg: "Failed To Load  Data");
    }

    print("ON BOOKING NUMBER LEAVE END>>>");
  }

  onCancelNoLeave() {
    // print("ON BOOKING NUMBER LEAVE CALLED>>>");
    if (selectedLocation == null || selectedChannel == null) {
      return;
    }
    LoadingDialog.call();
    try {
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_CANCELLATION_CANCEL_LEAVE,
          json: {
            "locationCode": selectedLocation?.key ?? '',
            "channelCode": selectedChannel?.key ?? '',
            "bookingNo": bookingNumberctrl.text,
            "cancelMonth": cancelMonthctrl.text,
            "cancelNumber": cancelNumberctrl.text
          },
          fun: (data) {
            Get.back();
            if (data is Map) {
              parseCancelLeaveData(data["showCancelData"]);
            }
            // try {
            //   if (data is Map) {
            //     parseCancelLeaveData(data["showCancelData"]);
            //   }
            // } catch (e) {
            //   LoadingDialog.callErrorMessage1(
            //       msg: "Failed To Load Cancellation Data");
            // }
          });
    } catch (e) {
      Get.back();
      LoadingDialog.callErrorMessage1(msg: "Failed To Load  Data");
    }

    print("ON BOOKING NUMBER LEAVE END>>>");
  }

  parseCancelLeaveData(Map data) {
    try {
      FocusScope.of(Get.context!).requestFocus(selectAllFocus);
      selectAllFocus.requestFocus();
      cancelFetchData = true;
      bookingNumberctrl.text = data["bookingnumber"] ?? "";
      clientctrl.text = data["clientName"] ?? "";
      brandctrl.text = data["brandName"] ?? "";
      agencyctrl.text = data["agencyName"] ?? "";
      if (data['bookingEffectiveDate'] != null) {
        effDatectrl.text = DateFormat('dd-MM-yyyy').format(
            DateFormat('yyyy-MM-ddThh:mm:ss')
                .parse(data['bookingEffectiveDate']));
      }
      FocusScope.of(Get.context!).requestFocus(selectAllFocus);
      selectAllFocus.requestFocus();

      cancelFetchData = false;
      List<LstBookingNoStatusData> lstBookingNoStatusData = [];
      for (var element in data["lstBookingNoStatusData"] ?? []) {
        lstBookingNoStatusData.add(LstBookingNoStatusData.fromJson(element));
      }
      roCancellationData = RoCancellationData(
        cancellationData: CancellationData(
          agencyName: data["agencyName"] ?? '',
          brandName: data["brandName"] ?? '',
          clientName: data["clientName"] ?? '',
          lstBookingNoStatusData: lstBookingNoStatusData,
        ),
      );
      enableBrandClientAgent.value = false;
      enableEffDate.value = false;
      enableCancelNumber.value = false;
      generateDate();
      update(["cancelData"]);
    } catch (e) {
      print(e.toString());
    }
  }

  void generateDate() {
    cancelMonthctrl.text =
        effDatectrl.text.split("-")[2] + effDatectrl.text.split("-")[1];
    enableCancelMonth.value = false;
  }

  parseCancellationData() {
    try {
      FocusScope.of(Get.context!).requestFocus(selectAllFocus);
      selectAllFocus.requestFocus();
      CancellationData data = roCancellationData!.cancellationData!;
      clientctrl.text = data.clientName ?? "";
      agencyctrl.text = data.agencyName ?? "";
      brandctrl.text = data.brandName ?? "";
      enableBrandClientAgent.value = false;
      enableEffDate.value = false;
      enableCancelNumber.value = false;
      update(["cancelData"]);
      if (data.message != null && data.message != "") {
        LoadingDialog.callErrorMessage1(msg: data.message ?? "");
      }
      intTotalCount.value = null;
      intTotalDuration.value = null;
      intTotalAmount.value = null;
      intTotalValuationAmount.value = null;
    } catch (e) {
      print(e.toString());
    }
  }

  docs() async {
    String documentKey = "";
    if (cancelNumberctrl.text.isEmpty ||
        selectedLocation == null ||
        selectedChannel == null ||
        cancelMonthctrl.text.isEmpty) {
      documentKey = "";
    } else {
      documentKey =
          "ROCancellation ${selectedLocation?.key ?? ''}${selectedChannel?.key ?? ''}${cancelMonthctrl.text}${cancelNumberctrl.text}";
    }
    if (documentKey == "") {
      return;
    }
    Get.defaultDialog(
      title: "Documents",
      content: CommonDocsView(
        documentKey: documentKey,
      ),
    ).then((value) {
      Get.delete<CommonDocsController>(tag: "commonDocs");
    });
  }

  calculate() {
    if (roCancellationData?.cancellationData?.lstBookingNoStatusData != null) {
      intTotalCount.value = 0;
      intTotalDuration.value = 0;
      intTotalAmount.value = 0;
      intTotalValuationAmount.value = 0;
      // roCancellationGridManager!.setFilter((element) => element.checked!);
      var list = roCancellationData?.cancellationData?.lstBookingNoStatusData
              ?.where((element) => (element.requested ?? false))
              .toList() ??
          [];
      // print(list.length);
      for (LstBookingNoStatusData element in list) {
        if (element.cancelNumber == null &&
            (element.cancelNumber?.isEmpty ?? true)) {
          intTotalCount.value = (intTotalCount.value ?? 0) + 1;
          intTotalDuration.value =
              (intTotalDuration.value ?? 0) + (element.tapeDuration ?? 0);
          intTotalAmount.value = (intTotalAmount.value ?? 0) +
              (double.parse((element.spotAmount ?? 0).toString())).toDouble();
          intTotalValuationAmount.value = (intTotalValuationAmount.value ?? 0) +
              (double.parse((element.valuationAmount ?? 0).toString()))
                  .toDouble();
        }
      }
      roCancellationGridManager!
          .setFilter((element) => element.cells['requested']!.value == 'true');
    }
  }

  save() {
    if (selectedLocation == null) {
      LoadingDialog.showErrorDialog("Please select Location.");
    } else if (selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Channel.");
    } else if (refNumberctrl.text.isEmpty || bookingNumberctrl.text.isEmpty) {
      LoadingDialog.showErrorDialog(
          "Please enter Reference number and Booking No.");
    } else if (roCancellationData
            ?.cancellationData?.lstBookingNoStatusData?.isEmpty ??
        true) {
      LoadingDialog.showErrorDialog("Please load data.");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_CANCELLATION_SAVE,
          json: {
            "locationCode": selectedLocation!.key,
            "channelCode": selectedChannel!.key,
            "cancelMonth": int.tryParse(cancelMonthctrl.text) ?? 0,
            "cancelNumber": int.tryParse(cancelNumberctrl.text) ?? 0,
            "cancelDate": DateFormat("yyyy-MM-dd")
                .format(DateFormat("dd-MM-yyyy").parse(cancelDatectrl.text)),
            "referenceNumber": refNumberctrl.text,
            "bookingnumber": bookingNumberctrl.text,
            "modifiedBy": Get.find<MainController>().user?.logincode,
            "lstdgvList": roCancellationData!
                .cancellationData!.lstBookingNoStatusData!
                .map((e) => e.toJson())
                .toList()
          },
          fun: (data) {
            Get.back();
            if (data is String) {
              LoadingDialog.callErrorMessage1(msg: data);
            } else if (data is Map && data.containsKey("saveInfo")) {
              if (data["saveInfo"]["message"]
                  .toString()
                  .contains("Records saved successfully")) {
                LoadingDialog.callDataSaved(
                    msg: data["saveInfo"]["message"],
                    callback: () {
                      Get.delete<RoCancellationController>();
                      Get.find<HomeController>().clearPage1();
                    });
              } else {
                LoadingDialog.callInfoMessage(data["saveInfo"]["message"]);
              }
            }
          });
    }
  }

  importfile() {
    LoadingDialog.call();
    dio.FormData formData = dio.FormData.fromMap({
      'File': dio.MultipartFile.fromBytes(
        importedFile!.bytes!.toList(),
        filename: importedFile!.name,
      )
    });

    Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
        api: ApiFactory.RO_CANCELLATION_IMPORT,
        json: formData,
        fun: (data) {
          Get.back();

          try {
            if (data.toString().contains(
                "Column 'BookingDetailCode' does not belong to table Table1.")) {
              LoadingDialog.showErrorDialog(data.toString());
            } else {
              List<LstBookingNoStatusData> _lstBookingNoStatusData = [];
              for (var element in data["importExcelResponse"]) {
                _lstBookingNoStatusData
                    .add(LstBookingNoStatusData.fromJson(element));
              }
              roCancellationData!.cancellationData!.lstBookingNoStatusData =
                  _lstBookingNoStatusData;
              update(["cancelData"]);
            }
          } catch (e) {
            LoadingDialog.callErrorMessage1(msg: "Failed To Import File");
          }
        });
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['xlsx'],
      type: FileType.custom,
    );

    if (result != null && result.files.isNotEmpty) {
      importedFile = result.files.single;

      importfile();
    } else {
      // User canceled the pic5ker
    }
  }
}
