import 'package:get/get.dart';

import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';

class PromoMasterController extends GetxController {
  List<PermissionModel>? formPermissions;
  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.PROMO_MASTER.replaceAll("/", ""));
    super.onInit();
  }

  formHandler(String string) {}
}
