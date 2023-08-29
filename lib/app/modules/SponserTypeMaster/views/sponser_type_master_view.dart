import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../../CommonSearch/views/common_search_view.dart';
import '../controllers/sponser_type_master_controller.dart';

class SponserTypeMasterView extends StatelessWidget {
  SponserTypeMasterView({Key? key}) : super(key: key);
  final controller =
      Get.put<SponserTypeMasterController>(SponserTypeMasterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SponsorTypeMasterView'),
        centerTitle: true,
      ),
      body: Center(
          child: SizedBox(
              width: Get.width * .64,
              child: Dialog(
                  backgroundColor: Colors.grey[100],
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppBar(
                          title: const Text('Sponsor Type Master'),
                          centerTitle: true,
                          backgroundColor: Colors.deepPurple,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          spacing: Get.width * 0.01,
                          children: [
                            InputFields.formField1(
                                hintTxt: "Sponsor",
                                controller: controller.sponserName,
                                width: 0.48,
                                autoFocus: true,
                                focusNode: controller.sponserNameFocus),
                            InputFields.formField1(
                              hintTxt: "Short Name",
                              controller: controller.shortName,
                              width: 0.48,
                            ),

                            InputFields.numbers(
                              padLeft: 0,
                              hintTxt: "Premium",
                              controller: controller.premium,
                              width: 0.235,
                              isNegativeReq: false
                            ),
                            Obx(() => DropDownField.formDropDown1WidthMap([
                                  DropDownValue(key: "M", value: "Multiple"),
                                  DropDownValue(key: "S", value: "Single")
                                ], (value) => {
                              controller.selectedSponser.value = value
                            }, "Sponsor Type", 0.235,
                                dialogHeight: 120,
                                    selected:
                                        controller.selectedSponser.value)),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.07,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: GetBuilder<HomeController>(
                              id: "buttons",
                              init: Get.find<HomeController>(),
                              builder: (controller) {
                                PermissionModel formPermissions =
                                Get.find<MainController>()
                                    .permissionList!
                                    .lastWhere((element) =>
                                element.appFormName ==
                                    "frmSponsorTypeMaster");
                                if (controller.buttons != null) {
                                  return Wrap(
                                    spacing: 5,
                                    runSpacing: 15,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      for (var btn in controller.buttons!)
                                        FormButtonWrapper(
                                          btnText: btn["name"],
                                          callback: Utils.btnAccessHandler2(btn['name'],
                                              controller, formPermissions) ==
                                              null
                                              ? null
                                              : () => btnhandler(
                                            btn['name'],
                                          ),
                                        )
                                    ],
                                  );
                                }
                                return Container();
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ])))),
    );
  }

  btnhandler(btnName) {
    switch (btnName) {
      case "Save":
        controller.validateSave();
        break;
      case "Clear":
        Get.delete<SponserTypeMasterController>();
        Get.find<HomeController>().clearPage1();
        break;
      case "Search":
        Get.to(
          const SearchPage(
            key: Key("Sponsor Type Master"),
            screenName: "Sponsor Type Master",
            appBarName: "Sponsor Type Master",
            strViewName: "vTesting",
            isAppBarReq: true,
          ),
        );
        break;
      default:
    }
  }
}
