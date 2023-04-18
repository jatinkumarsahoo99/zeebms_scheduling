import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/controller/ConnectorControl.dart';
import '../../app/data/DropDownValue.dart';
import '../../app/providers/SizeDefine.dart';
import '../LabelTextStyle.dart';

class CommonSearchDropDown extends StatelessWidget {
  CommonSearchDropDown(
      {Key? key,
      this.onChanged,
      required this.api,
      this.widthRatio = 0.20,
      this.height,
      this.leftPad,
      this.controller,
      this.validator,
      this.topPad,
      this.hint = "Program",
      this.isEnable,
      this.parseKey = "programCode",
      this.parseValue = "programName"})
      : super(key: key);
  final String? Function(String?)? validator;
  final Function(DropDownValue?)? onChanged;
  final String? parseKey;
  final String? parseValue;
  final String? hint;
  final String api;

  final double widthRatio;
  final double? leftPad;

  final double? height;

  final double? topPad;
  final RxBool? isEnable;

  TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelText.style(hint: hint),
        Container(
          height: SizeDefine.heightInputField,
          width: Get.width * (widthRatio),
          child: DropdownSearch<DropDownValue>(
            popupProps: PopupProps.menu(
              showSelectedItems: false,
              showSearchBox: true,

              // disabledItemFn: (String s) => s.startsWith('I'),
            ),
            enabled: isEnable != null ? isEnable!.value : true,

            asyncItems: (keyword) async {
              List<DropDownValue> _items = [];
              print("${api}$keyword");
              await Get.find<ConnectorControl>().GETMETHODCALL(
                  api: "${api}$keyword",
                  fun: (map) async {
                    print(map.toString());

                    _items.clear();
                    for (var item in map) {
                      _items.add(DropDownValue(
                          key: item[parseKey].toString(),
                          value: item[parseValue]));
                    }
                  });
              return _items;
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Menu mode",
                hintText: "country in menu mode",
              ),
            ),
            onChanged: onChanged,
            // selectedItem: "Brazil",
          ),
        ),
      ],
    );
  }
}
