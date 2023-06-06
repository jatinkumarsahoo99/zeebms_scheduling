import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/CheckBoxWidget.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../controllers/promos_controller.dart';

class PromosView extends GetView<PromosController> {
  PromosView({Key? key}) : super(key: key);

  late PlutoGridStateManager stateManager;
  var formName = 'Scheduling Promo';

  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {}
  //PromosController controller = Get.put(PromosController());
  // FillerController controller = Get.put(FillerController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GetBuilder<PromosController>(
        init: PromosController(),
        id: "initData",
        builder: (controller) {
          return Scaffold(
            body: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          /// Two Table
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Row(
                                      children: [
                                        Obx(
                                          () => DropDownField.formDropDown1WidthMap(
                                            controller.locations.value,
                                            (value) => controller.getChannel(value),
                                            "Location",
                                            0.15,
                                            selected: controller.selectLocation,
                                            isEnable: controller.controllsEnabled.value,
                                            autoFocus: true,
                                            inkWellFocusNode: controller.locationFN,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Obx(
                                          () => DropDownField.formDropDown1WidthMap(
                                            controller.channels.value,
                                            (value) => controller.selectChannel = value,
                                            isEnable: controller.controllsEnabled.value,
                                            "Channel",
                                            0.15,
                                            dialogHeight: Get.height * .7,
                                            selected: controller.selectChannel,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Obx(
                                          () => DateWithThreeTextField(
                                            title: "From Date",
                                            widthRation: .10,
                                            isEnable: controller.controllsEnabled.value,
                                            mainTextController: controller.fromdateTC,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, top: 17.0),
                                          child: FormButton(
                                            btnText: "Show Details",
                                            callback: controller.showDetails,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 17.0),
                                          child: Obx(() {
                                            return FormButton(
                                              btnText: "Import",
                                              isEnabled: controller.left1stDT.value.isNotEmpty,
                                              callback: controller.handleImportTap,
                                            );
                                          }),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, top: 17.0),
                                          child: FormButton(
                                            btnText: "Delete",
                                            callback: controller.handleDelete,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: controller.left1stDT.isEmpty ? BoxDecoration(border: Border.all(color: Colors.grey)) : null,
                                      child: controller.left1stDT.isEmpty ? null : DataGridFromMap(mapData: []),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    child: Container(
                                      decoration: controller.left2ndDT.isEmpty ? BoxDecoration(border: Border.all(color: Colors.grey)) : null,
                                      child: controller.left2ndDT.isEmpty ? null : DataGridFromMap(mapData: []),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Obx(
                                      () {
                                        return Text("Time Band : ${controller.timeBand.value}");
                                      },
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Obx(
                                        () {
                                          return Text("Program : ${controller.programName.value}");
                                        },
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: InputFields.formField1Width(
                                          widthRatio: 0.09,
                                          paddingLeft: 5,
                                          hintTxt: "Available",
                                          controller: controller.availableTC,
                                          maxLen: 10,
                                          isEnable: false,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: InputFields.formField1Width(
                                          widthRatio: 0.09,
                                          paddingLeft: 5,
                                          hintTxt: "Scheduled",
                                          controller: controller.scheduledTC,
                                          maxLen: 10,
                                          isEnable: false,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: InputFields.formField1Width(
                                          widthRatio: 0.09,
                                          paddingLeft: 5,
                                          hintTxt: "Count",
                                          controller: controller.countTC,
                                          maxLen: 10,
                                          isEnable: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// right ui part
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 15, 0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                            widthRatio: .15,
                                            paddingLeft: 5,
                                            hintTxt: "Promo Caption",
                                            controller: controller.promoCaptionTC,
                                            maxLen: 10,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formFieldDisable(
                                            widthRatio: (Get.width * 0.2) / 2 + 7,
                                            hintTxt: "",
                                            value: '00:00:00:00',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio: (Get.width * 0.2) / 2 + 7,
                                              paddingLeft: 5,
                                              hintTxt: "Promo Id",
                                              controller: controller.promoIDTC,
                                              maxLen: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                                        child: Row(children: [
                                          CheckBoxWidget1(
                                            title: "My",
                                            value: controller.myEnabled.value,
                                            onChanged: (val) {
                                              controller.myEnabled.value = val ?? false;
                                            },
                                          ),
                                        ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Search",
                                          callback: controller.handleSearchTap,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Add",
                                          callback: controller.handleAddTap,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Auto Add",
                                          callback: controller.handleAutoAddTap,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: controller.right3rdDT.isEmpty ? BoxDecoration(border: Border.all(color: Colors.grey)) : null,
                                      child: controller.right3rdDT.isEmpty ? null : DataGridFromMap(mapData: []),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GetBuilder<HomeController>(
                        id: "buttons",
                        init: Get.find<HomeController>(),
                        builder: (btcontroller) {
                          if (btcontroller.buttons != null) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: ButtonBar(
                                alignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (var btn in btcontroller.buttons!)
                                    //if (Utils.btnAccessHandler(btn['name'], controller.formPermissions!) != null)
                                    FormButtonWrapper(
                                      btnText: btn["name"],
                                      callback: () => controller.formHandler(
                                        btn['name'],
                                      ),
                                    )
                                ],
                              ),
                            );
                          }
                          return Container();
                        }),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
