import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ShortContentBulkImportController extends GetxController {
  var selectedFile = Rxn<PlatformFile?>();
  List<String> assestFiles = [
    'Commercial Form Data Structure_V2.xlsx',
    'Filler Form Data Structure_V1.xlsx',
    'Promo Form Data Structure_V1.xlsx',
    'Vignet_Still_Slide Form Data Structure_V1.xlsx',
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  saveFileFromAssest(String fileName) async {
    ByteData data = await rootBundle.load("assets/files/$fileName");
    Uint8List contentBytes = data.buffer.asUint8List();
    FileSaver().saveFile(name: fileName, bytes: contentBytes);
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

  @override
  void onClose() {
    super.onClose();
  }
}
