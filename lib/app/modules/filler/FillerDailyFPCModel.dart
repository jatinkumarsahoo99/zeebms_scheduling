class FillerDailyFPCModel {

  int? rowNo;
  String? programCode;
  String? languageCode;
  String? oriRepCode;
  String? programTypeCode;
  String? color;
  int? episodeDuration;
  String? fpcTime;
  String? endTime;
  String? programName;
  int? epsNo;
  String? tapeID;
  String? oriRep;
  String? wbs;
  String? caption;
  String? modified;
  String? episodeCaption;


  FillerDailyFPCModel({
      this.rowNo,
      this.programCode,
      this.languageCode,
      this.oriRepCode,
      this.programTypeCode,
      this.color,
      this.episodeDuration,
      this.fpcTime,
      this.endTime,
      this.programName,
      this.epsNo,
      this.tapeID,
      this.oriRep,
      this.wbs,
      this.caption,
      this.modified,
      this.episodeCaption});

  FillerDailyFPCModel.fromJson(Map<String, dynamic> json) {
    rowNo = json['rowNo'];
    programCode = (json['programCode']??"").toString();
    languageCode = (json['languageCode']??"").toString();
    oriRepCode = (json['oriRepCode']??"").toString();
    programTypeCode = (json['programTypeCode']??"").toString();
    color = (json['color']??"").toString();
    episodeDuration = (json['episodeDuration']??0);
    fpcTime = (json['fpcTime']??"").toString();
    endTime = (json['endTime']??"").toString();
    programName = (json['programName']??"").toString();
    epsNo = (json['epsNo']??0);
    tapeID = (json['tapeID']??"").toString();
    oriRep = (json['oriRep']??"").toString();
    wbs = (json['wbs']??"").toString();
    caption = (json['caption']??"").toString();
    modified = (json['modified']??"").toString();
    episodeCaption = (json['episodeCaption']??"").toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowNo'] = this.rowNo;
    data['programCode'] = this.programCode;
    data['languageCode'] = this.languageCode;
    data['oriRepCode'] = this.oriRepCode;
    data['programTypeCode'] = this.programTypeCode;
    data['color'] = this.color;
    data['episodeDuration'] = this.episodeDuration;
    data['fpcTime'] = this.fpcTime;
    data['endTime'] = this.endTime;
    data['programName'] = this.programName;
    data['epsNo'] = this.epsNo;
    data['tape id'] = this.tapeID;
    data['oriRep'] = this.oriRep;
    data['wbs'] = this.wbs;
    data['caption'] = this.caption;
    data['modified'] = this.modified;
    data['episodeCaption'] = this.episodeCaption;
    return data;
  }


}
