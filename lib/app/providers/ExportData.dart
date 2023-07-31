import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGridExport/pluto_grid_export.dart' as pluto_grid_export;
import 'package:bms_scheduling/widgets/PlutoGridExport/pluto_grid_export.dart';

import '../../widgets/LoadingDialog.dart';
import '../../widgets/Snack.dart';

class ExportData {
  @pragma('vm:entry-point')
  static void topLevelFunction(Map<String, dynamic> args) {
    // performs work in an isolate
  }
  exportExcelFromJsonList(jsonList, screenName, {Function? callBack}) {
    print("Call json List>>>" + jsonEncode(jsonList));
    if (jsonList!.isNotEmpty) {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel[screenName];
      excel.setDefaultSheet(screenName);
      sheetObject.appendRow((jsonList![0]).keys.toList());
      for (var element in jsonList!) {
        sheetObject.appendRow((element as Map).values.toList());
      }
      var value = excel.encode()!;
      String time = DateTime.now().toString();
      // var fileBytes = excel.save(fileName: "$screenName-$time.xlsx");
      var fileBytes = excel.save(fileName: screenName);
      if (callBack != null) {
        callBack();
      }
      // FlutterFileSaver()
      //     .writeFileAsBytes(
      //       fileName: 'fpc_search.xlsx',
      //       bytes: value as Uint8List,
      //     )
      //     .then((value) => Snack.callSuccess("File save to $value"));
    } else {
      Snack.callError("NO DATA TO EXPORT");
    }
  }

  exportFilefromString(String data, String fileName) async {
    try {
      await FlutterFileSaver().writeFileAsString(fileName: fileName, data: data).then((value) {
        return value;
      });
    } catch (e) {
      Snack.callError("Failed To Save File");
    }
  }

  exportFilefromBase64(String data, String fileName) async {
    try {
      await FlutterFileSaver().writeFileAsBytes(fileName: fileName, bytes: base64.decode(data)).then((value) {
        LoadingDialog.callInfoMessage("Exported Successfully");
        return value;
      });
    } catch (e) {
      Snack.callError("Failed To Save File");
    }
  }


  exportFilefromByte(Uint8List data, String fileName) async {
    try {
      await FlutterFileSaver().writeFileAsBytes(fileName: fileName, bytes: data).then((value) {
        return value;
      });
    } catch (e) {
      Snack.callError("Failed To Save File");
    }
  }

  printFromGridData(plutoGridPdfExport, stateManager) async {
    plutoGridPdfExport.themeData = pluto_grid_export.ThemeData.withFont(
      base: pluto_grid_export.Font.ttf(
        await rootBundle.load('assets/fonts/OpenSans-Regular.ttf'),
      ),
      bold: pluto_grid_export.Font.ttf(
        await rootBundle.load('assets/fonts/OpenSans-Bold.ttf'),
      ),
    );
    await Printing.layoutPdf(
        format: PdfPageFormat.a4.landscape,
        name: plutoGridPdfExport.getFilename(),
        onLayout: (PdfPageFormat format) async {
          // Update format onLayout
          plutoGridPdfExport.format = format;
          return plutoGridPdfExport.export(stateManager);
        });
  }

  exportPdfFromGridData(pluto_grid_export.PlutoGridDefaultPdfExport plutoGridPdfExport, stateManager) async {
    LoadingDialog.call();

    plutoGridPdfExport.themeData = pluto_grid_export.ThemeData.withFont(
      base: pluto_grid_export.Font.ttf(
        await rootBundle.load('assets/fonts/OpenSans-Regular.ttf'),
      ),
      bold: pluto_grid_export.Font.ttf(
        await rootBundle.load('assets/fonts/OpenSans-Bold.ttf'),
      ),
    );
    await pluto_grid_export.Printing.sharePdf(bytes: await plutoGridPdfExport.export(stateManager), filename: plutoGridPdfExport.getFilename());

    Get.back();
  }
}
