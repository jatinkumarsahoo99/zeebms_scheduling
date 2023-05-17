import 'package:bms_scheduling/app/modules/RoCancellation/bindings/ro_cancellation_data.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:dio/dio.dart' as dio;

import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';

class RoCancellationController extends GetxController {
  //TODO: Implement RoCancellationController
  PlatformFile? importedFile;
  DateFormat df2 = DateFormat("yyyy-MM-dd");
  RxList<DropDownValue> locations = <DropDownValue>[].obs;
  RxList<DropDownValue> channels = <DropDownValue>[].obs;
  TextEditingController cancelDatectrl = TextEditingController();
  DropDownValue? selectedLocation;
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

  @override
  void onInit() {
    getLocation();
    bookingNumberFocus.addListener(() {
      if (!bookingNumberFocus.hasFocus) {
        if (bookingNumberctrl.text != "" && !cancelFetchData) {
          onBookingNoLeave(bookingNumberctrl.text);
        }
      }
    });
    cancelNumberFocus.addListener(() {
      if (!cancelNumberFocus.hasFocus) {
        if (cancelNumberctrl.text != "" && !cancelFetchData) {
          onCancelNoLeave();
        }
      }
    });
    super.onInit();
  }

  getLocation() {
    locations.value = [];
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.RO_CANCELLATION_LOCATION,
          fun: (data) {
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
    channels.value = [];
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.RO_CANCELLATION_CHANNNEL(locationCode),
          fun: (data) {
            if ((data as Map).containsKey("lstChannel") &&
                data["lstChannel"] is List) {
              for (var e in data["lstChannel"]) {
                channels.add(DropDownValue(
                    key: e["channelcode"], value: e["channelName"]));
              }
              channels.refresh();
              // channels.value = data["lstChannel"]
              //     .map((e) => DropDownValue(
              //         key: e["channelcode"], value: e["channelName"]))
              //     .toList();
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
    print("ON BOOKING NUMBER LEAVE CALLED>>>");
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
      LoadingDialog.callErrorMessage1(msg: "Failed To Load  Data");
    }

    print("ON BOOKING NUMBER LEAVE END>>>");
  }

  onCancelNoLeave() {
    print("ON BOOKING NUMBER LEAVE CALLED>>>");
    try {
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_CANCELLATION_CANCEL_LEAVE,
          json: {
            "locationCode": selectedLocation!.key,
            "channelCode": selectedChannel!.key,
            "bookingNo": bookingNumberctrl.text,
            "cancelMonth": cancelMonthctrl.text,
            "cancelNumber": cancelNumberctrl.text
          },
          fun: (data) {
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
      LoadingDialog.callErrorMessage1(msg: "Failed To Load  Data");
    }

    print("ON BOOKING NUMBER LEAVE END>>>");
  }

  parseCancelLeaveData(Map data) {
    FocusScope.of(Get.context!).requestFocus(selectAllFocus);
    selectAllFocus.requestFocus();
    cancelFetchData = true;
    bookingNumberctrl.text = data["bookingnumber"];
    clientctrl.text = data["clientName"];
    brandctrl.text = data["brandName"];
    agencyctrl.text = data["agencyName"];
    enableBrandClientAgent.value = false;
    enableEffDate.value = false;
    enableCancelNumber.value = false;
    FocusScope.of(Get.context!).requestFocus(selectAllFocus);
    selectAllFocus.requestFocus();

    cancelFetchData = false;
    List<LstBookingNoStatusData> lstBookingNoStatusData = [];
    for (var element in data["lstBookingNoStatusData"]) {
      lstBookingNoStatusData.add(LstBookingNoStatusData.fromJson(element));
    }
    roCancellationData = RoCancellationData(
        cancellationData: CancellationData(
            agencyName: data["agencyName"],
            brandName: data["brandName"],
            clientName: data["clientName"],
            lstBookingNoStatusData: lstBookingNoStatusData));
    update(["cancelData"]);
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
    } catch (e) {}
  }

  calculate() {
    intTotalCount.value = 0;
    intTotalDuration.value = 0;
    intTotalAmount.value = 0;
    intTotalValuationAmount.value = 0;
    roCancellationGridManager!.setFilter((element) => element.checked!);
    for (var row in roCancellationGridManager!.rows) {
      if (row.checked! && row.cells["cancelNumber"]!.value == "") {
        intTotalCount.value = (intTotalCount.value ?? 0) + 1;
        intTotalDuration.value = (intTotalDuration.value ?? 0) +
            (num.parse((row.cells["tapeDuration"]?.value ?? 0).toString()))
                .toInt();
        intTotalAmount.value = (intTotalAmount.value ?? 0) +
            (double.parse((row.cells["spotAmount"]?.value ?? 0).toString()))
                .toDouble();
        intTotalValuationAmount.value = (intTotalValuationAmount.value ?? 0) +
            (double.parse(
                    (row.cells["valuationAmount"]?.value ?? 0).toString()))
                .toDouble();
      }
    }

//      For Each dr As DataGridViewRow In dgvList.Rows
//             If Convert.ToBoolean(dr.Cells("Requested").Value) And Convert.ToString(dr.Cells("CancelNumber").Value) = "" Then
//                 intTotalCount += 1
//                 intTotalDuration += Convert.ToInt32(dr.Cells("TapeDuration").Value)
//                 intTotalAmount += Convert.ToDouble(dr.Cells("SpotAmount").Value)
//                 intTotalValuationAmount += Convert.ToDouble(dr.Cells("ValuationAmount").Value)
//             End If
//         Next

//         lblTotalSpots.Text = Convert.ToString(intTotalCount)
//         lblTotalDuration.Text = Convert.ToString(intTotalDuration)
//         lblTotalAmount.Text = Convert.ToString(intTotalAmount)
//         lblTotalValAmount.Text = Convert.ToString(intTotalValuationAmount)
  }

  save() {
    print("RO SAVE CALLED>>>");
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
          "modifiedBy": "string",
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
            if (data["saveInfo"]["message"] == "Records saved successfully") {
              LoadingDialog.callDataSaved(msg: data["saveInfo"]["message"]);
            } else {
              LoadingDialog.callInfoMessage(data["saveInfo"]["message"]);
            }
          }
        });

    print("ON BOOKING NUMBER LEAVE END>>>");
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
          print(data);
          Get.back();

          try {
            List<LstBookingNoStatusData> _lstBookingNoStatusData = [];
            for (var element in data["importExcelResponse"]) {
              _lstBookingNoStatusData
                  .add(LstBookingNoStatusData.fromJson(element));
            }
            roCancellationData!.cancellationData!.lstBookingNoStatusData =
                _lstBookingNoStatusData;
            update(["cancelData"]);
          } catch (e) {
            LoadingDialog.callErrorMessage1(msg: "Failed To Import File");
          }
        });
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single != null) {
      importedFile = result.files.single;

      importfile();
    } else {
      // User canceled the pic5ker
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
