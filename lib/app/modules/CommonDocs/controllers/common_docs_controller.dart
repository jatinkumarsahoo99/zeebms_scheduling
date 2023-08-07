import 'dart:convert';

import 'package:bms_scheduling/widgets/PlutoGrid/src/pluto_grid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/MainController.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/ExportData.dart';
import '../model/common_docs_model.dart';

class CommonDocsController extends GetxController {
  PlutoGridStateManager? viewDocsStateManger;
  var documents = <CommonDocsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    documents.clear();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<bool> getInitailData(String docKey) async {
    await Get.find<ConnectorControl>().GET_METHOD_CALL_HEADER(
        api: ApiFactory.COMMON_DOCS_LOAD(docKey),
        fun: (data) {
          if (data is Map && data.containsKey("info_GetAllDocument")) {
            documents.clear();
            for (var doc in data["info_GetAllDocument"]) {
              documents.add(CommonDocsModel.fromJson(doc));
            }
          } else {
            viewDocsStateManger = null;
          }
        });
    return true;
  }

  handleOnRowDoubleTap(PlutoGridOnRowDoubleTapEvent row) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GET_METHOD_CALL_HEADER(
      api: ApiFactory.COMMON_DOCS_VIEW((documents[row.rowIdx].documentId).toString()),
      fun: (data) {
        Get.back();
        if (data is Map && data.containsKey("addingDocument")) {
          ExportData().exportFilefromByte(base64Decode(data["addingDocument"][0]["documentData"]), data["addingDocument"][0]["documentname"]);
        }
      },
      failed: () {
        Get.back();
      },
    );
  }

  handleOnDelete(String? documentKey) async {
    if (documents[viewDocsStateManger?.currentRowIdx ?? 0].documentId == null || documentKey == null) {
      return;
    }
    LoadingDialog.call();
    await Get.find<ConnectorControl>().DELETEMETHOD(
      api: ApiFactory.COMMON_DOCS_DELETE(documents[viewDocsStateManger?.currentRowIdx ?? 0].documentId.toString()),
      fun: (data) {
        Get.back();
      },
    );
    await getInitailData(documentKey);
  }

  Future<void> handleAddDocs(String? documentKey) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      LoadingDialog.call();
      await Get.find<ConnectorControl>().POSTMETHOD_FORMDATA_HEADER(
        api: ApiFactory.COMMON_DOCS_ADD,
        fun: (data) {
          if (data is Map && data.containsKey("addingDocument")) {
            documents.clear();
            for (var doc in data["addingDocument"]) {
              documents.add(CommonDocsModel.fromJson(doc));
            }

            Get.back();
          }
        },
        json: {
          "documentKey": documentKey ?? '',
          "loggedUser": Get.find<MainController>().user?.logincode ?? "",
          "strFilePath": result.files.first.name,
          "bytes": base64.encode(List<int>.from(result.files.first.bytes ?? []))
        },
      );
    }
  }

  handleViewDocs(String? documentKey) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GET_METHOD_CALL_HEADER(
      api: ApiFactory.COMMON_DOCS_VIEW(documents[viewDocsStateManger?.currentRowIdx ?? 0].documentId.toString()),
      fun: (data) {
        Get.back();
        if (data is Map && data.containsKey("addingDocument")) {
          ExportData().exportFilefromByte(base64Decode(data["addingDocument"][0]["documentData"]), data["addingDocument"][0]["documentname"]);
        }
      },
      failed: () {
        Get.back();
      },
    );
  }
}
