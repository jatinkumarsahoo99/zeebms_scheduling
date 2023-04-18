class MovieMapBillingMaster {
  Null? lstLocation;
  List<LstProgram>? lstProgram;
  List<LstSlot>? lstSlot;

  MovieMapBillingMaster({this.lstLocation, this.lstProgram, this.lstSlot});

  MovieMapBillingMaster.fromJson(Map<String, dynamic> json) {
    lstLocation = json['lstLocation'];
    if (json['lstProgram'] != null) {
      lstProgram = <LstProgram>[];
      json['lstProgram'].forEach((v) {
        lstProgram!.add(new LstProgram.fromJson(v));
      });
    }
    if (json['lstSlot'] != null) {
      lstSlot = <LstSlot>[];
      json['lstSlot'].forEach((v) {
        lstSlot!.add(new LstSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lstLocation'] = this.lstLocation;
    if (this.lstProgram != null) {
      data['lstProgram'] = this.lstProgram!.map((v) => v.toJson()).toList();
    }
    if (this.lstSlot != null) {
      data['lstSlot'] = this.lstSlot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstProgram {
  String? programName;
  String? programCode;

  LstProgram({this.programName, this.programCode});

  LstProgram.fromJson(Map<String, dynamic> json) {
    programName = json['programName'];
    programCode = json['programCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['programName'] = this.programName;
    data['programCode'] = this.programCode;
    return data;
  }
}

class LstSlot {
  String? programName;
  String? programCode;

  LstSlot({this.programName, this.programCode});

  LstSlot.fromJson(Map<String, dynamic> json) {
    programName = json['programName'];
    programCode = json['programCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['programName'] = this.programName;
    data['programCode'] = this.programCode;
    return data;
  }
}
