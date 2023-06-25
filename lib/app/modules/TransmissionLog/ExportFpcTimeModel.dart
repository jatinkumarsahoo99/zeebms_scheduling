import 'package:bms_scheduling/app/data/DropDownValue.dart';

class ExportFPCTimeModel {
  ResFPCTime? resFPCTime;

  ExportFPCTimeModel({this.resFPCTime});

  ExportFPCTimeModel.fromJson(Map<String, dynamic> json) {
    resFPCTime = json['resFPCTime'] != null
        ? new ResFPCTime.fromJson(json['resFPCTime'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.resFPCTime != null) {
      data['resFPCTime'] = this.resFPCTime!.toJson();
    }
    return data;
  }
}

class ResFPCTime {
  List<DropDownValue>? lstFPCFromTime;
  List<DropDownValue>? lstFPCToTime;

  ResFPCTime({this.lstFPCFromTime, this.lstFPCToTime});

  ResFPCTime.fromJson(Map<String, dynamic> json) {
    if (json['lstFPCFromTime'] != null) {
      lstFPCFromTime = <DropDownValue>[];
      json['lstFPCFromTime'].forEach((v) {
        lstFPCFromTime!.add(new DropDownValue(value: v["fpcFromTime"]));
      });
    }
    if (json['lstFPCToTime'] != null) {
      lstFPCToTime = <DropDownValue>[];
      json['lstFPCToTime'].forEach((v) {
        lstFPCToTime!.add(new DropDownValue(value: v["fpcToTime"]));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstFPCFromTime != null) {
      data['lstFPCFromTime'] =
          this.lstFPCFromTime!.map((v) => v.toJson()).toList();
    }
    if (this.lstFPCToTime != null) {
      data['lstFPCToTime'] = this.lstFPCToTime!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstFPCFromTime {
  String? fpcFromTime;

  LstFPCFromTime({this.fpcFromTime});

  LstFPCFromTime.fromJson(Map<String, dynamic> json) {
    fpcFromTime = json['fpcFromTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fpcFromTime'] = this.fpcFromTime;
    return data;
  }
}

class LstFPCToTime {
  String? fpcToTime;

  LstFPCToTime({this.fpcToTime});

  LstFPCToTime.fromJson(Map<String, dynamic> json) {
    fpcToTime = json['fpcToTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fpcToTime'] = this.fpcToTime;
    return data;
  }
}
