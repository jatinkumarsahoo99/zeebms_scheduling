class DrawerModel {
  List<Parent>? parent;

  DrawerModel({this.parent});

  DrawerModel.fromJson(Map<String, dynamic> json) {
    if (json['parent'] != null) {
      parent = <Parent>[];
      json['parent'].forEach((v) {
        parent!.add(new Parent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parent != null) {
      data['parent'] = this.parent!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parent {
  String? name;
  int? id;
  List<Child>? child;

  Parent({this.name, this.id, this.child});

  Parent.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    if (json['child'] != null) {
      child = <Child>[];
      json['child'].forEach((v) {
        child!.add(new Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    if (this.child != null) {
      data['child'] = this.child!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Child {
  String? name;
  String? id;
  List<SubChild>? subChild;

  Child({this.name, this.id, this.subChild});

  Child.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    if (json['subChild'] != null) {
      subChild = <SubChild>[];
      json['subChild'].forEach((v) {
        subChild!.add(new SubChild.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    if (this.subChild != null) {
      data['subChild'] = this.subChild!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubChild {
  String? name;
  String? id;
  String? path;
  String? key;

  SubChild({this.name, this.id});

  SubChild.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    path = json['path'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['path'] = this.path;
    data['key'] = this.key;
    return data;
  }
}
