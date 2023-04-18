import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:html' as html;

import '../app/providers/SizeDefine.dart';
import '../app/providers/Utils.dart';
import 'LoadingDialog.dart';

class FormButtonWrapper extends StatelessWidget {
  final String btnText;
  final VoidCallback? callback;
  final double? height;
  final bool? isEnabled;
  final IconData? iconDataM;
  final FocusNode? focusNode;
  final bool showIcon;

  FormButtonWrapper({
    required this.btnText,
    this.callback,
    this.focusNode,
    this.height = 25,
    this.isEnabled,
    this.iconDataM,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FormButton(
        focusNode: focusNode,
        btnText: btnText,
        callback: callback,
        isEnabled: isEnabled,
        iconDataM: iconDataM,
        showIcon: showIcon,
      ),
    );
  }
}

class FormButton extends StatelessWidget {
  final String btnText;
  final VoidCallback? callback;
  final bool? isEnabled;
  final FocusNode? focusNode;
  final IconData? iconDataM;
  final bool showIcon;

  const FormButton(
      {Key? key,
      required this.btnText,
      this.callback,
      this.isEnabled,
      this.focusNode,
      this.showIcon = true,
      this.iconDataM})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var iconData;
    if (btnText.toLowerCase() == "save") {
      iconData = Icons.save;
    } else if (btnText.toLowerCase() == "delete" ||
        btnText.toLowerCase() == "delete variance") {
      iconData = Icons.delete;
    } else if (btnText.toLowerCase() == "refresh") {
      iconData = Icons.refresh;
    } else if (btnText.toLowerCase() == "clear") {
      iconData = Icons.cleaning_services_outlined;
    } else if (btnText.toLowerCase() == "exit") {
      iconData = Icons.exit_to_app;
    } else if (btnText.toLowerCase() == "search") {
      iconData = Icons.search;
    } else if (btnText.toLowerCase() == "docs") {
      iconData = Icons.folder;
    } else if (btnText.toLowerCase() == "add" ||
        btnText.toLowerCase() == "add default segment" ||
        btnText.toLowerCase() == "add variance") {
      iconData = Icons.add;
    } else if (btnText.toLowerCase() == "next") {
      iconData = Icons.next_plan;
    } else if (btnText.toLowerCase() == "schedule") {
      iconData = Icons.schedule_outlined;
    } else if (btnText.toLowerCase() == "actuals/default") {
      iconData = Icons.person;
    } else if (btnText.toLowerCase() == "yes") {
      iconData = CupertinoIcons.check_mark_circled_solid;
    } else if (btnText.toLowerCase() == "no") {
      iconData = CupertinoIcons.clear_circled_solid;
    } else if (btnText.toLowerCase() == "map") {
      iconData = CupertinoIcons.arrow_right_arrow_left_circle;
    } else if (btnText.toLowerCase() == "summary") {
      iconData = Icons.plagiarism_outlined;
    } else if (btnText.toLowerCase() == "segment") {
      iconData = Icons.segment;
    } else if (btnText.toLowerCase() == "breakfile") {
      iconData = Icons.insert_page_break;
    } else if (btnText.toLowerCase() == "adjust dur") {
      iconData = Icons.adjust;
    } else if (btnText.toLowerCase() == "auto adjust") {
      iconData = Icons.commit;
    } else if (btnText.toLowerCase() == "show details") {
      iconData = Icons.description_sharp;
    } else if (btnText.toLowerCase() == "default") {
      iconData = CupertinoIcons.settings;
    } else if (btnText.toLowerCase() == "view day") {
      iconData = CupertinoIcons.brightness;
    } else if (btnText.toLowerCase() == "generate") {
      iconData = Icons.settings_suggest;
    } else if (btnText.toLowerCase() == "execute") {
      iconData = Icons.start;
    } else if (btnText.toLowerCase() == "ok" ||
        btnText.toLowerCase() == "done") {
      iconData = Icons.done;
    } else if (btnText.toLowerCase() == "show programs") {
      iconData = Icons.remove_red_eye;
    } else if (btnText.toLowerCase() == "cancel") {
      iconData = Icons.cancel;
    } else if (btnText.toLowerCase() == "undo") {
      iconData = Icons.undo;
    } else if (btnText.toLowerCase() == "validate") {
      iconData = Icons.verified_user_rounded;
    } else if (btnText.toLowerCase() == "fc") {
      iconData = Icons.color_lens_outlined;
    } else if (btnText.toLowerCase() == "bc") {
      iconData = Icons.color_lens;
    } else if (btnText.toLowerCase() == "copy segments/annotation") {
      iconData = Icons.copy;
    } else {
      iconData = Icons.error;
    }
    if (iconDataM != null) {
      iconData = iconDataM;
    }

