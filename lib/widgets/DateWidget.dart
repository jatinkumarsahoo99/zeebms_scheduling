import 'dart:developer';

// import 'package:bms_programming/app/providers/extensions/datetime.dart';
import 'package:bms_scheduling/app/providers/extensions/datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../app/providers/SizeDefine.dart';
import '../app/providers/Utils.dart';
import 'LabelTextStyle.dart';

class DateWidget {
  static Widget date(context, title, fun, bool margin, {String? preslected, num? width = 0.12, String? Function(String?)? validator, padding}) {
    TextEditingController _dateController = TextEditingController(text: preslected ?? DateFormat('dd/MM/yyyy').format(DateTime.now()));
    return GestureDetector(
      onTap: () {
        _selectDate(context, (value) {
          _dateController.text = new DateFormat('dd/MM/yyyy').format(value);
          fun(value);
        });
      },
      child: AbsorbPointer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: LabelText.style(
                hint: title,
              ),
            ),
            Container(
              // margin: EdgeInsets.symmetric(vertical: 10),
              height: SizeDefine.heightInputField,
              width: Get.width * width!,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: (padding ?? false) ? 5 : 0, vertical: 0),
              margin: EdgeInsets.symmetric(vertical: margin ? 10 : 0),
              child: TextFormField(
                validator: validator,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.datetime,
                textAlign: TextAlign.left,
                controller: _dateController,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                    hintText: "dd/MM/yyyy",
                    contentPadding: const EdgeInsets.only(left: 10),
                    // labelText: title,
                    labelStyle: TextStyle(fontSize: 17),
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.deepPurpleAccent,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget time(context, title, fun, {String? preslected, num? width = 0.12, bool padLeft = false}) {
    TextEditingController _timeController = TextEditingController(text: preslected);
    return Padding(
      padding: EdgeInsets.only(left: padLeft ? 12 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: padLeft ? 8 : 0),
            child: LabelText.style(
              hint: title,
            ),
          ),
          Container(
            // margin: EdgeInsets.symmetric(vertical: 10),
            height: SizeDefine.heightInputField,
            width: Get.width * width!,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),

            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.datetime,
              textAlign: TextAlign.left,
              controller: _timeController,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                  hintText: "HH:MM:SS",
                  contentPadding: const EdgeInsets.only(left: 10),
                  // labelText: title,
                  labelStyle: TextStyle(fontSize: 17),
                  border: InputBorder.none,
                  suffixIcon: InkWell(
                    onTap: () {
                      _selectTime(context, (value) {
                        _timeController.text = new DateFormat('HH:mm:ss').format(DateTime.now().fromtimeofday(value)).toString();
                        log(_timeController.text);
                        fun(value);
                      });
                    },
                    child: Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
          ),
        ],
      ),
    );
    //
  }

  static Widget timeEditable(title, context, fun,
      {num? width = 0.12, TextEditingController? timeController, String? format = 'yyyy-MM-dd HH:mm:ss'}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: LabelText.style(
            hint: title,
          ),
        ),
        Container(
          // margin: EdgeInsets.symmetric(vertical: 10),
          height: SizeDefine.heightInputField,
          width: Get.width * width!,
          alignment: Alignment.topLeft,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),

          child: TextField(
            enabled: true,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            controller: timeController,
            style: TextStyle(fontSize: 12),
            inputFormatters: [
              /* FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
              FilteringTextInputFormatter.deny("::"),
              MaskedTextInputFormatter(mask: 'xx:xx:xx', separator: ':'),*/
              FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
              // FilteringTextInputFormatter.deny("::"),
              // MaskedTextInputFormatter(mask: 'xx:xx:xx', separator: ':'),
              // TimeTextFormatterWithColun(),
              // LengthLimitingTextInputFormatter(8),
              // LengthLimitingTextInputFormatter(10),
              // TimeTextFormatterWithColun(),
            ],
            decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  borderRadius: BorderRadius.circular(0),
                ),
                hintText: "HH:MM:SS",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: title,
                labelStyle: TextStyle(fontSize: 17),
                border: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: () => _selectDatenTime(context, (value) {
                    timeController!.text = DateFormat(format).format(value).toString();
                    log(timeController.text);
                    fun(value);
                  }),
                  child: Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  borderRadius: BorderRadius.circular(0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  borderRadius: BorderRadius.circular(0),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        ),
      ],
    );
  }

  static Widget Datentime(context, title, fun,
      {String? preslected, num? width = 0.12, TextEditingController? timeController, String? format = 'yyyy-MM-dd HH:mm:ss'}) {
    if (timeController == null) {
      timeController = TextEditingController(text: DateFormat(format).format(DateTime.now()));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: LabelText.style(
            hint: title,
          ),
        ),
        Container(
          // margin: EdgeInsets.symmetric(vertical: 10),
          height: SizeDefine.heightInputField,
          width: Get.width * width!,
          alignment: Alignment.topLeft,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),

          child: InkWell(
            onTap: () => _selectDatenTime(context, (value) {
              timeController!.text = DateFormat(format).format(value).toString();
              log(timeController.text);
              fun(value);
            }),
            child: TextField(
              enabled: false,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.datetime,
              textAlign: TextAlign.left,
              controller: timeController,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  hintText: "HH:MM:SS",
                  contentPadding: const EdgeInsets.only(left: 10),
                  // labelText: title,
                  labelStyle: TextStyle(fontSize: 17),
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.deepPurpleAccent,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
          ),
        ),
      ],
    );
  }

  static Widget dateStartDtEndDt(context, title, fun, {DateTime? startDt, DateTime? endDt, String? initialValue, double? widthRatio}) {
    // RxString dateData = initialValue??"".obs;
    var dateData = RxString(initialValue ?? "");
    TextEditingController controller = TextEditingController(text: dateData.value);
    return GestureDetector(
      onTap: () => _selectDate(
        context,
        (value) {
          dateData.value = new DateFormat('dd/MM/yyyy').format(value);
          fun(value);
        },
        startDt: startDt ?? Utils.universalDateParserFromText(controller.text).subtract(Duration(days: 1000)),
        endDt: endDt,
        initDt: Utils.universalDateParserFromText(controller.text),
      ),
      child: Obx(() => AbsorbPointer(
            absorbing: true,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: LabelText.style(
                      hint: title,
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.symmetric(vertical: 10),
                    height: SizeDefine.heightInputField,
                    width: Get.width * (widthRatio ?? 0.12),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.datetime,
                      textAlign: TextAlign.left,
                      controller: controller,
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                          hintText: "dd/MM/yyyy",
                          contentPadding: const EdgeInsets.only(left: 10),
                          // labelText: title,
                          labelStyle: TextStyle(fontSize: 17),
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.deepPurpleAccent,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurpleAccent),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurpleAccent),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  static Widget dateStartDtEndDt2(context, title, fun,
      {DateTime? startDt,
      DateTime? endDt,
      DateTime? initDt,
      String? initialValue,
      double? widthRatio,
      double? paddingLeft,
      String? format = 'dd/MM/yyyy',
      Function(String)? onSubmitted,
      TextEditingController? controller,
      FocusNode? focusNode,
      bool margin = false,
      RxBool? enable}) {
    // RxString dateData = initialValue??"".obs;
    var dateData = RxString(initialValue ?? "");
    enable ??= RxBool(true);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: margin ? 10 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: paddingLeft ?? 6),
            child: LabelText.style(
              hint: title,
            ),
          ),
          Container(
            // margin: EdgeInsets.symmetric(vertical: 10),
            height: SizeDefine.heightInputField,
            width: Get.width * (widthRatio ?? 0.12),
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: paddingLeft ?? 5, vertical: 0),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.datetime,
              textAlign: TextAlign.left,
              controller: controller,
              onSubmitted: onSubmitted,
              focusNode: focusNode,
              enabled: enable.value,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                  hintText: format,
                  contentPadding: const EdgeInsets.only(left: 10),
                  // labelText: title,
                  labelStyle: TextStyle(fontSize: 17),
                  border: InputBorder.none,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      {
                        if (enable!.value) {
                          _selectDate2(context, (value) {
                            dateData.value = new DateFormat(format).format(value);
                            controller!.text = DateFormat(format).format(value);
                            fun(value);
                          }, startDt: startDt, endDt: endDt, initDt: initDt);
                        } else {
                          null;
                        }
                      }
                    },
                    child: Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: (enable.value) ? Colors.deepPurpleAccent : Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
          ),
        ],
      ),
    );
  }

  static Widget dateStartDtEndDt3(context, title, fun,
      {DateTime? startDt, DateTime? endDt, String? initialValue, double? widthRatio, double? paddingLeft, TextEditingController? controller}) {
    // RxString dateData = initialValue??"".obs;
    var dateData = RxString(initialValue ?? "");
    return GestureDetector(
      onTap: () => _selectDate2(context, (value) {
        dateData.value = new DateFormat('dd/MM/yyyy').format(value);
        fun(value);
      }, startDt: startDt, endDt: endDt),
      child: Obx(() => AbsorbPointer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: paddingLeft ?? 6.0),
                  child: LabelText.style(
                    hint: title,
                  ),
                ),
                Container(
                  // margin: EdgeInsets.symmetric(vertical: 10),
                  height: SizeDefine.heightInputField,
                  width: Get.width * (widthRatio ?? 0.12),
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: paddingLeft ?? 5, vertical: 0),
                  // margin: EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.datetime,
                    textAlign: TextAlign.left,
                    // autofocus: false,
                    controller: controller ?? TextEditingController()
                      ..text = dateData.value,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                        hintText: "dd/MM/yyyy",
                        contentPadding: const EdgeInsets.only(left: 10),
                        // labelText: title,
                        labelStyle: TextStyle(fontSize: 17),
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.deepPurpleAccent,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  static Widget dateStartDtEndDt1(context, title, fun, controller, {DateTime? startDt, DateTime? endDt, String? initialValue}) {
    RxString dateData = "".obs;
    return GestureDetector(
      onTap: () => _selectDate(
        context,
        (value) {
          dateData.value = new DateFormat('dd/MM/yyyy').format(value);
          fun(value);
        },
        startDt: startDt ?? Utils.universalDateParserFromText(controller!.text).subtract(Duration(days: 1000)),
        endDt: endDt,
        initDt: Utils.universalDateParserFromText(controller!.text),
      ),
      child: Obx(() => AbsorbPointer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelText.style(
                  hint: title,
                ),
                Container(
                  // margin: EdgeInsets.symmetric(vertical: 10),
                  height: SizeDefine.heightInputField,
                  width: Get.width * 0.12,
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.datetime,
                    textAlign: TextAlign.left,
                    controller: controller,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                        hintText: "dd/MM/yyyy",
                        contentPadding: const EdgeInsets.only(left: 10),
                        // labelText: title,
                        labelStyle: TextStyle(fontSize: 17),
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.deepPurpleAccent,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  static Future<Null> _selectDate(BuildContext context, function, {DateTime? initDt, DateTime? startDt, DateTime? endDt}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: Locale("en"),
        /*initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 1000)),
        lastDate: DateTime.now(),*/
        initialDate: initDt ?? DateTime.now(),
        firstDate: startDt ?? DateTime(1901, 1),
        lastDate: endDt ?? DateTime.now().add(Duration(days: 365))); //18 years is 6570 days
    if (picked != null) function(picked);
  }

  static Future<Null> _selectDate2(BuildContext context, function, {DateTime? initDt, DateTime? startDt, DateTime? endDt}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: Locale("en"),
      /*initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 1000)),
        lastDate: DateTime.now(),*/
      initialDate: initDt ?? DateTime.now(),
      firstDate: startDt ?? DateTime(1901, 1),
      lastDate: endDt ??
          DateTime.now().add(
            Duration(days: 1000),
          ),
    ); //18 years is 6570 days
    if (picked != null) function(picked);
  }

  static Future<DateTime?> showDateTimePickerDialog(BuildContext context, {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1901, 1),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 1000)),
    );
  }

  static Future<Null> _selectDatenTime(BuildContext context, function, {DateTime? initDt, DateTime? startDt, DateTime? endDt}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: Locale("en"),
        /*initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 1000)),
        lastDate: DateTime.now(),*/
        initialDate: endDt ?? DateTime.now(),
        firstDate: startDt ?? DateTime(1901, 1),
        lastDate: endDt ?? DateTime.now().add(Duration(days: 1000))); //18 years is 6570 days
    if (picked != null) {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial,
      );
      if (timeOfDay != null) {
        function(DateTime(picked.year, picked.month, picked.day, timeOfDay.hour, timeOfDay.minute));
      }
    }
  }

  static Future<Null> _selectTime(
    BuildContext context,
    function,
  ) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      function(timeOfDay);
    }
  }
}
