class ROSCellClickDataModel {
  InfoGetFpcCellDoubleClick? infoGetFpcCellDoubleClick;

  ROSCellClickDataModel({this.infoGetFpcCellDoubleClick});

  ROSCellClickDataModel.fromJson(Map<String, dynamic> json) {
    infoGetFpcCellDoubleClick =
        json['info_GetFpcCellDoubleClick'] != null ? InfoGetFpcCellDoubleClick.fromJson(json['info_GetFpcCellDoubleClick']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (infoGetFpcCellDoubleClick != null) {
      data['info_GetFpcCellDoubleClick'] = infoGetFpcCellDoubleClick!.toJson();
    }
    return data;
  }
}

class InfoGetFpcCellDoubleClick {
  String? today;
  String? tomorrow;
  int? moveSpotbuys;
  String? commercialCap;
  String? bookedduration;
  String? balanceDuration;
  String? programname;
  String? fpctime;
  List<LstFPC>? lstFPC;
  List<Null>? lstAllocatedSpots;
  List<Null>? lstUnallocatedSpots;
  List<String>? tblAllocatedSpotsVisiableFalse;
  List<String>? tblUnallocatedSpotsVisiableFalse;

  InfoGetFpcCellDoubleClick(
      {this.today,
      this.tomorrow,
      this.moveSpotbuys,
      this.commercialCap,
      this.bookedduration,
      this.balanceDuration,
      this.programname,
      this.fpctime,
      this.lstFPC,
      this.lstAllocatedSpots,
      this.lstUnallocatedSpots,
      this.tblAllocatedSpotsVisiableFalse,
      this.tblUnallocatedSpotsVisiableFalse});

  InfoGetFpcCellDoubleClick.fromJson(Map<String, dynamic> json) {
    today = json['today'];
    tomorrow = json['tomorrow'];
    moveSpotbuys = json['moveSpotbuys'];
    commercialCap = json['commercialCap'];
    bookedduration = json['bookedduration'];
    balanceDuration = json['balanceDuration'];
    programname = json['programname'];
    fpctime = json['fpctime'];
    if (json['lstFPC'] != null) {
      lstFPC = <LstFPC>[];
      json['lstFPC'].forEach((v) {
        lstFPC!.add(LstFPC.fromJson(v));
      });
    }
    if (json['lstAllocatedSpots'] != null) {
      lstAllocatedSpots = <Null>[];
      json['lstAllocatedSpots'].forEach((v) {
        // lstAllocatedSpots!.add(new Null.fromJson(v));
      });
    }
    if (json['lstUnallocatedSpots'] != null) {
      lstUnallocatedSpots = <Null>[];
      json['lstUnallocatedSpots'].forEach((v) {
        // lstUnallocatedSpots!.add(new Null.fromJson(v));
      });
    }
    tblAllocatedSpotsVisiableFalse = json['tblAllocatedSpots_Visiable_False'].cast<String>();
    tblUnallocatedSpotsVisiableFalse = json['tblUnallocatedSpots_Visiable_False'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['today'] = today;
    data['tomorrow'] = tomorrow;
    data['moveSpotbuys'] = moveSpotbuys;
    data['commercialCap'] = commercialCap;
    data['bookedduration'] = bookedduration;
    data['balanceDuration'] = balanceDuration;
    data['programname'] = programname;
    data['fpctime'] = fpctime;
    if (lstFPC != null) {
      data['lstFPC'] = lstFPC!.map((v) => v.toJson()).toList();
    }
    if (lstAllocatedSpots != null) {
      // data['lstAllocatedSpots'] = this.lstAllocatedSpots!.map((v) => v.toJson()).toList();
    }
    if (lstUnallocatedSpots != null) {
      // data['lstUnallocatedSpots'] = this.lstUnallocatedSpots!.map((v) => v.toJson()).toList();
    }
    data['tblAllocatedSpots_Visiable_False'] = tblAllocatedSpotsVisiableFalse;
    data['tblUnallocatedSpots_Visiable_False'] = tblUnallocatedSpotsVisiableFalse;
    return data;
  }
}

class LstFPC {
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
  String? modifed;
  int? commercialCap;
  int? groupCode;
  int? bookedDuration;
  String? backColor;
  String? foreColor;
  String? selectionBackColor;
  String? selectionForeColor;

  LstFPC(
      {this.rowNo,
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
      this.modifed,
      this.commercialCap,
      this.groupCode,
      this.bookedDuration,
      this.backColor,
      this.foreColor,
      this.selectionBackColor,
      this.selectionForeColor});

  LstFPC.fromJson(Map<String, dynamic> json) {
    rowNo = json['rowNo'];
    programCode = json['programCode'];
    languageCode = json['languageCode'];
    oriRepCode = json['oriRepCode'];
    programTypeCode = json['programTypeCode'];
    color = json['color'];
    episodeDuration = json['episodeDuration'];
    fpcTime = json['fpcTime'];
    endTime = json['endTime'];
    programName = json['programName'];
    epsNo = json['epsNo'];
    tapeID = json['tapeID'];
    oriRep = json['oriRep'];
    wbs = json['wbs'];
    caption = json['caption'];
    modifed = json['modifed'];
    commercialCap = json['commercialCap'];
    groupCode = json['groupCode'];
    bookedDuration = json['bookedDuration'];
    backColor = json['backColor'];
    foreColor = json['foreColor'];
    selectionBackColor = json['selectionBackColor'];
    selectionForeColor = json['selectionForeColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rowNo'] = rowNo;
    data['programCode'] = programCode;
    data['languageCode'] = languageCode;
    data['oriRepCode'] = oriRepCode;
    data['programTypeCode'] = programTypeCode;
    data['color'] = color;
    data['episodeDuration'] = episodeDuration;
    data['fpcTime'] = fpcTime;
    data['endTime'] = endTime;
    data['programName'] = programName;
    data['epsNo'] = epsNo;
    data['tapeID'] = tapeID;
    data['oriRep'] = oriRep;
    data['wbs'] = wbs;
    data['caption'] = caption;
    data['modifed'] = modifed;
    data['commercialCap'] = commercialCap;
    data['groupCode'] = groupCode;
    data['bookedDuration'] = bookedDuration;
    data['backColor'] = backColor;
    data['foreColor'] = foreColor;
    data['selectionBackColor'] = selectionBackColor;
    data['selectionForeColor'] = selectionForeColor;
    return data;
  }
}
