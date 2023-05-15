class RMSProgram {
  int? programCode;
  String? programName;

  RMSProgram({this.programCode, this.programName});

  RMSProgram.fromJson(Map<String, dynamic> json) {
    programCode = json['programCode'];
    programName = json['programName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['programCode'] = programCode;
    data['programName'] = programName;
    return data;
  }
}
