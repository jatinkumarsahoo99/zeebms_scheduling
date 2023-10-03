import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

// import 'package:bms_programming/app/providers/ApiFactory.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../data/DrawerModel.dart';
import '../data/user_data_settings_model.dart';
import '../providers/Aes.dart';
import '../providers/ApiFactory.dart';
import '../routes/app_pages.dart';
import 'ConnectorControl.dart';
import 'MainController.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  SubChild? selectChild;
  var selectChild1 = Rxn<SubChild>();
  List? buttons;
  List? tranmissionButtons;
  List? asurunImportButtoons;

  bool isMoviePlannerPopupShown = false;

  @override
  void onInit() {
    getbuttondata();
    getTransmissionLog();
    super.onInit();
  }

  getbuttondata() async {
    String value = await rootBundle.loadString('assets/json/buttons.json');
    buttons = json.decode(value);
    update(["buttons"]);
  }

  getTransmissionLog() async {
    String value =
        await rootBundle.loadString('assets/json/transmission_buttons.json');
    tranmissionButtons = json.decode(value)["transmissionLog"];
    asurunImportButtoons = json.decode(value)["assrunImport"];
    update(["transButtons"]);
  }

  clearPage1() {
    try {
      print(html.window.location.href);
      String extractName = (html.window.location.href.split("?")[0])
          .split(ApiFactory.SPLIT_CLEAR_PAGE)[1];
      print("Extract name>>>>" + extractName);
      var uri = Uri.dataFromString(
          html.window.location.href); //converts string to a uri
      Map<String, String> params = uri.queryParameters;
      print("Params are>>>>" + params.toString());
      if (RoutesList.listRoutes.contains("/" + extractName)) {
        if (extractName == "frmDailyFPC") {
          html.window.location.reload();
        } else {
          String personalNo =
              Aes.encrypt(Get.find<MainController>().user?.personnelNo ?? "") ??
                  "";
          String loginCode =
              (Aes.encrypt(Get.find<MainController>().user?.logincode ?? "") ??
                  "");
          String formName =
              (Aes.encrypt(Get.find<MainController>().formName) ?? "");
          Get.offAndToNamed("/" + extractName, parameters: {
            "loginCode": loginCode,
            "personalNo": personalNo,
            "formName": formName
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void postUserGridSetting(
      {required List<PlutoGridStateManager?>? listStateManager,
      List<String>? tableNamesList}) {
    if (listStateManager == null || listStateManager.isEmpty) return;
    if (tableNamesList != null &&
        (tableNamesList.length != listStateManager.length)) return;
    List data = [];
    for (int i = 0; i < listStateManager.length; i++) {
      Map<String, dynamic> singleMap = {};
      listStateManager[i]?.columns.forEach((element) {
        singleMap[element.field] = element.width;
      });
      String? mapData = jsonEncode(singleMap);
      data.add({
        "formName":
            Get.find<MainController>().formName.replaceAll(" ", "") ?? "",
        "controlName":
            tableNamesList == null ? "${i + 1}_table" : tableNamesList?[i],
        "userSettings": mapData
      });
    }
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.USER_SETTINGS,
        json: {"lstUserSettings": data},
        fun: (map) {});
  }

  Future<List<Map<String, Map<String, double>>>>? fetchUserSetting() {
    Completer<List<Map<String, Map<String, double>>>> completer =
        Completer<List<Map<String, Map<String, double>>>>();
    // List<Map<String, double>> data=[];
    List<Map<String, Map<String, double>>> data = [];
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.FETCH_USER_SETTING +
            "?formName=${Get.find<MainController>().formName.replaceAll(" ", "")}",
        fun: (map) {
          print("Data is>>" + jsonEncode(map));
          if (map is Map &&
              map.containsKey("userSetting") &&
              map["userSetting"] != null) {
            map["userSetting"].forEach((e) {
              Map<String, Map<String, double>> userGridSettingMain = {};
              Map<String, double> userGridSetting = {};
              jsonDecode(e["userSettings"]).forEach((key, value) {
                print("Data key is>>" +
                    key.toString() +
                    " value is>>>" +
                    value.toString());
                userGridSetting[key] = value;
              });
              userGridSettingMain[e["controlName"] ?? ""] = userGridSetting;
              // data.add(userGridSetting);
              data.add(userGridSettingMain);
            });
            completer.complete(data);
            // return data;
          } else {
            completer.complete(null);
            // return null;
          }
        });
    return completer.future;
  }

  void postUserGridSetting2(
      {required List<Map<String, PlutoGridStateManager?>> listStateManager,
      String? formName}) {
    if (listStateManager.isEmpty) return;
    var data = <Map<String, dynamic>>[];

    for (var element in listStateManager) {
      element.forEach(
        (key, value) {
          if (value != null) {
            Map<String, double> singleMap = {};
            for (var element in value.columns) {
              singleMap[element.field] = element.width;
            }
            data.add(
              UserSetting(
                formName: (formName?.replaceAll(' ', '')) ??
                    Get.find<MainController>().formName.replaceAll(" ", ""),
                controlName: key,
                userSettings: singleMap,
              ).toJson(),
            );
          }
        },
      );
    }
    if (data.isEmpty) return;
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.USER_SETTINGS,
      json: {"lstUserSettings": data},
      fun: (map) {},
    );
  }

  Future<UserDataSettings> fetchUserSetting2({String? formName}) {
    Completer<UserDataSettings> completer = Completer();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api:
          "${ApiFactory.FETCH_USER_SETTING}?formName=${(formName?.replaceAll(" ", "")) ?? Get.find<MainController>().formName.replaceAll(" ", "")}",
      fun: (map) {
        var userSettings = UserDataSettings.fromJson(map);
        return completer.complete(userSettings);
      },
    );
    return completer.future;
  }
}
