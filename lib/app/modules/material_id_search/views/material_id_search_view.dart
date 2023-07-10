import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DataGridShowOnly.dart';
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
                  controller: TextEditingController(),
                  width: 0.12,
                ),
                InputFields.formField1(
                  hintTxt: "Program Name",
                  controller: TextEditingController(),
                  width: 0.24,
                ),
                InputFields.formField1(
                  hintTxt: "Eps Caption",
                  controller: TextEditingController(),
                  width: 0.36,
                ),
                FormButtonWrapper(
                  btnText: "Show",
                  callback: () {},
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: DataGridShowOnlyKeys(mapData: []),
            ),
          )
        ],
      ),
    );
  }
}
