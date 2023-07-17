class ComingUpTomorrowLoadData {
  List<LstLocation>? lstLocation;
  List<LstProgramType>? lstProgramType;

  ComingUpTomorrowLoadData({this.lstLocation, this.lstProgramType});

  ComingUpTomorrowLoadData.fromJson(Map<String, dynamic> json) {
    if (json['lstLocation'] != null) {
      lstLocation = <LstLocation>[];
      json['lstLocation'].forEach((v) {
        lstLocation!.add(new LstLocation.fromJson(v));
      });
    }
    if (json['lstProgramType'] != null) {
      lstProgramType = <LstProgramType>[];
      json['lstProgramType'].forEach((v) {
        lstProgramType!.add(new LstProgramType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstLocation != null) {
      data['lstLocation'] = this.lstLocation!.map((v) => v.toJson()).toList();
    }
    if (this.lstProgramType != null) {
      data['lstProgramType'] =
          this.lstProgramType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstLocation {
  String? locationCode;
  String? locationName;

  LstLocation({this.locationCode, this.locationName});

  LstLocation.fromJson(Map<String, dynamic> json) {
    locationCode = json['locationCode'];
    locationName = json['locationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationCode'] = this.locationCode;
    data['locationName'] = this.locationName;
    return data;
  }
}

class LstProgramType {
  String? programTypecode;
  String? programTypeName;
  String? modifiedBy;
  String? modifiedOn;
  String? multiPart;
  String? episodeSpecific;
  String? relatedEpisode;
  String? liveEvent;
  String? sportevent;
  String? msreplSynctranTs;
  String? sapCategory;
  String? checkWBS;
  String? slotflag;

  LstProgramType(
      {this.programTypecode,
        this.programTypeName,
        this.modifiedBy,
        this.modifiedOn,
        this.multiPart,
        this.episodeSpecific,
        this.relatedEpisode,
        this.liveEvent,
        this.sportevent,
        this.msreplSynctranTs,
        this.sapCategory,
        this.checkWBS,
        this.slotflag});

  LstProgramType.fromJson(Map<String, dynamic> json) {
    programTypecode = json['programTypecode'];
    programTypeName = json['programTypeName'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    multiPart = json['multiPart'];
    episodeSpecific = json['episodeSpecific'];
    relatedEpisode = json['relatedEpisode'];
    liveEvent = json['liveEvent'];
    sportevent = json['sportevent'];
    msreplSynctranTs = json['msrepl_synctran_ts'];
    sapCategory = json['sapCategory'];
    checkWBS = json['checkWBS'];
    slotflag = json['slotflag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['programTypecode'] = this.programTypecode;
    data['programTypeName'] = this.programTypeName;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['multiPart'] = this.multiPart;
    data['episodeSpecific'] = this.episodeSpecific;
    data['relatedEpisode'] = this.relatedEpisode;
    data['liveEvent'] = this.liveEvent;
    data['sportevent'] = this.sportevent;
    data['msrepl_synctran_ts'] = this.msreplSynctranTs;
    data['sapCategory'] = this.sapCategory;
    data['checkWBS'] = this.checkWBS;
    data['slotflag'] = this.slotflag;
    return data;
  }
}