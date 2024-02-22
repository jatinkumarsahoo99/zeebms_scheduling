import 'package:bms_scheduling/widgets/text_drop_down.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../app/controller/ConnectorControl.dart';
import '../app/data/DropDownValue.dart';
import '../app/data/system_envirtoment.dart';
import '../app/providers/SizeDefine.dart';
import 'CustomSearchDropDown/dropdown_search.dart';
import 'CustomSearchDropDown/src/popupMenu.dart';
import 'LabelTextStyle.dart';

class DropDownField {
  static Widget formDropDown(List items, Function callback) {
    return Padding(
        padding: const EdgeInsets.only(
            left: SizeDefine.paddingHorizontal,
            right: SizeDefine.paddingHorizontal,
            top: 6.0,
            bottom: 6.0),
        child: DropdownButtonFormField(
          items: items.map((item) {
            return DropdownMenuItem(
                value: item,
                child: Text(
                  item.value!,
                  style: TextStyle(fontSize: SizeDefine.fontSizeInputField),
                ));
          }).toList(),
          onChanged: (newValue) {
            // value = newValue.obs;
            callback(newValue);
          },
          icon: const Padding(
            padding: EdgeInsets.only(right: 18.0),
            child: Icon(Icons.arrow_drop_down),
          ),
          // iconSize: 42,
          // value: items.value,
        ));
  }

  static Widget textDropdownFormFieldwithratio({
    required BuildContext context,
    required List<String>? items,
    required String label,
    required String seleceted,
    required DropdownEditingController<String> controller,
    widthRatio = 0.20,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      height: SizeDefine.heightInputField,
      width: MediaQuery.of(context).size.width * widthRatio,
      child: CustomTextDropdownFormField(
        controller: controller,
        options: items!,
        decoration: InputDecoration(
          // hintText: "dd/MM/yyyy",
          contentPadding: const EdgeInsets.only(left: 10),
          labelText: label,
          labelStyle:
              TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
          border: InputBorder.none,
          // suffixIcon: Icon(
          //   Icons.calendar_today,
          //   size: 14,
          //   color: Colors.deepPurpleAccent,
          // ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.circular(10),
          ),

          errorBorder: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        dropdownHeight: MediaQuery.of(context).size.height / 3,
      ),
    );
  }

