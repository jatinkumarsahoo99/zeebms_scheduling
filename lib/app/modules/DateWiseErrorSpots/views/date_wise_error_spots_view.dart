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
import '../controllers/date_wise_error_spots_controller.dart';

class DateWiseErrorSpotsView extends StatelessWidget{
   DateWiseErrorSpotsView({Key? key}) : super(key: key);

  DateWiseErrorSpotsController controllerX =
  Get.put<DateWiseErrorSpotsController>(DateWiseErrorSpotsController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * 0.94,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    title: Text('Datewise Error Spots Report'),
                    centerTitle: true,
                    backgroundColor: Colors.deepPurple,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(()=>DropDownField.formDropDown1WidthMap(
                        controllerX.locationList.value??[],
                            (value) {
                          controllerX.selectedLocation = value;
                        }, "Location", .21,
                        isEnable: controllerX.isEnable,
                        selected: controllerX.selectedLocation,
                        dialogHeight: Get.height * .7,
                        autoFocus: true,),)  ,
                      Obx(()=>DropDownField.formDropDown1WidthMap(
                        controllerX.channelList.value??[],
                            (value) {
                          controllerX.selectedChannel = value;
                        }, "Channel", .21,
                        isEnable: controllerX.isEnable,
                        selected: controllerX.selectedChannel,
                        dialogHeight: Get.height * .7,
                        autoFocus: true,),)  ,

                      DateWithThreeTextField(
                        title: "From Date",
                        mainTextController: controllerX.fromDateController,
                        widthRation: .1,
                        isEnable: controllerX.isEnable,
                      ),
                      DateWithThreeTextField(
                        title: "To Date",
                        mainTextController: controllerX.toDateController,
                        widthRation: .1,
                        isEnable: controllerX.isEnable,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 14.0, left: 10, right: 10),
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
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                          child:  GetBuilder<DateWiseErrorSpotsController>(
                            id: "grid",
                            builder: (controllerX) {
                              return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child:
                                  (controllerX.datewiseErrorSpotsModel != null)?
                                  (controllerX.datewiseErrorSpotsModel!.datewiseErrorSpots != null &&
                                      controllerX.datewiseErrorSpotsModel!.datewiseErrorSpots!.isNotEmpty
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
                                      mapData:controllerX.datewiseErrorSpotsModel!.datewiseErrorSpots!.map((e) =>
                                          e.toJson()).toList() ):Container():Container()
                              );
                            }
                        ),

                      ),
                    ),
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
                          element.appFormName == "frmCommercialMaster");
                          if (controller.buttons != null) {
                            return ButtonBar(
                              alignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
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
                  SizedBox(height: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
