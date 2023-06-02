class TransmissionLogModel {
  LoadSavedLogOutput? loadSavedLogOutput;

  TransmissionLogModel({this.loadSavedLogOutput});

  TransmissionLogModel.fromJson(Map<String, dynamic> json) {
    loadSavedLogOutput = json['loadSavedLogOutput'] != null
        ? new LoadSavedLogOutput.fromJson(json['loadSavedLogOutput'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.loadSavedLogOutput != null) {
      data['loadSavedLogOutput'] = this.loadSavedLogOutput!.toJson();
    }
    return data;
  }
}

class LoadSavedLogOutput {
  String? transmissiontime;
  String? logSavedBy;
  List<LstTransmissionLog>? lstTransmissionLog;

  LoadSavedLogOutput(
      {this.transmissiontime, this.logSavedBy, this.lstTransmissionLog});

  LoadSavedLogOutput.fromJson(Map<String, dynamic> json) {
    transmissiontime = json['transmissiontime'];
    logSavedBy = json['logSavedBy'];
    if (json['lstTransmissionLog'] != null) {
      lstTransmissionLog = <LstTransmissionLog>[];
      json['lstTransmissionLog'].forEach((v) {
        lstTransmissionLog!.add(new LstTransmissionLog.fromJson(v));
      });
    }

    if (json['lstTXLog'] != null) {
      lstTransmissionLog = <LstTransmissionLog>[];
      json['lstTXLog'].forEach((v) {
        lstTransmissionLog!.add(new LstTransmissionLog.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transmissiontime'] = this.transmissiontime;
    data['logSavedBy'] = this.logSavedBy;
    if (this.lstTransmissionLog != null) {
      data['lstTransmissionLog'] =
          this.lstTransmissionLog!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstTransmissionLog {
  String? fpCtime;
  String? transmissionTime;
  String? exportTapeCaption;
  String? exportTapeCode;
  String? tapeduration;
  String? som;
  int? breakNumber;
  int? episodeNumber;
  String? breakEvent;
  int? rownumber;
  String? eventType;
  String? bookingNumber;
  int? bookingdetailcode;
  String? scheduleTime;
  String? productName;
  String? rosTimeBand;
  String? client;
  String? promoTypecode;
  String? datechange;
  String? productGroup;
  String? longCaption;
  String? productnameFont;
  String? exporttapecodeFont;
  String? rosTimeBandFont;

  LstTransmissionLog(
      {this.fpCtime,
        this.transmissionTime,
        this.exportTapeCaption,
        this.exportTapeCode,
        this.tapeduration,
        this.som,
        this.breakNumber,
        this.episodeNumber,
        this.breakEvent,
        this.rownumber,
        this.eventType,
        this.bookingNumber,
        this.bookingdetailcode,
        this.scheduleTime,
        this.productName,
        this.rosTimeBand,
        this.client,
        this.promoTypecode,
        this.datechange,
        this.productGroup,
        this.longCaption,
        this.productnameFont,
        this.exporttapecodeFont,
        this.rosTimeBandFont});

  LstTransmissionLog.fromJson(Map<String, dynamic> json) {
    fpCtime = json['fpCtime'];
    transmissionTime = json['transmissionTime'];
    exportTapeCaption = json['exportTapeCaption'];
    exportTapeCode = json['exportTapeCode'];
    tapeduration = json['tapeduration'];
    som = json['som'];
    breakNumber = json['breakNumber'];
    episodeNumber = json['episodeNumber'];
    breakEvent = json['breakEvent'];
    rownumber = json['rownumber'];
    eventType = json['eventType'];
    bookingNumber = json['bookingNumber'];
    bookingdetailcode = json['bookingdetailcode'];
    scheduleTime = json['scheduleTime'];
    productName = json['productName'];
    rosTimeBand = json['rosTimeBand'];
    client = json['client'];
    promoTypecode = json['promoTypecode'];
    datechange = json['datechange'];
    productGroup = json['productGroup'];
    longCaption = json['longCaption'];
    productnameFont = json['productname_Font'];
    exporttapecodeFont = json['exporttapecode_Font'];
    rosTimeBandFont = json['rosTimeBand_Font'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fpCtime'] = this.fpCtime;
    data['transmissionTime'] = this.transmissionTime;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['exportTapeCode'] = this.exportTapeCode;
    data['tapeduration'] = this.tapeduration;
    data['som'] = this.som;
    data['breakNumber'] = this.breakNumber;
    data['episodeNumber'] = this.episodeNumber;
    data['breakEvent'] = this.breakEvent;
    data['rownumber'] = this.rownumber;
    // data['rownumber'] = (this.rownumber!-1);
    data['eventType'] = this.eventType;
    data['bookingNumber'] = this.bookingNumber;
    data['bookingdetailcode'] = this.bookingdetailcode;
    data['scheduleTime'] = this.scheduleTime;
    data['productName'] = this.productName;
    data['rosTimeBand'] = this.rosTimeBand;
    data['client'] = this.client;
    data['promoTypecode'] = this.promoTypecode;
    data['datechange'] = this.datechange;
    data['productGroup'] = this.productGroup;
    data['longCaption'] = this.longCaption;
    data['productname_Font'] = this.productnameFont;
    data['exporttapecode_Font'] = this.exporttapecodeFont;
    data['rosTimeBand_Font'] = this.rosTimeBandFont;
    return data;
  }
}
