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
