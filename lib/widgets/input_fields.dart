// import 'dart:developer';
// import 'dart:math';
// import 'dart:ui';

// import 'package:bms/providers/ColorData.dart';
// import 'package:bms/providers/SizeDefine.dart';
// import 'package:bms/providers/Utils.dart';
// import 'package:bms/widgets/InputFormatters/duration_formatter.dart';
// import 'package:bms/widgets/InputFormatters/input_formatters.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:get/get.dart';
// // import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:pluto_grid_export/pluto_grid_export.dart';

// import 'LabelTextStyle.dart';

import 'dart:math';

import 'package:bms_scheduling/widgets/LabelTextStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../app/providers/ColorData.dart';
import '../app/providers/SizeDefine.dart';
import '../app/providers/Utils.dart';
import 'InputFormatters/input_formatters.dart';

/// Uppercase text formater
class WithoutUpperCase extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(oldValue, TextEditingValue newValue) => TextEditingValue(text: newValue.text, selection: newValue.selection);
}

class InputFields {
  static Widget formFieldPass({required String hintTxt, required TextEditingController controller}) {
    var isPassVisible = RxBool(true);
    // var data = 0.obs;
    return Padding(
      padding: const EdgeInsets.only(left: SizeDefine.paddingHorizontal, right: SizeDefine.paddingHorizontal, top: 6.0, bottom: 6.0),
      child: Obx(() => CupertinoTextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            // keyboardType: Validator.getKeyboardTyp(validateModel.fieldType.toLowerCase()),
            style: const TextStyle(fontSize: 15),
            inputFormatters: [LengthLimitingTextInputFormatter(SizeDefine.maxcharlimit)],
            placeholder: hintTxt,
            decoration: BoxDecoration(
              color: ColorData.bgFormField,
              borderRadius: BorderRadius.circular(15),
            ),
            obscureText: isPassVisible.value,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            onChanged: (newValue) {},
            suffix: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: InkWell(
                onTap: () {
                  isPassVisible.value = !isPassVisible.value;
                },
                child: Icon(
                  (isPassVisible.value) ? CupertinoIcons.eye_solid : CupertinoIcons.eye_slash_fill,
                  color: ColorData.hintColor,
                ),
              ),
            ),
          )),
    );
  }

  static Widget formField2({
    String? Function(String?)? validator,
    required String hintTxt,
    required TextEditingController controller,
    Function(String)? onchanged,
    double? padLeft,
    List<TextInputFormatter> inputformatters = const [],
    num? width = 0.12,
    bool capital = false,
    bool? isEnable,
    int? maxLen,
    bool margin = false,
    bool autoFocus = false,
    bool showTitle = true,
    int maxLines = 1,
    double? height,
    FocusNode? focusNode,
    void Function(bool hasFocus)? onFocusChange,
    Function()? onEditComplete,
  }) {
    if (inputformatters.isNotEmpty) {
      inputformatters.add(FilteringTextInputFormatter.deny("  "));
    }

    return Focus(
      skipTraversal: true,
      onFocusChange: onFocusChange,
      canRequestFocus: isEnable ?? true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showTitle) ...{
            Padding(
              padding: EdgeInsets.only(left: margin ? (padLeft ?? 10) : 0),
              child: LabelText.style(
                hint: hintTxt,
                txtColor: (isEnable ?? true) ? Colors.black : Colors.grey,
              ),
            ),
          },
          Container(
            margin: EdgeInsets.only(left: margin ? (padLeft ?? 10) : 0),
            height: height ?? SizeDefine.heightInputField,
            width: Get.width * width!,
            child: TextFormField(
              focusNode: focusNode,
              maxLines: maxLines,
              minLines: maxLines,
              autofocus: autoFocus,
              onEditingComplete: onEditComplete,
              textCapitalization: capital ? TextCapitalization.characters : TextCapitalization.none,
              validator: validator,
              enabled: isEnable ?? true,
              maxLength: maxLen ?? 25,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (onchanged != null) ? onchanged : null,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.datetime,
              textAlign: TextAlign.left,
              inputFormatters: inputformatters.isEmpty
                  ? [
                      LengthLimitingTextInputFormatter(SizeDefine.maxcharlimit),
                      FilteringTextInputFormatter.deny("  "),
                    ]
                  : inputformatters,
              controller: controller,
              style: TextStyle(fontSize: 12, color: (isEnable ?? true) ? Colors.black : Colors.grey),
              decoration: InputDecoration(
                  enabled: isEnable ?? true,
                  errorBorder: InputBorder.none,
                  counterText: "",
                  contentPadding: const EdgeInsets.only(left: 10),
                  labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: (isEnable ?? true) ? Colors.black : Colors.grey),
                  border: InputBorder.none,
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

  static Widget formField1({
    String? Function(String?)? validator,
    required String hintTxt,
    required TextEditingController controller,
    Function(String)? onchanged,
    double? padLeft,
    FocusNode? focusNode,
    Function()? onEditComplete,
    List<TextInputFormatter> inputformatters = const [],
    num? width = 0.12,
    bool capital = false,
    bool? isEnable,
    int? maxLen,
    bool margin = false,
    bool autoFocus = false,
    bool showTitle = true,
    int maxLines = 1,
    double? height,
    void Function(String)? onFieldSubmitted,
    String? prefixText,
  }) {
    // var data = 0.obs;

    if (inputformatters.isNotEmpty) {
      inputformatters.add(FilteringTextInputFormatter.deny("  "));
      // inputformatters.add(
      //   FilteringTextInputFormatter.allow(RegExp(r"^(\w+ ?)*$")),
      // );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showTitle) ...{
          LabelText.style(
            hint: hintTxt,
            txtColor: (isEnable ?? true) ? Colors.black : Colors.grey,
          ),
        },
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),

          height: height ?? SizeDefine.heightInputField,
          width: Get.width * width!,

          child: TextFormField(
            maxLines: maxLines,
            focusNode: focusNode,
            minLines: maxLines,
            autofocus: autoFocus,
            onEditingComplete: onEditComplete,
            textCapitalization: capital ? TextCapitalization.characters : TextCapitalization.none,
            validator: validator,
            enabled: isEnable ?? true,
            maxLength: maxLen ?? 25,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (onchanged != null) ? onchanged : null,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            onFieldSubmitted: onFieldSubmitted,
            inputFormatters: inputformatters.isEmpty
                ? [
                    LengthLimitingTextInputFormatter(SizeDefine.maxcharlimit),
                    FilteringTextInputFormatter.deny("  "),
                    // FilteringTextInputFormatter.allow(RegExp(r"^(\w+ ?)*$")),
                  ]
                : inputformatters,
            controller: controller,
            style: TextStyle(fontSize: 12, color: (isEnable ?? true) ? Colors.black : Colors.grey),
            decoration: InputDecoration(
                enabled: isEnable ?? true,
                // prefixText: prefixText,

                prefixIcon: prefixText != null
                    ? SizedBox(
                        child: Center(
                          widthFactor: 0.0,
                          child: Text(
                            " $prefixText ",
                            style: TextStyle(
                              backgroundColor: Colors.grey.shade500,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    : null,
                prefixStyle: TextStyle(
                  backgroundColor: Colors.grey.shade500,
                  color: Colors.white,
                  fontSize: 12,
                ),
                errorBorder: InputBorder.none,
                counterText: "",
                // hintText: "dd/MM/yyyy",
                contentPadding: EdgeInsets.only(left: prefixText == null ? 10 : 0),
                // labelText: hintTxt,
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: (isEnable ?? true) ? Colors.black : Colors.grey),
                border: InputBorder.none,
                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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
    );
  }

  static Widget formFieldWidthWithValidation(
      {String? Function(String?)? validator,
      required String hintTxt,
      required double widthRatio,
      required TextEditingController controller,
      List<TextInputFormatter> inputformatters = const [],
      Function(String)? onchanged,
      bool margin = true,
      bool? isEnable,
      int? maxLen,
      bool autoFocus = false,
      bool istextCapitalized = false}) {
    // var data = 0.obs;

    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: margin ? 10 : 0),
          child: LabelText.style(
            hint: hintTxt,
          ),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: margin ? 10 : 0),
          height: SizeDefine.heightInputField,
          width: Get.width * widthRatio,
          child: TextFormField(
            autofocus: autoFocus,
            textCapitalization: istextCapitalized ? TextCapitalization.characters : TextCapitalization.none,
            inputFormatters: [...inputformatters, LengthLimitingTextInputFormatter(SizeDefine.maxcharlimit)],
            maxLength: maxLen ?? 25,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (onchanged != null) ? onchanged : null,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            controller: controller,
            enabled: isEnable ?? true,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
                errorBorder: InputBorder.none,
                counterText: "",
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
                border: InputBorder.none,
                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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
    );
  }

  static Widget formFieldOnSaved(
      {required String hintTxt,
      required TextEditingController controller,
      required Function function,
      double? widthSize,
      FocusNode? focusNode,
      int? maxLen,
      double? leftPadding}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: leftPadding ?? 10),
          child: LabelText.style(
            hint: hintTxt,
          ),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: leftPadding ?? 10),
          height: SizeDefine.heightInputField,
          width: Get.width * (widthSize ?? 0.12),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            controller: controller,
            maxLength: maxLen ?? 25,
            style: TextStyle(fontSize: 12),
            onSubmitted: (val) {
              function(val);
            },
            inputFormatters: [
              FilteringTextInputFormatter.deny("  "),
              // FilteringTextInputFormatter.allow(RegExp(r"^(\w+ ?)*$")),
            ],
            focusNode: focusNode,
            decoration: InputDecoration(
                errorBorder: InputBorder.none,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                counterText: "",
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
                border: InputBorder.none,
                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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

  static Widget formFieldWidthNoSpace(
      {required String hintTxt,
      required TextEditingController controller,
      required double widthRatio,
      double? height,
      double? paddingLeft,
      bool capital = false,
      bool? isEnable,
      int? maxLen,
      bool autofocus = false,
      FocusNode? focus,
      Function? onChange}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: paddingLeft ?? 10),
          child: LabelText.style(hint: hintTxt),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: paddingLeft ?? 10),
          height: height ?? SizeDefine.heightInputField,
          width: Get.width * widthRatio,

          child: TextField(
            autofocus: autofocus,
            inputFormatters: [
              LengthLimitingTextInputFormatter(SizeDefine.maxcharlimit),
              capital ? UpperCaseTextFormatter() : FilteringTextInputFormatter.deny(RegExp('')),
              FilteringTextInputFormatter.deny("  "),
              // FilteringTextInputFormatter.allow(RegExp(r"^(\w+ ?)*$")),
            ],
            focusNode: focus,
            textCapitalization: capital ? TextCapitalization.characters : TextCapitalization.none,
            enabled: isEnable ?? true,
            maxLength: maxLen ?? 25,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            controller: controller,
            style: TextStyle(fontSize: 12),
            onChanged: (val) {
              if (onChange != null) {
                onChange(val);
              }
            },
            decoration: InputDecoration(
                errorBorder: InputBorder.none,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                counterText: "",
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
                border: InputBorder.none,

                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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
    );
  }

  static Widget formField1Width({
    required String hintTxt,
    required TextEditingController controller,
    required double widthRatio,
    double? height,
    double? paddingLeft,
    bool capital = false,
    bool? isEnable,
    int? maxLen,
    FocusNode? focus,
    Function? onChange,
    bool autoFocus = false,
  }) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: paddingLeft ?? 10),
          child: LabelText.style(hint: hintTxt, txtColor: (isEnable ?? true) ? Colors.black : Colors.grey),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: paddingLeft ?? 10),
          height: height ?? SizeDefine.heightInputField,
          width: Get.width * widthRatio,

          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLen ?? SizeDefine.maxcharlimit),
              capital ? UpperCaseTextFormatter() : FilteringTextInputFormatter.deny(RegExp(''))
            ],
            autofocus: autoFocus,
            focusNode: focus,
            textCapitalization: capital ? TextCapitalization.characters : TextCapitalization.none,
            enabled: isEnable ?? true,
            maxLength: maxLen ?? SizeDefine.maxcharlimit,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            controller: controller,
            style: TextStyle(fontSize: 12, color: (isEnable ?? true) ? Colors.black : Colors.grey),
            onChanged: (val) {
              if (onChange != null) {
                onChange(val);
              }
            },
            decoration: InputDecoration(
                errorBorder: InputBorder.none,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                counterText: "",
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: (isEnable ?? true) ? Colors.black : Colors.grey),
                border: InputBorder.none,

                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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
    );
  }

  static Widget formField1WidthBox(
      {required String hintTxt,
      required TextEditingController controller,
      required double widthRatio,
      double? height,
      double? paddingLeft,
      bool capital = false,
      bool? isEnable,
      int? maxLen,
      FocusNode? focus,
      Function? onChange}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: paddingLeft ?? 10),
          child: LabelText.style(hint: hintTxt),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: paddingLeft ?? 10),
          height: height ?? SizeDefine.heightInputField,
          width: Get.width * widthRatio,
          alignment: Alignment.topLeft,
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLen ?? SizeDefine.maxcharlimit),
              capital ? UpperCaseTextFormatter() : FilteringTextInputFormatter.deny(RegExp(''))
            ],
            expands: true,
            focusNode: focus,
            textCapitalization: capital ? TextCapitalization.characters : TextCapitalization.none,
            enabled: isEnable ?? true,
            maxLength: maxLen ?? SizeDefine.maxcharlimit,
            maxLines: null,
            minLines: null,
            textAlignVertical: TextAlignVertical.top,
            keyboardType: TextInputType.multiline,
            textAlign: TextAlign.left,
            // minLines: 2,
            controller: controller,
            style: TextStyle(fontSize: 12),
            onChanged: (val) {
              if (onChange != null) {
                onChange(val);
              }
            },
            decoration: InputDecoration(
                errorBorder: InputBorder.none,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(
                  left: 10,
                  top: 10,
                ),
                // labelText: hintTxt,
                counterText: "",
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
                border: InputBorder.none,

                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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
    );
  }

  static Padding formFieldNumberMask({
    required String hintTxt,
    required TextEditingController controller,
    required double widthRatio,
    double? height,
    double? paddingLeft,
    Function? onEditComplete,
    // Function? onChange,
    // FocusNode? focusNode,
    int? maxLen,
    Function(String)? onchanged,
    bool isTime = false,
    bool isEnable = true,
    FocusNode? textFieldFN,
  }) {
    if (controller.text.isEmpty) {
      controller.text = isTime ? "00:00:00" : "00:00:00:00";
    }
    return Padding(
        padding: EdgeInsets.only(left: paddingLeft ?? 10),
        child: buildTimeDurationWidget(
          hintTxt,
          controller,
          widthRatio: widthRatio,
          isTime: isTime,
          isEnable: isEnable,
          textFieldFN: textFieldFN,
          onFocusChange: (time) {
            if (onEditComplete != null) {
              onEditComplete(time);
            }
          },
        ));
    // var data = 0.obs;
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.only(left: paddingLeft ?? 10),
    //       child: LabelText.style(hint: hintTxt),
    //     ),
    //     Container(
    //       // padding: const EdgeInsets.only(
    //       //     top: 6.0,
    //       //     bottom: 6.0),
    //       margin: EdgeInsets.only(left: paddingLeft ?? 10),
    //       height: height ?? SizeDefine.heightInputField,
    //       width: Get.width * widthRatio,
    //       child: TextField(
    //         onChanged: onchanged,
    //         textAlignVertical: TextAlignVertical.center,
    //         keyboardType: TextInputType.datetime,
    //         textAlign: TextAlign.left,
    //         maxLength: maxLen ?? 25,
    //         controller: controller,
    //         style: TextStyle(fontSize: 12),
    //         focusNode: focusNode ?? null,
    //         inputFormatters: [
    //           SeparatedNumberInputFormatter(2, separator: ":"),
    //           LengthLimitingTextInputFormatter(11)
    //         ],
    //         /* onEditingComplete: (){
    //           print("OnEdit COmplete");
    //           onEditComplete!();
    //         },*/
    //         onSubmitted: (val) {
    //           onEditComplete!();
    //         },
    //         /*  onChanged: (val) {
    //           onChange!(val);
    //         },*/
    //         decoration: InputDecoration(
    //             errorBorder: InputBorder.none,
    //             // hintText: "dd/MM/yyyy",
    //             contentPadding: const EdgeInsets.only(left: 10),
    //             // labelText: hintTxt,
    //             counterText: "",
    //             labelStyle: TextStyle(
    //                 fontSize: SizeDefine.labelSize, color: Colors.black),
    //             border: InputBorder.none,
    //             // suffixIcon: Icon(
    //             //   Icons.calendar_today,
    //             //   size: 14,
    //             //   color: Colors.deepPurpleAccent,
    //             // ),
    //             enabledBorder: OutlineInputBorder(
    //               borderSide: BorderSide(color: Colors.deepPurpleAccent),
    //               borderRadius: BorderRadius.circular(0),
    //             ),
    //             focusedBorder: OutlineInputBorder(
    //               borderSide: BorderSide(color: Colors.deepPurpleAccent),
    //               borderRadius: BorderRadius.circular(0),
    //             ),
    //             floatingLabelBehavior: FloatingLabelBehavior.always),
    //       ),
    //     ),
    //   ],
    // );
  }

  static Widget formFieldNumberMask1(
      {required String hintTxt,
      required TextEditingController controller,
      required double widthRatio,
      double? height,
      double? paddingLeft,
      Function? onEditComplete,
      Function? onChange,
      FocusNode? focusNode,
      int? maxLen,
      bool? isEnable = true,
      Function(String)? onchanged}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: paddingLeft ?? 10),
          child: LabelText.style(hint: hintTxt),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: paddingLeft ?? 10),
          height: height ?? SizeDefine.heightInputField,
          width: Get.width * widthRatio,
          child: TextField(
            onChanged: onchanged,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            maxLength: maxLen ?? 25,
            controller: controller,
            style: TextStyle(fontSize: 12, color: (isEnable != null && isEnable) ? Colors.grey : Colors.black),
            focusNode: focusNode ?? null,
            enabled: isEnable ?? true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
              FilteringTextInputFormatter.deny("::"),
              MaskedTextInputFormatter(mask: 'xx:xx:xx:xx', separator: ':'),
            ],
            /* onEditingComplete: (){
              print("OnEdit COmplete");
              onEditComplete!();
            },*/
            onSubmitted: (val) {
              onEditComplete!();
            },
            /*  onChanged: (val) {
              onChange!(val);
            },*/
            decoration: InputDecoration(
                errorBorder: InputBorder.none,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                counterText: "",
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: isEnable! ? Colors.black : Colors.grey),
                border: InputBorder.none,
                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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
    );
  }

  static Widget timeField1(
      {required String hintTxt, required TextEditingController controller, double? widthRatio, double? height, double? paddingLeft}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: paddingLeft ?? 10),
          child: LabelText.style(hint: hintTxt),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: paddingLeft ?? 10),
          height: height ?? SizeDefine.heightInputField,
          width: Get.width * (widthRatio ?? 0.12),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9:]'),
              )
            ],
            textAlign: TextAlign.left,
            controller: controller,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              // hintText: "dd/MM/yyyy",
              contentPadding: const EdgeInsets.only(left: 10),
              // labelText: hintTxt,
              labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
              border: InputBorder.none,
              // suffixIcon: Icon(
              //   Icons.calendar_today,
              //   size: 14,
              //   color: Colors.deepPurpleAccent,
              // ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurpleAccent),
                borderRadius: BorderRadius.circular(0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurpleAccent),
                borderRadius: BorderRadius.circular(0),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ),
      ],
    );
  }

  ///HH:MM:SS:FF
  ///23:59:59:29 max value will take
  static buildTimeDurationWidget(
    String title,
    TextEditingController controller, {
    bool isEnable = true,
    double widthRatio = .4,
    void Function(String time)? onFocusChange,
    bool isTime = true,
    FocusNode? textFieldFN,
  }) {
    bool backSpaceEnter = false;
    setCursor(int index) {
      controller.value = TextEditingValue(
        text: controller.text,
        selection: TextSelection.collapsed(offset: index),
      );
    }

    formatter(value) {
      if (!backSpaceEnter) {
        int len = value.length;
        if (len == (isTime ? 8 : 11)) {
          if ((int.tryParse(value.substring(0, 2)) ?? 0) > 23) {
//HOUR
            controller.text = "00${value.substring(2, (isTime ? 8 : 11))}";
            setCursor(2);
          } else if ((int.tryParse(value.substring(3, 5)) ?? 0) > 59) {
//MINUTES
            controller.text = "${value.substring(0, 3)}00${value.substring(5, (isTime ? 8 : 11))}";
            setCursor(5);
          } else if ((int.tryParse(value.substring(6, 8)) ?? 0) > 59) {
//SECOND
            controller.text = "${value.substring(0, 6)}00${value.substring(8, (isTime ? 8 : 11))}";
            setCursor(8);
          } else if (!isTime && (int.tryParse(value.substring(9, 11)) ?? 0) > 29) {
//FRAME
            String tempPrefix = value.substring(0, 9);
            controller.text = "${tempPrefix}00";
            setCursor(11);
          }
        } else {
          if (len == 2 && (int.tryParse(value) ?? 0) > 23) {
//HOUR
            controller.text = "00:";
            setCursor(2);
          } else if (len == 5 && (int.tryParse(value.substring(3, 5)) ?? 0) > 59) {
//MINUTES
            controller.text = "${value.substring(0, 3)}00:";
            setCursor(5);
          } else if (len == 8 && (int.tryParse(value.substring(6, 8)) ?? 0) > 59) {
//SECON
            controller.text = "${value.substring(0, 6)}00:";
            setCursor(8);
          }
        }
      }
    }

    final textColor = isEnable ? Colors.black : Colors.grey;
    const double textSize = 12;
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: isEnable ? Colors.deepPurpleAccent : Colors.grey,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(0),
    );

    return Focus(
      skipTraversal: true,
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
// when user leave textfield
          int len = controller.text.length;
          String tempValue = controller.text;
          if (len != (isTime ? 8 : 11)) {
            if (len == 0) {
              controller.text = "00:00:00:00";
            } else if (len == 1) {
//HOUR
              controller.text = "0$tempValue:00:00:00";
            } else if (len == 2) {
              controller.text = "$tempValue:00:00:00";
            } else if (len == 3) {
              controller.text = "${tempValue}00:00:00";
            } else if (len == 4) {
//MINUTES
              if ((int.tryParse(tempValue.substring(3, 4)) ?? 0) > 5) {
                controller.text = "${tempValue.substring(0, 3)}00:00";
              } else {
                controller.text = "${tempValue}0:00:00";
              }
            } else if (len == 5) {
              controller.text = "$tempValue:00:00";
            } else if (len == 6) {
              controller.text = "${tempValue}00:00";
            } else if (len == 7) {
//SECOND
              if ((int.tryParse(tempValue.substring(6, 7)) ?? 0) > 5) {
                controller.text = "${tempValue.substring(0, 6)}00:00";
              } else {
                controller.text = "${tempValue}0:00";
              }
            } else if (len == 8) {
              controller.text = "$tempValue:00";
            } else if (len == 9) {
              controller.text = "${tempValue}00";
            } else if (len == 10) {
//FRAME
              if ((int.tryParse(tempValue.substring(9, 10)) ?? 0) > 2) {
                controller.text = "${tempValue.substring(0, 9)}00";
              } else {
                controller.text = "${tempValue}0";
              }
            }
            if (isTime && controller.text.length > 8) {
              controller.text = controller.text.substring(0, 8);
            }
          }
          if (onFocusChange != null) {
            onFocusChange(controller.text);
          }
        } else {
          controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
        }
      },
      child: RawKeyboardListener(
        focusNode: FocusNode(
          skipTraversal: true,
        ),
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.space)) {
            int len = controller.text.length;
            if ((len == 0 || len == 1 || len == 3 || len == 4 || len == 6 || len == 7 || len == 9 || len == 10) &&
                (controller.text.length < (isTime ? 8 : 11))) {
              controller.text = controller.text + "0";
            } else if ((controller.text.length < (isTime ? 8 : 11))) {
              controller.text = controller.text + ":";
            }
            setCursor(controller.text.length);
          }
          if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
            backSpaceEnter = true;
          } else {
            backSpaceEnter = false;
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: textColor, fontSize: 10)),
            // LabelText.style(
            //     hint: title, txtColor: isEnable ? Colors.black : Colors.grey),
            const SizedBox(height: 5),
            SizedBox(
              width: Get.width * widthRatio,
              height: SizeDefine.heightInputField,
              child: TextFormField(
                enabled: isEnable,
                focusNode: textFieldFN,
                maxLength: (isTime ? 8 : 11),
                controller: controller,
                decoration: InputDecoration(
                  border: border,
                  enabled: isEnable,
                  enabledBorder: border,
                  focusedBorder: border,
                  counter: null,
                  counterText: "",
                  contentPadding: EdgeInsets.only(left: 10, top: 15, bottom: 5),
                ),
                cursorColor: Colors.deepPurpleAccent,
                onChanged: (value) {
                  if (!backSpaceEnter) {
                    formatter(value);
                  }
                },
                inputFormatters: [
                  SeparatedNumberInputFormatter(2, separator: ":"),
                ],
                cursorHeight: 15,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: textSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildDurationWidget(
    String title,
    TextEditingController controller, {
    double widthRatio = .2,
    int hourMax = 24,
    int minutesMax = 59,
    int secondMax = 59,
    int framMax = 59,
    bool isEnable = true,
  }) {
    final textColor = isEnable ? Colors.black : Colors.grey;
    final borderColor = isEnable ? Colors.deepPurpleAccent : Colors.grey;
    double textSize = 12;
    final bordder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: borderColor, width: 1),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText.style(hint: title, txtColor: textColor),
        // const SizedBox(height: 3),
        SizedBox(
          width: Get.width * widthRatio,
          height: SizeDefine.heightInputField,
          child: TextFormField(
            enabled: isEnable,
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 8),
              border: bordder,
              errorBorder: bordder,
              enabledBorder: bordder,
              focusedBorder: bordder,
              enabled: isEnable,
              counter: null,
              counterText: "",
            ),
            cursorColor: Colors.deepPurpleAccent,
            cursorHeight: 15,
            inputFormatters: [
              SeparatedNumberInputFormatter(2, separator: ":"),
            ],
            maxLength: 11,
            onChanged: (value) {
              var tempVal = value;
            },
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: textSize),
          ),
        ),
      ],
    );
  }

  static Widget formFieldNumber(
      {required String hintTxt,
      required TextEditingController controller,
      double? widthRatio,
      int? maxchar,
      double? height,
      bool? isNegativeReq = false,
      bool? isUpDownReq = true,
      double? paddingLeft}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: paddingLeft ?? 10),
          child: LabelText.style(hint: hintTxt),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: paddingLeft ?? 10),
          height: height ?? SizeDefine.heightInputField,
          width: Get.width * (widthRatio ?? 0.12),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxchar ?? SizeDefine.maxcharlimit),
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9:]'),
              ),
            ],
            textAlign: TextAlign.left,
            controller: controller,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
                errorBorder: InputBorder.none,
                suffixIcon: isUpDownReq!
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /*  InkWell(
                      child: Icon(Icons.arrow_drop_up_sharp,size: 18,),
                      onTap: () {
                        controller.text =
                            "${(int.tryParse(controller.text) ?? 0) + 1}";
                      },
                    ),*/
                          SizedBox(
                              width: 30,
                              height: 12,
                              child: IconButton(
                                focusNode: FocusNode(canRequestFocus: false),
                                padding: new EdgeInsets.all(0.0),
                                icon: Icon(Icons.arrow_drop_up_sharp),
                                onPressed: () {
                                  controller.text = "${(int.tryParse(controller.text) ?? 0) + 1}";
                                },
                              )),
                          SizedBox(
                              width: 30,
                              height: 12,
                              child: Center(
                                child: IconButton(
                                  focusNode: FocusNode(canRequestFocus: false),
                                  padding: new EdgeInsets.all(0.0),
                                  alignment: Alignment.center,
                                  icon: Icon(Icons.arrow_drop_down_sharp),
                                  onPressed: () {
                                    if (isNegativeReq == true) {
                                      controller.text = "${(int.tryParse(controller.text) ?? 0) - 1}";
                                    } else {
                                      if ((controller.text != "" && !(int.tryParse(controller.text)?.isNegative)!) && controller.text != "0") {
                                        controller.text = "${(int.tryParse(controller.text) ?? 0) - 1}";
                                      }
                                    }
                                  },
                                ),
                              )),
                        ],
                      )
                    : null,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
                border: InputBorder.none,

                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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

  static Widget numbers({
    String? Function(String?)? validator,
    required String hintTxt,
    required TextEditingController controller,
    Function(String)? onchanged,
    double? padLeft,
    bool? showbtn = true,
    List<TextInputFormatter> inputformatters = const [],
    num? width = 0.12,
    bool capital = false,
    bool isNegativeReq = true,
    int? maxchar,
    bool? isEnabled,
  }) {
    // var data = 0.obs;
    var fN = FocusNode();
    final iconColor = (isEnabled ?? true) ? Colors.deepPurpleAccent : Colors.grey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: padLeft ?? 10),
          child: LabelText.style(
            hint: hintTxt,
          ),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: padLeft ?? 10),
          height: SizeDefine.heightInputField,
          width: Get.width * width!,
          child: RawKeyboardListener(
            focusNode: fN,
            onKey: (RawKeyEvent keyEvent) {
              if (showbtn) {
                if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                  /* controller.text =
                      "${(int.tryParse(controller.text) ?? 1) - 1}";*/
                  if (!isNegativeReq) {
                    if (int.tryParse(controller.text) != 1 || int.tryParse(controller.text) != 0) {
                      controller.text = "${(int.tryParse(controller.text) ?? 1) - 1}";
                    }
                  } else {
                    controller.text = "${(int.tryParse(controller.text) ?? 1) - 1}";
                  }
                }
                if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                  controller.text = "${(int.tryParse(controller.text) ?? 0) + 1}";
                }
              }
            },
            child: AbsorbPointer(
              absorbing: isEnabled ?? false,
              child: TextFormField(
                textCapitalization: capital ? TextCapitalization.characters : TextCapitalization.none,
                validator: validator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (onchanged != null) ? onchanged : null,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.datetime,
                textAlign: TextAlign.left,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(maxchar ?? SizeDefine.maxcharlimit),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                enabled: isEnabled ?? true,
                decoration: InputDecoration(
                  errorBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 10),
                  labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  suffixIcon: showbtn!
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              canRequestFocus: isEnabled ?? true,
                              child: Icon(
                                Icons.arrow_drop_up_sharp,
                                size: 25,
                                color: iconColor,
                              ),
                              onTap: () {
                                if (isEnabled ?? true) {
                                  controller.text = "${(int.tryParse(controller.text) ?? 0) + 1}";
                                  onchanged!(controller.text);
                                } else {
                                  print("Print tap");
                                }
                              },
                            ),
                            InkWell(
                              canRequestFocus: (isEnabled ?? true),
                              child: Icon(
                                Icons.arrow_drop_down_sharp,
                                size: 25,
                                color: iconColor,
                              ),
                              onTap: () {
                                if (isEnabled ?? true) {
                                  if (!isNegativeReq) {
                                    print("Click on negative>>>" + controller.text);
                                    if (controller.text != "0") {
                                      controller.text = "${(int.tryParse(controller.text) ?? 1) - 1}";
                                      onchanged!(controller.text);
                                    }
                                  } else {
                                    controller.text = "${(int.tryParse(controller.text) ?? 1) - 1}";
                                    onchanged!(controller.text);
                                  }
                                } else {
                                  print("Print tap");
                                }
                              },
                            ),
                          ],
                        )
                      : SizedBox(),
                ),
                controller: controller,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget numbers1({
    String? Function(String?)? validator,
    required String hintTxt,
    required TextEditingController controller,
    Function(String)? onchanged,
    double? padLeft,
    bool? showbtn = true,
    List<TextInputFormatter> inputformatters = const [],
    num? width = 0.12,
    bool capital = false,
    bool isNegativeReq = true,
    int? maxchar,
    bool? isEnabled,
  }) {
    // var data = 0.obs;
    var fN = FocusNode();
    final iconColor = (isEnabled ?? true) ? Colors.deepPurpleAccent : Colors.grey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: padLeft ?? 10),
          child: LabelText.style(
            hint: hintTxt,
          ),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: padLeft ?? 10),
          height: SizeDefine.heightInputField,
          width: Get.width * width!,
          child: RawKeyboardListener(
            focusNode: fN,
            onKey: (RawKeyEvent keyEvent) {
              if (showbtn) {
                if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                  /* controller.text =
                      "${(int.tryParse(controller.text) ?? 1) - 1}";*/
                  if (!isNegativeReq) {
                    if (int.tryParse(controller.text) != 1 || int.tryParse(controller.text) != 0) {
                      controller.text = "${(int.tryParse(controller.text) ?? 1) - 1}";
                    }
                  } else {
                    controller.text = "${(int.tryParse(controller.text) ?? 1) - 1}";
                  }
                }
                if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                  controller.text = "${(int.tryParse(controller.text) ?? 0) + 1}";
                }
              }
            },
            child: AbsorbPointer(
              absorbing: isEnabled != null ? !isEnabled : false,
              child: TextFormField(
                textCapitalization: capital ? TextCapitalization.characters : TextCapitalization.none,
                validator: validator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (onchanged != null) ? onchanged : null,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.datetime,
                textAlign: TextAlign.left,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(maxchar ?? SizeDefine.maxcharlimit),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                enabled: isEnabled ?? true,
                decoration: InputDecoration(
                  errorBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 10),
                  labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  suffixIcon: showbtn!
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              canRequestFocus: isEnabled ?? true,
                              child: Icon(
                                Icons.arrow_drop_up_sharp,
                                size: 25,
                                color: iconColor,
                              ),
                              onTap: () {
                                if (isEnabled ?? true) {
                                  controller.text = "${(int.tryParse(controller.text) ?? 0) + 1}";
                                  onchanged!(controller.text);
                                } else {
                                  print("Print tap");
                                }
                              },
                            ),
                            InkWell(
                              canRequestFocus: (isEnabled ?? true),
                              child: Icon(
                                Icons.arrow_drop_down_sharp,
                                size: 25,
                                color: iconColor,
                              ),
                              onTap: () {
                                if (isEnabled ?? true) {
                                  if (!isNegativeReq) {
                                    print("Click on negative>>>" + controller.text);
                                    if (controller.text != "0") {
                                      controller.text = "${(int.tryParse(controller.text) ?? 1) - 1}";
                                      onchanged!(controller.text);
                                    }
                                  } else {
                                    controller.text = "${(int.tryParse(controller.text) ?? 1) - 1}";
                                    onchanged!(controller.text);
                                  }
                                } else {
                                  print("Print tap");
                                }
                              },
                            ),
                          ],
                        )
                      : SizedBox(),
                ),
                controller: controller,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget numbers3({
    String? Function(String?)? validator,
    required String hintTxt,
    required TextEditingController controller,
    Function(String)? onchanged,
    double? padLeft,
    bool? showbtn = true,
    List<TextInputFormatter> inputformatters = const [],
    num? width = 0.12,
    bool capital = false,
    bool isNegativeReq = true,
    int? maxchar,
    bool? isEnabled,
    FocusNode? fN,
  }) {
    // var data = 0.obs;
    fN ??= FocusNode();
    final iconColor =
    (isEnabled ?? true) ? Colors.deepPurpleAccent : Colors.grey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: padLeft ?? 10),
          child: LabelText.style(
            hint: hintTxt,
          ),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: padLeft ?? 10),
          height: SizeDefine.heightInputField,
          width: Get.width * width!,
          child: RawKeyboardListener(
            focusNode: FocusNode(skipTraversal: true),
            onKey: (RawKeyEvent keyEvent) {
              if (showbtn!) {
                if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                  /* controller.text =
                      "${(int.tryParse(controller.text) ?? 1) - 1}";*/
                  if (!isNegativeReq) {
                    if (int.tryParse(controller.text) != 1 ||
                        int.tryParse(controller.text) != 0) {
                      controller.text =
                      "${(int.tryParse(controller.text) ?? 1) - 1}";
                    }
                  } else {
                    controller.text =
                    "${(int.tryParse(controller.text) ?? 1) - 1}";
                  }
                }
                if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                  controller.text =
                  "${(int.tryParse(controller.text) ?? 0) + 1}";
                }
              }
            },
            child: AbsorbPointer(
              absorbing: isEnabled ?? false,
              child: TextFormField(
                focusNode: fN,
                textCapitalization: capital
                    ? TextCapitalization.characters
                    : TextCapitalization.none,
                validator: validator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (onchanged != null) ? onchanged : null,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.datetime,
                textAlign: TextAlign.left,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      maxchar ?? SizeDefine.maxcharlimit),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                enabled: isEnabled ?? true,
                decoration: InputDecoration(
                  errorBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 10),
                  labelStyle: TextStyle(
                      fontSize: SizeDefine.labelSize, color: Colors.black),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  suffixIcon: showbtn!
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        // canRequestFocus: isEnabled ?? true,
                        child: Icon(
                          Icons.arrow_drop_up_sharp,
                          size: 25,
                          color: iconColor,
                        ),
                        onTap: () {
                          if (isEnabled ?? true) {
                            controller.text =
                            "${(int.tryParse(controller.text) ?? 0) + 1}";
                            onchanged!(controller.text);
                          } else {
                            print("Print tap");
                          }
                        },
                      ),
                      GestureDetector(
                        // canRequestFocus: (isEnabled ?? true),
                        child: Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 25,
                          color: iconColor,
                        ),
                        onTap: () {
                          if (isEnabled ?? true) {
                            if (!isNegativeReq) {
                              print("Click on negative>>>" +
                                  controller.text);
                              if (controller.text != "0") {
                                controller.text =
                                "${(int.tryParse(controller.text) ?? 1) - 1}";
                                onchanged!(controller.text);
                              }
                            } else {
                              controller.text =
                              "${(int.tryParse(controller.text) ?? 1) - 1}";
                              onchanged!(controller.text);
                            }
                          } else {
                            print("Print tap");
                          }
                        },
                      ),
                    ],
                  )
                      : SizedBox(),
                ),
                controller: controller,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget timeField3(
      {required String hintTxt, required TextEditingController controller, double? widthRatio, double? height, double? paddingLeft}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: paddingLeft ?? 10),
          child: LabelText.style(hint: hintTxt),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: paddingLeft ?? 10),
          height: height ?? SizeDefine.heightInputField,
          width: Get.width * (widthRatio ?? 0.12),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9:]'),
              )
            ],
            textAlign: TextAlign.left,
            controller: controller,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
                errorBorder: InputBorder.none,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
                border: InputBorder.none,
                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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

  static Widget textAreaWidth(
      {required String hintTxt,
      minlines = 3,
      Function(String)? onchanged,
      required TextEditingController controller,
      required double widthRatio,
      double? paddingLeft}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: paddingLeft ?? 10),
          child: LabelText.style(hint: hintTxt),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: paddingLeft ?? 10),

          width: Get.width * widthRatio,
          child: TextFormField(
            onChanged: onchanged,
            // textAlignVertical: TextAlignVertical.center,
            // textAlign: TextAlign.left,
            minLines: minlines,
            maxLines: 6,
            controller: controller,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
                errorBorder: InputBorder.none,

                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
                border: InputBorder.none,
                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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

  static Widget formFieldDisable(
      {required String hintTxt,
      required String value,
      Color color = Colors.white,
      double? widthRatio,
      double? leftPad,
      double? height,
      bool margin = false}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: margin ? 10 : 0),
          child: LabelText.style(hint: hintTxt, txtColor: Colors.grey),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: margin ? 10 : 0),
          height: height ?? SizeDefine.heightInputField,
          width: Get.width * (widthRatio ?? 0.12),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            controller: TextEditingController()..text = value,
            enabled: false,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            decoration: InputDecoration(
                filled: true,
                fillColor: color,
                errorBorder: InputBorder.none,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.grey),
                border: InputBorder.none,
                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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
    );
  }

  static Widget formFieldDisable1(
      {required String hintTxt, required String value, Color color = Colors.white, double? widthRatio, double? leftPad, bool margin = false}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: leftPad ?? 10),
          child: LabelText.style(hint: hintTxt, txtColor: Colors.grey),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: leftPad ?? 10),
          height: SizeDefine.heightInputField,
          width: Get.width * (widthRatio ?? 0.12),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            controller: TextEditingController()..text = value,
            enabled: false,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            decoration: InputDecoration(
                filled: true,
                fillColor: color,
                errorBorder: InputBorder.none,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.grey),
                border: InputBorder.none,
                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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
    );
  }

  static Widget timeField(
      {required String hintTxt,
      required String value,
      required double widthRatio,
      // required BuildContext context,
      required VoidCallback callback,
      required TextEditingController controller,
      double? height,
      double? paddingLeft}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: LabelText.style(hint: hintTxt),
        ),
        Container(
          margin: EdgeInsets.only(left: paddingLeft ?? 10),
          height: (height != null) ? height : SizeDefine.heightInputField,
          width: Get.width * widthRatio,
          child: TextField(
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              controller: controller,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              decoration: InputDecoration(
                  errorBorder: InputBorder.none,
                  errorText: controller.text == "" ? 'Invalid ${hintTxt}' : null,
                  // hintText: "dd/MM/yyyy",
                  contentPadding: const EdgeInsets.only(left: 10),
                  // labelText: hintTxt,
                  labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.grey),
                  border: InputBorder.none,
                  // suffixIcon: Icon(
                  //   Icons.calendar_today,
                  //   size: 14,
                  //   color: Colors.deepPurpleAccent,
                  // ),
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
              // controller: timeinController ,
              // readOnly: true,
              onTap: callback),
        ),
      ],
    );
  }

  static Widget checkBoxField(
      {required String hintTxt, required bool? value, required double widthRatio, double? height, double? paddingLeft, callback}) {
    return Container(
      // margin: EdgeInsets.only(left: paddingLeft ?? 10),
      // margin: EdgeInsets.symmetric(vertical: 1),
      padding: EdgeInsets.all(0),
      height: (height != null) ? height : SizeDefine.heightInputField,
      width: Get.width * widthRatio,
      child: CheckboxListTile(
        // contentPadding: EdgeInsets.all(0),
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: Text(
          hintTxt,
          style: TextStyle(fontSize: 14),
        ),
        value: value,
        onChanged: callback,
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
    );
  }

  static Widget formFieldDisableWidth(
      {required String hintTxt, required String value, required double widthRatio, double? height, double? paddingLeft, Function? onEditComplete}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: paddingLeft ?? 10),
          child: LabelText.style(hint: hintTxt, txtColor: Colors.grey),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: paddingLeft ?? 10),
          height: (height != null) ? height : SizeDefine.heightInputField,
          width: Get.width * widthRatio,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            controller: TextEditingController()..text = value,
            enabled: false,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            onEditingComplete: () {
              onEditComplete!();
            },
            decoration: InputDecoration(
                errorBorder: InputBorder.none,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.grey),
                border: InputBorder.none,
                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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
    );
  }

  static Widget formFieldDisableWidth1(
      {required String hintTxt,
      required String value,
      required double widthRatio,
      double? height,
      double? paddingLeft,
      TextEditingController? controller,
      Function? onEditComplete}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: paddingLeft ?? 10),
          child: LabelText.style(hint: hintTxt, txtColor: Colors.grey),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: paddingLeft ?? 10),
          height: (height != null) ? height : SizeDefine.heightInputField,
          width: Get.width * widthRatio,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            controller: controller ?? TextEditingController()
              ..text = value,
            enabled: false,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            onEditingComplete: () {
              onEditComplete!();
            },
            decoration: InputDecoration(
                errorBorder: InputBorder.none,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.grey),
                border: InputBorder.none,
                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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
    );
  }

  static Widget formFieldDisableWidth2(
      {required String hintTxt,
      required String value,
      required double widthRatio,
      double? height,
      double? paddingLeft,
      int? maxChar,
      FocusNode? focusNode,
      TextEditingController? controller,
      Function? onChange}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: paddingLeft ?? 10),
          child: LabelText.style(hint: hintTxt, txtColor: Colors.grey),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: paddingLeft ?? 10),
          height: (height != null) ? height : SizeDefine.heightInputField,
          width: Get.width * widthRatio,

          child: TextField(
            focusNode: focusNode ?? null,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            controller: controller ?? TextEditingController()
              ..text = value,
            // enabled: false,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            onChanged: (v) {
              onChange!(v);
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxChar ?? SizeDefine.maxcharlimit),
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9]'),
              ),
            ],

            decoration: InputDecoration(
                errorBorder: InputBorder.none,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.grey),
                border: InputBorder.none,
                // suffixIcon: Icon(
                //   Icons.calendar_today,
                //   size: 14,
                //   color: Colors.deepPurpleAccent,
                // ),
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
    );
  }

  static Widget formFieldDisableDt({required String hintTxt, required String value}) {
    // var data = 0.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: LabelText.style(hint: hintTxt, txtColor: Colors.grey),
        ),
        Container(
          // padding: const EdgeInsets.only(
          //     top: 6.0,
          //     bottom: 6.0),
          margin: EdgeInsets.only(left: 10),
          height: SizeDefine.heightInputField,
          width: Get.width * 0.12,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.left,
            controller: TextEditingController()..text = value,
            enabled: false,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
                errorBorder: InputBorder.none,
                // hintText: "dd/MM/yyyy",
                contentPadding: const EdgeInsets.only(left: 10),
                // labelText: hintTxt,
                labelStyle: TextStyle(fontSize: SizeDefine.labelSize, color: Colors.grey),
                border: InputBorder.none,
                suffixIcon: Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey,
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
    );
  }
}

