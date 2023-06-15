class RoBookingDealDblClick {
  String? message;
  List? dgvProgramsAllowColumnsEditingTrue;
  List? dgvProgramsVisiableTrue;
  List? dgvProgramsVisiableFalse;
  List? dgvProgramsColumnMaxInputLength4;
  List<LstProgram>? lstProgram;
  String? revenueType;
  String? preMid;
  String? positionNo;
  String? breakNo;
  String? rate;
  String? total;

  RoBookingDealDblClick(
      {this.message,
      this.dgvProgramsAllowColumnsEditingTrue,
      this.dgvProgramsVisiableTrue,
      this.dgvProgramsVisiableFalse,
      this.dgvProgramsColumnMaxInputLength4,
      this.lstProgram,
      this.revenueType,
      this.preMid,
      this.positionNo,
      this.breakNo,
      this.rate,
      this.total});

  RoBookingDealDblClick.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    dgvProgramsAllowColumnsEditingTrue = json['dgvPrograms_AllowColumnsEditing_True'] ?? [];
    dgvProgramsVisiableTrue = json['dgvPrograms_Visiable_True'] ?? [];
    dgvProgramsVisiableFalse = json['dgvPrograms_Visiable_False'] ?? [];
    dgvProgramsColumnMaxInputLength4 = json['dgvPrograms_Column_MaxInputLength_4'] ?? [];

    print("parsing program");
    if (json['lstProgram'] != null) {
      lstProgram = <LstProgram>[];
      json['lstProgram'].forEach((v) {
        lstProgram!.add(LstProgram.fromJson(v));
      });
    }
    print("parsing program done");
    revenueType = json['revenueType'];
    preMid = json['preMid'];
    positionNo = json['positionNo'];
    breakNo = json['breakNo'];
    rate = json['rate'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['dgvPrograms_AllowColumnsEditing_True'] = dgvProgramsAllowColumnsEditingTrue;
    data['dgvPrograms_Visiable_True'] = dgvProgramsVisiableTrue;
    data['dgvPrograms_Visiable_False'] = dgvProgramsVisiableFalse;
    data['dgvPrograms_Column_MaxInputLength_4'] = dgvProgramsColumnMaxInputLength4;
    if (lstProgram != null) {
      data['lstProgram'] = lstProgram!.map((v) => v.toJson()).toList();
    }
    data['revenueType'] = revenueType;
    data['preMid'] = preMid;
    data['positionNo'] = positionNo;
    data['breakNo'] = breakNo;
    data['rate'] = rate;
    data['total'] = total;
    return data;
  }
}

class LstProgram {
  String? telecastdate;
  int? bookedSpots;
  String? startTime;
  String? endTime;
  String? programName;
  int? availableDuration;
  String? programcode;

  LstProgram({this.telecastdate, this.bookedSpots, this.startTime, this.endTime, this.programName, this.availableDuration, this.programcode});

  LstProgram.fromJson(Map<String, dynamic> json) {
    telecastdate = json['telecastdate'];
    bookedSpots = json['bookedSpots'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    programName = json['programName'];
    availableDuration = json['availableDuration'];
    programcode = json['programcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['telecastdate'] = telecastdate;
    data['bookedSpots'] = bookedSpots;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['programName'] = programName;
    data['availableDuration'] = availableDuration;
    data['programcode'] = programcode;
    return data;
  }
}
