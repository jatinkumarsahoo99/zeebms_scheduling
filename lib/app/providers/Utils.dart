import 'dart:convert';
import 'dart:developer';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';

// import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/TableTextStyle.dart';
import '../controller/HomeController.dart';
import '../controller/MainController.dart';
import '../data/PermissionModel.dart';
import "dart:js" as js;
import "dart:html" as html;

class Utils {
  static String twoDigits(int n) => n.toString().padLeft(2, "0");

  static String twoDigitsString(String n) => n.padLeft(2, "0");

  static toDateFormat(String? date, {bool? isStringRequired}) {
    final DateTime formatter =
        DateFormat("yyyy-MM-dd\'T\'HH:mm:ss").parse(date!);
    // log(">>>>>>"+formatter.toString());
    return (isStringRequired != null && isStringRequired)
        ? formatter.toString()
        : formatter;
  }

  static bool copyToClipboardHack(String text) {
    final textarea = html.TextAreaElement();
    html.document.body?.append(textarea);
    textarea.style.border = '0';
    textarea.style.margin = '0';
    textarea.style.padding = '0';
    textarea.style.opacity = '0';
    textarea.style.position = 'absolute';
    textarea.readOnly = true;
    textarea.value = text;
    textarea.select();
    final result = html.document.execCommand('copy');
    textarea.remove();
    return result;
  }
  static Future<String> pasteFromClipboardHack() async {
    // Request access to the clipboard
    try {
      // Request access to the clipboard
      final clipboardText = await html.window.navigator.clipboard?.readText();
      return clipboardText??"";
    } catch (error) {
      // Handle any errors, such as clipboard permissions denied
      print('Error reading clipboard: $error');
      return ''; // Return an empty string or null if you prefer
    }
  }

  static String getMMDDYYYYFromDDMMYYYYInString(String ddMMYYYY) {
    return DateFormat("MM/dd/yyyy")
        .format(DateFormat('dd-MM-yyyy').parse(ddMMYYYY));
  }

  static toDateFormat1(String date, {bool? isStringRequired}) {
    final DateTime formatter =
        DateFormat("yyyy-MM-dd\'T\'HH:mm:ss.SSS").parse(date);
    // log(">>>>>>"+formatter.toString());
    return (isStringRequired != null && isStringRequired)
        ? formatter.toString()
        : formatter;
  }

