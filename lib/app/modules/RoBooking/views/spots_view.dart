// import 'package:bms_scheduling/widgets/cutom_dropdown.dart';
import 'package:bms_scheduling/widgets/cutom_dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SpotsView extends GetView {
  const SpotsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpotsView'),
        centerTitle: true,
      ),
      body: Center(
        child: CustomDropDown(
          options: [
            DropDownValue(label: 'Option 1', value: 1),
            DropDownValue(label: 'Option 2', value: 2),
            DropDownValue(label: 'Option 3', value: 3),
            DropDownValue(label: 'Option 4', value: 4),
            DropDownValue(label: 'Option 5', value: 5),
          ],
          onSelected: (option) => print('Selected: ${option?.label}'),
          hint: 'Select an option',
          widthRatio: 0.5,
          showSearchBar: true,
          showProgressBar: true,
        ),
      ),
    );
  }
}