    return ElevatedButton.icon(
      focusNode: focusNode,
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.deepPurple[900])),
      onPressed: (isEnabled ?? true)
          ? (btnText == "Exit")
              ? () {
                  LoadingDialog.callExitForm(() {
                    if (html.window.location.href.contains("loginCode")) {
                      Utils.callJSToExit(param: "exit|${Utils.getFormName()}");
                      callback!();
                    } else {
                      Get.back();
                    }
                  });
                }
              : callback
          : null,
      icon: showIcon ? Icon(iconData, size: 16) : const SizedBox(width: 0),
      label: Text(
        btnText,
        style: TextStyle(fontSize: SizeDefine.fontSizeButton),
      ),
    );

    // if (iconData == null) {
    //   return ElevatedButton(
    //     onPressed: (isEnabled ?? true)
    //         ? (btnText == "Exit")
    //             ? () {
    //                 LoadingDialog.callExitForm(() {
    //                   Get.find<HomeController>()
    //                       .updateDarwerSelection(0, "0", "0");
    //                   Get.find<HomeController>()
    //                     ..selectChild1.value = null;
    //                   callback!();
    //                 });
    //               }
    //             : callback
    //         : null,
    //     // icon: ,
    //     child: Text(
    //       btnText,
    //       style: TextStyle(fontSize: SizeDefine.fontSizeButton),
    //     ),
    //     style: ElevatedButton.styleFrom(
    //       foregroundColor: Colors.white,
    //       backgroundColor: Colors.deepPurple,
    //     ),
    //   );
    // } else {
    //   return IconButton(
    //     onPressed: (isEnabled ?? true)
    //         ? (btnText == "Exit")
    //             ? () {
    //                 LoadingDialog.callExitForm(() {
    //                   Get.find<HomeController>()
    //                       .updateDarwerSelection(0, "0", "0");
    //                   Get.find<HomeController>()
    //                     ..selectChild1.value = null;
    //                   callback!();
    //                 });
    //               }
    //             : callback
    //         : null,
    //     icon: Icon(iconData),
    //     color: (isEnabled ?? true) ? Colors.deepPurpleAccent : Colors.grey,
    //     tooltip: btnText,
    //     disabledColor: Colors.grey,
    //   );
    // }
  }
}

class DailogCloseButton extends StatefulWidget {
  final String btnText;
  final VoidCallback? callback;
  final bool? isEnabled;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final IconData? iconDataM;

  const DailogCloseButton(
      {Key? key,
      required this.btnText,
      this.callback,
      this.isEnabled,
      this.focusNode,
      this.autoFocus = false,
      this.iconDataM})
      : super(key: key);

  @override
  State<DailogCloseButton> createState() => _DailogCloseButtonState();
}

