import 'package:flutter/material.dart';

import '../app/providers/SizeDefine.dart';

class NumericStepButton1 extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final String? hint;
  final int count;

  final ValueChanged<int> onChanged;

  NumericStepButton1(
      {Key? key,
        this.minValue = 1,
        this.maxValue = 100,
        required this.onChanged,
        this.hint,this.count = 1})
      : super(key: key);

  @override
  State<NumericStepButton1> createState() {
    return _NumericStepButton1State();
  }
}

class _NumericStepButton1State extends State<NumericStepButton1> {
  int counter = 1;
  TextEditingController txtCont = TextEditingController();
  @override
  void initState() {
    counter = widget.count;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.hint ?? "No",
          style: TextStyle(fontSize: SizeDefine.labelSize1),
        ),
        SizedBox(
          height: SizeDefine.marginGap,
        ),
        Container(
          decoration:
          BoxDecoration(border: Border.all(color: Colors.deepPurpleAccent)),
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove,
                  color: Theme.of(context).primaryColorLight,
                ),
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                iconSize: 18.0,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    if (counter > widget.minValue) {
                      counter--;
                    }
                    widget.onChanged(counter);
                  });
                },
              ),
              Text(
                '$counter',
                // controller: txtCont,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).primaryColorLight,
                ),
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                iconSize: 18.0,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    if (counter < widget.maxValue) {
                      counter++;
                    }
                    txtCont.text = counter.toString();
                    widget.onChanged(counter);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
