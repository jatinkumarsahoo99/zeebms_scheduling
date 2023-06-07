import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/system_envirtoment.dart';
import '../../filler/FillerDailyFPCModel.dart';
import '../../filler/FillerSegmentModel.dart';

class PromosController extends GetxController  {

  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);

  TextEditingController available_ = TextEditingController()..text = "";
  TextEditingController scheduled_ = TextEditingController()..text = "";
  TextEditingController count_ = TextEditingController()..text = "";
  TextEditingController promoCaptionDur_ = TextEditingController()..text = "00:00:00:00";
  TextEditingController promoCaption_ = TextEditingController()..text = "";
  TextEditingController promoId_ = TextEditingController()..text = "";
  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  PlutoGridStateManager? gridStateManager;

  List<PlutoRow> initRows = [];
  List<PlutoColumn> initColumn = [];
  List<PermissionModel>? formPermissions;
  List conflictReport = [];

  List<dynamic> programList = [];
  List<dynamic> policyList = [];
  List<dynamic> captionList = [];

  List<FillerDailyFPCModel>? fillerDailyFpcList = [];
  List<FillerSegmentModel>? fillerSegmentList = [];

  List beams = [];
  int? conflictDays = 4;
  List conflictPrograms = [];
  List<PlutoRow> beamRows = [];
  var selectedChannels = RxList([]);

  Map<String, dynamic> reportBody = {};

  var selectedIndex = RxInt(0);
  late PlutoGridStateManager conflictReportStateManager;
  PlutoGridStateManager? bmsReportStateManager;
  PlutoGridStateManager? locChanStateManager;
  Map? initData;
  TextEditingController refDateContrl = TextEditingController(
      text: DateFormat("dd-MM-yyyy").format(DateTime.now()));

  List<SystemEnviroment>? channelList = [];
  List<SystemEnviroment>? locationList = [];

  TextEditingController programName_ = TextEditingController();
  TextEditingController date_ = TextEditingController();

  DateTime now = DateTime.now();
  DateTime? selectedDate = DateTime.now();
  DateFormat df = DateFormat("dd/MM/yyyy");
  DateFormat df1 = DateFormat("dd-MM-yyyy");
  DateFormat df2 = DateFormat("MM-dd-yyyy");

  SystemEnviroment? selectedChannel;
  SystemEnviroment? selectedLocation;

  /// List for Columns
  // PromoProgramModel
  // ? selectedProgram;
  // PromoModel? selectedPromo;

  /// Radio Button
  int selectedGroup = 0;
  int selectIndex = 0;

  List<Map<String, dynamic>>? listData = [];

  DateTime selectDate = DateTime.now();

  /////////////Pluto Grid////////////
  List redBreaks = [];
  BuildContext? gridContext;
  PlutoGridStateManager? stateManager;

  double widthSize = 0.14;
  var locationEnable = RxBool(true);
  var channelEnable = RxBool(true);

  TextEditingController availableText_ = TextEditingController()..text = "";
  TextEditingController scheduleText_ = TextEditingController()..text = "";
  TextEditingController countText_ = TextEditingController()..text = "";
  TextEditingController promoCaptionText_ = TextEditingController()..text = "";
  TextEditingController promoCaptionDurText_ = TextEditingController()..text = "00:00:00:00";
  TextEditingController promoIDText_ = TextEditingController()..text = "";

  /// Radio Button
  int selectedAfter = 0;

  @override
  void onInit() {
    super.onInit();
  }

  formHandler(btnName) async {
    if (btnName == "Clear") {
      initData = null;
      initRows = [];
      initColumn = [];

      conflictReport = [];

      beams = [];
      conflictDays = 4;
      conflictPrograms = [];
      beamRows = [];
      selectedChannels.value = [];

      Map<String, dynamic> reportBody = {};
      update(["initData"]);
      //getInitData();
    }
  }

  fetchInitial() {
    // Get.find<ConnectorControl>().GETMETHODCALL(
    //   api: ApiFactory.FPC_WEEKLY_INITIAL,
    //   fun: (Map<String, dynamic> map) {
    //     locationList?.clear();
    //     channelList?.clear();
    //     map["lstLocations"].forEach((element) {
    //       locationList?.add(SystemEnviroment(key: element["locationCode"], value: element["locationName"]));
    //     });
    //     map["lstChannels"].forEach((element) {
    //       channelList?.add(SystemEnviroment(key: element["channelcode"], value: element["channelName"]));
    //     });
    //     update(["initialData"]);
    //   },
    // );
  }

  // fetchInitial() {
  //   Get.find<ConnectorControl>().GETMETHODCALL(
  //     api: ApiFactory.FPC_WEEKLY_INITIAL,
  //     fun: (Map<String, dynamic> map) {
  //       locationList?.clear();
  //       channelList?.clear();
  //       map["lstLocations"].forEach((element) {
  //         locationList?.add(SystemEnviroment(key: element["locationCode"], value: element["locationName"]));
  //       });
  //       map["lstChannels"].forEach((element) {
  //         channelList?.add(SystemEnviroment(key: element["channelcode"], value: element["channelName"]));
  //       });
  //       update(["initialData"]);
  //     },
  //   );
  // }

  fetchGenerate() {
    if (selectedLocation == null) {
      Snack.callError("Please select Location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select Channel");
    } else if (selectDate == null) {
      Snack.callError("Please select from date");
    } else {
      selectDate = df1.parse(date_.text);
      listData?.clear();
      LoadingDialog.call();
    }
  }

  void clear() {
    listData?.clear();
    locationEnable.value = true;
    channelEnable.value = true;
  }

  void exit() {
    Get.find<HomeController>().selectChild1.value = null;
    Get.delete<PromosController>();
  }

}
