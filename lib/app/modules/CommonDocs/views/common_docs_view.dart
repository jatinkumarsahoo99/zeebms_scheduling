import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../widgets/DataGridShowOnly.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../controllers/common_docs_controller.dart';

class CommonDocsView extends GetView<CommonDocsController> {
  final String documentKey;
  const CommonDocsView({
    Key? key,
    required this.documentKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width * .7,
        height: context.height * .5,
        child: Scaffold(
          body: FutureBuilder<bool>(
            initialData: false,
            future: controller.getInitailData(documentKey),
            builder: (context, snapshot) {
              if (snapshot.data!) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (value) {
                        if (value.isKeyPressed(LogicalKeyboardKey.delete)) {
                          LoadingDialog.delete(
                            "Want to delete selected row",
                            () => controller.handleOnDelete(documentKey),
                            cancel: () {},
                          );
                        }
                      },
                      child: DataGridShowOnlyKeys(
                        hideCode: true,
                        hideKeys: const ["documentId"],
                        dateFromat: "dd-MM-yyyy HH:mm",
                        mode: PlutoGridMode.selectWithOneTap,
                        mapData: controller.documents.map((e) => e.toJson()).toList(),
                        onload: (loadGrid) {
                          controller.viewDocsStateManger = loadGrid.stateManager;
                        },
                        onRowDoubleTap: controller.handleOnRowDoubleTap,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FormButton(btnText: "Add Docs", callback: () => controller.handleAddDocs(documentKey)),
                        const SizedBox(width: 20),
                        FormButton(btnText: "View Doc", callback: () => controller.handleViewDocs(documentKey)),
                      ],
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
