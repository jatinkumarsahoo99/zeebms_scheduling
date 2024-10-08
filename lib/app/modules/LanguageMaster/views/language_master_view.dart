import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/Utils.dart';
import '../controllers/language_master_controller.dart';

class LanguageMasterView extends GetView<LanguageMasterController> {
  const LanguageMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: context.width * .5,
          // height: context.height,
          child: Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppBar(
                  title: const Text('Langauge Master'),
                  centerTitle: true,
                  backgroundColor: Colors.deepPurple,
                ),

                const SizedBox(height: 20),
                InputFields.formField1(
                  hintTxt: "Langauge Name",
                  controller: controller.textEditingTC,
                  width: 0.4,
                  padLeft: 0,
                  autoFocus: true,
                  focusNode: controller.langaugeFN,
                  inputformatters: [
                    UpperCaseTextFormatter(),
                  ],
                ),
                const SizedBox(height: 20),

                ///Common Buttons
                GetBuilder<HomeController>(
                  id: "buttons",
                  init: Get.find<HomeController>(),
                  builder: (btncontroller) {
                    if (btncontroller.buttons != null) {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 15,
                        alignment: WrapAlignment.center,
                        children: [
                          for (var btn in btncontroller.buttons!) ...{
                            FormButtonWrapper(
                              btnText: btn["name"],
                              callback: ((Utils.btnAccessHandler(btn['name'], controller.formPermissions!) == null))
                                  ? null
                                  : () => controller.formHandler(btn['name']),
                            )
                          },
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
