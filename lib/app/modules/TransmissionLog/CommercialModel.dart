import '../../../app/data/DropDownValue.dart';

class CommercialModel {
  List<LstListLoggedCommercials>? lstListLoggedCommercials;
  Set<DropDownValue>? timelist = Set();

  CommercialModel({this.lstListLoggedCommercials});

  CommercialModel.fromJson(Map<String, dynamic> json) {
    if (json['lstListLoggedCommercials'] != null) {
      lstListLoggedCommercials = <LstListLoggedCommercials>[];
      json['lstListLoggedCommercials'].forEach((v) {
        lstListLoggedCommercials!.add(new LstListLoggedCommercials.fromJson(v));
        timelist?.add(
            DropDownValue(value: v["scheduletime"], key: v["scheduletime"]));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstListLoggedCommercials != null) {
      data['lstListLoggedCommercials'] =
          this.lstListLoggedCommercials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstListLoggedCommercials {
  int? column1;
  String? exportTapeCaption;
  String? productname;
  int? duration;
  String? exporttapecode;
  String? som;
  String? tonumber;
  int? bookingdetailcode;
  int? sEgmentnumber;
  String? rOsTime;
  String? scheduletime;

  LstListLoggedCommercials(
      {this.column1,
      this.exportTapeCaption,
      this.productname,
      this.duration,
      this.exporttapecode,
      this.som,
      this.tonumber,
      this.bookingdetailcode,
      this.sEgmentnumber,
      this.rOsTime,
      this.scheduletime});

  LstListLoggedCommercials.fromJson(Map<String, dynamic> json) {
    column1 = json['column1'];
    exportTapeCaption = json['exportTapeCaption'];
    productname = json['productname'];
    duration = json['duration'];
    exporttapecode = json['exporttapecode'];
    som = json['som'];
    tonumber = json['tonumber'];
    bookingdetailcode = json['bookingdetailcode'];
    sEgmentnumber = json['sEgmentnumber'];
    rOsTime = json['rOsTime'];
    scheduletime = json['scheduletime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['column1'] = this.column1;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['productname'] = this.productname;
    data['duration'] = this.duration;
    data['exporttapecode'] = this.exporttapecode;
    data['som'] = this.som;
    data['tonumber'] = this.tonumber;
    data['bookingdetailcode'] = this.bookingdetailcode;
    data['sEgmentnumber'] = this.sEgmentnumber;
    data['rOsTime'] = this.rOsTime;
    data['scheduletime'] = this.scheduletime;
    return data;
  }
}
