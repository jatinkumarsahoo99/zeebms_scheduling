import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/CheckBoxWidget.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../controllers/promo_type_master_controller.dart';

class PromoTypeMasterView extends StatelessWidget {
  PromoTypeMasterView({Key? key}) : super(key: key);
  final controller =
      Get.put<PromoTypeMasterController>(PromoTypeMasterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .55,
          child: Dialog(
            backgroundColor: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: const Text('Promo Type Master'),
                  centerTitle: true,
                  backgroundColor: Colors.deepPurple,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return DropDownField.formDropDown1WidthMap(
                        controller.promoCategories.value,
                        (val) {
                          controller.selectedCategory = val;
                        },
                        'Promo Category Name',
                        .2,
                        autoFocus: true,
                        inkWellFocusNode: controller.categoryFN,
                      );
                    }),
                    const SizedBox(width: 15),
                    InputFields.formField1(
                      hintTxt: "Promo Type Name",
                      controller: controller.promTypeNameCtrl,
                      focusNode: controller.promoFocusNode,
                      width: 0.2,
                      capital: true,
                      inputformatters: [UpperCaseTextFormatter()],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                InputFields.formField1(
                  hintTxt: "SAP Category",
                  controller: controller.sapCategory,
                  width: 0.41,
                  maxLen: 10,
                  inputformatters: [UpperCaseTextFormatter()],
                  capital: true,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return CheckBoxWidget1(
                        title: "Is Active",
                        value: controller.isActive.value,
                        onChanged: (val) {
                          controller.isActive.value = val ?? false;
                        },
                      );
                    }),
                    Obx(() {
                      return CheckBoxWidget1(
                        title: "Trai Promo",
                        value: controller.trailPromo.value,
                        onChanged: (val) {
                          controller.trailPromo.value = val ?? false;
                        },
                      );
                    }),
                    Obx(() {
                      return CheckBoxWidget1(
                        title: "Channel Specfic",
                        value: controller.channelSpec.value,
                        onChanged: (val) {
                          controller.channelSpec.value = val ?? false;
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                /*GetBuilder<HomeController>(
                  id: "buttons",
                  init: Get.find<HomeController>(),
                  builder: (btncontroller) {
                    return Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        for (var btn in btncontroller.buttons!)...{
                          FormButtonWrapper(
                            btnText: btn["name"],
                            callback: () => controller.btnHandler(btn["name"]),
                          ),
                        }
                      ],
                    );
                  },
                ),*/
                Align(
                  alignment: Alignment.topCenter,
                  child: GetBuilder<HomeController>(
                      id: "buttons",
                      init: Get.find<HomeController>(),
                      builder: (controll) {
                        PermissionModel formPermissions =
                            Get.find<MainController>()
                                .permissionList!
                                .lastWhere((element) =>
                                    element.appFormName ==
                                    "frmPromoTypeMaster");
                        formPermissions.delete = false;
                        if (controll.buttons != null) {
                          return Wrap(
                            spacing: 5,
                            runSpacing: 15,
                            alignment: WrapAlignment.center,
                            children: [
                              for (var btn in controll.buttons!)
                                FormButtonWrapper(
                                  btnText: btn["name"],
                                  callback: Utils.btnAccessHandler2(btn['name'],
                                              controll, formPermissions) ==
                                          null
                                      ? null
                                      : () =>
                                          controller.btnHandler(btn["name"]),
                                )
                            ],
                          );
                        }
                        return Container();
                      }),
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
