class DropDownValue {
  String? value;
  String? key;

  DropDownValue({this.value, this.key});

  DropDownValue.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    key = json['key'];
  }

  DropDownValue.fromJson1(Map<String, dynamic> json) {
    value = (json['locationName'] ?? json['name']).toString();
    key = (json['locationCode'] ?? json['code']).toString();
  }

  DropDownValue.fromJsonDynamic(
      Map<String, dynamic> json, String keyData, String name) {
    value = json[name].toString();
    key = json[keyData].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['key'] = key;
    return data;
  }
}

class DropDownValue2 {
  String? value;
  String? key;
  String? type;

  DropDownValue2({this.value, this.key, this.type});

  DropDownValue2.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    key = json['key'];
    type = json['type'];
  }

  DropDownValue2.fromJson1(Map<String, dynamic> json) {
    value = (json['locationName'] ?? json['name']).toString();
    key = (json['locationCode'] ?? json['code']).toString();
  }

  DropDownValue2.fromJsonDynamic(
      Map<String, dynamic> json, String keyData, String name) {
    value = json[name].toString();
    key = json[keyData].toString();
    type = json[type].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['key'] = key;
    data['type'] = type;
    return data;
  }
}
