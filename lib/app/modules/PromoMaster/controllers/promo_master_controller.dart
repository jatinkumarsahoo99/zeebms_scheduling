import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/cutom_dropdown.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../../FillerMaster/model/filler_annotation_model.dart';

class PromoMasterController extends GetxController {
  /// 0=>location
  /// 1=>channel
  /// 2=>banner
  /// 3=>tapeType
  /// 4=>type
  /// 5=>censhorship
  /// 6=>langauge
  /// 7=>production
  /// 8=>color
  /// 9=>region
  /// 10=>energy
  /// 11=>era
  /// 12=>songgrade
  /// 13=>mood
  /// 14=>tempo
  /// 15=>moviegrade
  /// 16=>source
  /// 17=>ID NO
  /// 18=>event
  /// 19=>channel
  late List<DropDownValue?> selectedDropDowns;
  List<PermissionModel>? formPermissions;
  // FillerMasterOnLoadModel? onloadModel;
  var rightDataTable = <FillerMasterAnnotationModel>[].obs;
  String fillerCode = "";
  var channelList = <DropDownValue>[].obs;
  var txCaptionPreFix = "".obs;
  var segHash = 1.obs;

  var startDateCtr = TextEditingController(),
      endDateCtr = TextEditingController(),
      copyCtr = TextEditingController(),
      tcInCtr = TextEditingController(text: "00:00:00:00"),
      tcOutCtr = TextEditingController(text: "00:00:00:00"),
      blankTapeIDCtr = TextEditingController(),
      captionCtr = TextEditingController(),
      txCaptionCtr = TextEditingController(),
      tapeIDCtr = TextEditingController(),
      segIDCtr = TextEditingController(),
      txNoCtr = TextEditingController(),
      eomCtr = TextEditingController(text: "00:00:00:00"),
      somCtr = TextEditingController(text: "00:00:00:00"),
      durationCtr = TextEditingController(text: "00:00:00:00");

  clearPage() {}

  var locationFN = FocusNode(), eomFN = FocusNode(), fillerNameFN = FocusNode(), segNoFN = FocusNode(), tapeIDFN = FocusNode(), txNoFN = FocusNode();
  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.PROMO_MASTER.replaceAll("/", ""));
    super.onInit();
  }

  formHandler(String btnName) {
    if (btnName == "Clear") {
      clearPage();
    }
  }

  void handleAddTapFromAnnotations() {}

  void handleCopyTap() {}
}
