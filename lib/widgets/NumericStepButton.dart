import 'package:flutter/material.dart';

import '../app/providers/SizeDefine.dart';

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final String? hint;

  final ValueChanged<int> onChanged;

  NumericStepButton(
      {Key? key, this.minValue = 1, this.maxValue = 100, required this.onChanged,this.hint})
      : super(key: key);

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {

  int counter= 1;
  TextEditingController txtCont=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.hint??"No",style: TextStyle(fontSize: SizeDefine.labelSize1),),
        SizedBox(height: SizeDefine.marginGap,),
        Container(
          decoration:BoxDecoration(border: Border.all(color: Colors.deepPurpleAccent)),
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove,
                  color: Theme.of(context).accentColor,
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
                  color: Theme.of(context).accentColor,
                ),
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                iconSize: 18.0,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    if (counter < widget.maxValue) {
                      counter++;
                    }
                    txtCont.text=counter.toString();
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