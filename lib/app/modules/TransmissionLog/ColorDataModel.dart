class ColorDataModel {
  String? eventType;
  String? foreColor;
  String? backColor;

  ColorDataModel({this.eventType, this.foreColor, this.backColor});

  ColorDataModel.fromJson(Map<String, dynamic> json) {
    eventType = json['eventType'];
    foreColor = json['foreColor'];
    backColor = json['backColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventType'] = this.eventType;
    data['foreColor'] = this.foreColor;
    data['backColor'] = this.backColor;
    return data;
  }
}
