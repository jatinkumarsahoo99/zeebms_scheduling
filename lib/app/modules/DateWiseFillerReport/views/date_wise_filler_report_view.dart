import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../controllers/date_wise_filler_report_controller.dart';

class DateWiseFillerReportView extends GetView<DateWiseFillerReportController> {
   DateWiseFillerReportView({Key? key}) : super(key: key);

   DateWiseFillerReportController controllerX =
   Get.put<DateWiseFillerReportController>(DateWiseFillerReportController());

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
                    title: Text('Datewise Filler'),
                    centerTitle: true,
                    backgroundColor: Colors.deepPurple,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropDownField.formDropDown1WidthMap(
                        [],
                            (value) {

                        }, "Location", .24,
                        isEnable: controllerX.isEnable,
                        // selected: controllerX.selectedClientDetails,
                        autoFocus: true,),
                      DropDownField.formDropDown1WidthMap(
                        [],
                            (value) {

                        }, "Channel", .31,
                        isEnable: controllerX.isEnable,
                        // selected: controllerX.selectedClientDetails,
                        autoFocus: true,),
                      DateWithThreeTextField(
                        title: "Date",
                        mainTextController: TextEditingController(),
                        widthRation: .1,
                        isEnable: controllerX.isEnable,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 14.0, left: 10, right: 10),
                        child: FormButtonWrapper(
                          btnText: "Genrate",
                          callback: () {
                            // controller.callGetRetrieve();
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
