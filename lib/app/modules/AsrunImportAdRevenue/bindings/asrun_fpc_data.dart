import 'package:bms_scheduling/app/modules/AsrunImportAdRevenue/bindings/arun_data.dart';

class AsrunFPCData {
  String? programName;
  String? telecastdate;
  String? starttime;
  String? endtime;
  String? exporttapecode;
  String? programcode;
  int? present;

  AsrunFPCData({this.programName, this.telecastdate, this.starttime, this.endtime, this.exporttapecode, this.programcode, this.present});

  AsrunFPCData.fromJson(Map<String, dynamic> json) {
    programName = json['programName'];
    telecastdate = json['telecastdate'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    exporttapecode = json['exporttapecode'];
    programcode = json['programcode'];
    present = json['present'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['programName'] = programName;
    data['telecastdate'] = telecastdate;
    data['starttime'] = starttime;
    data['endtime'] = endtime;
    data['exporttapecode'] = exporttapecode;
    data['programcode'] = programcode;
    data['present'] = present;
    return data;
  }
}

class FPCProgramList {
  String? fpcTime;
  String? programName;
  String? programCode;
  int? isMismatch;
  String? programTime;
  String? telecastDuration;
  String? tapeDuration;
  String? eventType;
  String? bookingNumber;
  String? scheduleTime;
  String? scheduledProgram;
  int? fpc;
  String? rosBand;
  String? ros;
  int? dur;
  String? telecastTime;
  num? maxDurationDifference;

  FPCProgramList(
      {this.fpcTime,
      this.programName,
      this.programCode,
      this.isMismatch,
      this.programTime,
      this.telecastDuration,
      this.tapeDuration,
      this.eventType,
      this.bookingNumber,
      this.scheduleTime,
      this.scheduledProgram,
      this.fpc,
      this.rosBand,
      this.ros,
      this.dur,
      this.telecastTime,
      this.maxDurationDifference});

  FPCProgramList.fromJson(Map<String, dynamic> json) {
    fpcTime = json['FPCTime'];
    programName = json['ProgramName'];
    programCode = json['ProgramCode'];
    isMismatch = json['IsMismatch'];
    programTime = json['ProgramTime'];
    telecastDuration = json['TelecastDuration'];
    tapeDuration = json['TapeDuration'];
    eventType = json['EventType'];
    bookingNumber = json['Bookingnumber'];
    scheduleTime = json['ScheduleTime'];
    scheduledProgram = json['ScheduledProgram'];
    fpc = json['FPC'];
    rosBand = json['ROSBand'];
    ros = json['ROS'];
    dur = json['Dur'];
    telecastTime = json['TeleCastTime'];
    maxDurationDifference = json["MaxDurationDifference"];
  }
  FPCProgramList.convertAsRunDataToFPCProgramList(AsRunData asRunData) {
    fpcTime = asRunData.fpctIme;
    programName = asRunData.programName;
    programCode = asRunData.programCode;
    isMismatch = int.tryParse(asRunData.isMismatch ?? '');
    programTime = asRunData.programTime;
    telecastDuration = asRunData.telecastDuration;
    tapeDuration = asRunData.tapeDuration;
    eventType = asRunData.eventtype;
    bookingNumber = asRunData.bookingnumber;
    scheduleTime = asRunData.scheduletime;
    scheduledProgram = asRunData.scheduledProgram;
    fpc = int.tryParse(asRunData.fpc ?? '');
    rosBand = asRunData.rosBand;
    maxDurationDifference = null;
    dur = int.tryParse(asRunData.dur ?? '');
    telecastTime = asRunData.telecasttime;
  }

  Map<String, dynamic> toJson() {
    return {
      'FPCTime': fpcTime,
      'ProgramName': programName,
      'ProgramCode': programCode,
      'IsMismatch': isMismatch,
      'ProgramTime': programTime,
      'TelecastDuration': telecastDuration,
      'TapeDuration': tapeDuration,
      'EventType': eventType,
      'Bookingnumber': bookingNumber,
      "MaxDurationDifference": maxDurationDifference,
      'ScheduleTime': scheduleTime,
      'ScheduledProgram': scheduledProgram,
      'FPC': fpc,
      'ROSBand': rosBand,
      'ROS': ros,
      'Dur': dur,
      'TeleCastTime': telecastTime,
    };
  }
}