  static Widget apisearchDropdownWithRatio({
    required BuildContext context,
    required String label,
    DropDownValue? selectedvalue,
    required Function(DropDownValue? value) seleceted,
    required Future<List<DropDownValue>> Function(String? filter)? api,
    widthRatio = 0.20,
    String? Function(DropDownValue? value)? validator,
  }) {
    return Focus(
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        height: SizeDefine.heightInputField,
        width: MediaQuery.of(context).size.width * widthRatio,
        child: DropdownSearch<DropDownValue>(
          itemAsString: (item) => item!.value!,
          validator: validator,
          selectedItem: selectedvalue,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          dropdownSearchDecoration: InputDecoration(
            // hintText: "dd/MM/yyyy",
            contentPadding: const EdgeInsets.only(left: 10),
            labelText: label,
            labelStyle:
                TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
            border: InputBorder.none,
            // suffixIcon: Icon(
            //   Icons.calendar_today,
            //   size: 14,
            //   color: Colors.deepPurpleAccent,
            // ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepPurpleAccent),
              borderRadius: BorderRadius.circular(10),
            ),

            errorBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepPurpleAccent),
              borderRadius: BorderRadius.circular(10),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          showSearchBox: true,
          onFind: api,
          onChanged: seleceted,
        ),
      ),
    );
  }

  static Widget searchDropdownWithRatio({
    required BuildContext context,
    required List<DropDownValue>? items,
    required String label,
    DropDownValue? selectedItem,
    TextEditingController? controller,
    required Function(DropDownValue? value) seleceted,
    String? Function(DropDownValue? value)? validator,
    widthRatio = 0.20,
    RxBool? enable,
    bool margin = false,
    bool autoFocus = false,
    double dialogHeight = 350.0,
  }) {
    enable ??= RxBool(true);
    final widgetKey = GlobalKey();
    final textColor = (enable.value) ? Colors.black : Colors.grey;
    final iconLineColor =
        (enable.value) ? Colors.deepPurpleAccent : Colors.grey;
    FocusNode inkWellFocusNode = FocusNode();
    final _scrollController = ScrollController();
    return Column(
      key: widgetKey,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: SizeDefine.labelSize1,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        StatefulBuilder(builder: (context, re) {
          return InkWell(
              autofocus: autoFocus,
              focusNode: inkWellFocusNode,
              // onFocusChange: onFocusChange,
              onTap: !enable!.value
                  ? null
                  : () {
                      if ((items == null || items.isEmpty)) {
                        return;
                      }
                      var isLoading = RxBool(false);
                      var tempList = RxList<DropDownValue>([]);
                      tempList.addAll(items);
                      final width =
                          (widgetKey.currentContext?.size?.width ?? 200);
                      final height =
                          (widgetKey.currentContext?.size?.height ?? 200);
                      var box = widgetKey.currentContext!.findRenderObject()
                          as RenderBox;
                      var startpoints = box.localToGlobal(Offset(0, height));
                      showMenu(
                        context: context,
                        position: RelativeRect.fromSize(
                            (startpoints & const Size(0, 0)), Get.size),
                        constraints: BoxConstraints.expand(
                          width: width,
                          height: dialogHeight,
                        ),
                        items: [
                          CustomPopupMenuItem(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: SizeDefine.fontSizeInputField),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              height: dialogHeight - 20,
                              child: Column(
                                children: [
                                  /// search
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(12),
                                      isDense: true,
                                      isCollapsed: true,
                                      hintText: "Search",
                                    ),
                                    autofocus: true,
                                    style: TextStyle(
                                      fontSize: SizeDefine.fontSizeInputField,
                                    ),
                                    onChanged: ((value) {
                                      if (value.isNotEmpty) {
                                        tempList.clear();
                                        for (var i = 0; i < items.length; i++) {
                                          if (items[i]
                                              .value!
                                              .toLowerCase()
                                              .contains(value.toLowerCase())) {
                                            tempList.add(items[i]);
                                          }
                                        }
                                      }
                                    }),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny("  "),
                                    ],
                                  ),

                                  /// progreesbar
                                  Obx(() {
                                    return Visibility(
                                      visible: isLoading.value,
                                      child: const LinearProgressIndicator(
                                        minHeight: 3,
                                      ),
                                    );
                                  }),

                                  const SizedBox(height: 5),

                                  /// list
                                  Expanded(
                                    child: Obx(
                                      () {
                                        return Scrollbar(
                                          controller: _scrollController,
                                          isAlwaysShown: true,
                                          child: ListView(
                                            controller: _scrollController,
                                            shrinkWrap: true,
                                            children: tempList
                                                .map(
                                                  (element) => InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      selectedItem = element;
                                                      seleceted(element);
                                                      re(() {});
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              inkWellFocusNode);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8),
                                                      child: Text(
                                                        element.value ?? "null",
                                                        style: TextStyle(
                                                          fontSize: SizeDefine
                                                                  .dropDownFontSize -
                                                              1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
              child: Container(
                width: Get.width * widthRatio,
                height: SizeDefine.heightInputField,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: iconLineColor,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 4),
                        child: Text(
                          (selectedItem?.value ?? ""),
                          style: TextStyle(
                            fontSize: SizeDefine.fontSizeInputField,
                            color: textColor,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    )),
                    Icon(
                      Icons.arrow_drop_down,
                      color: iconLineColor,
                    )
                  ],
                ),
              ));
        }),
      ],
    );
    // enable ??= RxBool(true);
    // controller ??= TextEditingController(text: "");
    // if (selectedItem != null) {
    //   controller.text = selectedItem.value!;
    // }
    // DropDownValue _selectedItem = DropDownValue();
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.only(left: margin ? 10 : 0),
    //       child: LabelText.style(
    //         hint: label,
    //       ),
    //     ),
    //     Obx(
    //       () => Container(
    //         decoration: BoxDecoration(
    //             border: Border.all(
    //                 color:
    //                     enable!.value ? Colors.deepPurpleAccent : Colors.grey)),
    //         height: SizeDefine.heightInputField,
    //         margin: EdgeInsets.only(left: margin ? 10 : 0, top: 0),
    //         width: MediaQuery.of(context).size.width * widthRatio,
    //         child: InkWell(
    //           autofocus: autoFocus,
    //           onTap: () {
    //             if (enable!.value) {
    //               showDialog(
    //                   context: context,
    //                   useRootNavigator: true,
    //                   builder: (context) {
    //                     var keyword = RxString(controller!.text);
    //                     return Dialog(
    //                       child: Container(
    //                         width: MediaQuery.of(context).size.width / 3,
    //                         constraints: BoxConstraints(
    //                             maxHeight:
    //                                 MediaQuery.of(context).size.height / 2),
    //                         child: Padding(
    //                           padding: const EdgeInsets.all(12.0),
    //                           child: Column(
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               TextField(
    //                                 style: TextStyle(
    //                                     fontSize:
    //                                         SizeDefine.fontSizeInputField),
    //                                 autofocus: true,
    //                                 onChanged: (value) {
    //                                   keyword.value = value;
    //                                 },
    //                                 decoration: const InputDecoration(
    //                                     border: InputBorder.none,
    //                                     hintText:
    //                                         'What do you want to search?'),
    //                               ),
    //                               Expanded(
    //                                   child: Obx(
    //                                 () => keyword.value == ""
    //                                     ? ListView(
    //                                         controller: ScrollController(),
    //                                         shrinkWrap: true,
    //                                         children: [
    //                                           for (var item in items!)
    //                                             ListTile(
    //                                               onTap: () {
    //                                                 controller?.text =
    //                                                     item.value!;
    //                                                 Get.back();
    //                                                 seleceted(item);
    //                                                 // Navigator.pop(context);
    //                                               },
    //                                               title: Text(
    //                                                 item.value!,
    //                                                 style: TextStyle(
    //                                                     fontSize: SizeDefine
    //                                                         .fontSizeInputField),
    //                                               ),
    //                                             )
    //                                         ],
    //                                       )
    //                                     : ListView(
    //                                         controller: ScrollController(),
    //                                         shrinkWrap: true,
    //                                         children: [
    //                                           for (var item in items!.where(
    //                                               (element) => element.value!
    //                                                   .toLowerCase()
    //                                                   .contains(keyword.value
    //                                                       .toLowerCase())))
    //                                             ListTile(
    //                                               onTap: () {
    //                                                 controller?.text =
    //                                                     item.value!;
    //                                                 seleceted(item);
    //                                                 Navigator.pop(context);
    //                                               },
    //                                               title: Text(item.value!,
    //                                                   style: TextStyle(
    //                                                       fontSize: SizeDefine
    //                                                           .fontSizeInputField)),
    //                                             )
    //                                         ],
    //                                       ),
    //                               ))
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     );
    //                   });
    //             } else {
    //               null;
    //             }
    //           },
    //           child: Row(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Container(
    //                 width: (Get.width * widthRatio) - 30,
    //                 child: AbsorbPointer(
    //                   child: TextFormField(
    //                     enabled: false,
    //                     validator: (value) {
    //                       validator!(_selectedItem);
    //                     },
    //                     autovalidateMode: AutovalidateMode.onUserInteraction,
    //                     style:
    //                         TextStyle(fontSize: SizeDefine.fontSizeInputField),
    //                     readOnly: true,
    //                     controller: controller,
    //                     decoration: InputDecoration(
    //                       disabledBorder: const OutlineInputBorder(
    //                           borderSide:
    //                               BorderSide(color: Colors.transparent)),
    //                       enabledBorder: const OutlineInputBorder(
    //                           borderSide:
    //                               BorderSide(color: Colors.transparent)),
    //                       focusedBorder: const OutlineInputBorder(
    //                           borderSide:
    //                               BorderSide(color: Colors.transparent)),
    //                       errorBorder: InputBorder.none,
    //                       contentPadding: const EdgeInsets.only(left: 10),

    //                       labelStyle: TextStyle(
    //                           fontSize: SizeDefine.labelSize,
    //                           color: Colors.black),

    //                       border: InputBorder.none,

    //                       // suffixIcon: Icon(
    //                       //   Icons.calendar_today,
    //                       //   size: 14,
    //                       //   color: Colors.deepPurpleAccent,
    //                       // ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(right: 4),
    //                 child: Icon(
    //                   Icons.arrow_drop_down,
    //                   color:
    //                       enable.value ? Colors.deepPurpleAccent : Colors.grey,
    //                   size: 24,
    //                 ),
    //               ),
    //               // const SizedBox(height: 10)
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  static Widget searchDropdownWithRatio1(
      {required BuildContext context,
      required List<DropDownValue>? items,
      required String label,
      DropDownValue? selectedItem,
      required Function(DropDownValue? value) seleceted,
      widthRatio = 0.20,
      double? height,
      String? Function(DropDownValue? value)? validator,
      controller}) {
    return Focus(
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        height: height ?? SizeDefine.heightInputField,
        width: MediaQuery.of(context).size.width * widthRatio,
        child: DropdownSearch<DropDownValue>(
          validator: validator,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          selectedItem: selectedItem,
          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem == null ? "" : selectedItem.value!,
              style: TextStyle(
                  color: Colors.black, fontSize: SizeDefine.fontSizeInputField),
            );
          },
          dropdownButtonProps: IconButtonProps(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(3),
              focusNode: AlwaysDisabledFocusNode(),
              alignment: Alignment.topCenter,
              icon: const Icon(Icons.arrow_drop_down_outlined)),
          showSearchBox: true,
          isFilteredOnline: false,
          dialogMaxWidth: MediaQuery.of(context).size.width / 3,
          maxHeight: MediaQuery.of(context).size.height / 2,
          itemAsString: (item) => item!.value!,
          dropdownSearchDecoration: InputDecoration(
            // hintText: "dd/MM/yyyy",
            contentPadding: const EdgeInsets.only(left: 10),
            labelText: label,

            labelStyle:
                TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            // suffixIcon: Icon(
            //   Icons.calendar_today,
            //   size: 14,
            //   color: Colors.deepPurpleAccent,
            // ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepPurpleAccent),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepPurpleAccent),
              borderRadius: BorderRadius.circular(10),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: items!,
          onChanged: seleceted,
        ),
      ),
    );
  }

  static Widget searchDropdownWithRatio2(
      {required BuildContext context,
      required List<DropDownValue>? items,
      required String label,
      DropDownValue? selectedItem,
      required Function(DropDownValue? value) seleceted,
      widthRatio = 0.20,
      double? height,
      String? Function(DropDownValue? value)? validator,
      controller}) {
    // print("Selected Item???>>>"+jsonEncode(selectedItem??{}));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: LabelText.style(hint: label),
        ),
        Container(
          margin: const EdgeInsets.only(left: 0),
          height: height ?? SizeDefine.heightInputField,
          width: MediaQuery.of(context).size.width * widthRatio,
          child: DropdownSearch<DropDownValue>(
            // validator: validator,
            // autoValidateMode: AutovalidateMode.onUserInteraction,
            selectedItem: selectedItem ?? null,
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem == null ? "" : selectedItem.value!,
                style: TextStyle(
                    fontSize: SizeDefine.fontSizeInputField,
                    color: Colors.black),
              );
            },
            dropdownButtonProps: IconButtonProps(
                visualDensity: VisualDensity.compact,
                focusNode: AlwaysDisabledFocusNode(),
                padding: const EdgeInsets.all(3),
                alignment: Alignment.centerRight,
                icon: const Icon(Icons.arrow_drop_down_outlined)),
            showSearchBox: true,
            isFilteredOnline: false,
            dialogMaxWidth: MediaQuery.of(context).size.width / 3,
            maxHeight: MediaQuery.of(context).size.height / 2,
            itemAsString: (item) => item!.value!,
            dropdownSearchDecoration: InputDecoration(
              // hintText: "dd/MM/yyyy",
              contentPadding: const EdgeInsets.only(left: 10),
              // labelText: label,

              labelStyle: TextStyle(
                  fontSize: SizeDefine.labelSize, color: Colors.black),
              border: InputBorder.none,
              // suffixIcon: Icon(
              //   Icons.calendar_today,
              //   size: 14,
              //   color: Colors.deepPurpleAccent,
              // ),
              errorBorder: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                borderRadius: BorderRadius.circular(0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                borderRadius: BorderRadius.circular(0),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            items: items,
            onChanged: seleceted,
          ),
        ),
      ],
    );
  }

  static Widget simpleDropDownwithWidthRatio(
    List<DropDownValue> items,
    Function(DropDownValue? value) seleceted,
    String hint,
    widthRatio,
    context, {
    DropDownValue? value,
    double? leftpad = 10,
    bool autoFocus = false,
    PopupMenuPosition position = PopupMenuPosition.under,
    RxBool? enable,
    TextEditingController? controller,
    String? Function(DropDownValue? value)? validator,
  }) {
    enable ??= RxBool(true);
    controller ??= TextEditingController(text: "");
    if (value != null) {
      controller.text = value.value!;
    }
    DropDownValue _selectedItem = DropDownValue();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: leftpad!),
          child: LabelText.style(hint: hint),
        ),
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.deepPurpleAccent)),
          margin: EdgeInsets.only(left: leftpad),
          height: SizeDefine.heightInputField,
          width: MediaQuery.of(context).size.width * widthRatio,

          child: Obx(
            () => PopupMenuButton<DropDownValue>(
              enabled: enable!.value,
              constraints: BoxConstraints(maxHeight: Get.height / 2),
              position: position,
              itemBuilder: (context) => <PopupMenuEntry<DropDownValue>>[
                for (var item in items)
                  PopupMenuItem<DropDownValue>(
                    padding: const EdgeInsets.all(3),
                    height: SizeDefine.heightInputField,
                    value: item,
                    child: Text(
                      item.value!,
                      style: TextStyle(fontSize: SizeDefine.fontSizeInputField),
                    ),
                  )
              ],
              onSelected: (value) {
                controller!.text = value.value!;
                _selectedItem = value;
                seleceted(value);
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: (Get.width * widthRatio) - 30,
                    child: AbsorbPointer(
                      child: TextFormField(
                        enabled: false,
                        autofocus: autoFocus,
                        validator: (val) {
                          validator!(DropDownValue());
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(
                            fontSize: SizeDefine.fontSizeInputField,
                            color: Colors.black),
                        readOnly: true,
                        controller: controller,
                        decoration: InputDecoration(
                          disabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          errorBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 10),

                          labelStyle: TextStyle(
                              fontSize: SizeDefine.labelSize,
                              color: Colors.black),

                          border: InputBorder.none,

                          // suffixIcon: Icon(
                          //   Icons.calendar_today,
                          //   size: 14,
                          //   color: Colors.deepPurpleAccent,
                          // ),
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blueGrey,
                    size: 24,
                  )
                ],
              ),
            ),
          ),
          // child: DropdownSearch<DropDownValue>(
          //     focusNode: AlwaysDisabledFocusNode(),
          //     autoValidateMode: AutovalidateMode.onUserInteraction,
          //     validator: validator,
          //     selectedItem: value,
          //     dropdownBuilder: (context, selectedItem) {
          //       return Text(
          //         selectedItem == null ? "" : selectedItem.value!,
          //         style: TextStyle(
          //             fontSize: SizeDefine.fontSizeInputField - 2,
          //             color: Colors.black),
          //       );
          //     },
          //     dropdownButtonProps: IconButtonProps(
          //         visualDensity: VisualDensity.compact,
          //         padding: EdgeInsets.all(3),
          //         focusNode: AlwaysDisabledFocusNode(),
          //         alignment: Alignment.topCenter,
          //         icon: Icon(Icons.arrow_drop_down_outlined)),
          //     showSearchBox: false,
          //     isFilteredOnline: false,
          //     mode: Mode.MENU,
          //     itemAsString: (item) => item!.value!,
          //     dropdownSearchDecoration: InputDecoration(
          //       // hintText: "dd/MM/yyyy",
          //       contentPadding: const EdgeInsets.only(left: 10),
          //       // labelText: hint,

          //       labelStyle: TextStyle(
          //           fontSize: SizeDefine.labelSize, color: Colors.black),
          //       border: InputBorder.none,
          //       // suffixIcon: Icon(
          //       //   Icons.calendar_today,
          //       //   size: 14,
          //       //   color: Colors.deepPurpleAccent,
          //       // ),
          //       enabledBorder: OutlineInputBorder(
          //         borderSide: BorderSide(color: Colors.deepPurpleAccent),
          //         borderRadius: BorderRadius.circular(0),
          //       ),
          //       errorBorder: InputBorder.none,
          //       focusedBorder: OutlineInputBorder(
          //         borderSide: BorderSide(color: Colors.deepPurpleAccent),
          //         borderRadius: BorderRadius.circular(0),
          //       ),
          //       floatingLabelBehavior: FloatingLabelBehavior.always,
          //     ),
          //     items: items,
          //     onChanged: (value) {
          //       seleceted(value);
          //     }),
        ),
      ],
    );
  }

  static Widget simpleDropDownwithWidthRatio2(
    List<SystemEnviroment> items,
    Function(SystemEnviroment? value) seleceted,
    String hint,
    widthRatio,
    context, {
    SystemEnviroment? value,
    String? Function(SystemEnviroment? value)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: LabelText.style(hint: hint),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10),
          height: SizeDefine.heightInputField,
          width: MediaQuery.of(context).size.width * widthRatio,
          child: DropdownSearch<SystemEnviroment>(
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            selectedItem: value,
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem == null ? "" : selectedItem.value!,
                style: TextStyle(
                    fontSize: SizeDefine.fontSizeInputField,
                    color: Colors.black),
              );
            },
            dropdownButtonProps: IconButtonProps(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(3),
                focusNode: AlwaysDisabledFocusNode(),
                alignment: Alignment.topCenter,
                icon: const Icon(Icons.arrow_drop_down_outlined)),
            showSearchBox: false,
            isFilteredOnline: false,
            mode: Mode.MENU,
            itemAsString: (item) => item!.value!,
            dropdownSearchDecoration: InputDecoration(
              // hintText: "dd/MM/yyyy",
              contentPadding: const EdgeInsets.only(left: 10),
              // labelText: hint,

              labelStyle: TextStyle(
                  fontSize: SizeDefine.labelSize, color: Colors.black),
              border: InputBorder.none,
              // suffixIcon: Icon(
              //   Icons.calendar_today,
              //   size: 14,
              //   color: Colors.deepPurpleAccent,
              // ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                borderRadius: BorderRadius.circular(0),
              ),
              errorBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                borderRadius: BorderRadius.circular(0),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            items: items,
            onChanged: seleceted,
          ),
        ),
      ],
    );
  }

  static Widget simpleDropDownwithWidthRatio1(
      List<DropDownValue> items,
      Function(DropDownValue? value) seleceted,
      String hint,
      widthRatio,
      context,
      String? Function(DropDownValue? value)? validator,
      selected) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      height: SizeDefine.heightInputField,
      width: MediaQuery.of(context).size.width * widthRatio,
      child: DropdownButtonFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        // value: value,
        isExpanded: true,
        enableFeedback: true,
        items: items.map((item) {
          return DropdownMenuItem(
              value: item,
              child: Text(
                item.value!,
                style: TextStyle(fontSize: SizeDefine.fontSizeInputField),
              ));
        }).toList(),
        onChanged: seleceted,
        style: TextStyle(fontSize: SizeDefine.fontSizeInputField),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 10),
          labelText: hint,
          labelStyle:
              TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),
          border: InputBorder.none,
          // suffixIcon: Icon(
          //   Icons.calendar_today,
          //   size: 14,
          //   color: Colors.deepPurpleAccent,
          // ),
          errorBorder: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  static Widget formDropDown1(
    List items,
    Function callback,
    String hint, {
    double? height,
    SystemEnviroment? selected,
    String? Function(Object? value)? validator,
  }) {
    return Padding(
        padding: const EdgeInsets.only(
            // left: SizeBox.paddingHorizontal,
            // right: SizeBox.paddingHorizontal,
            left: 5,
            top: 6.0,
            bottom: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(hint,style: TextStyle(
            //     fontSize: SizeDefine.labelSize1, color: Colors.black),),
            // SizedBox(height: SizeDefine.marginGap,),
            LabelText.style(hint: hint),
            SizedBox(
              height: height ?? SizeDefine.heightInputField,
              width: Get.width * 0.1,
              child: DropdownButtonFormField(
                isExpanded: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validator,
                items: items.map((item) {
                  return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item.value,
                        style:
                            TextStyle(fontSize: SizeDefine.fontSizeInputField),
                      ));
                }).toList(),
                onChanged: (newValue) {
                  // value = newValue.obs;
                  callback(newValue);
                },
                value: selected,
                style: TextStyle(fontSize: SizeDefine.fontSizeInputField),

                decoration: InputDecoration(
                    // labelText: hint,
                    labelStyle: TextStyle(
                        fontSize: SizeDefine.labelSize, color: Colors.black),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    errorBorder: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: Get.width * 0.013,
                ),
                // iconSize: 42,
                // value: items.value,
              ),
            ),
          ],
        ));
  }

  static Widget formDropDown2(
      List<SystemEnviroment>? items, Function callback, String hint,
      {double? height, double? widthRatio, DropdownMenuItem? selectedItem}) {
    return Padding(
        padding: const EdgeInsets.only(
            // left: SizeBox.paddingHorizontal,
            // right: SizeBox.paddingHorizontal,
            left: 5,
            top: 6.0,
            bottom: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Text(hint,style: TextStyle(
                fontSize: SizeDefine.labelSize1, color: Colors.black),),
            SizedBox(height: SizeDefine.marginGap,),*/
            LabelText.style(hint: hint),
            SizedBox(
              height: height ?? SizeDefine.heightInputField,
              width: widthRatio ?? Get.width * 0.1,
              child: DropdownButtonFormField(
                isExpanded: true,
                items: items?.map((item) {
                  return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item.value ?? "",
                        style:
                            TextStyle(fontSize: SizeDefine.fontSizeInputField),
                        overflow: TextOverflow.ellipsis,
                      ));
                }).toList(),
                onChanged: (newValue) {
                  // value = newValue.obs;
                  callback(newValue);
                },
                value: selectedItem,
                style: TextStyle(fontSize: SizeDefine.fontSizeInputField),
                decoration: InputDecoration(
                    labelText: hint,
                    contentPadding: const EdgeInsets.only(left: 8),
                    labelStyle: TextStyle(
                        fontSize: SizeDefine.labelSize, color: Colors.black),
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: Get.width * 0.013,
                ),
                // iconSize: 42,
                // value: items.value,
              ),
            ),
          ],
        ));
  }

  static Widget formDropDownSelected(
    List<SystemEnviroment>? items,
    Function callback,
    String hint,
    SystemEnviroment? value, {
    double? height,
    Key? key,
    double? widthRatio,
    bool? searchReq,
    double? paddingLeft,
    bool? isEnable,
  }) {
    // return Padding(
    //     padding: const EdgeInsets.only(
    //         // left: SizeBox.paddingHorizontal,
    //         // right: SizeBox.paddingHorizontal,
    //         left: 5,
    //         top: 6.0,
    //         bottom: 6.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         /*Text(hint,style: TextStyle(
    //             fontSize: SizeDefine.labelSize1, color: Colors.black),),
    //         SizedBox(height: SizeDefine.marginGap,),*/
    //         LabelText.style(hint: hint),
    //         SizedBox(
    //           height: height ?? SizeDefine.heightInputField,
    //           width: Get.width * 0.1,
    //           child: DropdownButtonFormField(
    //             key: key,
    //             isExpanded: true,
    //             value: value,
    //             items: items?.map((item) {
    //               return DropdownMenuItem(
    //                   value: item,
    //                   child: SizedBox(
    //                     width: Get.width * 0.1,
    //                     child: Text(
    //                       item.value ?? "",
    //                       overflow: TextOverflow.ellipsis,
    //                     ),
    //                   ));
    //             }).toList(),
    //
    //             onChanged: (newValue) {
    //               // value = newValue.obs;
    //               callback(newValue);
    //             },
    //             style: TextStyle(fontSize: 13),
    //             decoration: InputDecoration(
    //                 // labelText: hint,
    //                 contentPadding: EdgeInsets.only(left: 8),
    //                 labelStyle: TextStyle(
    //                     fontSize: SizeDefine.labelSize, color: Colors.black),
    //                 border: InputBorder.none,
    //                 errorBorder: InputBorder.none,
    //                 enabledBorder: OutlineInputBorder(
    //                   borderSide: BorderSide(color: Colors.deepPurpleAccent),
    //                   borderRadius: BorderRadius.circular(0),
    //                 ),
    //                 focusedBorder: OutlineInputBorder(
    //                   borderSide: BorderSide(color: Colors.deepPurpleAccent),
    //                   borderRadius: BorderRadius.circular(0),
    //                 ),
    //                 floatingLabelBehavior: FloatingLabelBehavior.always),
    //             icon: Icon(
    //               Icons.arrow_drop_down,
    //               size: Get.width * 0.013,
    //             ),
    //             // iconSize: 42,
    //             // value: items.value,
    //           ),
    //         ),
    //       ],
    //     ));
    FocusNode focus = FocusNode();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: paddingLeft ?? 10.0),
          child: LabelText.style(hint: hint),
        ),
        Container(
          margin: EdgeInsets.only(left: paddingLeft ?? 10),
          height: SizeDefine.heightInputField,
          width: Get.width * (widthRatio ?? 0.1),
          child: DropdownSearch<SystemEnviroment>(
            // scrollbarProps: ScrollbarProps(isAlwaysShown: false, controller: new ScrollController()),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            // validator: validator,
            enabled: isEnable ?? true,
            selectedItem: value,
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem == null ? "" : selectedItem.value!,
                style: TextStyle(
                    // fontSize: SizeDefine.dropDownFontSize,
                    fontSize: SizeDefine.fontSizeInputField,
                    color: Colors.black),
              );
            },
            popupItemBuilder: (context, selectedItem, s) {
              return Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  child: Text(
                    selectedItem == null ? "" : selectedItem.value!,
                    style: TextStyle(
                        // fontSize: SizeDefine.dropDownFontSize,
                        fontSize: SizeDefine.fontSizeInputField,
                        color: Colors.black),
                  ));
            },

            dropdownButtonProps: IconButtonProps(
                autofocus: false,
                focusNode: AlwaysDisabledFocusNode(),
                enableFeedback: false,
                visualDensity: VisualDensity.standard,
                padding: const EdgeInsets.all(3),
                alignment: Alignment.topCenter,
                icon: Icon(Icons.arrow_drop_down_outlined)),
            showSearchBox: searchReq ?? false,
            isFilteredOnline: false,
            mode: Mode.MENU,

            searchFieldProps: TextFieldProps(
              inputFormatters: [
                FilteringTextInputFormatter.deny("  "),
                FilteringTextInputFormatter.allow(RegExp(r"^(\w+ ?)*$")),
              ],
              autofocus: true,
              // selectionHeightStyle: BoxHeightStyle.strut,
              // scrollPadding: EdgeInsets.symmetric(vertical: 0),
              // scrollPadding: ,
              style: TextStyle(fontSize: SizeDefine.fontSizeInputField),
              decoration: InputDecoration(
                hintText: "Search",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                  borderRadius: BorderRadius.circular(0),
                ),
                errorBorder: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                  borderRadius: BorderRadius.circular(0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
            itemAsString: (item) => item!.value!,
            dropdownSearchDecoration: InputDecoration(
              // hintText: "dd/MM/yyyy",
              contentPadding: const EdgeInsets.only(left: 10),
              // labelText: hint,

              labelStyle: TextStyle(
                  fontSize: SizeDefine.labelSize, color: Colors.black),
              border: InputBorder.none,
              // suffixIcon: Icon(
              //   Icons.calendar_today,
              //   size: 14,
              //   color: Colors.deepPurpleAccent,
              // ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                borderRadius: BorderRadius.circular(0),
              ),
              errorBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                borderRadius: BorderRadius.circular(0),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ),
      ],
    );
  }

  static Widget formDropDownSearchAPI2(
    GlobalKey widgetKey,
    BuildContext context, {
    required String title,
    required String url,
    String parseKeyForValue = "programName",
    String parseKeyForKey = "programCode",
    required void Function(DropDownValue) onchanged,
    DropDownValue? selectedValue,
    String textFieldHintText = "Search",
    String hintText = "Select Item",
    double dialogHeight = 350.0,
    double? width,
    bool isEnable = true,
    bool autoFocus = false,
    bool? isMandatory = false,
    dynamic customInData,
    double? widthofDialog,
    FocusNode? inkwellFocus,
    bool startFromLeft = true,
    int maxLength = 40,
    int miniumSearchLength = 2,
    void Function()? suffixCallBack,
    IconData suffixIconData = Icons.article,
    Function(bool dropDownOpen)? dropdownOpen,
  }) {
    final textColor = isEnable ? Colors.black : Colors.grey;
    final iconLineColor = isEnable ? Colors.deepPurpleAccent : Colors.grey;
    var items = RxList([]);
    var isLoading = RxBool(false);
    var msg = RxnString();
    getDataFromAPI(String value) async {
      await Get.find<ConnectorControl>().GETMETHODCALL(
          api: url + value,
          fun: (data) async {
            var tempData = [];
            items.clear();
            if (customInData != null) {
              data = await data[customInData];
            }
            for (var element in data) {
              tempData.add(Map.from(element));
            }
            items.addAll(tempData);
            tempData.clear();
            if (items.isEmpty) {
              msg.value = "No Data Found";
            } else {
              msg.value = "";
            }
          });
    }

    inkwellFocus ??= FocusNode();
    final _scrollController = ScrollController();
    return Column(
      key: widgetKey,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: title ?? "",
              style: TextStyle(
                fontSize: SizeDefine.labelSize1,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: (isMandatory ?? false) ? " *" : "",
              style: TextStyle(
                fontSize: SizeDefine.labelSize1,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ) /*
        Text(
          title,
          style: TextStyle(
            fontSize: SizeDefine.labelSize1,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        )*/
        ,
        const SizedBox(height: 5),
        StatefulBuilder(
          builder: (context, re) {
            return InkWell(
              autofocus: autoFocus,
              focusNode: inkwellFocus,
              canRequestFocus: isEnable,
              onTap: !isEnable
                  ? null
                  : () {
                      if (dropdownOpen != null) {
                        dropdownOpen(true);
                      }
                      String fieldText = "";
                      final RenderBox renderBox = widgetKey.currentContext
                          ?.findRenderObject() as RenderBox;
                      final offset = renderBox.localToGlobal(Offset.zero);
                      final top = offset.dy + renderBox.size.height;
                      final left = offset.dx;
                      final right = startFromLeft
                          ? left + renderBox.size.width
                          : offset.dy;
                      final width = renderBox.size.width;

                      searchData(String value) {
                        if (value.length >= miniumSearchLength &&
                            (!isLoading.value)) {
                          isLoading.value = true;
                          getDataFromAPI(value).then((value) {
                            isLoading.value = false;
                          });
                        }
                      }

                      showMenu(
                        context: context,
                        useRootNavigator: true,
                        position: RelativeRect.fromLTRB(left, top, right, 0.0),
                        constraints: BoxConstraints.expand(
                          width: widthofDialog ?? width,
                          height: dialogHeight,
                        ),
                        items: [
                          CustomPopupMenuItem(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: SizeDefine.fontSizeInputField),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              height: dialogHeight - 20,
                              child: Column(
                                children: [
                                  /// search
                                  TextFormField(
                                    maxLength: maxLength,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          12.0, 17.0, 20.0, 15.0),
                                      isDense: true,
                                      isCollapsed: true,
                                      hintText: textFieldHintText,
                                      suffixIcon: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () => searchData(fieldText),
                                        icon: const Icon(Icons.search),
                                        splashRadius: 15,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: SizeDefine.fontSizeInputField,
                                    ),
                                    onFieldSubmitted: searchData,
                                    onChanged: (value) => fieldText = value,
                                    autofocus: true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny("  "),
                                    ],
                                  ),

                                  /// progreesbar
                                  Obx(() {
                                    return Visibility(
                                      visible: isLoading.value,
                                      child: const LinearProgressIndicator(
                                        minHeight: 3,
                                      ),
                                    );
                                  }),

                                  const SizedBox(height: 5),

                                  /// list
                                  Expanded(
                                    child: Obx(
                                      () {
                                        return (msg.value != null &&
                                                msg.value != "")
                                            ? Center(
                                                child: Text(msg.value!),
                                              )
                                            : Scrollbar(
                                                controller: _scrollController,
                                                isAlwaysShown: true,
                                                child: ListView(
                                                  controller: _scrollController,
                                                  shrinkWrap: true,
                                                  children: items
                                                      .map(
                                                        (element) => InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            selectedValue =
                                                                DropDownValue(
                                                              key: element[
                                                                      parseKeyForKey]
                                                                  .toString(),
                                                              value: element[
                                                                      parseKeyForValue]
                                                                  .toString(),
                                                            );
                                                            re(() {});
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    inkwellFocus);
                                                            onchanged(
                                                                selectedValue!);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                            child: Text(
                                                              (element[parseKeyForValue] ??
                                                                      "null")
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: SizeDefine
                                                                        .dropDownFontSize -
                                                                    1,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ).then((value) {
                        if (dropdownOpen != null) {
                          dropdownOpen(false);
                        }
                      });
                    },
              child: Builder(
                builder: (context) {
                  if (inkwellFocus!.hasFocus) {
                    FocusScope.of(context).requestFocus(inkwellFocus);
                  }
                  return Container(
                    width: width,
                    height: SizeDefine.heightInputField,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: iconLineColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 4),
                            child: Text(
                              (selectedValue?.value ?? ""),
                              style: TextStyle(
                                fontSize: SizeDefine.fontSizeInputField,
                                color: textColor,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        )),
                        Visibility(
                          visible: suffixCallBack == null,
                          replacement: GestureDetector(
                            onTap: suffixCallBack,
                            child: Icon(
                              suffixIconData,
                              color: iconLineColor,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: iconLineColor,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  static Widget formDropDownSearchAPI({
    required String title,
    required String url,
    required String parseKeyForTitle,
    required Function(Map<String, dynamic>) onchanged,
    Map<String, dynamic>? selectedValue,
    String textFieldHintText = "Search",
    String hintText = "Select Item",
    double? height,
    Key? key,
    double? widthRatio,
    double? paddingLeft,
  }) {
    FocusNode focus = FocusNode();
    bool isLoading = false;
    TextEditingController textCtr = TextEditingController();
    List<Map> items = [];

    getDataFromAPI(String value) async {
      items = [];
      await Get.find<ConnectorControl>().GETMETHODCALL(
          api: url + value,
          fun: (data) {
            for (var element in data) {
              items.add(Map.from(element));
            }
          });
    }

    return StatefulBuilder(
      builder: (context, setState) {
        textCtr.addListener(() {
          print("calling api addListener");
          if (!isLoading) {
            String value = textCtr.text;
            if (value.length > 2) {
              setState(() {
                isLoading = true;
              });
              getDataFromAPI(value).then((value) {
                print("set state called  ${items.length}");
                setState(() {
                  isLoading = false;
                });
              });
            }
          }
        });
        print("after set state called ${items.length}");
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelText.style(hint: title),
            Container(
              margin: EdgeInsets.only(left: paddingLeft ?? 10),
              height: SizeDefine.heightInputField,
              width: Get.width * (widthRatio ?? 0.1),
              child: DropdownSearch<Map>(
                selectedItem: selectedValue,
                items: items,
                mode: Mode.MENU,
                showSearchBox: true,
                isFilteredOnline: true,
                onChanged: (newVal) => onchanged,
                searchFieldProps: TextFieldProps(
                  controller: textCtr,
                  decoration: InputDecoration(
                    hintText: "Search",
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    errorBorder: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
                itemAsString: (item) => item?[parseKeyForTitle] ?? "null",
                // dropdownButtonProps: const IconButtonProps(
                //   visualDensity: VisualDensity.standard,
                //   padding: EdgeInsets.all(3),
                //   alignment: Alignment.topCenter,
                //   icon: SizedBox(),
                // ),
                // emptyBuilder: (context, searchEntry) {
                //   log("emptyBuilder");
                //   if (items.isEmpty && (isLoading)) {
                //     return const SizedBox();
                //   }

                //   if (isLoading) {
                //     return const Center(
                //         child: CircularProgressIndicator(strokeWidth: 2));
                //   } else if (items.isEmpty) {
                //     return const Center(child: Text("No Data Found"));
                //   } else {
                //     return const SizedBox();
                //   }
                // },
                popupItemBuilder: (context, selectedItem, s) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    child: Text(
                      selectedItem[parseKeyForTitle] ?? hintText,
                      style: TextStyle(
                          fontSize: SizeDefine.dropDownFontSize,
                          color: Colors.black),
                    ),
                  );
                },

                dropdownBuilder: (context, selectedItem) {
                  print(selectedItem);
                  return Text(
                    selectedItem?[parseKeyForTitle] ?? hintText,
                    style: TextStyle(
                      fontSize: SizeDefine.fontSizeInputField,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget formDropDown1Width(
    BuildContext buildcontext,
    List<SystemEnviroment>? items,
    Function callback,
    String hint,
    double widthRatio, {
    double? height,
    double? paddingLeft,
    double? paddingTop,
    // FocusNode? focusNode,
    double? paddingBottom,
    SystemEnviroment? selected,
    bool? isEnable,
    bool? searchReq,
    bool autoFocus = false,
    double dialogHeight = 350,
    double? dialogWidth,
  }) {
    isEnable ??= true;
    final widgetKey = GlobalKey();
    final textColor = (isEnable) ? Colors.black : Colors.grey;
    final iconLineColor = (isEnable) ? Colors.deepPurpleAccent : Colors.grey;
    FocusNode inkwellFocus = FocusNode(
        descendantsAreFocusable: false, descendantsAreTraversable: false);
    final _scrollController = ScrollController();
    return Column(
      key: widgetKey,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hint,
          style: TextStyle(
            fontSize: SizeDefine.labelSize1,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        StatefulBuilder(builder: (context, re) {
          return InkWell(
              autofocus: autoFocus,
              focusNode: inkwellFocus,
              canRequestFocus: isEnable ?? true,
              onTap: !isEnable!
                  ? null
                  : () {
                      if ((items == null || items.isEmpty)) {
                        return;
                      }
                      // var isLoading = RxBool(false);
                      var tempList = RxList<SystemEnviroment>([]);
                      tempList.addAll(items);
                      final width =
                          (widgetKey.currentContext?.size?.width ?? 200);
                      final height =
                          (widgetKey.currentContext?.size?.height ?? 200);
                      var box = widgetKey.currentContext!.findRenderObject()
                          as RenderBox;
                      var startpoints = box.localToGlobal(Offset(0, height));
                      showMenu(
                        context: context,
                        position: RelativeRect.fromSize(
                            (startpoints & const Size(0, 0)), Get.size),
                        constraints: BoxConstraints.expand(
                          width: dialogWidth ?? width,
                          height: dialogHeight,
                        ),
                        items: [
                          CustomPopupMenuItem(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: SizeDefine.fontSizeInputField),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              height: dialogHeight - 20,
                              child: Column(
                                children: [
                                  /// search
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(12),
                                      isDense: true,
                                      isCollapsed: true,
                                      hintText: "Search",
                                    ),
                                    autofocus: true,
                                    style: TextStyle(
                                      fontSize: SizeDefine.fontSizeInputField,
                                    ),
                                    onChanged: ((value) {
                                      if (value.isNotEmpty) {
                                        tempList.clear();
                                        for (var i = 0; i < items.length; i++) {
                                          if (items[i]
                                              .value!
                                              .toLowerCase()
                                              .contains(value.toLowerCase())) {
                                            tempList.add(items[i]);
                                          }
                                        }
                                      }
                                    }),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny("  "),
                                    ],
                                  ),

                                  /// progreesbar
                                  // Obx(() {
                                  //   return Visibility(
                                  //     visible: isLoading.value,
                                  //     child: const LinearProgressIndicator(
                                  //       minHeight: 3,
                                  //     ),
                                  //   );
                                  // }),

                                  const SizedBox(height: 5),

                                  /// list
                                  Expanded(
                                    child: Obx(
                                      () {
                                        return Scrollbar(
                                          controller: _scrollController,
                                          isAlwaysShown: true,
                                          child: ListView(
                                            controller: _scrollController,
                                            shrinkWrap: true,
                                            children: tempList
                                                .map(
                                                  (element) => InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      selected = element;
                                                      callback(element);
                                                      re(() {});
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              inkwellFocus);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8),
                                                      child: Text(
                                                        element.value ?? "null",
                                                        style: TextStyle(
                                                          fontSize: SizeDefine
                                                                  .dropDownFontSize -
                                                              1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
              child: Container(
                width: Get.width * widthRatio,
                height: SizeDefine.heightInputField,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: iconLineColor,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 4),
                        child: Text(
                          (selected?.value ?? ""),
                          style: TextStyle(
                            fontSize: SizeDefine.fontSizeInputField,
                            color: textColor,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    )),
                    Icon(
                      Icons.arrow_drop_down,
                      color: iconLineColor,
                    )
                  ],
                ),
              ));
        }),
      ],
    );
    /* return Padding(
        padding: EdgeInsets.only(
            // left: SizeBox.paddingHorizontal,
            // right: SizeBox.paddingHorizontal,
            left: paddingLeft ?? 5,
            top: paddingTop ?? 6.0,
            bottom: paddingBottom ?? 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(hint,style: TextStyle(
            //     fontSize: SizeDefine.labelSize1, color: Colors.black),),
            // SizedBox(height: SizeDefine.marginGap,),
            LabelText.style(hint: hint),
            SizedBox(
              height: height ?? SizeDefine.heightInputField,
              width: Get.width * widthRatio,
              child: DropdownButtonFormField(
                isExpanded: true,
                items: items?.map((item) {
                  return DropdownMenuItem(
                      value: item, child: Text(item.value!));
                }).toList(),
                onChanged: (newValue) {
                  // value = newValue.obs;
                  callback(newValue);
                },
                value: selected ?? null,
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, right: 5),
                    // labelText: hint,
                    labelStyle: TextStyle(
                        fontSize: SizeDefine.labelSize, color: Colors.black),
                    border: InputBorder.none,
                    // suffixIcon: Icon(
                    //   Icons.calendar_today,
                    //   size: 14,
                    //   color: Colors.deepPurpleAccent,
                    // ),
                    errorBorder: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: Get.width * 0.013,
                ),
                // iconSize: 42,
                // value: items.value,
              ),
            ),
          ],
        ));*/

    // final iconColor =
    //     (isEnable ?? true) ? Colors.deepPurpleAccent : Colors.grey;
    // return Builder(builder: (context) {
    //   FocusNode focusNode = FocusNode();
    //   return Focus(
    //     focusNode: focusNode,
    //     // onFocusChange: (value) {
    //     //   if (value) {
    //     //     // FocusScope.of(context).nextFocus();
    //     //   }
    //     // },
    //     child: Container(
    //       padding: EdgeInsets.only(top: paddingTop ?? 0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Padding(
    //             padding: EdgeInsets.only(left: paddingLeft ?? 10.0),
    //             child: LabelText.style(hint: hint),
    //           ),
    //           Container(
    //             margin: EdgeInsets.only(
    //               left: paddingLeft ?? 10.0,
    //             ),
    //             height: SizeDefine.heightInputField,
    //             width: Get.width * widthRatio,
    //             child: DropdownSearch<SystemEnviroment>(
    //               // focusNode: focusNode,
    //               autoValidateMode: AutovalidateMode.onUserInteraction,
    //               enabled: isEnable ?? true,
    //               selectedItem: selected,
    //               dropdownBuilder: (context, selectedItem) {
    //                 return Text(
    //                   selectedItem == null ? "" : selectedItem.value!,
    //                   style: TextStyle(
    //                       fontSize: SizeDefine.fontSizeInputField,
    //                       color: Colors.black),
    //                 );
    //               },
    //               popupItemBuilder: (context, selectedItem, s) {
    //                 /* return Text(
    //                     selectedItem == null ? "" : selectedItem.value!,
    //                     style: TextStyle(
    //                         // fontSize: SizeDefine.dropDownFontSize,
    //                         fontSize: SizeDefine.dropDownFontSize,
    //                         color: Colors.black),
    //                   );*/
    //                 return Container(
    //                   padding:
    //                       EdgeInsets.symmetric(vertical: 5, horizontal: 16),
    //                   child: Text(
    //                     selectedItem == null ? "" : selectedItem.value!,
    //                     style: TextStyle(
    //                         // fontSize: SizeDefine.dropDownFontSize,
    //                         fontSize: SizeDefine.dropDownFontSize,
    //                         color: Colors.black),
    //                   ),
    //                 );
    //               },
    //               dropdownButtonProps: IconButtonProps(
    //                 focusNode: AlwaysDisabledFocusNode(),
    //                 visualDensity: VisualDensity.compact,
    //                 padding: const EdgeInsets.all(3),
    //                 alignment: Alignment.topCenter,
    //                 icon: Icon(
    //                   Icons.arrow_drop_down_outlined,
    //                   color: iconColor,
    //                 ),
    //                 focusColor: iconColor,
    //                 color: iconColor,
    //                 disabledColor: iconColor,
    //               ),
    //               showSearchBox: searchReq ?? false,
    //               isFilteredOnline: false,
    //               mode: Mode.MENU,
    //               itemAsString: (item) => item!.value!,
    //               searchFieldProps: TextFieldProps(
    //                   style: TextStyle(fontSize: SizeDefine.dropDownFontSize),
    //                   autofocus: (searchReq ?? false),
    //                   decoration: InputDecoration(
    //                     errorBorder: InputBorder.none,
    //                     hintText: "Search",
    //                     contentPadding: const EdgeInsets.symmetric(
    //                         horizontal: 10, vertical: 12),
    //                     isDense: true,
    //                     enabledBorder: OutlineInputBorder(
    //                       borderSide:
    //                           const BorderSide(color: Colors.deepPurpleAccent),
    //                       borderRadius: BorderRadius.circular(0),
    //                     ),
    //                     focusedBorder: OutlineInputBorder(
    //                       borderSide:
    //                           const BorderSide(color: Colors.deepPurpleAccent),
    //                       borderRadius: BorderRadius.circular(0),
    //                     ),
    //                     disabledBorder: OutlineInputBorder(
    //                       borderSide: const BorderSide(color: Colors.grey),
    //                       borderRadius: BorderRadius.circular(0),
    //                     ),
    //                   ),
    //                   inputFormatters: [
    //                     FilteringTextInputFormatter.deny("  "),
    //                     // FilteringTextInputFormatter.allow(RegExp(r"^(\w+ ?)*$")),
    //                   ]),
    //               // dropdownSearchDecoration: InputDecoration(
    //               //   contentPadding: const EdgeInsets.only(left: 10),
    //               //   labelStyle: TextStyle(
    //               //       fontSize: SizeDefine.labelSize, color: Colors.black),
    //               //   border: InputBorder.none,
    //               //   enabledBorder: OutlineInputBorder(
    //               //     borderSide:
    //               //         const BorderSide(color: Colors.deepPurpleAccent),
    //               //     borderRadius: BorderRadius.circular(0),
    //               //   ),
    //               //   inputFormatters: [
    //               //     FilteringTextInputFormatter.deny("  "),
    //               //     // FilteringTextInputFormatter.allow(RegExp(r"^(\w+ ?)*$")),
    //               //     // FilteringTextInputFormatter.allow(RegExp("&")),
    //               //   ]),
    //               dropdownSearchDecoration: InputDecoration(
    //                 contentPadding: const EdgeInsets.only(left: 10),
    //                 labelStyle: TextStyle(
    //                     fontSize: SizeDefine.labelSize, color: Colors.black),
    //                 border: InputBorder.none,
    //                 enabledBorder: OutlineInputBorder(
    //                   borderSide:
    //                       const BorderSide(color: Colors.deepPurpleAccent),
    //                   borderRadius: BorderRadius.circular(0),
    //                 ),
    //               ),
    //               items: items!,
    //               onChanged: (val) {
    //                 callback(val);
    //                 FocusScope.of(Get.context!).requestFocus(focusNode);
    //               },
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // });
  }

  static Widget formDropDown22Width(
    BuildContext buildcontext,
    List<SystemEnviroment>? items,
    Function callback,
    String hint,
    double widthRatio, {
    double? height,
    double? paddingLeft,
    double? paddingTop,
    // FocusNode? focusNode,
    double? paddingBottom,
    Rxn<SystemEnviroment>? selected,
    bool? isEnable,
    bool? searchReq,
    bool autoFocus = false,
    double dialogHeight = 350,
    double? widthofDialog,
  }) {
    isEnable ??= true;
    final widgetKey = GlobalKey();
    final textColor = (isEnable) ? Colors.black : Colors.grey;
    final iconLineColor = (isEnable) ? Colors.deepPurpleAccent : Colors.grey;
    FocusNode inkwellFocus = FocusNode(
        descendantsAreFocusable: false, descendantsAreTraversable: false);
    final _scrollController = ScrollController();
    return Column(
      key: widgetKey,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hint,
          style: TextStyle(
            fontSize: SizeDefine.labelSize1,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        StatefulBuilder(builder: (context, re) {
          return InkWell(
              autofocus: autoFocus,
              focusNode: inkwellFocus,
              canRequestFocus: isEnable ?? true,
              onTap: !isEnable!
                  ? null
                  : () {
                      if ((items == null || items.isEmpty)) {
                        return;
                      }
                      // var isLoading = RxBool(false);
                      var tempList = RxList<SystemEnviroment>([]);
                      tempList.addAll(items);
                      // final width =
                      //     (widgetKey.currentContext?.size?.width ?? 200);
                      // final height =
                      //     (widgetKey.currentContext?.size?.height ?? 200);
                      // var box = widgetKey.currentContext!.findRenderObject()
                      //     as RenderBox;
                      // var startpoints = box.localToGlobal(Offset(0, height));

                      // final width =
                      //     (widgetKey.currentContext?.size?.width ?? 200);
                      // final height =
                      //     (widgetKey.currentContext?.size?.height ?? 200);
                      // var box = widgetKey.currentContext!.findRenderObject()
                      //     as RenderBox;
                      // var startpoints = box.localToGlobal(Offset(0, height));
                      //*get the render box from the context
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      //*get the global position, from the widget local position
                      final offset = renderBox.localToGlobal(Offset.zero);
                      //*calculate the start point in this case, below the button
                      final left = offset.dx;
                      final top = offset.dy + renderBox.size.height;
                      //*The right does not indicates the width
                      final right = left + renderBox.size.width;
                      final width = renderBox.size.width;
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(left, top, right, 0.0),
                        //  RelativeRect.fromSize(
                        //     (startpoints & const Size(0, 0)), Get.size),
                        constraints: BoxConstraints.expand(
                          width: widthofDialog ?? width,
                          height: dialogHeight,
                        ),
                        items: [
                          CustomPopupMenuItem(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: SizeDefine.fontSizeInputField),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              height: dialogHeight - 20,
                              child: Column(
                                children: [
                                  /// search
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(12),
                                      isDense: true,
                                      isCollapsed: true,
                                      hintText: "Search",
                                    ),
                                    autofocus: true,
                                    style: TextStyle(
                                      fontSize: SizeDefine.fontSizeInputField,
                                    ),
                                    onChanged: ((value) {
                                      if (value.isNotEmpty) {
                                        tempList.clear();
                                        for (var i = 0; i < items.length; i++) {
                                          if (items[i]
                                              .value!
                                              .toLowerCase()
                                              .contains(value.toLowerCase())) {
                                            tempList.add(items[i]);
                                          }
                                        }
                                      }
                                    }),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny("  "),
                                    ],
                                  ),

                                  /// progreesbar
                                  // Obx(() {
                                  //   return Visibility(
                                  //     visible: isLoading.value,
                                  //     child: const LinearProgressIndicator(
                                  //       minHeight: 3,
                                  //     ),
                                  //   );
                                  // }),

                                  const SizedBox(height: 5),

                                  /// list
                                  Expanded(
                                    child: Obx(
                                      () {
                                        return Scrollbar(
                                          isAlwaysShown: true,
                                          controller: _scrollController,
                                          child: ListView(
                                            controller: _scrollController,
                                            shrinkWrap: true,
                                            children: tempList
                                                .map(
                                                  (element) => InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      selected?.value = element;
                                                      callback(element);
                                                      re(() {});
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              inkwellFocus);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8),
                                                      child: Text(
                                                        element.value ?? "null",
                                                        style: TextStyle(
                                                          fontSize: SizeDefine
                                                                  .dropDownFontSize -
                                                              1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
              child: Container(
                width: Get.width * widthRatio,
                height: SizeDefine.heightInputField,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: iconLineColor,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 4),
                        child: Obx(() {
                          return Text(
                            selected?.value?.value ?? "",
                            style: TextStyle(
                              fontSize: SizeDefine.fontSizeInputField,
                              color: textColor,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          );
                        }),
                      ),
                    )),
                    Icon(
                      Icons.arrow_drop_down,
                      color: iconLineColor,
                    )
                  ],
                ),
              ));
        }),
      ],
    );
    /* return Padding(
        padding: EdgeInsets.only(
            // left: SizeBox.paddingHorizontal,
            // right: SizeBox.paddingHorizontal,
            left: paddingLeft ?? 5,
            top: paddingTop ?? 6.0,
            bottom: paddingBottom ?? 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(hint,style: TextStyle(
            //     fontSize: SizeDefine.labelSize1, color: Colors.black),),
            // SizedBox(height: SizeDefine.marginGap,),
            LabelText.style(hint: hint),
            SizedBox(
              height: height ?? SizeDefine.heightInputField,
              width: Get.width * widthRatio,
              child: DropdownButtonFormField(
                isExpanded: true,
                items: items?.map((item) {
                  return DropdownMenuItem(
                      value: item, child: Text(item.value!));
                }).toList(),
                onChanged: (newValue) {
                  // value = newValue.obs;
                  callback(newValue);
                },
                value: selected ?? null,
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, right: 5),
                    // labelText: hint,
                    labelStyle: TextStyle(
                        fontSize: SizeDefine.labelSize, color: Colors.black),
                    border: InputBorder.none,
                    // suffixIcon: Icon(
                    //   Icons.calendar_today,
                    //   size: 14,
                    //   color: Colors.deepPurpleAccent,
                    // ),
                    errorBorder: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: Get.width * 0.013,
                ),
                // iconSize: 42,
                // value: items.value,
              ),
            ),
          ],
        ));*/

    // final iconColor =
    //     (isEnable ?? true) ? Colors.deepPurpleAccent : Colors.grey;
    // return Builder(builder: (context) {
    //   FocusNode focusNode = FocusNode();
    //   return Focus(
    //     focusNode: focusNode,
    //     // onFocusChange: (value) {
    //     //   if (value) {
    //     //     // FocusScope.of(context).nextFocus();
    //     //   }
    //     // },
    //     child: Container(
    //       padding: EdgeInsets.only(top: paddingTop ?? 0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Padding(
    //             padding: EdgeInsets.only(left: paddingLeft ?? 10.0),
    //             child: LabelText.style(hint: hint),
    //           ),
    //           Container(
    //             margin: EdgeInsets.only(
    //               left: paddingLeft ?? 10.0,
    //             ),
    //             height: SizeDefine.heightInputField,
    //             width: Get.width * widthRatio,
    //             child: DropdownSearch<SystemEnviroment>(
    //               // focusNode: focusNode,
    //               autoValidateMode: AutovalidateMode.onUserInteraction,
    //               enabled: isEnable ?? true,
    //               selectedItem: selected,
    //               dropdownBuilder: (context, selectedItem) {
    //                 return Text(
    //                   selectedItem == null ? "" : selectedItem.value!,
    //                   style: TextStyle(
    //                       fontSize: SizeDefine.fontSizeInputField,
    //                       color: Colors.black),
    //                 );
    //               },
    //               popupItemBuilder: (context, selectedItem, s) {
    //                 /* return Text(
    //                     selectedItem == null ? "" : selectedItem.value!,
    //                     style: TextStyle(
    //                         // fontSize: SizeDefine.dropDownFontSize,
    //                         fontSize: SizeDefine.dropDownFontSize,
    //                         color: Colors.black),
    //                   );*/
    //                 return Container(
    //                   padding:
    //                       EdgeInsets.symmetric(vertical: 5, horizontal: 16),
    //                   child: Text(
    //                     selectedItem == null ? "" : selectedItem.value!,
    //                     style: TextStyle(
    //                         // fontSize: SizeDefine.dropDownFontSize,
    //                         fontSize: SizeDefine.dropDownFontSize,
    //                         color: Colors.black),
    //                   ),
    //                 );
    //               },
    //               dropdownButtonProps: IconButtonProps(
    //                 focusNode: AlwaysDisabledFocusNode(),
    //                 visualDensity: VisualDensity.compact,
    //                 padding: const EdgeInsets.all(3),
    //                 alignment: Alignment.topCenter,
    //                 icon: Icon(
    //                   Icons.arrow_drop_down_outlined,
    //                   color: iconColor,
    //                 ),
    //                 focusColor: iconColor,
    //                 color: iconColor,
    //                 disabledColor: iconColor,
    //               ),
    //               showSearchBox: searchReq ?? false,
    //               isFilteredOnline: false,
    //               mode: Mode.MENU,
    //               itemAsString: (item) => item!.value!,
    //               searchFieldProps: TextFieldProps(
    //                   style: TextStyle(fontSize: SizeDefine.dropDownFontSize),
    //                   autofocus: (searchReq ?? false),
    //                   decoration: InputDecoration(
    //                     errorBorder: InputBorder.none,
    //                     hintText: "Search",
    //                     contentPadding: const EdgeInsets.symmetric(
    //                         horizontal: 10, vertical: 12),
    //                     isDense: true,
    //                     enabledBorder: OutlineInputBorder(
    //                       borderSide:
    //                           const BorderSide(color: Colors.deepPurpleAccent),
    //                       borderRadius: BorderRadius.circular(0),
    //                     ),
    //                     focusedBorder: OutlineInputBorder(
    //                       borderSide:
    //                           const BorderSide(color: Colors.deepPurpleAccent),
    //                       borderRadius: BorderRadius.circular(0),
    //                     ),
    //                     disabledBorder: OutlineInputBorder(
    //                       borderSide: const BorderSide(color: Colors.grey),
    //                       borderRadius: BorderRadius.circular(0),
    //                     ),
    //                   ),
    //                   inputFormatters: [
    //                     FilteringTextInputFormatter.deny("  "),
    //                     // FilteringTextInputFormatter.allow(RegExp(r"^(\w+ ?)*$")),
    //                   ]),
    //               // dropdownSearchDecoration: InputDecoration(
    //               //   contentPadding: const EdgeInsets.only(left: 10),
    //               //   labelStyle: TextStyle(
    //               //       fontSize: SizeDefine.labelSize, color: Colors.black),
    //               //   border: InputBorder.none,
    //               //   enabledBorder: OutlineInputBorder(
    //               //     borderSide:
    //               //         const BorderSide(color: Colors.deepPurpleAccent),
    //               //     borderRadius: BorderRadius.circular(0),
    //               //   ),
    //               //   inputFormatters: [
    //               //     FilteringTextInputFormatter.deny("  "),
    //               //     // FilteringTextInputFormatter.allow(RegExp(r"^(\w+ ?)*$")),
    //               //     // FilteringTextInputFormatter.allow(RegExp("&")),
    //               //   ]),
    //               dropdownSearchDecoration: InputDecoration(
    //                 contentPadding: const EdgeInsets.only(left: 10),
    //                 labelStyle: TextStyle(
    //                     fontSize: SizeDefine.labelSize, color: Colors.black),
    //                 border: InputBorder.none,
    //                 enabledBorder: OutlineInputBorder(
    //                   borderSide:
    //                       const BorderSide(color: Colors.deepPurpleAccent),
    //                   borderRadius: BorderRadius.circular(0),
    //                 ),
    //               ),
    //               items: items!,
    //               onChanged: (val) {
    //                 callback(val);
    //                 FocusScope.of(Get.context!).requestFocus(focusNode);
    //               },
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // });
  }

  static Widget formDropDown2Width(
      List? items, Function? callback, String hint, double widthRatio,
      {double? height,
      double? paddingLeft,
      double? paddingTop,
      double? paddingBottom,
      SystemEnviroment? selected}) {
    // FocusNode focusNode = FocusNode();
    return Padding(
        padding: EdgeInsets.only(
            // left: SizeBox.paddingHorizontal,
            // right: SizeBox.paddingHorizontal,
            left: paddingLeft ?? 5,
            top: paddingTop ?? 6.0,
            bottom: paddingBottom ?? 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Text(hint,style: TextStyle(
                fontSize: SizeDefine.labelSize1, color: Colors.black),),
            SizedBox(height: SizeDefine.marginGap,),*/
            LabelText.style(hint: hint),
            SizedBox(
              height: height ?? SizeDefine.heightInputField,
              width: Get.width * widthRatio,
              child: DropdownButtonFormField(
                // focusNode: focusNode,
                isExpanded: true,
                items: items?.map((item) {
                  return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item.value!,
                        style:
                            TextStyle(fontSize: SizeDefine.fontSizeInputField),
                      ));
                }).toList(),
                onChanged: (callback != null)
                    ? (val) {
                        callback(val);
                        // FocusScope.of(Get.context!).requestFocus(focusNode);
                      }
                    : null,
                value: selected ?? null,
                style: TextStyle(fontSize: SizeDefine.fontSizeInputField),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, right: 5),
                    // labelText: hint,
                    labelStyle: TextStyle(
                        fontSize: SizeDefine.labelSize, color: Colors.black),
                    border: InputBorder.none,
                    // suffixIcon: Icon(
                    //   Icons.calendar_today,
                    //   size: 14,
                    //   color: Colors.deepPurpleAccent,
                    // ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: Get.width * 0.013,
                ),
                // iconSize: 42,
                // value: items.value,
              ),
            ),
          ],
        ));
  }

  static Widget formDropDown1WidthMap(
    List<DropDownValue>? items,
    Function(DropDownValue) callback,
    String hint,
    double widthRatio, {
    double? height,
    bool showMenuInbottom = true,
    double? paddingBottom,
    DropDownValue? selected,
    bool? isEnable,
    String? Function(DropDownValue? value)? validator,
    bool? searchReq,
    bool autoFocus = false,
    bool? showSearchField = true,
    double dialogHeight = 350,
    void Function(bool)? onFocusChange,
    double? dialogWidth,
    FocusNode? inkWellFocusNode,
    GlobalKey? widgetKey,
    bool showtitle = true,
    bool titleInLeft = false,
    bool? isMandatory = false,
    Function(bool dropDownOpen)? dropdownOpen,
  }) {
    isEnable ??= true;
    widgetKey ??= GlobalKey();
    final textColor = (isEnable) ? Colors.black : Colors.grey;
    final iconLineColor = (isEnable) ? Colors.deepPurpleAccent : Colors.grey;
    inkWellFocusNode ??= FocusNode();
    final _scrollController = ScrollController();
    return Column(
      // key: titleInLeft ? null : widgetKey,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showtitle && !titleInLeft) ...{
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: hint ?? "",
                style: TextStyle(
                  fontSize: SizeDefine.labelSize1,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: (isMandatory ?? false) ? " *" : "",
                style: TextStyle(
                  fontSize: SizeDefine.labelSize1,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 5),
        },
        StatefulBuilder(builder: (context, re) {
          bool showNoRecord = false;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (titleInLeft) ...{
                Text(
                  hint,
                  style: TextStyle(
                    fontSize: SizeDefine.labelSize1,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
              },
              InkWell(
                  // key: widgetKey,
                  // key: titleInLeft ? widgetKey : null,
                  autofocus: autoFocus,
                  focusNode: inkWellFocusNode,
                  canRequestFocus: (isEnable ?? true),
                  onFocusChange: onFocusChange,
                  onTap: (!isEnable!)
                      ? null
                      : () {
                          if (dropdownOpen != null) {
                            dropdownOpen(true);
                          }
                          var isLoading = RxBool(false);

                          final RenderBox renderBox = widgetKey!.currentContext
                              ?.findRenderObject() as RenderBox;
                          final offset = renderBox.localToGlobal(Offset.zero);
                          final left = offset.dx;
                          final top = (offset.dy + renderBox.size.height);
                          final right = left + renderBox.size.width;
                          final width = renderBox.size.width;
                          if ((items == null || items.isEmpty)) {
                            showMenu(
                                context: context,
                                useRootNavigator: true,
                                position: RelativeRect.fromLTRB(
                                    left, top, right, 0.0),
                                constraints: BoxConstraints.expand(
                                  width: dialogWidth ?? width,
                                  height: 120,
                                ),
                                items: [
                                  PopupMenuItem(
                                    child: Text(
                                      "No Record Found",
                                      style: TextStyle(
                                        fontSize:
                                            SizeDefine.dropDownFontSize - 1,
                                      ),
                                    ),
                                  )
                                ]).then((value) {
                              if (dropdownOpen != null) {
                                dropdownOpen(false);
                              }
                            });
                          } else {
                            var tempList = RxList<DropDownValue>([]);
                            // if (selected == null) {
                            //   tempList.addAll(items);
                            // } else {
                            for (var i = 0; i < items.length; i++) {
                              tempList.add(items[i]);
                            }
                            // }
                            showMenu(
                              context: context,
                              useRootNavigator: true,
                              position:
                                  RelativeRect.fromLTRB(left, top, right, 0.0),
                              constraints: BoxConstraints.expand(
                                width: dialogWidth ?? width,
                                height: dialogHeight,
                              ),
                              items: [
                                CustomPopupMenuItem(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: SizeDefine.fontSizeInputField),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    height: dialogHeight - 20,
                                    child: Column(
                                      children: [
                                        /// search
                                        if (showSearchField ?? true)
                                          TextFormField(
                                            decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                                isDense: true,
                                                isCollapsed: true,
                                                hintText: "Search",
                                                counterText: ""),
                                            controller: TextEditingController(),
                                            autofocus: true,
                                            style: TextStyle(
                                              fontSize:
                                                  SizeDefine.fontSizeInputField,
                                            ),
                                            onChanged: ((value) {
                                              if (value.isNotEmpty) {
                                                tempList.clear();
                                                for (var i = 0;
                                                    i < items.length;
                                                    i++) {
                                                  if (items[i]
                                                      .value!
                                                      .toLowerCase()
                                                      .contains(value
                                                          .toLowerCase())) {
                                                    tempList.add(items[i]);
                                                  }
                                                }
                                              } else {
                                                tempList.clear();
                                                tempList.addAll(items);
                                                tempList.refresh();
                                              }
                                            }),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  "  "),
                                            ],
                                            maxLength: SizeDefine.maxcharlimit,
                                          ),

                                        /// progreesbar
                                        Obx(() {
                                          return Visibility(
                                            visible: isLoading.value,
                                            child:
                                                const LinearProgressIndicator(
                                              minHeight: 3,
                                            ),
                                          );
                                        }),

                                        const SizedBox(height: 5),

                                        /// list
                                        Expanded(
                                          child: Obx(
                                            () {
                                              return Scrollbar(
                                                isAlwaysShown: true,
                                                controller: _scrollController,
                                                child: ListView(
                                                  controller: _scrollController,
                                                  shrinkWrap: true,
                                                  children: tempList
                                                      .map(
                                                        (element) => InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            selected = element;
                                                            re(() {});
                                                            callback(element);
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    inkWellFocusNode);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                            child: Text(
                                                              element.value ??
                                                                  "null",
                                                              style: TextStyle(
                                                                fontSize: SizeDefine
                                                                        .dropDownFontSize -
                                                                    1,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ).then((value) {
                              if (dropdownOpen != null) {
                                dropdownOpen(false);
                              }
                            });
                          }
                        },
                  child: Container(
                    key: widgetKey,
                    width: Get.width * widthRatio,
                    height: SizeDefine.heightInputField,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: iconLineColor,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 4),
                            child: Text(
                              (selected?.value ??
                                  (items!.isEmpty && showNoRecord
                                      ? "NO Record Found"
                                      : "")),
                              style: TextStyle(
                                fontSize: SizeDefine.fontSizeInputField,
                                color: textColor,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        )),
                        Icon(
                          Icons.arrow_drop_down,
                          color: iconLineColor,
                        )
                      ],
                    ),
                  )),
            ],
          );
        }),
      ],
    );
    // final iconColor =
    //     (isEnable ?? true) ? Colors.deepPurpleAccent : Colors.grey;
    // return Builder(builder: (context) {
    //   FocusNode focusNode = FocusNode();
    //   return Focus(
    //     focusNode: focusNode,
    //     autofocus: autoFocus,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         LabelText.style(hint: hint),
    //         SizedBox(
    //           height: SizeDefine.heightInputField,
    //           width: Get.width * widthRatio,
    //           child: DropdownSearch<DropDownValue>(
    //             // focusNode: focusNode,
    //             autoValidateMode: AutovalidateMode.onUserInteraction,
    //             enabled: isEnable ?? true,
    //             selectedItem: selected,
    //             dropdownBuilder: (context, selectedItem) {
    //               return Padding(
    //                 padding: const EdgeInsets.only(top: 2.5),
    //                 child: Text(
    //                   (selectedItem?.value ?? ""),
    //                   style: TextStyle(
    //                     fontSize: SizeDefine.fontSizeInputField,
    //                     color: Colors.black,
    //                     fontWeight: FontWeight.normal,
    //                   ),
    //                   textAlign: TextAlign.start,
    //                 ),
    //               );
    //             },
    //             validator: (value) {
    //               if (validator != null) {
    //                 return validator(selected);
    //               } else {
    //                 return null;
    //               }
    //             },
    //             popupItemBuilder: (context, item, s) {
    //               return Container(
    //                 // padding: EdgeInsets.only(left: 4),
    //                 // height: 15,
    //                 //   minVerticalPadding:5,
    //                 // dense:true,
    //                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
    //                 child: Text(
    //                   (item.value ?? ""),
    //                   style: TextStyle(
    //                     fontSize: SizeDefine.dropDownFontSize,
    //                     color: Colors.black,
    //                     fontWeight: FontWeight.normal,
    //                   ),
    //                 ),
    //               );
    //             },
    //             dropdownButtonProps: IconButtonProps(
    //               focusNode: AlwaysDisabledFocusNode(),
    //               visualDensity: VisualDensity.compact,
    //               padding: const EdgeInsets.all(3),
    //               alignment: Alignment.topCenter,
    //               icon: Icon(
    //                 Icons.arrow_drop_down_outlined,
    //                 color: iconColor,
    //               ),
    //               focusColor: iconColor,
    //               color: iconColor,
    //               disabledColor: iconColor,
    //             ),
    //             showSearchBox: searchReq ?? true,
    //             isFilteredOnline: false,
    //             mode: Mode.MENU,
    //             itemAsString: (item) => item?.value ?? "",
    //             searchFieldProps: TextFieldProps(
    //               autofocus: true,
    //               style: TextStyle(
    //                 fontSize: SizeDefine.dropDownFontSize,
    //                 color: Colors.black,
    //                 fontWeight: FontWeight.normal,
    //               ),
    //               inputFormatters: [
    //                 // LengthLimitingTextInputFormatter(45),
    //                 // UpperCaseTextFormatter(),
    //                 FilteringTextInputFormatter.deny("  "),
    //                 // FilteringTextInputFormatter.allow(RegExp(r"^(\w+ ?)*$")),
    //               ],
    //               decoration: InputDecoration(
    //                 errorBorder: InputBorder.none,
    //                 hintText: "Search",
    //                 contentPadding: const EdgeInsets.symmetric(
    //                     horizontal: 10, vertical: 12),
    //                 isDense: true,
    //                 enabledBorder: OutlineInputBorder(
    //                   borderSide:
    //                       const BorderSide(color: Colors.deepPurpleAccent),
    //                   borderRadius: BorderRadius.circular(0),
    //                 ),
    //                 focusedBorder: OutlineInputBorder(
    //                   borderSide:
    //                       const BorderSide(color: Colors.deepPurpleAccent),
    //                   borderRadius: BorderRadius.circular(0),
    //                 ),
    //                 disabledBorder: OutlineInputBorder(
    //                   borderSide: const BorderSide(color: Colors.grey),
    //                   borderRadius: BorderRadius.circular(0),
    //                 ),
    //               ),
    //             ),
    //             dropdownSearchDecoration: InputDecoration(
    //               contentPadding: const EdgeInsets.only(left: 10),
    //               border: InputBorder.none,
    //               enabledBorder: OutlineInputBorder(
    //                 borderSide:
    //                     const BorderSide(color: Colors.deepPurpleAccent),
    //                 borderRadius: BorderRadius.circular(0),
    //               ),
    //               errorBorder: InputBorder.none,
    //               focusedBorder: OutlineInputBorder(
    //                 borderSide:
    //                     const BorderSide(color: Colors.deepPurpleAccent),
    //                 borderRadius: BorderRadius.circular(0),
    //               ),
    //               disabledBorder: OutlineInputBorder(
    //                 borderSide: const BorderSide(color: Colors.grey),
    //                 borderRadius: BorderRadius.circular(0),
    //               ),
    //               floatingLabelBehavior: FloatingLabelBehavior.always,
    //             ),
    //             items: items,
    //             onChanged: (val) {
    //               callback(val!);
    //               FocusScope.of(Get.context!).requestFocus(focusNode);
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // });
  }

  static Widget formDropDownWidthMapArrowUpDown(
    List<DropDownValue>? items,
    Function(DropDownValue) callback,
    String hint,
    double widthRatio, {
    double? height,
    bool showMenuInbottom = true,
    double? paddingBottom,
    DropDownValue? selected,
    bool? isEnable,
    String? Function(DropDownValue? value)? validator,
    bool? searchReq,
    bool autoFocus = false,
    double dialogHeight = 350,
    void Function(bool)? onFocusChange,
    double? dialogWidth,
    FocusNode? inkWellFocusNode,
    GlobalKey? widgetKey,
    bool showtitle = true,
    bool titleInLeft = false,
  }) {
    isEnable ??= true;
    widgetKey ??= GlobalKey();
    final textColor = (isEnable) ? Colors.black : Colors.grey;
    final iconLineColor = (isEnable) ? Colors.deepPurpleAccent : Colors.grey;
    inkWellFocusNode ??= FocusNode();
    FocusNode keyboard = FocusNode();
    keyboard.skipTraversal = true;
    // keyboard.descendantsAreTraversable
    keyboard.addListener(() {
      if (!keyboard.hasFocus) {
        if (onFocusChange != null) {
          onFocusChange(keyboard.hasFocus);
        }
      }
    });
    RxnInt currentIndex = RxnInt();
    final _scrollController = ScrollController();
    return Column(
      // key: titleInLeft ? null : widgetKey,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showtitle && !titleInLeft) ...{
          Text(
            hint,
            style: TextStyle(
              fontSize: SizeDefine.labelSize1,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
        },
        StatefulBuilder(builder: (context, re) {
          bool showNoRecord = false;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (titleInLeft) ...{
                Text(
                  hint,
                  style: TextStyle(
                    fontSize: SizeDefine.labelSize1,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
              },
              RawKeyboardListener(
                focusNode: keyboard!,
                onKey: (RawKeyEvent keyEvent) {
                  if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                    if (items != null && ((items.length ?? 0) > 0)) {
                      if (currentIndex.value != null &&
                          currentIndex.value != 0) {
                        currentIndex.value = currentIndex.value! - 1;
                        selected = items[currentIndex.value!];
                        re(() {});
                        callback(selected!);
                      }
                    }
                  } else if (keyEvent
                      .isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                    if (items != null && ((items.length ?? 0) > 0)) {
                      if (currentIndex.value == null) {
                        currentIndex.value = 0;
                        selected = items[currentIndex.value!];
                        re(() {});
                        callback(selected!);
                      } else if (currentIndex.value == (items.length - 1)) {
                      } else {
                        currentIndex.value = currentIndex.value! + 1;
                        selected = items[currentIndex.value!];
                        re(() {});
                        callback(selected!);
                      }
                    }
                  }
                },
                child: InkWell(
                    // key: widgetKey,
                    // key: titleInLeft ? widgetKey : null,
                    autofocus: autoFocus,
                    focusNode: inkWellFocusNode,
                    canRequestFocus: (isEnable ?? true),
                    // onFocusChange: onFocusChange,
                    onTap: (!isEnable!)
                        ? null
                        : () {
                            var isLoading = RxBool(false);

                            final RenderBox renderBox =
                                widgetKey!.currentContext?.findRenderObject()
                                    as RenderBox;
                            final offset = renderBox.localToGlobal(Offset.zero);
                            final left = offset.dx;
                            final top = (offset.dy + renderBox.size.height);
                            final right = left + renderBox.size.width;
                            final width = renderBox.size.width;
                            if ((items == null || items.isEmpty)) {
                              showMenu(
                                  context: context,
                                  useRootNavigator: true,
                                  position: RelativeRect.fromLTRB(
                                      left, top, right, 0.0),
                                  constraints: BoxConstraints.expand(
                                    width: dialogWidth ?? width,
                                    height: 120,
                                  ),
                                  items: [
                                    PopupMenuItem(
                                        child: Text(
                                      "No Record Found",
                                      style: TextStyle(
                                        fontSize:
                                            SizeDefine.dropDownFontSize - 1,
                                      ),
                                    ))
                                  ]);
                            } else {
                              var tempList = RxList<DropDownValue>([]);
                              // if (selected == null) {
                              //   tempList.addAll(items);
                              // } else {
                              for (var i = 0; i < items.length; i++) {
                                tempList.add(items[i]);
                              }
                              // }
                              showMenu(
                                context: context,
                                useRootNavigator: true,
                                position: RelativeRect.fromLTRB(
                                    left, top, right, 0.0),
                                constraints: BoxConstraints.expand(
                                  width: dialogWidth ?? width,
                                  height: dialogHeight,
                                ),
                                items: [
                                  CustomPopupMenuItem(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            SizeDefine.fontSizeInputField),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      height: dialogHeight - 20,
                                      child: Column(
                                        children: [
                                          /// search
                                          TextFormField(
                                            decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                                isDense: true,
                                                isCollapsed: true,
                                                hintText: "Search",
                                                counterText: ""),
                                            controller: TextEditingController(
                                                text: selected?.value ?? ""),
                                            autofocus: true,
                                            style: TextStyle(
                                              fontSize:
                                                  SizeDefine.fontSizeInputField,
                                            ),
                                            onChanged: ((value) {
                                              if (value.isNotEmpty) {
                                                tempList.clear();
                                                for (var i = 0;
                                                    i < items.length;
                                                    i++) {
                                                  if (items[i]
                                                      .value!
                                                      .toLowerCase()
                                                      .contains(value
                                                          .toLowerCase())) {
                                                    tempList.add(items[i]);
                                                  }
                                                }
                                              } else {
                                                tempList.clear();
                                                tempList.addAll(items);
                                                tempList.refresh();
                                              }
                                            }),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  "  "),
                                            ],
                                            maxLength: SizeDefine.maxcharlimit,
                                          ),

                                          /// progreesbar
                                          Obx(() {
                                            return Visibility(
                                              visible: isLoading.value,
                                              child:
                                                  const LinearProgressIndicator(
                                                minHeight: 3,
                                              ),
                                            );
                                          }),

                                          const SizedBox(height: 5),

                                          /// list
                                          Expanded(
                                            child: Obx(
                                              () {
                                                return Scrollbar(
                                                  controller: _scrollController,
                                                  isAlwaysShown: true,
                                                  child: ListView(
                                                    controller:
                                                        _scrollController,
                                                    shrinkWrap: true,
                                                    children: tempList
                                                        .map(
                                                          (element) => InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              selected =
                                                                  element;
                                                              re(() {});
                                                              callback(element);
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      inkWellFocusNode);
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8),
                                                              child: Text(
                                                                element.value ??
                                                                    "null",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      SizeDefine
                                                                              .dropDownFontSize -
                                                                          1,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                    child: Container(
                      key: widgetKey,
                      width: Get.width * widthRatio,
                      height: SizeDefine.heightInputField,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: iconLineColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 4),
                              child: Text(
                                (selected?.value ??
                                    (items!.isEmpty && showNoRecord
                                        ? "NO Record Found"
                                        : "")),
                                style: TextStyle(
                                  fontSize: SizeDefine.fontSizeInputField,
                                  color: textColor,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          )),
                          Icon(
                            Icons.arrow_drop_down,
                            color: iconLineColor,
                          )
                        ],
                      ),
                    )),
              ),
            ],
          );
        }),
      ],
    );
  }

  static Widget formDropDownDisableWidth(
    List? items,
    String hint,
    double widthRatio, {
    required String selected,
    double? height,
    double? paddingLeft,
    double? paddingTop,
    double? paddingBottom,
  }) {
    return Padding(
        padding: EdgeInsets.only(
            // left: SizeBox.paddingHorizontal,
            // right: SizeBox.paddingHorizontal,
            left: paddingLeft ?? 5,
            top: paddingTop ?? 6.0,
            bottom: paddingBottom ?? 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Text(hint,style: TextStyle(
                fontSize: SizeDefine.labelSize1, color: Colors.grey),),
            SizedBox(height: SizeDefine.marginGap,),*/
            LabelText.style(hint: hint, txtColor: Colors.grey),
            SizedBox(
              height: height ?? SizeDefine.heightInputField,
              width: Get.width * widthRatio,
              child: DropdownButtonFormField(
                isExpanded: true,
                disabledHint: Text(selected),
                items: items?.map((item) {
                  return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item.value!,
                        style:
                            TextStyle(fontSize: SizeDefine.fontSizeInputField),
                      ));
                }).toList(),
                onChanged: null,
                // value: selected,
                style: TextStyle(fontSize: SizeDefine.fontSizeInputField),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, right: 5),
                    // labelText: hint,
                    labelStyle: TextStyle(
                        fontSize: SizeDefine.labelSize, color: Colors.grey),
                    border: InputBorder.none,
                    // suffixIcon: Icon(
                    //   Icons.calendar_today,
                    //   size: 14,
                    //   color: Colors.deepPurpleAccent,
                    // ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: Get.width * 0.013,
                ),
                // iconSize: 42,
                // value: items.value,
              ),
            ),
          ],
        ));
  }

  static Widget formDropDown1WidthMap2(
    List<DropDownValue2>? items,
    Function(DropDownValue2) callback,
    String hint,
    double widthRatio, {
    double? height,
    bool showMenuInbottom = true,
    double? paddingBottom,
    DropDownValue2? selected,
    bool? isEnable,
    String? Function(DropDownValue2? value)? validator,
    bool? searchReq,
    bool autoFocus = false,
    bool? showSearchField = true,
    double dialogHeight = 350,
    void Function(bool)? onFocusChange,
    double? dialogWidth,
    FocusNode? inkWellFocusNode,
    GlobalKey? widgetKey,
    bool showtitle = true,
    bool titleInLeft = false,
    Function(bool dropDownOpen)? dropdownOpen,
  }) {
    isEnable ??= true;
    widgetKey ??= GlobalKey();
    final textColor = (isEnable) ? Colors.black : Colors.grey;
    final iconLineColor = (isEnable) ? Colors.deepPurpleAccent : Colors.grey;
    inkWellFocusNode ??= FocusNode();
    final _scrollController = ScrollController();
    return Column(
      // key: titleInLeft ? null : widgetKey,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showtitle && !titleInLeft) ...{
          Text(
            hint,
            style: TextStyle(
              fontSize: SizeDefine.labelSize1,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
        },
        StatefulBuilder(builder: (context, re) {
          bool showNoRecord = false;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (titleInLeft) ...{
                Text(
                  hint,
                  style: TextStyle(
                    fontSize: SizeDefine.labelSize1,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
              },
              InkWell(
                  // key: widgetKey,
                  // key: titleInLeft ? widgetKey : null,
                  autofocus: autoFocus,
                  focusNode: inkWellFocusNode,
                  canRequestFocus: (isEnable ?? true),
                  onFocusChange: onFocusChange,
                  onTap: (!isEnable!)
                      ? null
                      : () {
                          if (dropdownOpen != null) {
                            dropdownOpen(true);
                          }
                          var isLoading = RxBool(false);

                          final RenderBox renderBox = widgetKey!.currentContext
                              ?.findRenderObject() as RenderBox;
                          final offset = renderBox.localToGlobal(Offset.zero);
                          final left = offset.dx;
                          final top = (offset.dy + renderBox.size.height);
                          final right = left + renderBox.size.width;
                          final width = renderBox.size.width;
                          if ((items == null || items.isEmpty)) {
                            showMenu(
                                context: context,
                                useRootNavigator: true,
                                position: RelativeRect.fromLTRB(
                                    left, top, right, 0.0),
                                constraints: BoxConstraints.expand(
                                  width: dialogWidth ?? width,
                                  height: 120,
                                ),
                                items: [
                                  PopupMenuItem(
                                    child: Text(
                                      "No Record Found",
                                      style: TextStyle(
                                        fontSize:
                                            SizeDefine.dropDownFontSize - 1,
                                      ),
                                    ),
                                  )
                                ]).then((value) {
                              if (dropdownOpen != null) {
                                dropdownOpen(false);
                              }
                            });
                          } else {
                            var tempList = RxList<DropDownValue2>([]);
                            // if (selected == null) {
                            //   tempList.addAll(items);
                            // } else {
                            for (var i = 0; i < items.length; i++) {
                              tempList.add(items[i]);
                            }
                            // }
                            showMenu(
                              context: context,
                              useRootNavigator: true,
                              position:
                                  RelativeRect.fromLTRB(left, top, right, 0.0),
                              constraints: BoxConstraints.expand(
                                width: dialogWidth ?? width,
                                height: dialogHeight,
                              ),
                              items: [
                                CustomPopupMenuItem(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: SizeDefine.fontSizeInputField),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    height: dialogHeight - 20,
                                    child: Column(
                                      children: [
                                        /// search
                                        if (showSearchField ?? true)
                                          TextFormField(
                                            decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                                isDense: true,
                                                isCollapsed: true,
                                                hintText: "Search",
                                                counterText: ""),
                                            controller: TextEditingController(),
                                            autofocus: true,
                                            style: TextStyle(
                                              fontSize:
                                                  SizeDefine.fontSizeInputField,
                                            ),
                                            onChanged: ((value) {
                                              if (value.isNotEmpty) {
                                                tempList.clear();
                                                for (var i = 0;
                                                    i < items.length;
                                                    i++) {
                                                  if (items[i]
                                                      .value!
                                                      .toLowerCase()
                                                      .contains(value
                                                          .toLowerCase())) {
                                                    tempList.add(items[i]);
                                                  }
                                                }
                                              } else {
                                                tempList.clear();
                                                tempList.addAll(items);
                                                tempList.refresh();
                                              }
                                            }),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  "  "),
                                            ],
                                            maxLength: SizeDefine.maxcharlimit,
                                          ),

                                        /// progreesbar
                                        Obx(() {
                                          return Visibility(
                                            visible: isLoading.value,
                                            child:
                                                const LinearProgressIndicator(
                                              minHeight: 3,
                                            ),
                                          );
                                        }),

                                        const SizedBox(height: 5),

                                        /// list
                                        Expanded(
                                          child: Obx(
                                            () {
                                              return Scrollbar(
                                                controller: _scrollController,
                                                isAlwaysShown: true,
                                                child: ListView(
                                                  controller: _scrollController,
                                                  shrinkWrap: true,
                                                  children: tempList
                                                      .map(
                                                        (element) => InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            selected = element;
                                                            re(() {});
                                                            callback(element);
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    inkWellFocusNode);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                            child: Text(
                                                              element.value ??
                                                                  "null",
                                                              style: TextStyle(
                                                                fontSize: SizeDefine
                                                                        .dropDownFontSize -
                                                                    1,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ).then((value) {
                              if (dropdownOpen != null) {
                                dropdownOpen(false);
                              }
                            });
                          }
                        },
                  child: Container(
                    key: widgetKey,
                    width: Get.width * widthRatio,
                    height: SizeDefine.heightInputField,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: iconLineColor,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 4),
                            child: Text(
                              (selected?.value ??
                                  (items!.isEmpty && showNoRecord
                                      ? "NO Record Found"
                                      : "")),
                              style: TextStyle(
                                fontSize: SizeDefine.fontSizeInputField,
                                color: textColor,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        )),
                        Icon(
                          Icons.arrow_drop_down,
                          color: iconLineColor,
                        )
                      ],
                    ),
                  )),
            ],
          );
        }),
      ],
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