  static toDateFormat3(DateTime? date) {
    final String formatter =
        DateFormat("dd-MMM-yyyy").format(date ?? DateTime.now());
    // log(">>>>>>"+formatter.toString());
    return formatter;
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s) != null;
  }

  static int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  static DateTime dateJoin(DateTime date, TimeOfDay time) {
    return new DateTime(
        date.year, date.month, date.day, time.hour, time.minute);
  }

  static List<T> modelBuilder<M, T>(
          List<M> models, T Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();

  static String getDuration({required int minute}) {
    if (minute == null || minute == 0) return "00:00:00:00";
    log(">>getDuration>>" + minute.toString());
    Duration duration = Duration(minutes: minute);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    String val =
        "${twoDigits(duration.inDays)}:${twoDigits(duration.inHours.remainder(24))}:$twoDigitMinutes:$twoDigitSeconds";
    log(":Result>>>>>" + val);
    return val;
  }

  static String getDurationSecond({required int second}) {
    if (second == null || second == 0) return "00:00:00:00";
    log(">>getDuration>>" + second.toString());

    Duration duration = Duration(seconds: second);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitFrame = twoDigits(duration.inSeconds.remainder(25));
    String val;
    if (second < 1200000) {
      val =
          "${twoDigits(duration.inHours.remainder(24))}:$twoDigitMinutes:$twoDigitSeconds:$twoDigitFrame";
    } else {
      val =
          "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds:$twoDigitFrame";
    }
    log(":Result>>>>>" + val);
    return val;
  }

  static String getDurationSecondThreeDigit({required int second}) {
    if (second == null || second == 0) return "00:00:00";
    log(">>getDuration>>" + second.toString());

    Duration duration = Duration(seconds: second);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    // String twoDigitFrame = twoDigits(duration.inSeconds.remainder(25));
    String val;
    if (second < 1200000) {
      val =
          "${twoDigits(duration.inHours.remainder(24))}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      val = "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    }
    log(":Result>>>>>" + val);
    return val;
  }

  static String getDuration1({required int minute}) {
    log(">>getDuration>>" + minute.toString());
    Duration duration = Duration(minutes: minute);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitFrame = twoDigits(duration.inSeconds.remainder(24));

    String val =
        "${twoDigits(duration.inHours.remainder(24))}:$twoDigitMinutes:$twoDigitSeconds:$twoDigitFrame";
    log(":Result>>>>>" + val);
    return val;
  }

  static List<DateTime> getDiffDates(
      {required DateTime startDt, required DateTime endDt}) {
    int daysToGenerate = endDt.difference(startDt).inDays;
    if (daysToGenerate == 0) {
      daysToGenerate = 1;
    } else {
      daysToGenerate = daysToGenerate + 2;
    }
    print("Days count>>>" + daysToGenerate.toString());
    List<DateTime> days =
        List.generate(daysToGenerate, (i) => startDt.add(Duration(days: i)));
    return days;
  }

  //
  // static getTimeToInt(String value) {
  //   return int.tryParse(value.replaceAll(":", ""));
  // }
  //
  // static convertToDotted(String value) {
  //   switch (value.length) {
  //     case 1:
  //       return "00:00:00:0$value";
  //     case 2:
  //       return "00:00:00:$value";
  //     case 3:
  //       return "00:00:0${value[0]}:${value[1] + value[2]}";
  //     case 4:
  //       return "00:00:${value[0] + value[1]}:${value[2] + value[3]}";
  //     case 5:
  //       return "00:0${value[0]}:${value[1] + value[2]}:${value[3] + value[4]}";
  //     case 6:
  //       return "00:${value[0] + value[1]}:${value[2] + value[3]}:${value[4] + value[5]}";
  //     case 7:
  //       return "0${value[0]}:${value[1] + value[2]}:${value[3] + value[4]}:${value[5] + value[6]}";
  //     case 8:
  //       return "${value[0] + value[1]}:${value[2] + value[3]}:${value[4] + value[5]}:${value[6] + value[7]}";
  //     default:
  //       return "00:00:00:00";
  //   }
  // }

  // static String getDuration1({required int minute}) {
  //   log(">>getDuration>>" + minute.toString());
  //   Duration duration = Duration(minutes: minute);
  //   String twoDigits(int n) => n.toString().padLeft(2, "0");
  //   String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  //   String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  //   String twoDigitFrame = twoDigits(duration.inSeconds.remainder(24));
  //
  //   String val =
  //       "${twoDigits(duration.inHours.remainder(24))}:$twoDigitMinutes:$twoDigitSeconds:$twoDigitFrame";
  //   log(":Result>>>>>" + val);
  //   return val;
  // }

  static getTimeToInt(String value) {
    return int.tryParse(value.replaceAll(":", ""));
  }

  static convertToDotted(String value) {
    switch (value.length) {
      case 1:
        return "00:00:00:0$value";
      case 2:
        return "00:00:00:$value";
      case 3:
        return "00:00:0${value[0]}:${value[1] + value[2]}";
      case 4:
        return "00:00:${value[0] + value[1]}:${value[2] + value[3]}";
      case 5:
        return "00:0${value[0]}:${value[1] + value[2]}:${value[3] + value[4]}";
      case 6:
        return "00:${value[0] + value[1]}:${value[2] + value[3]}:${value[4] + value[5]}";
      case 7:
        return "0${value[0]}:${value[1] + value[2]}:${value[3] + value[4]}:${value[5] + value[6]}";
      case 8:
        return "${value[0] + value[1]}:${value[2] + value[3]}:${value[4] + value[5]}:${value[6] + value[7]}";
      default:
        return "00:00:00:00";
    }
  }

  static int convertToSecond({required String value}) {
    if (value.contains(":")) {
      List<String> list = value.split(":");
      if (list.length == 4) {
        try {
          Duration duration = Duration(
              hours: int.tryParse(list[0])!,
              minutes: int.tryParse(list[1])!,
              seconds: int.tryParse(list[2])! +
                  (((int.tryParse(list[3])!) == 0)
                      ? 0
                      : ((int.tryParse(list[3])! / 24).round())));
          return duration.inSeconds;
        } catch (e) {
          return 0;
        }
      } else if (list.length == 3) {
        try {
          Duration duration = Duration(
              hours: int.tryParse(list[0])!,
              minutes: int.tryParse(list[1])!,
              seconds: int.tryParse(list[2])!);
          return duration.inSeconds;
        } catch (e) {
          return 0;
        }
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  static int convertToMinute({required String value}) {
    if (value.contains(":")) {
      List<String> list = value.split(":");
      if (list.length == 4) {
        try {
          Duration duration = Duration(
              hours: int.tryParse(list[0])!,
              minutes: int.tryParse(list[1])!,
              seconds: int.tryParse(list[2])! +
                  (((int.tryParse(list[3])!) == 0)
                      ? 0
                      : ((int.tryParse(list[3])! / 24).round())));
          return duration.inMinutes;
        } catch (e) {
          return 0;
        }
      } else if (list.length == 3) {
        try {
          Duration duration = Duration(
              hours: int.tryParse(list[0])!,
              minutes: int.tryParse(list[1])!,
              seconds: int.tryParse(list[2])!);
          return duration.inMinutes;
        } catch (e) {
          return 0;
        }
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  static captionName(String programName, int i, int seg) {
    return ((programName.length > 5)
        ? programName.substring(0, 5)
        : programName.substring(0, programName.length) +
            (" # S" + (i.toString() + ("/" + seg.toString()))));
  }

  static removeLastChar(String data, int howManyDigit) {
    data = data.substring(0, data.length - howManyDigit);
    return data;
  }

  static int getMinutesDiff(TimeOfDay tod1, TimeOfDay tod2) {
    return (tod1.hour * 60 + tod1.minute) - (tod2.hour * 60 + tod2.minute);
  }

  static Color getColorCode(String color) {
    if (color == null) {
      return Colors.white;
    }
    switch (color.toLowerCase()) {
      case "red":
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  static String dateFormatChange(
      String date, String existFormat, String reqFormat) {
    if (date != "") {
      //try {
      DateTime currentFormat = DateFormat(existFormat).parse(date);
      return DateFormat(reqFormat).format(currentFormat);
      /*} catch (e) {
        return date;
      }*/
    } else {
      return "";
    }
  }

  static Color? convertStringARGBToColor(String? colorString) {
    if (colorString == null) {
      return null;
    }
    List<String> listRgb = colorString.split(",");
    return Color.fromRGBO(int.tryParse(listRgb[0])!, int.tryParse(listRgb[1])!,
        int.tryParse(listRgb[2])!, 1);
  }

  static timeCallback(controller, context) async {
    String time = '';
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      //midnight validation

      DateTime date = DateTime.now();
      String second = date.second.toString().padLeft(2, '0');
      List timeSplit = pickedTime.format(context).split(' ');
      String formattedTime = timeSplit[0];
      time = '$formattedTime:$second';
      String type = '';
      if (timeSplit.length > 1) {
        type = timeSplit[1];
        time = '$time';
      }
      print(time); //output 7:10:00 PM
    } else {
      print("Time is not selected");
    }
    return time;
  }

  // static launchURL(String url) async {
  //   if (await canLaunchUrlString(url)) {
  //     await launchUrlString(url,mode: LaunchMode.inAppWebView);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // static List<DataColumn2> getColumns(List<String> columns) => columns
  //     .map((String column) => DataColumn2(
  //           size: ColumnSize.S,
  //           label: Center(
  //             child: TableTextStyle(title: column),
  //           ),
  //         ))
  //     .toList();

  static checkPermission() {
    if (Get.find<HomeController>().selectChild != null) {
      print("Resposss>>>" +
          jsonEncode(Get.find<HomeController>().selectChild?.toJson()));
      PermissionModel? permissionModel = Get.find<MainController>()
          .permissionList
          ?.lastWhere((element) =>
              element.appFormName ==
              Get.find<HomeController>().selectChild?.key);
      return permissionModel;
    } else {
      return null;
    }
  }

  static double getColumnSize(
      {required String key, dynamic value, double? widthRatio = 120}) {
    value ??= "";
    // print(key);
    try {
      if (key == "no" || key == "Sr No") {
        return 50;
      } else if (key.toLowerCase().contains("locationname")) {
        return 80;
      } else if (key.toLowerCase().contains("segment") ||
          key.toLowerCase().contains("client")) {
        return 220;
      } else if (key.toLowerCase().contains("name") ||
          key.toLowerCase().contains("program")) {
        return 280;
      } else if (value is num ||
          (value is String && num.tryParse(value) != null)) {
        return 50;
      } else if (key.toLowerCase().contains("date")) {
        return 80;
      }
    } catch (e) {
      print("problem in setting width $e");
    }

    return 120;
  }

  static double getColumnSize1(
      {required String key, dynamic value, double? widthRatio = 120}) {
    value ??= "";

    try {
      if (key == "no" || key == "Sr No") {
        return 50;
      } else if (key == "tapeduration") {
        return 80;
      } else if (key.toLowerCase().contains("locationname")) {
        return 80;
      } else if (key.toLowerCase().contains("time") ||
          key.toLowerCase().contains("program")) {
        return 120;
      } else if (value is num ||
          (value is String && num.tryParse(value) != null)) {
        return 50;
      } else if (key.toLowerCase().contains("date")) {
        return 100;
      }
    } catch (e) {
      print("problem in setting width $e");
    }

    return 120;
  }

  static double getRowMinWidth(
      {required String key, dynamic value, double? widthRatio = 120}) {
    value ??= "";

    try {
      if (key == "no" || key == "Sr No") {
        return 30;
      } else if (key == "tapeduration") {
        return 5;
      } else if (key.toLowerCase().contains("locationname")) {
        return 80;
      } else if (key.toLowerCase().contains("time") ||
          key.toLowerCase().contains("program")) {
        return 120;
      } else if (value is num ||
          (value is String && num.tryParse(value) != null)) {
        return 45;
      } else if (key.toLowerCase().contains("date")) {
        return 100;
      }
    } catch (e) {
      print("problem in setting width $e");
    }

    return 120;
  }

  static double getRowWidth(
      {required String key, dynamic value, double? widthRatio = 120}) {
    value ??= "";

    try {
      if (key == "no" || key == "Sr No") {
        return 30;
      } else if (key == "tapeduration") {
        return 90;
      } else if (key.toLowerCase().contains("locationname")) {
        return 80;
      } else if (key.toLowerCase().contains("time") ||
          key.toLowerCase().contains("program")) {
        return 120;
      } else if (value is num ||
          (value is String && num.tryParse(value) != null)) {
        return 45;
      } else if (key.toLowerCase().contains("date")) {
        return 100;
      }
    } catch (e) {
      print("problem in setting width $e");
    }

    return 120;
  }

  static List<PermissionModel> fetchPermissions() {
    HomeController dashboardController = Get.find<HomeController>();
    List<PermissionModel> formPermissions;
    // var formName = (dashboardController.drawerModel!.parent!.firstWhere(
    //         (element) =>
    //             element.id == dashboardController.currentParentValue.value))
    //     .child!
    //     .firstWhere((element) =>
    //         element.id == dashboardController.currentChildValue.value)
    //     .subChild!
    //     .firstWhere((element) =>
    //         element.id == dashboardController.currentSubChildValue.value)
    //     .name;

    var formName = dashboardController.selectChild1.value!.name!;

    print('formmmm =======================>>>> $formName');
    formPermissions = Get.find<MainController>()
        .permissionList!
        .where((element) =>
            (element.displayName == formName || element.formName! == formName))
        .toList();
    print(formPermissions.length.toString() + " Permissions Found");

    return formPermissions;
  }

  static List<PermissionModel> fetchPermissions1(String formName) {
    List<PermissionModel> formPermissions;
    print('formmmm =======================>>>> $formName');
    formPermissions = Get.find<MainController>()
        .permissionList!
        .where((element) => (element.appFormName == formName))
        .toList();
    print(formPermissions.length.toString() + " Permissions Found");

    return formPermissions;
  }

  static btnAccessHandler(btn, List<PermissionModel> formPermissions) {
    log('permission ===> ${jsonEncode(formPermissions)}');
    if (formPermissions.isEmpty) return;
    //default btns
    List permittedBtns = ['Refresh', 'Clear', 'Exit', 'Docs'];
    if (formPermissions[0].delete!) {
      permittedBtns.add('Delete');
    }
    if (formPermissions[0].write!) {
      permittedBtns.add('Save');
    }
    if (formPermissions[0].search!) {
      permittedBtns.add('Search');
    }

    // log('outside callback' + jsonEncode(permittedBtns) + btn);

    var value = btnDisabilityHandler(btn, permittedBtns);
    return value;
  }

  static btnAccessHandler2(
      btn, HomeController controller, PermissionModel formPermissions) {
    // print('Here= ================?????');
    // print('permission ===> ${jsonEncode(formPermissions)}');
    //default btns
    List permittedBtns = [
      'Refresh',
      'Clear',
      'Exit',
      'Docs',
      "Auto",
      "Commercials",
      "Insert",
      "Updated",
      "Segments",
      "Change",
      "Export",
      "Next Time",
      "Undo",
      "TS",
      "Verify",
      "Load"
    ];
    if (formPermissions.delete!) {
      permittedBtns.add('Delete');
    }
    if (formPermissions.write!) {
      permittedBtns.add('Save');
    }
    if (formPermissions.search!) {
      permittedBtns.add('Search');
    }

    // log('outside callback' + jsonEncode(permittedBtns) + btn);

    var value = btnDisabilityHandler(btn, permittedBtns);
    return value;
  }

  static btnDisabilityHandler(String btn, List permittedBtns) {
    var isDisabled = null;
    // log('inside callback' + jsonEncode(permittedBtns) + btn);
    for (var i = 0; i < permittedBtns.length; i++) {
      if (permittedBtns[i].toString().toLowerCase() == btn.toLowerCase()) {
        isDisabled = 'not disabled';
      }
    }
    return isDisabled;
  }

  static String getValueAfterSkipKey(String data, String key) {
    return data.substring(data.indexOf(key) + key.length, data.length);
    // return "";
  }

  static String getValueBeforeSkipKey(String data, String key) {
    return data.substring(0, data.indexOf(key));
  }

  static callJSToExit({String? param}) {
    js.context
        .callMethod('fromFlutter', [param ?? "exit", ApiFactory.NOTIFY_URL]);
  }

  static String getFormName() {
    return (html.window.location.href.split("?")[0])
        .split(ApiFactory.SPLIT_CLEAR_PAGE)[1];
  }

  static String convertToTimeFromDouble({required num value}) {
    String? functionReturnValue;
    num inputValue = value;
    String? outputText;
    num fraction = 0;
    String? newText;
    if (inputValue < 0) {
      inputValue = inputValue + 86400;
    }
    if (inputValue != 0) {
      if (inputValue >= 172800) {
        inputValue = inputValue - 172800;
      } else if (inputValue >= 86400) {
        inputValue = inputValue - 86400;
      }
      outputText = "";
      fraction = inputValue - (inputValue).floor();
      inputValue = (inputValue).floor();
      newText = (inputValue / 3600).floor().toString();
      if (newText.toString().length < 2) {
        newText = "0" + newText;
      } else {
        newText = newText;
      }
      outputText = newText;
      inputValue = inputValue % 3600;
      newText = (inputValue / 60).floor().toString();
      if (newText.toString().length < 2) {
        newText = "0" + newText;
      }
      outputText = outputText + ":" + newText;
      inputValue = inputValue % 60;
      newText = (inputValue / 1).toString();
      if (newText.toString().length < 2) {
        newText = "0" + newText;
      }
      outputText = outputText + ":" + newText;
      newText = ((fraction * 25).round()).toString();
      if (newText.toString().length < 2) {
        newText = "0" + newText;
      }
      outputText = outputText + ":" + newText;
      functionReturnValue = outputText;
    } else {
      functionReturnValue = "00:00:00:00";
    }
    return functionReturnValue;
  }

  static num oldBMSConvertToSecondsValue({required String value}) {
    num second = 0;
    List<String> str = value.split(":");
    if ((str.length == 3)) {
      second = ((int.tryParse(str[0])! * (60 * 60)) +
          ((int.tryParse(str[1])! * 60) + int.tryParse(str[2])!));
    } else if ((str.length == 4)) {
      second = ((int.tryParse(str[0])! * (60 * 60)) +
          ((int.tryParse(str[1])! * 60) +
              (int.tryParse(str[2])! + (int.tryParse(str[3])! / 25))));
    }
    return second;
  }

  static DateTime universalDateParserFromText(String dateString) {
    DateTime _date = DateTime.now();
    if (DateTime.tryParse(dateString) != null) {
      _date = DateTime.tryParse(dateString)!;
    } else {
      if (dateString.contains("/")) {
        var splitString = dateString.split("/");
        if (splitString.length == 3) {
          if (!splitString.any((element) => int.tryParse(element) == null)) {
            _date = DateTime(int.parse(splitString[2]),
                int.parse(splitString[1]), int.parse(splitString[0]));
          }
        }
      } else if (dateString.contains("-")) {
        var splitString = dateString.split("-");
        if (splitString.length == 3) {
          if (!splitString.any((element) => int.tryParse(element) == null)) {
            _date = DateTime(int.parse(splitString[2]),
                int.parse(splitString[1]), int.parse(splitString[0]));
          }
        }
      }
    }

    return _date;
  }

  static String getWeekday(int e) {
    String data;
    if (e == 1) {
      data = "Monday";
    } else if (e == 2) {
      data = "Tuesday";
    } else if (e == 3) {
      data = "Wednesday";
    } else if (e == 4) {
      data = "Thursday";
    } else if (e == 5) {
      data = "Friday";
    } else if (e == 6) {
      data = "Saturday";
    } else {
      data = "Sunday";
    }
    return data;
  }
}
