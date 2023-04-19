import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../app/providers/SizeDefine.dart';


class TimeWithThreeTextField extends StatefulWidget {
  final String title, splitType;
  final int hour, minutes, second, frame;
  final bool isTime;
  final TextEditingController mainTextController;
  final bool isEnable;
  final double widthRation;
  final void Function(String time)? onFocusChange;
  const TimeWithThreeTextField({
    Key? key,
    required this.title,
    required this.mainTextController,
    this.splitType = ":",
    this.hour = 23,
    this.minutes = 59,
    this.second = 59,
    this.frame = 30,
    this.isTime = true,
    this.isEnable = true,
    this.widthRation = .15,
    this.onFocusChange,
  }) : super(key: key);

  @override
  State<TimeWithThreeTextField> createState() =>
      _DateTimeWithThreeTextFieldState();
}

class _DateTimeWithThreeTextFieldState extends State<TimeWithThreeTextField> {
  late List<TextEditingController> textCtr;
  late List<FocusNode> focus;
  var iconFocusNode = FocusNode();

  @override
  void initState() {
    focus = List.generate(widget.isTime ? 3 : 4, (index) => FocusNode());
    if (widget.mainTextController.text.isEmpty) {
      textCtr = List.generate(
          widget.isTime ? 3 : 4, (index) => TextEditingController(text: "00"));
    } else {
      textCtr = List.generate(
          widget.isTime ? 3 : 4, (index) => TextEditingController(text: "00"));
      assignNewValeToEditTextField();
      widget.mainTextController.addListener(() {
        assignNewValeToEditTextField();
      });
    }
    super.initState();
    handleOnFocusChange();
  }

  // var tempFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    removeFocusListener();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = (widget.isEnable) ? Colors.black : Colors.grey;
    final borderColor =
        (widget.isEnable) ? Colors.deepPurpleAccent : Colors.grey;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        Text(
          widget.title,
          style: TextStyle(
            fontSize: SizeDefine.labelSize1,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),

        /// BOX
        Container(
          height: SizeDefine.heightInputField,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          width: Get.width * widget.widthRation,
          decoration: BoxDecoration(border: Border.all(color: borderColor)),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              /// HH:MM:SS:FF Textinput fields
              SizedBox(
                width: widget.isTime ? 55 : 80,
                child: Row(
                  children: [
                    /// Hours
                    Expanded(
                      child: RawKeyboardListener(
                        focusNode: focus[0],
                        onKey: (event) {
                          if (event.isShiftPressed &&
                              event.isKeyPressed(LogicalKeyboardKey.tab)) {
                            // FocusScope.of(context).previousFocus(); //hours
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.tab)) {
                            FocusScope.of(context).nextFocus(); //minutes
                            FocusScope.of(context).nextFocus(); // seconds
                            if (!widget.isTime) {
                              FocusScope.of(context).nextFocus(); // frame
                            } else {
                              FocusScope.of(context).nextFocus(); // icon

                            }
                            if (widget.onFocusChange != null) {
                              assignValueToMainTextEditingController();
                              widget.onFocusChange!(
                                  widget.mainTextController.text);
                            }
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                            FocusScope.of(context).nextFocus(); //minutes
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                            cursorAtLast(0);
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                            incrementDecrementOnKeyBoardEvent(0, widget.hour);
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                            incrementDecrementOnKeyBoardEvent(0, widget.hour,
                                up: false);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: TextFormField(
                            controller: textCtr[0],
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: style,
                            onChanged: (value) {
                              int no = int.tryParse(value) ?? 00;
                              if (no > widget.hour) {
                                textCtr[0].text = "00";
                                cursorAtLast(0);
                              }
                              if (value.length == 2) {
                                cursorAtLast(0);
                              }
                            },
                            maxLength: 2,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor,
                            ),
                            showCursor: false,
                            enabled: widget.isEnable,
                          ),
                        ),
                      ),
                    ),

                    /// Split 1
                    Text(
                      widget.splitType,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor,
                      ),
                    ),

                    /// Minutes
                    Expanded(
                      child: RawKeyboardListener(
                        focusNode: focus[1],
                        onKey: (event) {
                          if (event.isShiftPressed &&
                              event.isKeyPressed(LogicalKeyboardKey.tab)) {
                            FocusScope.of(context).previousFocus(); //hours
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.tab)) {
                            FocusScope.of(context).nextFocus(); // seconds
                            if (!widget.isTime) {
                              FocusScope.of(context).nextFocus(); // frame
                            } else {
                              FocusScope.of(context).nextFocus(); // icon
                            }
                            if (widget.onFocusChange != null) {
                              assignValueToMainTextEditingController();
                              widget.onFocusChange!(
                                  widget.mainTextController.text);
                            }
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                            FocusScope.of(context).previousFocus(); //hours
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                            FocusScope.of(context).nextFocus(); //seconds
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                            incrementDecrementOnKeyBoardEvent(1, widget.second);
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                            incrementDecrementOnKeyBoardEvent(1, widget.second,
                                up: false);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: TextFormField(
                            controller: textCtr[1],
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: style,
                            onChanged: (value) {
                              int no = int.tryParse(value) ?? 00;
                              if (no > widget.second) {
                                textCtr[1].text = "00";
                                cursorAtLast(1);
                              }
                              if (value.length == 2) {
                                cursorAtLast(1);
                              }
                            },
                            maxLength: 2,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor,
                            ),
                            showCursor: false,
                            enabled: widget.isEnable,
                          ),
                        ),
                      ),
                    ),

                    /// Split 2
                    Text(
                      widget.splitType,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor,
                      ),
                    ),

                    /// Seconds
                    Expanded(
                      child: RawKeyboardListener(
                        focusNode: focus[2],
                        onKey: (event) {
                          if (event.isShiftPressed &&
                              event.isKeyPressed(LogicalKeyboardKey.tab)) {
                            FocusScope.of(context).previousFocus(); //minutes
                            FocusScope.of(context).previousFocus(); //Hours
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.tab)) {
                            if (!widget.isTime) {
                              FocusScope.of(context)
                                  .nextFocus(); // next widget get focus
                            } else {
                              FocusScope.of(context).nextFocus(); // icon
                            }
                            if (widget.onFocusChange != null) {
                              assignValueToMainTextEditingController();
                              widget.onFocusChange!(
                                  widget.mainTextController.text);
                            }
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                            incrementDecrementOnKeyBoardEvent(2, widget.second);
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                            FocusScope.of(context).previousFocus(); //minutes
                            // cursorAtLast(1);
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                            if (!widget.isTime) {
                              FocusScope.of(context)
                                  .nextFocus(); // frame per second
                            } else {
                              cursorAtLast(2);
                            }
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                            incrementDecrementOnKeyBoardEvent(2, widget.second,
                                up: false);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: TextFormField(
                            controller: textCtr[2],
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: style,
                            onChanged: (value) {
                              int no = int.tryParse(value) ?? 00;
                              if (no > widget.second) {
                                textCtr[2].text = "00";
                                cursorAtLast(2);
                              }
                              if (value.length == 2) {
                                cursorAtLast(2);
                              }
                            },
                            textAlign: TextAlign.right,
                            maxLength: 2,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor,
                            ),
                            showCursor: false,
                            enabled: widget.isEnable,
                          ),
                        ),
                      ),
                    ),

