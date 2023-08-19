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
import '../../../providers/Utils.dart';
import '../controllers/date_wise_filler_report_controller.dart';

class DateWiseFillerReportView extends StatelessWidget {
   DateWiseFillerReportView({Key? key}) : super(key: key);

   DateWiseFillerReportController controllerX =
   Get.put<DateWiseFillerReportController>(DateWiseFillerReportController());

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
                Obx(()=>DropDownField.formDropDown1WidthMap(
                 controllerX.locationList.value??[],
                      (value) {
                        controllerX.selectedLocation = value;
                  }, "Location", .17,
                  isEnable: controllerX.isEnable,
                  selected: controllerX.selectedLocation,
                  dialogHeight: Get.height * .4,
                  autoFocus: true,),)  ,
                  SizedBox(
                    width: 8,
                  ),
                  Obx(()=>DropDownField.formDropDown1WidthMap(
                    controllerX.channelList.value??[],
                        (value) {
                      controllerX.selectedChannel = value;
                    }, "Channel", .17,
                    isEnable: controllerX.isEnable,
                    selected: controllerX.selectedChannel,
                    dialogHeight: Get.height * .4,
                    autoFocus: true,),)  ,
                  SizedBox(
                    width: 8,
                  ),
                  DateWithThreeTextField(
                    title: "Date",
                    mainTextController: controllerX.dateController,
                    widthRation: .1,
                    isEnable: controllerX.isEnable,
                    // intailDate: DateTime.now(),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 10, right: 10),
                    child: FormButtonWrapper(
                      btnText: "Genrate",
                      callback: () {
                        controllerX.callGetRetrieve();
                      },
                      showIcon: true,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                flex: 9,
                child: GetBuilder<DateWiseFillerReportController>(
                  id: "grid",
                  builder: (controllerX) {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey)),
                      child:
                      (controllerX.dateWiseFillerModel != null)?
                      (controllerX.dateWiseFillerModel!.datewiseErrorSpots != null &&
                          controllerX.dateWiseFillerModel!.datewiseErrorSpots!.isNotEmpty
                      )?
                      DataGridFromMap(
                            hideCode: false,
                            formatDate: false,
                            focusNode: controllerX.gridFocus,
                            // checkRow: true,
                            // checkRowKey: "no",
                            mode: PlutoGridMode.selectWithOneTap,
                            onSelected: (PlutoGridOnSelectedEvent? val ){

                            },

                            onload: (PlutoGridOnLoadedEvent load) {

                            },
                            // colorCallback: (renderC) => Colors.red[200]!,
                            mapData:controllerX.dateWiseFillerModel!.datewiseErrorSpots!.map((e) =>
                                e.toJson()).toList() ):Container():Container()
                    );
                  }
                ),
              ),
              SizedBox(
                height: 8,
              ),
              /// bottom common buttons
              Align(
                alignment: Alignment.topLeft,
                child: GetBuilder<HomeController>(
                    id: "buttons",
                    init: Get.find<HomeController>(),
                    builder: (controller) {
                      PermissionModel formPermissions = Get.find<MainController>()
                          .permissionList!
                          .lastWhere((element) =>
                      element.appFormName == "frmDatewiseFillerReport");
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
