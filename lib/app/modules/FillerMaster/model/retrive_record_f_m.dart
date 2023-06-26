import 'filler_annotation_model.dart';

class RetriveRecordFillerMasterModel {
  List<HouseID>? houseID;

  RetriveRecordFillerMasterModel({this.houseID});

  RetriveRecordFillerMasterModel.fromJson(Map<String, dynamic> json) {
    if (json['retriveRecord'] != null) {
      houseID = <HouseID>[];
      json['retriveRecord'].forEach((v) {
        houseID!.add(new HouseID.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.houseID != null) {
      data['retriveRecord'] = this.houseID!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HouseID {
  String? fillerCode;
  String? fillerCaption;
  int? fillerDuration;
  String? fillerTypeCode;
  String? bannerCode;
  String? languageCode;
  String? censorshipCode;
  String? tapeTypeCode;
  String? exportTapeCode;
  String? exportTapeCaption;
  String? blackWhite;
  String? inHouseOutHouse;
  int? segmentNumber;
  String? som;
  String? fromDate;
  String? killDate;
  String? fillerSynopsis;
  String? modifiedBy;
  String? dated;
  String? houseId;
  String? blanktapeid;
  String? locationcode;
  String? channelcode;
  String? eom;
  String? moviename;
  String? releaseYear;
  String? singerName;
  String? musicCompany;
  String? musicDirector;
  String? grade;
  int? moodCode;
  int? energyCode;
  int? tempoCode;
  int? eraCode;
  int? gradeCode;
  int? regioncode;
  String? bannerName;
  List<dynamic>? lstAnnotationLoadDatas;

  HouseID(
      {this.fillerCode,
      this.fillerCaption,
      this.bannerName,
      this.fillerDuration,
      this.fillerTypeCode,
      this.bannerCode,
      this.languageCode,
      this.censorshipCode,
      this.tapeTypeCode,
      this.exportTapeCode,
      this.exportTapeCaption,
      this.blackWhite,
      this.inHouseOutHouse,
      this.segmentNumber,
      this.som,
      this.fromDate,
      this.killDate,
      this.fillerSynopsis,
      this.modifiedBy,
      this.dated,
      this.houseId,
      this.blanktapeid,
      this.locationcode,
      this.channelcode,
      this.eom,
      this.moviename,
      this.releaseYear,
      this.singerName,
      this.musicCompany,
      this.musicDirector,
      this.grade,
      this.moodCode,
      this.energyCode,
      this.tempoCode,
      this.eraCode,
      this.gradeCode,
      this.lstAnnotationLoadDatas,
      this.regioncode});

  HouseID.fromJson(Map<String, dynamic> json) {
    fillerCode = json['fillerCode'];
    fillerCaption = json['fillerCaption'];
    fillerDuration = json['fillerDuration'];
    fillerTypeCode = json['fillerTypeCode'];
    bannerCode = json['bannerCode'];
    languageCode = json['languageCode'];
    censorshipCode = json['censorshipCode'];
    tapeTypeCode = json['tapeTypeCode'];
    exportTapeCode = json['exportTapeCode'];
    exportTapeCaption = json['exportTapeCaption'];
    blackWhite = json['blackWhite'];
    inHouseOutHouse = json['inHouseOutHouse'];
    segmentNumber = json['segmentNumber'];
    som = json['som'];
    fromDate = json['fromDate'];
    killDate = json['killDate'];
    fillerSynopsis = json['fillerSynopsis'];
    modifiedBy = json['modifiedBy'];
    dated = json['dated'];
    houseId = json['houseId'];
    blanktapeid = json['blanktapeid'];
    locationcode = json['locationcode'];
    channelcode = json['channelcode'];
    eom = json['eom'];
    moviename = json['moviename'];
    releaseYear = json['releaseYear'];
    singerName = json['singerName'];
    musicCompany = json['musicCompany'];
    musicDirector = json['musicDirector'];
    grade = json['grade'];
    moodCode = json['moodCode'];
    energyCode = json['energyCode'];
    tempoCode = json['tempoCode'];
    eraCode = json['eraCode'];
    gradeCode = json['gradeCode'];
    regioncode = json['regioncode'];
    bannerName = json['bannerName'];
    if (json['lstAnnotationLoadDatas'] != null && json['lstAnnotationLoadDatas'] is List<dynamic>) {
      lstAnnotationLoadDatas = [];
      for (var element in json['lstAnnotationLoadDatas']) {
        lstAnnotationLoadDatas?.add(FillerMasterAnnotationModel.fromJson(element));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fillerCode'] = this.fillerCode;
    data['fillerCaption'] = this.fillerCaption;
    data['fillerDuration'] = this.fillerDuration;
    data['fillerTypeCode'] = this.fillerTypeCode;
    data['bannerCode'] = this.bannerCode;
    data['languageCode'] = this.languageCode;
    data['censorshipCode'] = this.censorshipCode;
    data['tapeTypeCode'] = this.tapeTypeCode;
    data['exportTapeCode'] = this.exportTapeCode;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['blackWhite'] = this.blackWhite;
    data['inHouseOutHouse'] = this.inHouseOutHouse;
    data['segmentNumber'] = this.segmentNumber;
    data['som'] = this.som;
    data['fromDate'] = this.fromDate;
    data['killDate'] = this.killDate;
    data['fillerSynopsis'] = this.fillerSynopsis;
    data['modifiedBy'] = this.modifiedBy;
    data['dated'] = this.dated;
    data['houseId'] = this.houseId;
    data['blanktapeid'] = this.blanktapeid;
    data['locationcode'] = this.locationcode;
    data['channelcode'] = this.channelcode;
    data['eom'] = this.eom;
    data['moviename'] = this.moviename;
    data['releaseYear'] = this.releaseYear;
    data['singerName'] = this.singerName;
    data['musicCompany'] = this.musicCompany;
    data['musicDirector'] = this.musicDirector;
    data['grade'] = this.grade;
    data['moodCode'] = this.moodCode;
    data['energyCode'] = this.energyCode;
    data['tempoCode'] = this.tempoCode;
    data['eraCode'] = this.eraCode;
    data['gradeCode'] = this.gradeCode;
    data['regioncode'] = this.regioncode;
    return data;
  }
}