class RangeTextInputFormatter24 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '')
      return TextEditingValue();
    else if (int.parse(newValue.text) < 1) return TextEditingValue().copyWith(text: '1');

    return int.parse(newValue.text) > 24 ? TextEditingValue().copyWith(text: '24') : newValue;
  }
}

class RangeTextInputFormatter60 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '')
      return TextEditingValue();
    else if (int.parse(newValue.text) < 1) return TextEditingValue().copyWith(text: Utils.twoDigitsString('1'));

    return int.parse(newValue.text) > 60 ? TextEditingValue().copyWith(text: Utils.twoDigitsString('60')) : newValue;
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length && mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}

class DateTextFormatterWithSlash extends TextInputFormatter {
  static const _maxChars = 80;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String separator = '/';
    var text = _format(
      newValue.text,
      oldValue.text,
      separator,
    );

    return newValue.copyWith(
      text: text,
      selection: updateCursorPosition(
        oldValue,
        text,
      ),
    );
  }

  String _format(
    String value,
    String oldValue,
    String separator,
  ) {
    var isErasing = value.length < oldValue.length;
    var isComplete = value.length > _maxChars + 2;

    if (!isErasing && isComplete) {
      return oldValue;
    }

    value = value.replaceAll(separator, '');
    final result = <String>[];

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      result.add(value[i]);
      if ((i == 1 || i == 3) && i != value.length - 1) {
        result.add(separator);
      }
    }

    return result.join();
  }

  TextSelection updateCursorPosition(
    TextEditingValue oldValue,
    String text,
  ) {
    var endOffset = max(
      oldValue.text.length - oldValue.selection.end,
      0,
    );

    var selectionEnd = text.length - endOffset;

    return TextSelection.fromPosition(TextPosition(offset: selectionEnd));
  }
}

