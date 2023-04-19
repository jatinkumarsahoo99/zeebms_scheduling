class PermissionModel {
  String? moduleName;
  String? menuName;
  String? formName;
  String? appFormName;
  bool? read;
  bool? write;
  bool? delete;
  bool? export;
  bool? print;
  bool? backDated;
  bool? search;
  String? displayName;

  PermissionModel(
      {this.moduleName,
      this.menuName,
      this.formName,
      this.appFormName,
      this.read,
      this.write,
      this.delete,
      this.export,
      this.print,
      this.backDated,
      this.search,
      this.displayName});

  PermissionModel.fromJson(Map<String, dynamic> json) {
    moduleName = json['moduleName'];
    menuName = json['menuName'];
    formName = json['formName'];
    appFormName = json['appFormName'];
    read = json['read'];
    write = json['write'];
    delete = json['delete'];
    export = json['export'];
    print = json['print'];
    backDated = json['backDated'];
    search = json['search'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['moduleName'] = moduleName;
    data['menuName'] = menuName;
    data['formName'] = formName;
    data['appFormName'] = appFormName;
    data['read'] = read;
    data['write'] = write;
    data['delete'] = delete;
    data['export'] = export;
    data['print'] = print;
    data['backDated'] = backDated;
    data['search'] = search;
    data['displayName'] = displayName;
    return data;
  }

  @override
  String toString() {
    return 'PermissionModel{moduleName: $moduleName, menuName: $menuName, formName: $formName, displayName: $displayName, appFormName: $appFormName, read: $read, write: $write, delete: $delete, export: $export, print: $print, backDated: $backDated, search: $search}';
  }
}
