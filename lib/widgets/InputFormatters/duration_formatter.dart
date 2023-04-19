import 'dart:math';
import 'package:flutter/services.dart';

class DuarationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = _format(newValue.text, ':', oldValue);
    return newValue.copyWith(
        text: text, selection: _updateCursorPosition(text, oldValue));
  }
}

String _format(String value, String seperator, TextEditingValue old) {
  var finalString = '';
  var hh = '';
  var mm = '';
  var ss = '';
  var ff = '';
  var oldVal = old.text;
  print('<------------------------- start---------------------------->');
  print('oldVal -> $oldVal');
  print('value -> $value');
  var tempOldVal = oldVal;
  var tempValue = value;

  if (!oldVal.contains(seperator) ||
      oldVal.isEmpty ||
      seperator.allMatches(oldVal).length < 2) {
    oldVal += ':::';
  }
  if (!value.contains(seperator) || _backSlashCount(value) < 2) {
    value += ':::';
  }

  var splitArrOLD = oldVal.split(seperator);
  var splitArrNEW = value.split(seperator);
// int lastCursorPosition = controller.selection.base.offset;
  print('----> splitArrOLD: $splitArrOLD');
  print('----> splitArrNEW: $splitArrNEW');
  for (var i = 0; i < 3; i++) {
    splitArrOLD[i] = splitArrOLD[i].toString().trim();
    splitArrNEW[i] = splitArrNEW[i].toString().trim();
  }
  // block erasing
  if ((splitArrOLD[0].isNotEmpty &&
          splitArrOLD[2].isNotEmpty &&
          splitArrOLD[1].isEmpty &&
          tempValue.length < tempOldVal.length &&
          splitArrOLD[0] == splitArrNEW[0] &&
          splitArrOLD[2].toString().trim() ==
              splitArrNEW[1].toString().trim()) ||
      (_backSlashCount(tempOldVal) > _backSlashCount(tempValue) &&
          splitArrNEW[1].length > 2) ||
      (splitArrNEW[0].length > 2 && _backSlashCount(tempOldVal) == 1) ||
      (_backSlashCount(tempOldVal) == 2 &&
          _backSlashCount(tempValue) == 1 &&
          splitArrNEW[0].length > splitArrOLD[0].length)) {
    finalString = tempOldVal; // making the old date as it is
    print('blocked finalString : $finalString ');
  } else {
    if (splitArrNEW[0].length > splitArrOLD[0].length) {
      if (splitArrNEW[0].length < 3) {
        hh = splitArrNEW[0];
      } else {
        for (var i = 0; i < 2; i++) {
          hh += splitArrNEW[0][i];
        }
      }
      if (hh.length == 2 && !hh.contains(seperator)) {
        hh += seperator;
      }
    } else if (splitArrNEW[0].length == splitArrOLD[0].length) {
      print('splitArrNEW[0].length == 2');
      if (oldVal.length > value.length && splitArrNEW[1].isEmpty) {
        hh = splitArrNEW[0];
      } else {
        hh = splitArrNEW[0] + seperator;
      }
    } else if (splitArrNEW[0].length < splitArrOLD[0].length) {
      print('splitArrNEW[0].length < splitArrOLD[0].length');
      if (oldVal.length > value.length &&
          splitArrNEW[1].isEmpty &&
          splitArrNEW[0].isNotEmpty) {
        hh = splitArrNEW[0];
      } else if (tempOldVal.length > tempValue.length &&
          splitArrNEW[0].isEmpty &&
          _backSlashCount(tempValue) == 2) {
        hh += seperator;
      } else {
        if (splitArrNEW[0].isNotEmpty) {
          hh = splitArrNEW[0] + seperator;
        }
      }
    }
    print('hh value --> $hh');

    if (hh.isNotEmpty) {
      finalString = hh;
      if (hh.length == 2 &&
          !hh.contains(seperator) &&
          oldVal.length < value.length &&
          splitArrNEW[1].isNotEmpty) {
        if (seperator.allMatches(hh).isEmpty) {
          finalString += seperator;
        }
      } else if (splitArrNEW[2].isNotEmpty &&
          splitArrNEW[1].isEmpty &&
          tempOldVal.length > tempValue.length) {
        if (seperator.allMatches(hh).isEmpty) {
          finalString += seperator;
        }
      } else if (oldVal.length < value.length &&
          (splitArrNEW[1].isNotEmpty || splitArrNEW[2].isNotEmpty)) {
        if (seperator.allMatches(hh).isEmpty) {
          finalString += seperator;
        }
      }
    } else if (_backSlashCount(tempOldVal) == 2 && splitArrNEW[1].isNotEmpty) {
      hh += seperator;
    }
    print('finalString after hh=> $finalString');
    if (splitArrNEW[0].length == 3 && splitArrOLD[1].isEmpty) {
      mm = splitArrNEW[0][2];
    }

    if (splitArrNEW[1].length > splitArrOLD[1].length) {
      print('splitArrNEW[1].length > splitArrOLD[1].length');
      if (splitArrNEW[1].length < 3) {
        mm = splitArrNEW[1];
      } else {
        for (var i = 0; i < 2; i++) {
          mm += splitArrNEW[1][i];
        }
      }
      if (mm.length == 2 && !mm.contains(seperator)) {
        mm += seperator;
      }
    } else if (splitArrNEW[1].length == splitArrOLD[1].length) {
      print('splitArrNEW[1].length = splitArrOLD[1].length');
      if (splitArrNEW[1].isNotEmpty) {
        mm = splitArrNEW[1];
      }
    } else if (splitArrNEW[1].length < splitArrOLD[1].length) {
      print('splitArrNEW[1].length < splitArrOLD[1].length');
      if (splitArrNEW[1].isNotEmpty) {
        mm = splitArrNEW[1] + seperator;
      }
    }
    print('mm value --> $mm');

    if (mm.isNotEmpty) {
      finalString += mm;
      if (mm.length == 2 && !mm.contains(seperator)) {
        if (tempOldVal.length < tempValue.length) {
          finalString += seperator;
        }
      }
    }
    print('finalString after mm=> $finalString');

    if (splitArrNEW[1].length == 3 && splitArrOLD[2].isEmpty) {
      ss = splitArrNEW[1][2];
    }

    if (splitArrNEW[2].length > splitArrOLD[2].length) {
      print('splitArrNEW[2].length > splitArrOLD[2].length');
      if (splitArrNEW[2].length < 5) {
        ss = splitArrNEW[2];
      } else {
        for (var i = 0; i < 4; i++) {
          ss += splitArrNEW[2][i];
        }
      }
    } else if (splitArrNEW[2].length == splitArrOLD[2].length) {
      print('splitArrNEW[2].length == splitArrOLD[2].length');
      if (splitArrNEW[2].isNotEmpty) {
        ss = splitArrNEW[2];
      }
    } else if (splitArrNEW[2].length < splitArrOLD[2].length) {
      print('splitArrNEW[2].length < splitArrOLD[2].length');
      ss = splitArrNEW[2];
    }
    print('ss value --> $ss');

    if (ss.isNotEmpty) {
      if (_backSlashCount(finalString) < 2) {
        if (splitArrNEW[0].isEmpty && splitArrNEW[1].isEmpty) {
          finalString = seperator + seperator + ss;
        } else {
          finalString = finalString + seperator + ss;
        }
      } else {
        finalString += ss;
      }
    } else {
      if (_backSlashCount(finalString) > 1 && oldVal.length > value.length) {
        var valueUpdate = finalString.split(seperator);
        finalString = valueUpdate[0] + seperator + valueUpdate[1];
      }
    }

    print('finalString after yyyy=> $finalString');
  }

  print('<------------------------- finish---------------------------->');

  return finalString;
}

TextSelection _updateCursorPosition(String text, TextEditingValue oldValue) {
  var endOffset = max(
    oldValue.text.length - oldValue.selection.end,
    0,
  );
  var selectionEnd = text.length - endOffset;
  print('My log ---> $selectionEnd');
  return TextSelection.fromPosition(TextPosition(offset: selectionEnd));
}

int _backSlashCount(String value) {
  return ':'.allMatches(value).length;
}