class DateTextFormatterWithMinus extends TextInputFormatter {
  static const _maxChars = 8;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String separator = '-';
    var text = _format(
      newValue.text,
      oldValue.text,
      separator,
    );

    return newValue.copyWith(
      text: text,
      selection: updateCursorPosition(
        oldValue,
        text,
      ),
    );
  }

  String _format(
    String value,
    String oldValue,
    String separator,
  ) {
    var isErasing = value.length < oldValue.length;
    var isComplete = value.length > _maxChars + 2;

    if (!isErasing && isComplete) {
      return oldValue;
    }

    value = value.replaceAll(separator, '');
    final result = <String>[];

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      result.add(value[i]);
      if ((i == 1 || i == 3) && i != value.length - 1) {
        result.add(separator);
      }
    }

    return result.join();
  }

  TextSelection updateCursorPosition(
    TextEditingValue oldValue,
    String text,
  ) {
    var endOffset = max(
      oldValue.text.length - oldValue.selection.end,
      0,
    );

    var selectionEnd = text.length - endOffset;

    return TextSelection.fromPosition(TextPosition(offset: selectionEnd));
  }
}

class TimeTextFormatterWithColun extends TextInputFormatter {
  static const _maxChars = 6;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String separator = ':';
    var text = _format(
      newValue.text,
      oldValue.text,
      separator,
    );

