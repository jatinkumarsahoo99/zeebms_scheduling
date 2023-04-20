import '../../providers/ColorData.dart';

class TransmissionLogModel {
  int? rowNo;
  String? programCode;
  String? languageCode;
  String? originalRepeatCode;
  String? programTypeCode;
  int? color;
  int? episodeDuration;
  String? fpcTime;
  String? endTime;
  String? programName;
  int? epsNo;
  int? colorNo;
  String? tapeid;
  String? status;
  String? oriRep;
  String? wbs;
  String? caption;
  String? modifed;
  String? oriRepCode;
  String? telecastdate1;
  String? telecastdate2;
  String? telecastdate3;


  TransmissionLogModel(
      {this.rowNo,
      this.programCode,
      this.languageCode,
      this.originalRepeatCode,
      this.programTypeCode,
      this.color,
      this.episodeDuration,
      this.fpcTime,
      this.endTime,
      this.programName,
      this.epsNo,
      this.tapeid,
      this.status,
      this.oriRep,
      this.wbs,
      this.caption,
      this.modifed,
      this.oriRepCode,
      this.telecastdate1,
      this.telecastdate2,
      this.telecastdate3,
      });

  TransmissionLogModel.fromJson(Map<String, dynamic> json) {
    rowNo = json['rowNo'];
    programCode = json['programCode'];
    languageCode = json['languageCode'];
    originalRepeatCode = json['originalRepeatCode'];
    programTypeCode = json['programTypeCode'];
    color = json['color'];
    colorNo = ColorData.getColorData(json['color']).value;
    episodeDuration = json['episodeDuration'];
    fpcTime = json['fpcTime'];
    endTime = json['endTime'];
    programName = json['programName'];
    epsNo = json['epsNo'];
    tapeid = json['tapeid'];
    status = json['status'];
    oriRep = json['oriRep'];
    wbs = json['wbs'];
    caption = json['caption'];
    modifed = json['modifed'];
    oriRepCode = json['oriRepCode'];
    telecastdate1 = json['telecastdate1'];
    telecastdate2 = json['telecastdate2'];
    telecastdate3 = json['telecastdate3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowNo'] = this.rowNo;
    data['programCode'] = this.programCode;
    data['languageCode'] = this.languageCode;
    data['originalRepeatCode'] = this.originalRepeatCode;
    data['programTypeCode'] = this.programTypeCode;
    data['color'] = this.color;
    data['episodeDuration'] = this.episodeDuration;
    data['fpcTime'] = this.fpcTime;
    data['endTime'] = this.endTime;
    data['programName'] = this.programName;
    data['epsNo'] = this.epsNo;
    data['tapeid'] = this.tapeid;
    data['status'] = this.status;
    data['oriRep'] = this.oriRep;
    data['wbs'] = this.wbs;
    data['caption'] = this.caption;
    data['modifed'] = this.modifed;
    data['oriRepCode'] = this.oriRepCode;
    data['telecastdate1'] = this.telecastdate1;
    data['telecastdate2'] = this.telecastdate2;
    data['telecastdate3'] = this.telecastdate3;
    return data;
  }

  Map<String, dynamic> toJson1() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['rowNo'] = this.rowNo;
    data['programCode'] = this.programCode;
    data['languageCode'] = this.languageCode;
    data['originalRepeatCode'] = this.originalRepeatCode;
    data['programTypeCode'] = this.programTypeCode;
    data['color'] = ColorData.getColorData(this.color).value;
    data['Episode Dur'] = this.episodeDuration;
    data['fpcTime'] = this.fpcTime;
    data['endTime'] = this.endTime;
    data['programName'] = this.programName;
    data['epsNo'] = this.epsNo;
    data['tapeid'] = this.tapeid;
    data['status'] = this.status;
    data['oriRep'] = this.oriRep;
    data['wbs'] = this.wbs;
    data['caption'] = this.caption;
    data['modifed'] = this.modifed;
    data['oriRepCode'] = this.oriRepCode;
    return data;
  }

  Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowNo'] = this.rowNo;
    data['programCode'] = this.programCode;
    data['languageCode'] = this.languageCode;
    data['originalRepeatCode'] = this.originalRepeatCode;
    data['programTypeCode'] = this.programTypeCode;
    data['color'] = this.color;
    data['episodeDuration'] = this.episodeDuration;
    data['fpcTime'] = this.fpcTime;
    data['endTime'] = this.endTime;
    data['programName'] = this.programName;
    data['epsNo'] = this.epsNo;
    data['tapeid'] = this.tapeid;
    data['status'] = this.status;
    data['oriRep'] = this.oriRep;
    data['wbs'] = this.wbs;
    data['caption'] = this.caption;
    data['modifed'] = this.modifed;
    data['oriRepCode'] = this.oriRepCode;
    data['telecastdate1'] = this.telecastdate1;
    data['telecastdate2'] = this.telecastdate2;
    data['telecastdate3'] = this.telecastdate3;
    return data;
  }
}
