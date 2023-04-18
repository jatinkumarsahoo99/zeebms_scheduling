// import 'package:bms_programming/app/controller/HomeController.dart';
// import 'package:bms_programming/widgets/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*class DrawerPage extends StatelessWidget {
  HomeController controller;

  DrawerPage({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // elevation: ,
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: ListTile(
            textColor: Colors.white,
            iconColor: Colors.white,
            trailing: const Icon(
              Icons.search,
            ),
            title: const Text('BMS v0.1'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SearchDialog(
                      controller: controller,
                    );
                  });
            },
          ),
        ),
        GetBuilder<HomeController>(builder: (controller) {
          if (controller.drawerModel == null) {
            return Container();
          } else {
            //Parent List View
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (c, i) {
                return Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ExpansionTile(
                        title:
                            Text(controller.drawerModel?.parent?[i].name ?? ""),
                        children: [
                          //Child List View
                          ListView.builder(
                            padding: const EdgeInsets.only(left: 10),
                            itemBuilder: (c, j) {
                              return ExpansionTile(
                                title: Text(controller.drawerModel?.parent?[i]
                                        .child?[j].name ??
                                    ""),
                                children: [
                                  //Sub Child List View
                                  ListView.builder(
                                    itemBuilder: (c, k) {
                                      return ListTile(
                                        title: Text(controller
                                                .drawerModel
                                                ?.parent?[i]
                                                .child?[j]
                                                .subChild?[k]
                                                .name ??
                                            ""),
                                        trailing: Icon(Icons.arrow_right),
                                        onTap: () {
                                          controller.updateSelection(controller
                                                  .drawerModel
                                                  ?.parent?[i]
                                                  .child?[j]
                                                  .subChild?[k]
                                                  .id ??
                                              "");
                                        },
                                      );
                                    },
                                    padding: const EdgeInsets.only(left: 10),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: controller.drawerModel
                                        ?.parent?[i].child?[j].subChild?.length,
                                  )
                                ],
                              );
                            },
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller
                                .drawerModel?.parent?[i].child?.length,
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
              itemCount: controller.drawerModel?.parent?.length,
            );
          }
        })
        *//*ExpansionTile(
          backgroundColor: Colors.white,
          leading: Icon(Icons.person_pin_rounded),
          title: Text('Administration'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                backgroundColor: Colors.white,
                leading: Icon(Icons.miscellaneous_services_outlined),
                title: Text('Master'),
                children: [],
              ),
            ),
          ],
        ),
        ExpansionTile(
          backgroundColor: Colors.white,
          leading: Icon(Icons.pending_actions_rounded),
          title: Text('Programming & Marketing'),
        ),*//*
      ]),
    );
  }
}*/
