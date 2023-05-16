class SearchBindGrid {
  List<Variances>? variances;
  String? type;
  String? pivotTemplate;

  SearchBindGrid({this.variances, this.type, this.pivotTemplate});

  SearchBindGrid.fromJson(Map<String, dynamic> json) {
    if (json['variances'] != null) {
      variances = <Variances>[];
      json['variances'].forEach((v) {
        variances!.add(Variances.fromJson(v));
      });
    }
    type = json['type'];
    pivotTemplate = json['pivotTemplate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (variances != null) {
      data['variances'] = variances!.map((v) => v.toJson()).toList();
    }
    data['type'] = type;
    data['pivotTemplate'] = pivotTemplate;
    return data;
  }
}

class Variances {
  bool? selected;
  String? name;
  String? dataType;
  String? tableName;
  String? searchCriteria;
  int? sequence;
  String? formula;
  bool? fileSeparator;
  String? valueColumnName;

  Variances(
      {this.selected,
      this.name,
      this.dataType,
      this.tableName,
      this.searchCriteria,
      this.sequence,
      this.formula,
      this.fileSeparator,
      this.valueColumnName});

  Variances.fromJson(Map<String, dynamic> json) {
    selected = json['selected'];
    name = json['name'];
    dataType = json['dataType'];
    tableName = json['tableName'];
    searchCriteria = json['searchCriteria'];
    sequence = json['sequence'];
    formula = json['formula'];
    fileSeparator = json['fileSeparator'];
    valueColumnName = json['valueColumnName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['selected'] = selected ?? false;
    data['name'] = name ?? "";
    data['dataType'] = dataType ?? "";
    data['tableName'] = tableName ?? "";
    data['searchCriteria'] = searchCriteria ?? "";
    data['sequence'] = sequence ?? 0;
    data['formula'] = formula ?? "";
    data['fileSeparator'] = fileSeparator ?? false;
    data['valueColumnName'] = valueColumnName ?? "";
    return data;
  }
}
