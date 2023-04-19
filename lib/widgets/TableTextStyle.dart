import 'package:flutter/material.dart';

class TableTextStyle extends StatelessWidget {
  TableTextStyle({Key? key, required  this.title}) : super(key: key);
  String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
    );
    ;
  }
}
