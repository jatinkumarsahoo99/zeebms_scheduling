import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/providers/SizeDefine.dart';


class DateWithThreeTextField extends StatefulWidget {
  final String title, splitType;
  final int day, month, year;
  final bool monthWithFullName;
  final TextEditingController mainTextController;
  final bool isEnable;
  final double widthRation;
  final void Function(String date)? onFocusChange;
  final DateTime? startDate, endDate, intailDate;
  final String formatting;
  const DateWithThreeTextField({
    Key? key,
    required this.title,
    required this.mainTextController,
    this.splitType = "-",
    this.day = 31,
    this.month = 12,
    this.year = 2022,
    this.monthWithFullName = false,
    this.isEnable = true,
    this.widthRation = .15,
    this.onFocusChange,
    this.startDate,
    this.endDate,
    this.formatting = "yyyy/MM/dd",
    this.intailDate,
  }) : super(key: key);

  @override
  State<DateWithThreeTextField> createState() => _DateWithThreeTextFieldState();
}

class _DateWithThreeTextFieldState extends State<DateWithThreeTextField> {
  late List<TextEditingController> textCtr;
  late List<FocusNode> focus;
  var iconFocusNode = FocusNode();

  DateTime? dateTime;
  late DateFormat requireFormatDateStr;
  List<String> months = [
    "Janurary",
    "Feburary",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  bool isLeapYearFun(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  List<int> maxDays = [];

  @override
  void initState() {
    focus = List.generate(3, (index) => FocusNode());
    textCtr = List.generate(3, (index) => TextEditingController());
    maxDays = [
      31,
      (isLeapYearFun(DateTime.now().year) ? 29 : 28),
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31,
    ];
    // requireFormatDateStr = DateFormat(widget.formatting);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      assignNewValeToEditTextField();
      Future.delayed(const Duration(seconds: 1)).then((value) {
        handleOnFocusChange();
        widget.mainTextController.addListener(() {
          assignNewValeToEditTextField();
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // removeFocusListener();
  }

  String previousTextInMonth = "";

  void setMonthInTextField(String value) {
    int no = int.tryParse(value) ?? 1;
    if (value.startsWith("0")) {
      no = 1;
    }
    if (no > widget.month) {
      textCtr[1].text = getMonthsFromIndex(1);
    } else {
      textCtr[1].text = getMonthsFromIndex(no);
    }
    cursorAtLast(1);
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
              /// DD/MMM/YYYY Textinput fields
              SizedBox(
                width: widget.monthWithFullName ? 115 : 80,
                child: Row(
                  children: [
                    /// DAY
                    Expanded(
                      flex: widget.monthWithFullName ? 1 : 2,
                      child: RawKeyboardListener(
                        focusNode: focus[0],
                        onKey: (event) async {
                          if (event.isShiftPressed &&
                              event.isKeyPressed(LogicalKeyboardKey.tab)) {
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.tab)) {
                            FocusScope.of(context).nextFocus(); //months
                            FocusScope.of(context).nextFocus(); // years
                            FocusScope.of(context)
                                .nextFocus(); // next widget get focus
                            if (widget.onFocusChange != null) {
                              await assignValueToMainTextEditingController();
                              widget.onFocusChange!(
                                  widget.mainTextController.text);
                            }
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                            FocusScope.of(context).nextFocus(); //months
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                            cursorAtLast(0);
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                            incrementDecrementOnKeyBoardEvent(0, widget.day);
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                            incrementDecrementOnKeyBoardEvent(0, widget.day,
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
                              int selectedMonth =
                              getMonthINTFromMonthStr(textCtr[1].text);
                              print(selectedMonth - 1);
                              print(maxDays[selectedMonth - 1]);
                              if (no > maxDays[selectedMonth - 1] ||
                                  value == "00") {
                                textCtr[0].text = "01";
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

                    /// MONTHS
                    Expanded(
                      flex: widget.monthWithFullName ? 4 : 3,
                      child: RawKeyboardListener(
                        focusNode: focus[1],
                        onKey: (event) async {
                          if (event.isShiftPressed &&
                              event.isKeyPressed(LogicalKeyboardKey.tab)) {
                            FocusScope.of(context).previousFocus(); //day
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.tab)) {
                            FocusScope.of(context).nextFocus(); // year
                            FocusScope.of(context)
                                .nextFocus(); // next widget get focus
                            if (widget.onFocusChange != null) {
                              await assignValueToMainTextEditingController();
                              widget.onFocusChange!(
                                  widget.mainTextController.text);
                            }
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                            FocusScope.of(context).previousFocus(); //day
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                            FocusScope.of(context).nextFocus(); //year
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                            incrementDecrementOnKeyBoardEvent(1, widget.month);
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                            incrementDecrementOnKeyBoardEvent(1, widget.month,
                                up: false);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: TextFormField(
                            controller: textCtr[1],
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: style,
                            onChanged: (value) {
                              if (previousTextInMonth + value == "10" ||
                                  previousTextInMonth + value == "11" ||
                                  previousTextInMonth + value == "12") {
                                setMonthInTextField(
                                    previousTextInMonth + value);
                              } else {
                                setMonthInTextField(value);
                              }
                              previousTextInMonth = value;
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

                    /// YEAR
                    Expanded(
                      flex: widget.monthWithFullName ? 2 : 4,
                      child: RawKeyboardListener(
                        focusNode: focus[2],
                        onKey: (event) async {
                          if (event.isShiftPressed &&
                              event.isKeyPressed(LogicalKeyboardKey.tab)) {
                            FocusScope.of(context).previousFocus(); //minutes
                            FocusScope.of(context).previousFocus(); //Hours
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.tab)) {
                            FocusScope.of(context)
                                .nextFocus(); // next widget get focus
                            if (widget.onFocusChange != null) {
                              await assignValueToMainTextEditingController();
                              widget.onFocusChange!(
                                  widget.mainTextController.text);
                            }
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                            incrementDecrementOnKeyBoardEvent(2, widget.year);
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                            FocusScope.of(context).previousFocus(); //month
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                            cursorAtLast(2);
                          } else if (event
                              .isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                            incrementDecrementOnKeyBoardEvent(2, widget.year,
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
                              if (value.length == 4) {
                                cursorAtLast(2);
                              }
                            },
                            textAlign: TextAlign.right,
                            maxLength: 4,
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
                  ],
                ),
              ),
              const Spacer(),

              /// ICON BUTTON
              InkWell(
                focusNode: iconFocusNode,
                onTap: widget.isEnable
                    ? () {
                  showDatePicker(
                    context: context,
                    initialDate: widget.intailDate ?? DateTime.now(),
                    firstDate: widget.startDate ?? DateTime(2011),
                    lastDate: widget.endDate ?? DateTime(2050),
                  ).then(
                        (selectedDate) {
                      if (selectedDate != null) {
                        // var now = DateTime.now();
                        textCtr[0].text = selectedDate.day.toString();
                        addZeroAndSetCursorAtLast(0);
                        textCtr[1].text =
                            getMonthsFromIndex(selectedDate.month);
                        textCtr[2].text = selectedDate.year.toString();
                      }
                      FocusScope.of(context).requestFocus(iconFocusNode);
                      FocusScope.of(context).previousFocus();
                    },
                  );
                }
                    : null,
                child: Icon(Icons.date_range,
                    size: 16,
                    color: widget.isEnable
                        ? Colors.deepPurpleAccent
                        : Colors.grey),
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
      if (ctrIndex == 2 && len != 4) {
        textCtr[ctrIndex].text = DateTime.now().year.toString();
      } else if (ctrIndex == 0) {
        if (textCtr[ctrIndex].text == "0") {
          textCtr[ctrIndex].text = "01";
        } else if (len == 1) {
          textCtr[ctrIndex].text = "0${textCtr[ctrIndex].text}";
        }
      } else if (len == 1 || len == 0) {
        textCtr[ctrIndex].text = "0${len == 0 ? '0' : textCtr[ctrIndex].text}";
      }
      assignValueToMainTextEditingController();
    }
  }

  assignNewValeToEditTextField() {
    var now = DateTime.now();
    List<String?> tempDate =
    widget.mainTextController.text.split(widget.splitType);
    if (tempDate.length == 3) {
      tempDate = widget.mainTextController.text.split(widget.splitType);
      textCtr[0].text = (tempDate[0] ?? now.day.toString()); //DD
      textCtr[1].text =
      (getMonthsFromIndex(int.tryParse(tempDate[1] ?? "0") ?? 0)); //MMM
      textCtr[2].text = tempDate[2] ?? now.year.toString(); //YYYY
    } else {
      textCtr[0].text = now.day.toString();
      textCtr[1].text = getMonthsFromIndex(now.month);
      textCtr[2].text = now.year.toString();
    }
  }

  assignValueToMainTextEditingController() async {
    if (textCtr[0].text.isEmpty) {
      textCtr[0].text = "01";
    } else if (textCtr[1].text.isEmpty) {
      textCtr[1].text = getMonthsFromIndex(1);
    } else if (textCtr[2].text.isEmpty) {
      textCtr[2].text = DateTime.now().year.toString();
    }
    int tempMonth = getMonthINTFromMonthStr(textCtr[1].text);
    String time = textCtr[0].text +
        widget.splitType +
        (tempMonth >= 10 ? tempMonth.toString() : "0$tempMonth") +
        widget.splitType +
        textCtr[2].text;
    widget.mainTextController.text = time;
  }

  incrementDecrementOnKeyBoardEvent(int index, int maxNo, {bool up = true}) {
    int no = int.tryParse(textCtr[index].text) ?? 00;
    if (index == 2) {
      /// year
      no = up ? no = no + 1 : no = no - 1;
      no = no == 0 ? no = 0001 : no;
      textCtr[index].text = no.toString();
      maxDays[1] = isLeapYearFun(no) ? 29 : 28;
    } else if (index == 0) {
      /// day
      int selectedMonth = getMonthINTFromMonthStr(textCtr[1].text);
      no = up ? no = no + 1 : no = no - 1;

      if (no >
          (selectedMonth == 2
              ? isLeapYearFun(int.tryParse(textCtr[2].text) ?? 2022)
              ? 29
              : 28
              : maxNo)) {
        no = 01;
      } else if (no <= 0) {
        if (selectedMonth == 2) {
          no = isLeapYearFun(int.tryParse(textCtr[2].text) ?? 2022) ? 29 : 28;
        } else {
          no = maxNo;
        }
      }
      textCtr[index].text = no >= 10 ? no.toString() : "0$no";
    } else if (index == 1) {
      /// month
      int selectedMonth = getMonthINTFromMonthStr(textCtr[1].text);
      int dayInt = int.tryParse(textCtr[0].text) ?? 0;
      selectedMonth = up
          ? selectedMonth = selectedMonth + 1
          : selectedMonth = selectedMonth - 1;
      if (selectedMonth > 12) {
        selectedMonth = 1;
      } else if (selectedMonth <= 0) {
        selectedMonth = 12;
      }
      if (dayInt > maxDays[selectedMonth - 1]) {
        textCtr[0].text = (maxDays[selectedMonth - 1]).toString();
      }
      textCtr[1].text = getMonthsFromIndex(selectedMonth);
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

  String getMonthsFromIndex(int month) {
    month = month - 1;
    if (widget.monthWithFullName) {
      return months[month];
    } else {
      return months[month].substring(0, 3);
    }
  }

  int getMonthINTFromMonthStr(String monthName) {
    int foundMonthIndex = -1;
    loop:
    for (int i = 0; i < months.length; i++) {
      if (monthName == getMonthsFromIndex(i + 1)) {
        foundMonthIndex = i;
        break loop;
      }
    }
    return foundMonthIndex + 1;
  }
}
