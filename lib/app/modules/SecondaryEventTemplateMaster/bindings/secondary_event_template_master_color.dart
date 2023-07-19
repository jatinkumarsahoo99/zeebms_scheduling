class SecondaryTemplateEventColors {
  String? eventType;
  String? foreColor;
  String? backColor;

  SecondaryTemplateEventColors(
      {this.eventType, this.foreColor, this.backColor});

  SecondaryTemplateEventColors.fromJson(Map<String, dynamic> json) {
    eventType = json['eventType'].toString().trim();
    foreColor = json['foreColor'];
    backColor = json['backColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventType'] = eventType;
    data['foreColor'] = foreColor;
    data['backColor'] = backColor;
    return data;
  }
}
