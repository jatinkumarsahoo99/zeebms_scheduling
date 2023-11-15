import 'dart:io';

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../providers/ApiFactory.dart';
import 'package:dio/dio.dart' as dio;

class ShortContentBulkImportController extends GetxController {
  var selectedFile = Rxn<PlatformFile?>();
  DropDownValue? selectedMaster;
  var masters = <DropDownValue>[].obs;
  var responseList = [].obs;
  var masterFN = FocusNode();

  @override
  void onReady() {
    super.onReady();
    getOnloadData();
  }

  void handleUploadORSelectClick() {
    if (selectedFile.value == null) {
      pickFile();
    } else {
      saveFile();
    }
  }

  void saveFile() {
    if (selectedMaster == null) {
      LoadingDialog.callInfoMessage("Please select Master.");
    } else if (selectedFile.value == null) {
      LoadingDialog.callInfoMessage("Please select File First.");
    } else {
      LoadingDialog.call();
      dio.FormData formData = dio.FormData.fromMap({
        'masterId': num.tryParse(selectedMaster!.key!),
        'formFile': dio.MultipartFile.fromBytes(
          selectedFile.value!.bytes!.toList(),
          filename: selectedFile.value?.name,
        ),
      });

      Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
        api: ApiFactory.SHORT_CONTENT_BULK_IMPORT_UPLOAD_FILE,
        json: formData,
        fun: (resp) {
          Get.back();
          if (resp != null && resp['result'] != null) {
            responseList.value = resp['result'];
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
      );
    }
  }

  saveFileFromAssest(String fileName) async {
    fileName = fileName.trim();
    if (masters.any((element) => element.value == fileName)) {
      try {
        ByteData data = await rootBundle.load("assets/files/$fileName.xlsx");
        Uint8List contentBytes = data.buffer.asUint8List();
        FileSaver().saveFile(name: fileName, bytes: contentBytes, ext: '.xlsx');
      } catch (e) {
        LoadingDialog.showErrorDialog(e.toString());
      }
    } else {
      LoadingDialog.callInfoMessage("File not found in assests folder.");
    }
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["xlsx", 'xlx'],
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      selectedFile.value = result.files.first;
    } else {
      selectedFile.value = null;
    }
  }

  getOnloadData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.SHORT_CONTENT_BULK_IMPORT_ON_LOAD,
      fun: (resp) {
        Get.back();
        if (resp != null && resp['result'] != null) {
          masters.value = [];
          masters.addAll((resp['result'] as List<dynamic>)
              .map(
                (e) => DropDownValue(
                  key: e['id'].toString(),
                  value: e['contentType'].toString(),
                ),
              )
              .toList());
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      failed: (resp) {
        Get.back();
        LoadingDialog.showErrorDialog(resp.toString());
      },
    );
  }
}
