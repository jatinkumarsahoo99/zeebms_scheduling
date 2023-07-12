import 'package:bms_scheduling/app/data/DropDownValue.dart';

class InventoryStatusReportLoadModel {
  Info? info;

  InventoryStatusReportLoadModel({this.info});

  InventoryStatusReportLoadModel.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (info != null) {
      data['info'] = info!.toJson();
    }
    return data;
  }
}

class Info {
  List<DropDownValue>? locations;
  List<Channels>? channels;

  Info({this.locations, this.channels});

  Info.fromJson(Map<String, dynamic> json) {
    if (json['locations'] != null) {
      locations = <DropDownValue>[];
      json['locations'].forEach((v) {
        locations!.add(DropDownValue(key: v['locationCode'].toString(), value: v['locationName'].toString()));
      });
    }
    if (json['channels'] != null) {
      channels = <Channels>[];
      json['channels'].forEach((v) {
        channels!.add(Channels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (locations != null) {
      data['locations'] = locations!.map((v) => v.toJson()).toList();
    }
    if (channels != null) {
      data['channels'] = channels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Channels {
  DropDownValue? downValue;
  bool? isSelected;

  Channels({this.downValue, this.isSelected = false});

  Channels.fromJson(Map<String, dynamic> json) {
    downValue ??= DropDownValue();
    downValue?.key = json['channelCode'];
    downValue?.value = json['channelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['channelCode'] = downValue?.key;
    data['ischecked'] = isSelected ?? false;
    return data;
  }
}
