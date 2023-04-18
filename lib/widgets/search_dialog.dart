import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
/*
class SearchDialog extends StatefulWidget {
  SearchDialog({Key? key, required this.controller}) : super(key: key);
  DashboardController controller;

  @override
  State<SearchDialog> createState() => _SearchDailogState();
}

class _SearchDailogState extends State<SearchDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String keyword = "";

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return GetBuilder<DashboardController>(builder: (controller) {
      return Dialog(
        elevation: 2,
        child: Builder(builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width / 3,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 2),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        keyword = value;
                      });
                      log(keyword);
                    },
                    style: TextStyle(
                        fontSize: SizeDefine.fontSizeInputField,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'What do you want to search?',
                        prefixIcon: Icon(Icons.search)),
                  ),
                  Expanded(
                      child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: ListView(
                      // shrinkWrap: true,
                      controller: scrollController,
                      children: [
                        if (keyword != "")
                          for (var parent
                              in widget.controller.drawerModel!.parent!)
                            for (var child in parent.child!)
                              for (var subchild in child.subChild!)
                                if (subchild.name!
                                    .toLowerCase()
                                    .contains(keyword.toLowerCase()))
                                  ListTile(
                                    title: Text(
                                      subchild.name!,
                                      style: TextStyle(
                                          fontSize:
                                              SizeDefine.fontSizeInputField,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      controller.sendFormNameAPI(subchild.name);
                                      Navigator.pop(context);
                                      // controller.updateDarwerSelection(parent.id, child.id, subchild.id);
                                      controller.currentSubChildValue.value =
                                          subchild.id!;
                                      print(subchild.toJson());
                                      // controller.toggleFullScreen(value: true);
                                      controller.selectChild = subchild;
                                      controller.selectChild1.value = subchild;
                                      controller.update(["drawerselection"]);
                                    },
                                  )
                      ],
                    ),
                  ))
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}*/
