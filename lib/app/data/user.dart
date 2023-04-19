import 'TokenData.dart';

class User {
  String? employeeName;
  String? personnelNo;
  String? logincode;
  String? loginName;
  String? mailId;
  String? employeeId;
  String? jobTitle;
  String? msId;
  String? photo;
  int? passStatus;
  String? username;
  bool? auditAllActivities;
  String? token;
  String? refreshToken;
  TokenData? tokenData;


  User(
      {this.employeeName,
        this.personnelNo,
        this.logincode,
        this.loginName,
        this.passStatus,
        this.photo,
        this.username,
        this.auditAllActivities,
        this.token});

  User.fromJson(Map<String, dynamic> json) {
    employeeName = json['employeeName'];
    personnelNo = json['personnelNo'];
    logincode = json['logincode'];
    loginName = json['loginName'];
    passStatus = json['passStatus'];
    username = json['username'];
    auditAllActivities = json['auditAllActivities'];
    token = json['token'];
    refreshToken = json['refreshToken'];
    employeeId = json['employeeId'];
    jobTitle = json['jobTitle'];
    mailId = json['mailId'];
    photo = json['photo'];
    msId = json['id'];
    tokenData = json['tokenData'] != null
        ? new TokenData.fromJson(json['tokenData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeName'] = this.employeeName;
    data['personnelNo'] = this.personnelNo;
    data['logincode'] = this.logincode;
    data['loginName'] = this.loginName;
    data['passStatus'] = this.passStatus;
    data['username'] = this.username;
    data['auditAllActivities'] = this.auditAllActivities;
    data['token'] = this.token;
    data['employeeId'] = this.employeeId;
    data['refreshToken'] = this.refreshToken;
    data['jobTitle'] = this.jobTitle;
    data['id'] = this.msId;
    data['mailId'] = this.mailId;
    if (this.tokenData != null) {
      data['tokenData'] = this.tokenData!.toJson();
    }
    return data;
  }
}
