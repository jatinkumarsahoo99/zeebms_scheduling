// import 'package:bms_programming/app/controller/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';/*

class DashboardDrawer extends StatefulWidget {
  const DashboardDrawer({Key? key, required this.controller}) : super(key: key);
  final HomeController controller;

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  bool isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        builder: (controller) {
      if (controller.drawerModel == null) {
        return Container();
      } else {
        return AnimatedContainer(
          padding: EdgeInsets.zero,
          duration: Duration(milliseconds: 100),
          width: isCollapsed ? 68 : 268,
          child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              // clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[300],
                    ),
                    margin: EdgeInsets.zero,
                    width: 68,
                    child: Column(mainAxisSize: MainAxisSize.max,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: [
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    right: 3,
                                    left: 3,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      useRootNavigator: true,
                                      builder: (BuildContext context) {
                                        return SearchDialog(
                                          controller: controller,
                                        );
                                      });
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                              ),
                              GetBuilder<DashboardController>(
                                  id: "drawerselection",
                                  //for selection
                                  builder: (controller) {
                                    if (controller.drawerModel == null) {
                                      return Container();
                                    } else {
                                      //Parent List View
                                      return Column(
                                        children: [
                                          for (var parent in controller
                                              .drawerModel!.parent!)
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isCollapsed = false;
                                                });
                                                controller
                                                    .updateDarwerSelection(
                                                        parent.id, "0", "0");
                                              },
                                              child: AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 100),
                                                decoration: parent.id ==
                                                        controller
                                                            .currentParentValue
                                                            .value
                                                    ? BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 4)))
                                                    : BoxDecoration(),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2, vertical: 8),
                                                child: Column(
                                                  children: [
                                                    ParentIcon(
                                                      id: parent.id!,
                                                      selected: parent.id ==
                                                              controller
                                                                  .currentParentValue
                                                                  .value
                                                          ? true
                                                          : false,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      parent.name!
                                                          .toUpperCase(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                        ],
                                      );
                                    }
                                  }),
                            ],
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: InkWell(
                                  onTap: () {
                                    controller.logout();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black26,
                                    radius: 20,
                                    child: Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                )),
                          ),
                          // SizedBox(height: 10,),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isCollapsed = !isCollapsed;
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black26,
                                    radius: 20,
                                    child: Icon(
                                      isCollapsed
                                          ? Icons.arrow_forward_ios_rounded
                                          : Icons.arrow_back_ios_new_outlined,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                )),
                          ),

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
                  ),

                  // Sub Childs //
                  if (!isCollapsed)
                    GetBuilder<DashboardController>(
                        id: "drawerselection",
                        //for selection
                        builder: (controller) {
                          if (controller.drawerModel == null) {
                            return Container();
                          } else {
                            var selectedParent = controller.drawerModel!.parent!
                                .firstWhere((element) =>
                                    element.id ==
                                    controller.currentParentValue.value);
                            return Expanded(
                              child: Container(
                                  width: 200,
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: ListView(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          selectedParent.name!.toUpperCase(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      for (var child in selectedParent.child!)
                                        ExpansionTile(
                                          title: Text(child.name!),
                                          children: [
                                            for (var subChild
                                                in child.subChild!)
                                              ListTile(
                                                title: Text(subChild.name!),
                                                onTap: () {
                                                  setState(() {
                                                    isCollapsed = true;
                                                  });
                                                  controller
                                                      .updateDarwerSelection(
                                                          selectedParent.id,
                                                          child.id,
                                                          subChild.id);
                                                },
                                              )
                                          ],
                                        )
                                    ],
                                  )),
                            );
                          }
                        })
                ],
              )),
        );
      }
    });
  }
}*/
