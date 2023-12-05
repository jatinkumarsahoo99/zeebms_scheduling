import 'package:bms_scheduling/app/controller/HomeController.dart';
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
                    Obx(() {
                      return DropDownField.formDropDown1WidthMap(
                        controller.masters.value,
                        (val) => controller.selectedMaster = val,
                        "Master",
                        .15,
                        autoFocus: true,
                        inkWellFocusNode: controller.masterFN,
                      );
                    }),
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
                          callback: controller.handleUploadORSelectClick,
                          iconDataM: Icons.upload_file,
                        );
                      },
                    ),
                    FormButton(
                      btnText: "Clear",
                      callback: () {
                        controller.selectedMaster = null;
                        controller.selectedFile.value = null;
                        controller.masters.refresh();
                        controller.responseList.clear();
                        controller.masterFN.requestFocus();
                        // Get.delete<ShortContentBulkImportController>();
                        // Get.find<HomeController>().clearPage1();
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Obx(() {
                          return DataGridFromMap3(
                            mapData: controller.responseList.value,
                            formatDate: false,
                            hideCode: false,
                          );
                        }),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Obx(
                          () {
                            return ListView.builder(
                              itemCount: controller.masters.value.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xffDDDDDD),
                                        blurRadius: 6.0,
                                        spreadRadius: 2.0,
                                        offset: Offset(0.0, 0.0),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(controller
                                              .masters[index].value
                                              .toString())),
                                      const SizedBox(width: 10),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            controller.saveFileFromAssest(
                                              controller.masters[index].value
                                                  .toString(),
                                            );
                                          },
                                          icon: const Icon(Icons.download))
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
                // Expanded(
                //   child: DataGridFromMap3(
                //     rowHeight: 35,
                //     witdthSpecificColumn: {
                //       'Download': 50,
                //     },
                //     columnAutoResize: true,
                //     mapData: controller.assestFiles.map((e) {
                //       return {"File Name": e, "Download": ""};
                //     }).toList(),
                //     customWidgetInRenderContext: {
                //       "Download": (renderContext) {
                //         return FormButton(
                //           btnText: "Download",
                //           iconDataM: Icons.download,
                //           callback: () {
                //             controller.saveFileFromAssest(
                //                 renderContext.row.cells['File Name']?.value);
                //           },
                //         );
                //       },
                //     },
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
