import 'package:bms_scheduling/app/data/DropDownValue.dart';

class MAMWORKORDERONLOADMODEL {
  List<DropDownValue>? lstcboLocation;
  List<DropDownValue>? lstcboLocationFPC;
  List<DropDownValue>? lstcboLocationWOCanc;
  List<DropDownValue>? lstcboLocationWOHistory;
  List<DropDownValue>? lstcboTelecastType;
  List<DropDownValue>? lstcboTelecastTypeWOCanc;
  List<DropDownValue>? lstcboTelecastTypeWOHistory;
  bool? chkQuality;
  List<DropDownValue>? lstcboWorkOrderType;
  List<DropDownValue>? lstcboWOTypeFPC;
  List<DropDownValue>? lstcboWOTypeCancelWO;
  bool? btnSave;

  MAMWORKORDERONLOADMODEL(
      {this.lstcboLocation,
      this.lstcboLocationFPC,
      this.lstcboLocationWOCanc,
      this.lstcboLocationWOHistory,
      this.lstcboTelecastType,
      this.lstcboTelecastTypeWOCanc,
      this.lstcboTelecastTypeWOHistory,
      this.chkQuality,
      this.lstcboWorkOrderType,
      this.lstcboWOTypeFPC,
      this.lstcboWOTypeCancelWO,
      this.btnSave});

  MAMWORKORDERONLOADMODEL.fromJson(Map<String, dynamic> json) {
    print(json);
    if (json['lstcboLocation'] != null) {
      lstcboLocation = <DropDownValue>[];
      json['lstcboLocation'].forEach((v) {
        lstcboLocation!.add(DropDownValue.fromJson1(v));
      });
    }
    if (json['lstcboLocationFPC'] != null) {
      lstcboLocationFPC = <DropDownValue>[];
      json['lstcboLocationFPC'].forEach((v) {
        lstcboLocationFPC!.add(DropDownValue.fromJson1(v));
      });
    }
    if (json['lstcboLocationWOCanc'] != null) {
      lstcboLocationWOCanc = <DropDownValue>[];
      json['lstcboLocationWOCanc'].forEach((v) {
        lstcboLocationWOCanc!.add(DropDownValue.fromJson1(v));
      });
    }
    if (json['lstcboLocationWOHistory'] != null) {
      lstcboLocationWOHistory = <DropDownValue>[];
      json['lstcboLocationWOHistory'].forEach((v) {
        lstcboLocationWOHistory!.add(DropDownValue.fromJson1(v));
      });
    }
    if (json['lstcboTelecastType'] != null) {
      lstcboTelecastType = <DropDownValue>[];
      json['lstcboTelecastType'].forEach((v) {
        lstcboTelecastType!.add(DropDownValue.fromJson({"key": v['telecastTypeCode'].toString(), "value": v['telecastTypeName'].toString()}));
      });
    }
    if (json['lstcboTelecastTypeWOCanc'] != null) {
      lstcboTelecastTypeWOCanc = <DropDownValue>[];
      json['lstcboTelecastTypeWOCanc'].forEach((v) {
        lstcboTelecastTypeWOCanc!.add(DropDownValue.fromJson({"key": v['telecastTypeCode'].toString(), "value": v['telecastTypeName'].toString()}));
      });
    }
    if (json['lstcboTelecastTypeWOHistory'] != null) {
      lstcboTelecastTypeWOHistory = <DropDownValue>[];
      json['lstcboTelecastTypeWOHistory'].forEach((v) {
        lstcboTelecastTypeWOHistory!
            .add(DropDownValue.fromJson({"key": v['telecastTypeCode'].toString(), "value": v['telecastTypeName'].toString()}));
      });
    }
    chkQuality = json['chkQuality'];
    if (json['lstcboWorkOrderType'] != null) {
      lstcboWorkOrderType = <DropDownValue>[];
      json['lstcboWorkOrderType'].forEach((v) {
        lstcboWorkOrderType!.add(DropDownValue.fromJson({"key": v['workFlowId'].toString(), "value": v['workFlowName'].toString()}));
      });
    }
    if (json['lstcboWOTypeFPC'] != null) {
      lstcboWOTypeFPC = <DropDownValue>[];
      json['lstcboWOTypeFPC'].forEach((v) {
        lstcboWOTypeFPC!.add(DropDownValue.fromJson({"key": v['workFlowId'].toString(), "value": v['workFlowName'].toString()}));
      });
    }
    if (json['lstcboWOTypeCancelWO'] != null) {
      lstcboWOTypeCancelWO = <DropDownValue>[];
      json['lstcboWOTypeCancelWO'].forEach((v) {
        lstcboWOTypeCancelWO!.add(DropDownValue.fromJson({"key": v['workFlowId'].toString(), "value": v['workFlowName'].toString()}));
      });
    }
    btnSave = json['btnSave'];
  }
}
