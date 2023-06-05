class RoBookingInitData {
  List<LstLocation>? lstLocation;
  List<Lstspotpositiontype>? lstspotpositiontype;
  List<LstExecutives>? lstExecutives;
  List<LstPosition>? lstPosition;
  List<Lstsecondaryevents>? lstsecondaryevents;
  List<LstSecondaryEventTrigger>? lstSecondaryEventTrigger;
  List? lstdgvSpotsHeader;
  LstVerifiedLoationChannel? lstVerifiedLoationChannel;

  RoBookingInitData(
      {this.lstLocation,
      this.lstspotpositiontype,
      this.lstExecutives,
      this.lstPosition,
      this.lstsecondaryevents,
      this.lstSecondaryEventTrigger,
      this.lstdgvSpotsHeader,
      this.lstVerifiedLoationChannel});

  RoBookingInitData.fromJson(Map<String, dynamic> json) {
    if (json['lstLocation'] != null) {
      lstLocation = <LstLocation>[];
      json['lstLocation'].forEach((v) {
        lstLocation!.add(new LstLocation.fromJson(v));
      });
    }
    if (json['lstspotpositiontype'] != null) {
      lstspotpositiontype = <Lstspotpositiontype>[];
      json['lstspotpositiontype'].forEach((v) {
        lstspotpositiontype!.add(new Lstspotpositiontype.fromJson(v));
      });
    }
    if (json['lstExecutives'] != null) {
      lstExecutives = <LstExecutives>[];
      json['lstExecutives'].forEach((v) {
        lstExecutives!.add(new LstExecutives.fromJson(v));
      });
    }
    if (json['lstPosition'] != null) {
      lstPosition = <LstPosition>[];
      json['lstPosition'].forEach((v) {
        lstPosition!.add(new LstPosition.fromJson(v));
      });
    }
    if (json['lstsecondaryevents'] != null) {
      lstsecondaryevents = <Lstsecondaryevents>[];
      json['lstsecondaryevents'].forEach((v) {
        lstsecondaryevents!.add(new Lstsecondaryevents.fromJson(v));
      });
    }
    if (json['lstSecondaryEventTrigger'] != null) {
      lstSecondaryEventTrigger = <LstSecondaryEventTrigger>[];
      json['lstSecondaryEventTrigger'].forEach((v) {
        lstSecondaryEventTrigger!.add(new LstSecondaryEventTrigger.fromJson(v));
      });
    }
    if (json['lstdgvSpotsHeader'] != null) {
      lstdgvSpotsHeader = <Null>[];
      json['lstdgvSpotsHeader'].forEach((v) {
        lstdgvSpotsHeader!.add(v);
      });
    }
    lstVerifiedLoationChannel =
        json['lstVerifiedLoationChannel'] != null ? new LstVerifiedLoationChannel.fromJson(json['lstVerifiedLoationChannel']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstLocation != null) {
      data['lstLocation'] = this.lstLocation!.map((v) => v.toJson()).toList();
    }
    if (this.lstspotpositiontype != null) {
      data['lstspotpositiontype'] = this.lstspotpositiontype!.map((v) => v.toJson()).toList();
    }
    if (this.lstExecutives != null) {
      data['lstExecutives'] = this.lstExecutives!.map((v) => v.toJson()).toList();
    }
    if (this.lstPosition != null) {
      data['lstPosition'] = this.lstPosition!.map((v) => v.toJson()).toList();
    }
    if (this.lstsecondaryevents != null) {
      data['lstsecondaryevents'] = this.lstsecondaryevents!.map((v) => v.toJson()).toList();
    }
    if (this.lstSecondaryEventTrigger != null) {
      data['lstSecondaryEventTrigger'] = this.lstSecondaryEventTrigger!.map((v) => v.toJson()).toList();
    }
    if (this.lstdgvSpotsHeader != null) {
      data['lstdgvSpotsHeader'] = this.lstdgvSpotsHeader!.map((v) => v).toList();
    }
    if (this.lstVerifiedLoationChannel != null) {
      data['lstVerifiedLoationChannel'] = this.lstVerifiedLoationChannel!.toJson();
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

class Lstspotpositiontype {
  String? spotPositionTypeCode;
  String? spotPositionTypeName;

  Lstspotpositiontype({this.spotPositionTypeCode, this.spotPositionTypeName});

  Lstspotpositiontype.fromJson(Map<String, dynamic> json) {
    spotPositionTypeCode = json['spotPositionTypeCode'];
    spotPositionTypeName = json['spotPositionTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spotPositionTypeCode'] = this.spotPositionTypeCode;
    data['spotPositionTypeName'] = this.spotPositionTypeName;
    return data;
  }
}

class LstExecutives {
  String? personnelCode;
  String? personnelName;

  LstExecutives({this.personnelCode, this.personnelName});

  LstExecutives.fromJson(Map<String, dynamic> json) {
    personnelCode = json['personnelCode'];
    personnelName = json['personnelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personnelCode'] = this.personnelCode;
    data['personnelName'] = this.personnelName;
    return data;
  }
}

class LstPosition {
  String? positioncode;
  String? column1;

  LstPosition({this.positioncode, this.column1});

  LstPosition.fromJson(Map<String, dynamic> json) {
    positioncode = json['positioncode'];
    column1 = json['column1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['positioncode'] = this.positioncode;
    data['column1'] = this.column1;
    return data;
  }
}

class Lstsecondaryevents {
  int? secondaryeventid;
  String? secondaryevent;

  Lstsecondaryevents({this.secondaryeventid, this.secondaryevent});

  Lstsecondaryevents.fromJson(Map<String, dynamic> json) {
    secondaryeventid = json['secondaryeventid'];
    secondaryevent = json['secondaryevent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['secondaryeventid'] = this.secondaryeventid;
    data['secondaryevent'] = this.secondaryevent;
    return data;
  }
}

class LstSecondaryEventTrigger {
  int? secondaryeventid;
  String? secondaryevent;

  LstSecondaryEventTrigger({this.secondaryeventid, this.secondaryevent});

  LstSecondaryEventTrigger.fromJson(Map<String, dynamic> json) {
    secondaryeventid = json['secondaryeventid'];
    secondaryevent = json['secondaryevent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['secondaryeventid'] = this.secondaryeventid;
    data['secondaryevent'] = this.secondaryevent;
    return data;
  }
}

class LstVerifiedLoationChannel {
  List<VerifiedLocations>? lVerifiedLocations;
  List<VerifiedChannel>? lVerifiedChannel;

  LstVerifiedLoationChannel({this.lVerifiedLocations, this.lVerifiedChannel});

  LstVerifiedLoationChannel.fromJson(Map<String, dynamic> json) {
    if (json['_verifiedLocations'] != null) {
      lVerifiedLocations = <VerifiedLocations>[];
      json['_verifiedLocations'].forEach((v) {
        lVerifiedLocations!.add(new VerifiedLocations.fromJson(v));
      });
    }
    if (json['_verifiedChannel'] != null) {
      lVerifiedChannel = <VerifiedChannel>[];
      json['_verifiedChannel'].forEach((v) {
        lVerifiedChannel!.add(new VerifiedChannel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lVerifiedLocations != null) {
      data['_verifiedLocations'] = this.lVerifiedLocations!.map((v) => v.toJson()).toList();
    }
    if (this.lVerifiedChannel != null) {
      data['_verifiedChannel'] = this.lVerifiedChannel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VerifiedLocations {
  String? locationcode;
  String? locationname;

  VerifiedLocations({this.locationcode, this.locationname});

  VerifiedLocations.fromJson(Map<String, dynamic> json) {
    locationcode = json['locationcode'];
    locationname = json['locationname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationcode'] = this.locationcode;
    data['locationname'] = this.locationname;
    return data;
  }
}

class VerifiedChannel {
  String? channelCode;
  String? channelName;

  VerifiedChannel({this.channelCode, this.channelName});

  VerifiedChannel.fromJson(Map<String, dynamic> json) {
    channelCode = json['channelCode'];
    channelName = json['channelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelCode'] = this.channelCode;
    data['channelName'] = this.channelName;
    return data;
  }
}
