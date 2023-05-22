import 'package:flutter/material.dart';
import '../../../data/system_envirtoment.dart';

class SearchListPage extends StatelessWidget {
  SearchListPage({Key? key, required this.list}) : super(key: key);
  List<SystemEnviroment> list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Checkbox(value: false, onChanged: (v){}),
            Text(list[index].value.toString()),
            Text(list[index].key.toString()),
          ],
        );
      },
        itemCount: list.length,

      ),
    );
  }
}
