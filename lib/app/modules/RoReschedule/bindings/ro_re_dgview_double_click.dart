class RORescheduleDGviewDoubleClickData {
  String? caption;
  String? ravType;
  String? language;
  String? tapeID;
  String? oriProg;
  String? schDate;
  String? schTime;
  String? oriTapeID;
  String? segment;
  String? duration;
  String? campStartDate;
  String? campEndDate;
  String? killDate;
  String? preMid;
  String? position;
  List? dgvProgramColumnVisiableTrue;
  List<String>? dgvProgramColumnVisiableFalse;
  List<String>? formControlVisiableFalse;
  List? formControlVisiableTrue;
  List? message;
  List? dgvUpdateds;
  List<LstDetTable>? lstDetTable;

  RORescheduleDGviewDoubleClickData(
      {this.caption,
      this.ravType,
      this.language,
      this.tapeID,
      this.oriProg,
      this.schDate,
      this.schTime,
      this.oriTapeID,
      this.segment,
      this.duration,
      this.campStartDate,
      this.campEndDate,
      this.killDate,
      this.preMid,
      this.position,
      this.dgvProgramColumnVisiableTrue,
      this.dgvProgramColumnVisiableFalse,
      this.formControlVisiableFalse,
      this.formControlVisiableTrue,
      this.message,
      this.dgvUpdateds,
      this.lstDetTable});

  RORescheduleDGviewDoubleClickData.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    ravType = json['ravType'];
    language = json['language'];
    tapeID = json['tapeID'];
    oriProg = json['oriProg'];
    schDate = json['schDate'];
    schTime = json['schTime'];
    oriTapeID = json['oriTapeID'];
    segment = json['segment'];
    duration = json['duration'];
    campStartDate = json['campStartDate'];
    campEndDate = json['campEndDate'];
    killDate = json['killDate'];
    preMid = json['preMid'];
    position = json['position'];
    if (json['dgvProgramColumnVisiable_True'] != null) {
      dgvProgramColumnVisiableTrue = [];
      json['dgvProgramColumnVisiable_True'].forEach((v) {
        dgvProgramColumnVisiableTrue!.add(v);
      });
    }
    dgvProgramColumnVisiableFalse = json['dgvProgramColumnVisiable_False'].cast<String>();
    formControlVisiableFalse = json['formControlVisiable_False'].cast<String>();
    if (json['formControlVisiable_True'] != null) {
      formControlVisiableTrue = [];
      json['formControlVisiable_True'].forEach((v) {
        formControlVisiableTrue!.add(v);
      });
    }
    if (json['message'] != null) {
      message = <Null>[];
      json['message'].forEach((v) {
        message!.add(v);
      });
    }
    if (json['dgvUpdateds'] != null) {
      dgvUpdateds = [];
      json['dgvUpdateds'].forEach((v) {
        dgvUpdateds!.add(v);
      });
    }
    if (json['lstDetTable'] != null) {
      lstDetTable = <LstDetTable>[];
      json['lstDetTable'].forEach((v) {
        lstDetTable!.add(new LstDetTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['caption'] = this.caption;
    data['ravType'] = this.ravType;
    data['language'] = this.language;
    data['tapeID'] = this.tapeID;
    data['oriProg'] = this.oriProg;
    data['schDate'] = this.schDate;
    data['schTime'] = this.schTime;
    data['oriTapeID'] = this.oriTapeID;
    data['segment'] = this.segment;
    data['duration'] = this.duration;
    data['campStartDate'] = this.campStartDate;
    data['campEndDate'] = this.campEndDate;
    data['killDate'] = this.killDate;
    data['preMid'] = this.preMid;
    data['position'] = this.position;
    if (this.dgvProgramColumnVisiableTrue != null) {
      data['dgvProgramColumnVisiable_True'] = this.dgvProgramColumnVisiableTrue!.map((v) => v.toJson()).toList();
    }
    data['dgvProgramColumnVisiable_False'] = this.dgvProgramColumnVisiableFalse;
    data['formControlVisiable_False'] = this.formControlVisiableFalse;
    if (this.formControlVisiableTrue != null) {
      data['formControlVisiable_True'] = this.formControlVisiableTrue!.map((v) => v.toJson()).toList();
    }
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    if (this.dgvUpdateds != null) {
      data['dgvUpdateds'] = this.dgvUpdateds!.map((v) => v.toJson()).toList();
    }
    if (this.lstDetTable != null) {
      data['lstDetTable'] = this.lstDetTable!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstDetTable {
  String? telecastdate;
  int? bookedSpots;
  String? startTime;
  String? endTime;
  String? programName;
  int? availableDuration;
  String? programcode;

  LstDetTable({this.telecastdate, this.bookedSpots, this.startTime, this.endTime, this.programName, this.availableDuration, this.programcode});

  LstDetTable.fromJson(Map<String, dynamic> json) {
    telecastdate = json['telecastdate'];
    bookedSpots = json['bookedSpots'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    programName = json['programName'];
    availableDuration = json['availableDuration'];
    programcode = json['programcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['telecastdate'] = this.telecastdate;
    data['bookedSpots'] = this.bookedSpots;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['programName'] = this.programName;
    data['availableDuration'] = this.availableDuration;
    data['programcode'] = this.programcode;
    return data;
  }
}