    return newValue.copyWith(
      text: text,
      selection: updateCursorPosition(
        oldValue,
        text,
      ),
    );
  }

  String _format(
    String value,
    String oldValue,
    String separator,
  ) {
    var isErasing = value.length < oldValue.length;
    var isComplete = value.length > _maxChars + 2;
    if (!isErasing && isComplete) {
      return oldValue;
    }
    value = value.replaceAll(separator, '');
    final result = <String>[];
    for (int i = 0; i < min(value.length, _maxChars); i++) {
      print("index $i value:${value[i]}");
      bool canAdd = true;
      if (i == 1) {
        int hours = int.tryParse(value[0] + value[1]) ?? -1;
        if (hours > 24) {
          canAdd = false;
        }
      }
      if (i == 2 || i == 4) {
        int minute = int.tryParse(value[i]) ?? -1;
        if (minute > 5) {
          canAdd = false;
        }
      }

      result.add(canAdd ? value[i] : "0");
      if ((i == 1 || i == 3) && i != value.length - 1) {
        result.add(separator);
      }
    }
    return result.join();
  }

  TextSelection updateCursorPosition(
    TextEditingValue oldValue,
    String text,
  ) {
    var endOffset = max(
      oldValue.text.length - oldValue.selection.end,
      0,
    );

    var selectionEnd = text.length - endOffset;

    return TextSelection.fromPosition(TextPosition(offset: selectionEnd));
  }
}

/// Uppercase text formater
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(oldValue, TextEditingValue newValue) =>
      TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection);
}
