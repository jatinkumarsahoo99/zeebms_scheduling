import '../../../data/DropDownValue.dart';

class PromoMasterOnloadModel {
  PromoMasterOnLoad? promoMasterOnLoad;

  PromoMasterOnloadModel({this.promoMasterOnLoad});

  PromoMasterOnloadModel.fromJson(Map<String, dynamic> json) {
    promoMasterOnLoad = json['promoMasterOnLoad'] != null ? PromoMasterOnLoad.fromJson(json['promoMasterOnLoad']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (promoMasterOnLoad != null) {
      data['promoMasterOnLoad'] = promoMasterOnLoad!.toJson();
    }
    return data;
  }
}

class PromoMasterOnLoad {
  List<DropDownValue>? lstLocation;
  List<DropDownValue>? lstPromoType;
  List<DropDownValue>? lstTapeType;
  List<DropDownValue>? lstCategory;
  List<DropDownValue>? lstOriginalRepeat;
  List<DropDownValue>? lstBilling;
  List<DropDownValue>? lstptype;
  List<DropDownValue>? lstTapeID;

  PromoMasterOnLoad(
      {this.lstLocation,
      this.lstPromoType,
      this.lstTapeType,
      this.lstCategory,
      this.lstOriginalRepeat,
      this.lstBilling,
      this.lstptype,
      this.lstTapeID});

  PromoMasterOnLoad.fromJson(Map<String, dynamic> json) {
    if (json['lstLocation'] != null) {
      lstLocation = <DropDownValue>[];
      json['lstLocation'].forEach((v) {
        lstLocation!.add(DropDownValue(
          key: v['locationCode'].toString(),
          value: v['locationName'].toString(),
        ));
      });
    }
    if (json['lstPromoType'] != null) {
      lstPromoType = <DropDownValue>[];
      json['lstPromoType'].forEach((v) {
        lstPromoType!.add(DropDownValue(
          key: v['code'].toString(),
          value: v['name'].toString(),
        ));
      });
    }
    if (json['lstTapeType'] != null) {
      lstTapeType = <DropDownValue>[];
      json['lstTapeType'].forEach((v) {
        lstTapeType!.add(DropDownValue(
          key: v['code'].toString(),
          value: v['name'].toString(),
        ));
      });
    }
    if (json['lstCategory'] != null) {
      lstCategory = <DropDownValue>[];
      json['lstCategory'].forEach((v) {
        lstCategory!.add(DropDownValue(
          key: v['code'].toString(),
          value: v['name'].toString(),
        ));
      });
    }
    if (json['lstOriginalRepeat'] != null) {
      lstOriginalRepeat = <DropDownValue>[];
      json['lstOriginalRepeat'].forEach((v) {
        lstOriginalRepeat!.add(DropDownValue(
          key: v['code'].toString(),
          value: v['name'].toString(),
        ));
      });
    }
    if (json['lstBilling'] != null) {
      lstBilling = <DropDownValue>[];
      json['lstBilling'].forEach((v) {
        lstBilling!.add(DropDownValue(
          key: v['code'].toString(),
          value: v['name'].toString(),
        ));
      });
    }
    if (json['lstptype'] != null) {
      lstptype = <DropDownValue>[];
      json['lstptype'].forEach((v) {
        lstptype!.add(DropDownValue(
          key: v['ptype'].toString(),
          value: v['ptypeName'].toString(),
        ));
      });
    }
    if (json['lstTapeID'] != null) {
      lstTapeID = <DropDownValue>[];
      json['lstTapeID'].forEach((v) {
        lstTapeID!.add(DropDownValue(
          key: v['tapeid'].toString(),
          value: v['ptypeName'].toString(),
        ));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lstLocation != null) {
      data['lstLocation'] = lstLocation!.map((v) => v.toJson()).toList();
    }
    if (lstPromoType != null) {
      data['lstPromoType'] = lstPromoType!.map((v) => v.toJson()).toList();
    }
    if (lstTapeType != null) {
      data['lstTapeType'] = lstTapeType!.map((v) => v.toJson()).toList();
    }
    if (lstCategory != null) {
      data['lstCategory'] = lstCategory!.map((v) => v.toJson()).toList();
    }
    if (lstOriginalRepeat != null) {
      data['lstOriginalRepeat'] = lstOriginalRepeat!.map((v) => v.toJson()).toList();
    }
    if (lstBilling != null) {
      data['lstBilling'] = lstBilling!.map((v) => v.toJson()).toList();
    }
    if (lstptype != null) {
      data['lstptype'] = lstptype!.map((v) => v.toJson()).toList();
    }
    if (lstTapeID != null) {
      data['lstTapeID'] = lstTapeID!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
