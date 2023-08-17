import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/app/modules/promos/promo_model.dart';
import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:bms_scheduling/app/routes/app_pages.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../widgets/CheckBoxWidget.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../CommonSearch/views/common_search_view.dart';
import '../controllers/promos_controller.dart';

class SchedulePromoView extends StatelessWidget {
  SchedulePromoView({Key? key}) : super(key: key);

  late PlutoGridStateManager stateManager;
  var formName = 'Scheduling Promo';
  final controller = Get.put<SchedulePromoController>(SchedulePromoController());

  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {}
  //PromosController controller = Get.put(PromosController());
  // FillerController controller = Get.put(FillerController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GetBuilder<SchedulePromoController>(
        init: controller,
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
                                            callback: () {
                                              if (controller.selectLocation != null && controller.selectChannel != null) {
                                                controller.showDetails();
                                              } else {
                                                LoadingDialog.showErrorDialog("");
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 17.0),
                                          child: Obx(() {
                                            return FormButton(
                                              btnText: "Import",
                                              isEnabled: controller.dailyFpc.value.isNotEmpty,
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
                                    child: Obx(() {
                                      return Container(
                                        decoration: controller.dailyFpc.value.isEmpty ? BoxDecoration(border: Border.all(color: Colors.grey)) : null,
                                        child: controller.dailyFpc.value.isEmpty
                                            ? null
                                            : DataGridShowOnlyKeys(
                                                mapData: controller.dailyFpc.value.map((e) => e.toJson()).toList(),
                                                onRowDoubleTap: (row) => controller.handleDoubleTapInLeft1stTable(row.rowIdx, row.cell.column.field),
                                                onload: (event) {
                                                  controller.fpcStateManager = event.stateManager;
                                                  event.stateManager.setSelectingMode(PlutoGridSelectingMode.cell);
                                                  event.stateManager.setSelecting(true);
                                                  if (controller.fpcSelectedCol.isNotEmpty) {
                                                    event.stateManager.setCurrentCell(
                                                        event.stateManager.getRowByIdx(controller.fpcSelectedIdx)?.cells[controller.fpcSelectedCol],
                                                        controller.fpcSelectedIdx);
                                                  }
                                                },
                                                mode: PlutoGridMode.selectWithOneTap,
                                                colorCallback: (row) => controller.dailyFpc[row.rowIdx].exceed ? Colors.red : Colors.white,
                                                onSelected: (row) => {
                                                  controller.fpcSelectedIdx = row.rowIdx ?? 0,
                                                  controller.fpcSelectedCol = row.cell?.column.field ?? ""
                                                },
                                              ),
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    child: Obx(() {
                                      return Container(
                                        decoration:
                                            controller.promoScheduled.value.isEmpty ? BoxDecoration(border: Border.all(color: Colors.grey)) : null,
                                        child: controller.promoScheduled.value.isEmpty
                                            ? null
                                            : DataGridShowOnlyKeys(
                                                mapData: controller.promoScheduled.value.map((e) => e.toJson()).toList(),
                                                mode: PlutoGridMode.selectWithOneTap,
                                                colorCallback: (row) =>
                                                    (row.row.cells.containsValue(controller.scheduledPromoStateManager?.currentCell))
                                                        ? Colors.deepPurple.shade200
                                                        : Colors.white,
                                                onload: (event) {
                                                  controller.scheduledPromoStateManager = event.stateManager;
                                                  controller.scheduledPromoStateManager!.gridFocusNode.onKeyEvent = (node, event) {
                                                    print("Key Pressed");
                                                    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.delete) {
                                                      print("Delete Pressed");
                                                      if (controller.scheduledPromoStateManager?.currentCell != null) {
                                                        PromoScheduled promo =
                                                            controller.promoScheduled[controller.scheduledPromoStateManager!.currentRowIdx!];
                                                        controller.promoData?.promoScheduled?.removeWhere((element) =>
                                                            element.programCode == promo.programCode &&
                                                            element.telecastTime?.toLowerCase() == promo.telecastTime?.toLowerCase() &&
                                                            element.rowNo == promo.rowNo);
                                                        controller.promoScheduled.removeAt(controller.scheduledPromoStateManager!.currentRowIdx!);
                                                      }
                                                    }
                                                    return KeyEventResult.skipRemainingHandlers;
                                                  };
                                                  event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                                                  event.stateManager.setSelecting(true);
                                                  event.stateManager.setCurrentCell(
                                                      event.stateManager.getRowByIdx(controller.schedulePromoSelectedIdx)?.cells['promoPolicyName'],
                                                      controller.schedulePromoSelectedIdx);
                                                  // event.stateManager.moveCurrentCell(PlutoMoveDirection.down, force: true, notify: true);
                                                  event.stateManager.moveCurrentCellByRowIdx(
                                                      controller.schedulePromoSelectedIdx, PlutoMoveDirection.down,
                                                      notify: true);
                                                },
                                                onSelected: (row) => controller.schedulePromoSelectedIdx = row.rowIdx ?? 0,
                                              ),
                                      );
                                    }),
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
                                          disabledTextColor: Colors.black,
                                          controller: controller.availableTC,
                                          maxLen: 10,
                                          isEnable: false,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: InputFields.formField1Width(
                                          widthRatio: 0.09,
                                          disabledTextColor: Colors.black,
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
                                          disabledTextColor: Colors.black,
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
                                          child: Obx(() {
                                            return InputFields.formFieldDisable(
                                              widthRatio: (Get.width * 0.2) / 2 + 7,
                                              hintTxt: "",
                                              value: controller.rightCount.value,
                                            );
                                          }),
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
                                            maxLen: 10,
                                          ),
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
                                          callback: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Obx(() {
                                      return Container(
                                        decoration:
                                            controller.searchPromos.value.isEmpty ? BoxDecoration(border: Border.all(color: Colors.grey)) : null,
                                        child: controller.searchPromos.value.isEmpty
                                            ? null
                                            : DataGridShowOnlyKeys(
                                                mapData: controller.searchPromos.value,
                                                onRowDoubleTap: (row) => controller.handleDoubleTapInRightTable(row.rowIdx, row.cell.column.field),
                                                onload: (event) {
                                                  controller.searchedPromoStateManager = event.stateManager;
                                                  event.stateManager.setSelectingMode(PlutoGridSelectingMode.cell);
                                                  event.stateManager.setSelecting(true);
                                                  if (controller.searchPromoSelectedCol.isNotEmpty) {
                                                    controller.searchedPromoStateManager?.setCurrentCell(
                                                        controller.searchedPromoStateManager
                                                            ?.getRowByIdx(controller.searchPromoSelectedIdx)
                                                            ?.cells[controller.schedulePromoSelectedCol],
                                                        controller.searchPromoSelectedIdx);
                                                  }
                                                },
                                                colorCallback: (row) =>
                                                    (row.row.cells.containsValue(controller.searchedPromoStateManager?.currentCell))
                                                        ? Colors.deepPurple.shade200
                                                        : Colors.white,
                                                mode: PlutoGridMode.selectWithOneTap,
                                                onSelected: (row) =>
                                                    controller.handleOnSelectRightTable(row.rowIdx ?? 0, row.cell?.column.field ?? "caption"),
                                              ),
                                      );
                                    }),
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
                          PermissionModel formPermissions = Get.find<MainController>().permissionList!.lastWhere((element) {
                            return element.appFormName == Routes.SCHEDULE_PROMO.replaceAll("/", "");
                          });
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
                                      callback: Utils.btnAccessHandler2(btn['name'], btcontroller, formPermissions) == null
                                          ? null
                                          : () => formHandler(
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

  formHandler(btnName) async {
    if (btnName == "Clear") {
      Get.delete<SchedulePromoController>();
      Get.find<HomeController>().clearPage1();
    } else if (btnName == "Save") {
      controller.saveData();
    } else if (btnName == "Search") {
      Get.to(SearchPage(
          key: Key("Promo Scheduling"),
          screenName: "Promo Scheduling",
          appBarName: "Promo Scheduling",
          strViewName: "Bms_view_promoscheduling",
          isAppBarReq: true));
    }
  }
}
