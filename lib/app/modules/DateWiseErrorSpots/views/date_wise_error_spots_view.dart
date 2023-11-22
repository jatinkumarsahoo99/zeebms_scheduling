import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/Utils.dart';
import '../controllers/date_wise_error_spots_controller.dart';

class DateWiseErrorSpotsView extends StatelessWidget {
  DateWiseErrorSpotsView({Key? key}) : super(key: key);

  DateWiseErrorSpotsController controllerX =
      Get.put<DateWiseErrorSpotsController>(DateWiseErrorSpotsController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                        controllerX.locationList.value ?? [], (value) {
                      controllerX.selectedLocation = value;
                    }, "Location", .17,
                        isEnable: controllerX.isEnable,
                        selected: controllerX.selectedLocation,
                        dialogHeight: Get.height * .4,
                        autoFocus: true,
                        inkWellFocusNode: controllerX.locationFocus),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                        controllerX.channelList.value ?? [], (value) {
                      controllerX.selectedChannel = value;
                    }, "Channel", .17,
                        isEnable: controllerX.isEnable,
                        selected: controllerX.selectedChannel,
                        dialogHeight: Get.height * .4,
                        autoFocus: false,
                        inkWellFocusNode: controllerX.channelFocus),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  DateWithThreeTextField(
                    title: "From Date",
                    mainTextController: controllerX.fromDateController,
                    widthRation: .1,
                    isEnable: controllerX.isEnable,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  DateWithThreeTextField(
                    title: "To Date",
                    mainTextController: controllerX.toDateController,
                    widthRation: .1,
                    isEnable: controllerX.isEnable,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                    child: FormButtonWrapper(
                      btnText: "Genrate",
                      callback: () {
                        controllerX.callGetRetrieve();
                      },
                      showIcon: false,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                flex: 9,
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: GetBuilder<DateWiseErrorSpotsController>(
                      id: "grid",
                      builder: (controllerX) {
                        return Container(
                            child: (controllerX.datewiseErrorSpotsModel != null)
                                ? (controllerX.datewiseErrorSpotsModel!
                                                .datewiseErrorSpots !=
                                            null &&
                                        controllerX.datewiseErrorSpotsModel!
                                            .datewiseErrorSpots!.isNotEmpty)
                                    ? DataGridFromMap(
                                        hideCode: false,
                                        formatDate: false,
                                        exportFileName:
                                            "Datewise Error Spots Report",
                                        csvFormat: true,
                                        focusNode: controllerX.gridFocus,
                                        // checkRow: true,
                                        // checkRowKey: "no",
                                        mode: PlutoGridMode.selectWithOneTap,
                                        colorCallback: (row) =>
                                            (row.row.cells.containsValue(controllerX.gridStateManager?.currentCell))
                                                ? Colors.deepPurple.shade200
                                                : Colors.white,
                                        onSelected:
                                            (PlutoGridOnSelectedEvent? val) {},
                                        onload: (PlutoGridOnLoadedEvent load) {
                                          controllerX.gridStateManager =
                                              load.stateManager;
                                        },
                                        witdthSpecificColumn: (controllerX
                                            .userDataSettings?.userSetting
                                            ?.firstWhere((element) => element.controlName == "gridStateManager",
                                                orElse: () => UserSetting())
                                            .userSettings),
                                        // colorCallback: (renderC) => Colors.red[200]!,
                                        mapData: controllerX
                                            .datewiseErrorSpotsModel!
                                            .datewiseErrorSpots!
                                            .map((e) => e.toJson())
                                            .toList())
                                    : Container()
                                : Container());
                      }),
                ),
              ),
              SizedBox(height: 8),

              /// bottom common buttons
              Align(
                alignment: Alignment.topLeft,
                child: GetBuilder<HomeController>(
                    id: "buttons",
                    init: Get.find<HomeController>(),
                    builder: (controller) {
                      PermissionModel formPermissions =
                          Get.find<MainController>().permissionList!.lastWhere(
                              (element) =>
                                  element.appFormName ==
                                  "frmDateWiseErrorReport");
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
                                    : () => controllerX.formHandler(
                                          btn['name'],
                                        ),
                              )
                          ],
                        );
                      }
                      return Container();
                    }),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
