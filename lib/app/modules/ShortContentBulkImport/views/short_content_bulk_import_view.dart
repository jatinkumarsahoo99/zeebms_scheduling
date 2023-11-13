import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../controllers/short_content_bulk_import_controller.dart';

class ShortContentBulkImportView extends StatelessWidget {
  const ShortContentBulkImportView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ShortContentBulkImportController>(
        init: Get.put(ShortContentBulkImportController()),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    DropDownField.formDropDown1WidthMap(
                      [],
                      (p0) => null,
                      "Master",
                      .15,
                    ),
                    Obx(() {
                      return Visibility(
                        visible: controller.selectedFile.value != null,
                        child: InputFields.formFieldDisable(
                          hintTxt: "Selected File",
                          value: controller.selectedFile.value?.name ?? "",
                          widthRatio: .2,
                        ),
                      );
                    }),
                    Obx(
                      () {
                        return FormButton(
                          btnText: controller.selectedFile.value == null
                              ? "Select File"
                              : "Upload",
                          callback: controller.pickFile,
                          iconDataM: Icons.upload_file,
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: DataGridFromMap3(
                    rowHeight: 35,
                    witdthSpecificColumn: {
                      'Download': 50,
                    },
                    columnAutoResize: true,
                    mapData: controller.assestFiles.map((e) {
                      return {"File Name": e, "Download": ""};
                    }).toList(),
                    customWidgetInRenderContext: {
                      "Download": (renderContext) {
                        return FormButton(
                          btnText: "Download",
                          iconDataM: Icons.download,
                          callback: () {
                            controller.saveFileFromAssest(
                                renderContext.row.cells['File Name']?.value);
                          },
                        );
                      },
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