class _DailogCloseButtonState extends State<DailogCloseButton> {
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        FocusScope.of(context).requestFocus(widget.focusNode);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var iconData;
    if (widget.btnText.toLowerCase() == "save") {
      iconData = Icons.save;
    } else if (widget.btnText.toLowerCase() == "delete") {
      iconData = Icons.delete;
    } else if (widget.btnText.toLowerCase() == "ok") {
      iconData = Icons.done;
    } else if (widget.btnText.toLowerCase() == "refresh") {
      iconData = Icons.refresh;
    } else if (widget.btnText.toLowerCase() == "clear" ||
        widget.btnText.toLowerCase() == "cancel") {
      iconData = Icons.clear;
    } else if (widget.btnText.toLowerCase() == "exit") {
      iconData = Icons.exit_to_app;
    } else if (widget.btnText.toLowerCase() == "search") {
      iconData = Icons.search;
    } else if (widget.btnText.toLowerCase() == "docs") {
      iconData = Icons.folder;
    } else if (widget.btnText.toLowerCase() == "add") {
      iconData = Icons.add;
    } else if (widget.btnText.toLowerCase() == "next") {
      iconData = Icons.next_plan;
    } else if (widget.btnText.toLowerCase() == "schedule") {
      iconData = Icons.schedule_outlined;
    } else if (widget.btnText.toLowerCase() == "actuals/default") {
      iconData = Icons.person;
    } else if (widget.btnText.toLowerCase() == "yes") {
      iconData = CupertinoIcons.check_mark_circled_solid;
    } else if (widget.btnText.toLowerCase() == "undo") {
      iconData = Icons.undo;
    } else if (widget.btnText.toLowerCase() == "no") {
      iconData = CupertinoIcons.clear_circled_solid;
    } else {
      iconData = Icons.error;
    }
    if (widget.iconDataM != null) {
      iconData = widget.iconDataM;
    }

    return ElevatedButton.icon(
      focusNode: widget.focusNode,
      onPressed: (widget.isEnabled ?? true)
          ? (widget.btnText == "Exit")
              ? () {
                  LoadingDialog.callExitForm(() {
                    if (html.window.location.href.contains("dashboard")) {
                      // Get.find<HomeController>().updateDarwerSelection(0, "0", "0");
                      // Get.find<HomeController>().updateDarwerSelection(0, "0", "0");
                      // Get.find<HomeController>()..selectChild1.value = null;
                      if (kIsWeb) {
                        SystemChrome.setApplicationSwitcherDescription(
                          ApplicationSwitcherDescription(label: "Zee BMS"),
                        );
                      }
                      widget.callback!();
                    } else {
                      Get.back();
                    }
                  });
                }
              : widget.callback
          : null,
      icon: Icon(iconData, size: 16),
      autofocus: widget.autoFocus,
      label: Text(
        widget.btnText,
        style: TextStyle(fontSize: SizeDefine.fontSizeButton),
      ),
    );
    if (iconData == null) {
      return ElevatedButton(
        onPressed: (widget.isEnabled ?? true)
            ? (widget.btnText == "Exit")
                ? () {
                    LoadingDialog.callExitForm(() {
                      // Get.find<HomeController>().updateDarwerSelection(0, "0", "0");
                      // Get.find<HomeController>()..selectChild1.value = null;
                      widget.callback!();
                    });
                  }
                : widget.callback
            : null,
        // icon: ,
        child: Text(
          widget.btnText,
          style: TextStyle(fontSize: SizeDefine.fontSizeButton),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
        ),
      );
    } else {
      return IconButton(
        onPressed: (widget.isEnabled ?? true)
            ? (widget.btnText == "Exit")
                ? () {
                    LoadingDialog.callExitForm(() {
                      // Get.find<HomeController>().updateDarwerSelection(0, "0", "0");
                      // Get.find<HomeController>()..selectChild1.value = null;
                      widget.callback!();
                    });
                  }
                : widget.callback
            : null,
        icon: Icon(iconData),
        color:
            (widget.isEnabled ?? true) ? Colors.deepPurpleAccent : Colors.grey,
        tooltip: widget.btnText,
        disabledColor: Colors.grey,
      );
    }
  }
}

class FormButton1 extends StatelessWidget {
  final String btnText;

  // final isDisabled;
  final VoidCallback? callback;
  final Color? color;

  FormButton1({required this.btnText, this.callback, this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (btnText == "Exit")
          ? () {
              LoadingDialog.callExitForm(() {
                // Get.find<HomeController>().updateDarwerSelection(0, "0", "0");
                // Get.find<HomeController>()..selectChild1.value = null;
                callback!();
              });
            }
          : callback,
      child: Text(
        btnText,
        style: TextStyle(fontSize: SizeDefine.fontSizeButton),
      ),
      style: ElevatedButton.styleFrom(
        primary: color ?? Colors.deepPurple,
        onPrimary: Colors.white,
      ),
    );
  }
}
