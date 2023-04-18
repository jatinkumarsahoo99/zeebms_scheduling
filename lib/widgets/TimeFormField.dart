import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'input_fields.dart';

class TimeInputField extends StatefulWidget {
  const TimeInputField({Key? key}) : super(key: key);

  @override
  _TimeInputFieldState createState() => _TimeInputFieldState();
}

class _TimeInputFieldState extends State<TimeInputField> {
  String hrCounter = '00';
  String minCounter = '00';
  String secCounter = '00';
  String frameCounter = '00';
  String temp="";

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        controller: _controller,
        keyboardType:
        const TextInputType.numberWithOptions(decimal: false),
        inputFormatters: [
          LengthLimitingTextInputFormatter(9),
          RangeTextInputFormatter60()
        ],
        decoration: InputDecoration(
            hintText: '$hrCounter:$minCounter:$secCounter',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: '$hrCounter:$minCounter:$secCounter'),
        onChanged: (val) {
          String y="";
          switch (val.length) {
            case 0:
              setState(() {
                hrCounter = "00";
                minCounter = "00";
                secCounter = "00";
              });
              break;
            case 1:
              setState(() {
                secCounter = "0"+val;
                temp=val;
                _controller.value = _controller.value.copyWith(
                  text: hrCounter+":"+minCounter+":"+secCounter,
                  selection: const TextSelection.collapsed(offset: 8),
                );
              });
              break;
            default: setState((){
              for(int i=1;i<=val.length-1;i++){
                y=y+val.substring(i,i+1);
              }
              y=y.replaceAll(":", "");
              val=y.substring(0,2)+":"+y.substring(2,4)+":"+y.substring(4,6);
              temp=val;
              _controller.value = _controller.value.copyWith(
                text: val,
                selection: const TextSelection.collapsed(offset: 8),
              );
            });
            break;

          }
        },
      ),
    );
  }
}