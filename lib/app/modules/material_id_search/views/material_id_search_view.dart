import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DataGridShowOnly.dart';
import '../../../controller/HomeController.dart';
import '../controllers/material_id_search_controller.dart';

class MaterialIdSearchView extends GetView<MaterialIdSearchController> {
  const MaterialIdSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 5,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                InputFields.formField1(
                  hintTxt: "Material ID",
                  controller: controller.tapeIdCode,
                  width: 0.12,
                  autoFocus: true,
                ),
                InputFields.formField1(
                  hintTxt: "Program Name",
                  controller: controller.programName,
                  width: 0.24,
                ),
                InputFields.formField1(
                  hintTxt: "Eps Caption",
                  controller: controller.epsCaption,
                  width: 0.36,
                ),
                FormButtonWrapper(
                  btnText: "Show",
                  callback: () {
                    controller.getData();
                  },
                ),
                FormButtonWrapper(
                  btnText: "Clear",
                  callback: () {
                    Get.delete<MaterialIdSearchController>();
                    Get.find<HomeController>().clearPage1();
                  },
                ),
              ],
            ),
          ),
          Obx(() => Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: DataGridShowOnlyKeys(
                      mapData: controller.data.value, hideCode: false),
                ),
              ))
        ],
      ),
    );
  }
}
