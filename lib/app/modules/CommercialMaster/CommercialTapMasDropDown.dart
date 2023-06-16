class CommercialTapMasDropDownModel {
  List<TapeType>? tapeType;
  List<Language>? language;
  List<RevenueType>? revenueType;
  List<SecType>? secType;
  List<CensorshipType>? censorshipType;

  CommercialTapMasDropDownModel(
      {this.tapeType,
        this.language,
        this.revenueType,
        this.secType,
        this.censorshipType});

  CommercialTapMasDropDownModel.fromJson(Map<String, dynamic> json) {
    if (json['tapeType'] != null) {
      tapeType = <TapeType>[];
      json['tapeType'].forEach((v) {
        tapeType!.add(new TapeType.fromJson(v));
      });
    }
    if (json['language'] != null) {
      language = <Language>[];
      json['language'].forEach((v) {
        language!.add(new Language.fromJson(v));
      });
    }
    if (json['revenueType'] != null) {
      revenueType = <RevenueType>[];
      json['revenueType'].forEach((v) {
        revenueType!.add(new RevenueType.fromJson(v));
      });
    }
    if (json['secType'] != null) {
      secType = <SecType>[];
      json['secType'].forEach((v) {
        secType!.add(new SecType.fromJson(v));
      });
    }
    if (json['censorshipType'] != null) {
      censorshipType = <CensorshipType>[];
      json['censorshipType'].forEach((v) {
        censorshipType!.add(new CensorshipType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tapeType != null) {
      data['tapeType'] = this.tapeType!.map((v) => v.toJson()).toList();
    }
    if (this.language != null) {
      data['language'] = this.language!.map((v) => v.toJson()).toList();
    }
    if (this.revenueType != null) {
      data['revenueType'] = this.revenueType!.map((v) => v.toJson()).toList();
    }
    if (this.secType != null) {
      data['secType'] = this.secType!.map((v) => v.toJson()).toList();
    }
    if (this.censorshipType != null) {
      data['censorshipType'] =
          this.censorshipType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TapeType {
  String? code;
  String? name;

  TapeType({this.code, this.name});

  TapeType.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class CensorshipType {
  String? code;
  String? name;

  CensorshipType({this.code, this.name});

  CensorshipType.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class RevenueType {
  String? code;
  String? name;

  RevenueType({this.code, this.name});

  RevenueType.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class Language {
  String? code;
  String? name;

  Language({this.code, this.name});

  Language.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class SecType {
  int? eventCode;
  String? eventName;

  SecType({this.eventCode, this.eventName});

  SecType.fromJson(Map<String, dynamic> json) {
    eventCode = json['eventCode'];
    eventName = json['eventName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventCode'] = this.eventCode;
    data['eventName'] = this.eventName;
    return data;
  }
}