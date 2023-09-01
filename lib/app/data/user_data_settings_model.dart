import 'dart:convert';
import 'package:flutter/material.dart';

class UserDataSettings {
  List<UserSetting>? userSetting;

  UserDataSettings({this.userSetting});

  UserDataSettings.fromJson(Map<String, dynamic> json) {
    if (json['userSetting'] != null) {
      userSetting = <UserSetting>[];
      json['userSetting'].forEach((v) {
        userSetting!.add(UserSetting.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (userSetting != null) {
      data['userSetting'] = userSetting!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserSetting {
  String? formName;
  String? controlName;
  Map<String, double>? userSettings;

  UserSetting({this.formName, this.controlName, this.userSettings});

  UserSetting.fromJson(Map<String, dynamic> json) {
    formName = json['formName'];
    controlName = json['controlName'];
    if (json['userSettings'] != null) {
      userSettings = {};
      (jsonDecode(json['userSettings']) as Map).forEach((key, value) {
        userSettings![key] = value;
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['formName'] = formName;
    data['controlName'] = controlName;
    data['userSettings'] = jsonEncode(userSettings);
    return data;
  }
}