                    /// Frame Per Second
                    if (!widget.isTime) ...{
                      /// Split 3
                      Text(
                        widget.splitType,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                        ),
                      ),
                      Expanded(
                        child: RawKeyboardListener(
                          focusNode: focus[3],
                          onKey: (event) {
                            if (event.isShiftPressed &&
                                event.isKeyPressed(LogicalKeyboardKey.tab)) {
                              FocusScope.of(context).previousFocus(); //second
                              FocusScope.of(context).previousFocus(); //minutes
                              FocusScope.of(context).previousFocus(); //Hours
                            } else if (event
                                .isKeyPressed(LogicalKeyboardKey.tab)) {
                              if (widget.isTime) {
                                FocusScope.of(context).nextFocus(); // icon
                              }
                              if (widget.onFocusChange != null) {
                                assignValueToMainTextEditingController();
                                widget.onFocusChange!(
                                    widget.mainTextController.text);
                              }
                            } else if (event
                                .isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                              FocusScope.of(context).previousFocus(); //secound
                            } else if (event
                                .isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                              cursorAtLast(3);
                            } else if (event
                                .isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                              incrementDecrementOnKeyBoardEvent(
                                  3, widget.frame);
                            } else if (event
                                .isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                              incrementDecrementOnKeyBoardEvent(3, widget.frame,
                                  up: false);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: TextFormField(
                              controller: textCtr[3],
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: style,
                              onChanged: (value) {
                                int no = int.tryParse(value) ?? 00;
                                if (no > widget.frame) {
                                  textCtr[3].text = "00";
                                  cursorAtLast(3);
                                }
                                if (value.length == 2) {
                                  cursorAtLast(3);
                                }
                              },
                              style: TextStyle(
                                fontSize: 12,
                                color: textColor,
                              ),
                              maxLength: 2,
                              textAlign: TextAlign.right,
                              showCursor: false,
                              enabled: widget.isEnable,
                            ),
                          ),
                        ),
                      ),
                    }
                  ],
                ),
              ),
              const Spacer(),

              /// ICON BUTTON
              Visibility(
                visible: widget.isTime,
                child: InkWell(
                  focusNode: iconFocusNode,
                  onTap: widget.isEnable
                      ? () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.dial,
                            useRootNavigator: true,
                          ).then((pickedTime) {
                            if (pickedTime != null) {
                              textCtr[1].text =
                                  pickedTime.minute.toString(); //minutes
                              addZeroAndSetCursorAtLast(1,
                                  setCUrsor: false); // minutes
                              textCtr[0].text =
                                  pickedTime.hour.toString(); // hour
                              addZeroAndSetCursorAtLast(0,
                                  setCUrsor: false); // hours
                              FocusScope.of(context)
                                  .requestFocus(iconFocusNode);
                              FocusScope.of(context).previousFocus();
                            }
                          });
                        }
                      : null,
                  child: Icon(Icons.date_range,
                      size: 16,
                      color: widget.isEnable
                          ? Colors.deepPurpleAccent
                          : Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration style = const InputDecoration(
    counter: null,
    counterText: "",
    filled: false,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    hoverColor: Colors.transparent,
    contentPadding: EdgeInsets.zero,
    focusColor: Colors.transparent,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
  );

  assignNewValeToEditTextField() {
    if (widget.mainTextController.text.length == (widget.isTime ? 8 : 11)) {
      List<String?> tempTime = widget.mainTextController.text.split(":");
      textCtr[0].text = (tempTime[0] ?? "00"); //HH
      textCtr[1].text = (tempTime[1] ?? "00"); //MM
      textCtr[2].text = tempTime[2] ?? "00"; //SS
      if (!widget.isTime) {
        textCtr[3].text = tempTime[3] ?? "00"; //FF
      }
    }
  }

  handleOnFocusChange() {
    for (int i = 0; i < focus.length; i++) {
      focus[i].skipTraversal = true;
      focus[i].addListener(() {
        addZeroAndSetCursorAtLast(i);
      });
    }
    iconFocusNode.addListener(() {
      if (iconFocusNode.hasFocus) {
        FocusScope.of(context).previousFocus();
      }
    });
  }

  addZeroAndSetCursorAtLast(int ctrIndex, {bool setCUrsor = true}) {
    if (focus[ctrIndex].hasFocus) {
      if (setCUrsor) {
        cursorAtLast(ctrIndex);
      }
    } else {
      int len = textCtr[ctrIndex].text.length;
      if (len == 1 || len == 0) {
        textCtr[ctrIndex].text = "0${len == 0 ? '0' : textCtr[ctrIndex].text}";
      }
      assignValueToMainTextEditingController();
    }
  }

  assignValueToMainTextEditingController() {
    String time = textCtr[0].text +
        widget.splitType +
        textCtr[1].text +
        widget.splitType +
        textCtr[2].text;
    if (!widget.isTime) {
      time = time + widget.splitType + textCtr[3].text;
    }
    widget.mainTextController.text = time;
  }

  incrementDecrementOnKeyBoardEvent(int index, int maxNo, {bool up = true}) {
    int no = int.tryParse(textCtr[index].text) ?? 00;
    if ((no <= 1 && !up) || (no == maxNo && up)) {
      textCtr[index].text = up ? "00" : maxNo.toString();
      // textCtr[index].text = up ? "01" : maxNo.toString();
    } else {
      if (up) {
        no = no + 1;
      } else {
        no = no - 1;
        if (no <= 0) {
          no = 0;
        }
      }
      if (no <= maxNo) {
        if (no < 10) {
          if (!widget.isTime && no == 0) {
            textCtr[index].text = maxNo.toString();
          } else {
            textCtr[index].text = "0$no";
          }
        } else {
          textCtr[index].text = no.toString();
        }
      }
    }
    cursorAtLast(index);
    assignValueToMainTextEditingController();
  }

  cursorAtLast(int ctrIndex) {
    Future.delayed(const Duration(milliseconds: 150)).then((value) {
      // textCtr[ctrIndex].value = TextEditingValue(
      //   text: textCtr[ctrIndex].text,
      //   selection:
      //       TextSelection.collapsed(offset: textCtr[ctrIndex].text.length),
      // );
      textCtr[ctrIndex].selection = TextSelection(
        baseOffset: 0,
        extentOffset: textCtr[ctrIndex].text.length,
      );
    });
  }

  removeFocusListener() {
    for (int i = 0; i < focus.length; i++) {
      focus[i].removeListener(() {});
      focus[i].dispose();
      textCtr[i].dispose();
    }
    widget.mainTextController.removeListener(() {});
    iconFocusNode.removeListener(() {});
    iconFocusNode.dispose();
  }
}
