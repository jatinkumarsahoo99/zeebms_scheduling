class RowFilter {
  String? field;
  String? operator;
  dynamic value;

  RowFilter({this.field, this.operator, this.value});

  RowFilter.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    operator = json['operator'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field'] = field;
    data['operator'] = operator;
    data['value'] = value;
    return data;
  }
}
