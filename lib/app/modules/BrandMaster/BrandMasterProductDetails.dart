class BrandMasterProductDetails {
  List<Getproduct>? getproduct;

  BrandMasterProductDetails({this.getproduct});

  BrandMasterProductDetails.fromJson(Map<String, dynamic> json) {
    if (json['getproduct'] != null) {
      getproduct = <Getproduct>[];
      json['getproduct'].forEach((v) {
        getproduct!.add(new Getproduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.getproduct != null) {
      data['getproduct'] = this.getproduct!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Getproduct {
  String? productCode;
  String? productName;
  int? ptCode;
  String? ptName;
  int? pl1;
  String? level1Name;
  int? pl2;
  String? level2Name;
  int? pl3;
  String? level3Name;

  Getproduct(
      {this.productCode,
        this.productName,
        this.ptCode,
        this.ptName,
        this.pl1,
        this.level1Name,
        this.pl2,
        this.level2Name,
        this.pl3,
        this.level3Name});

  Getproduct.fromJson(Map<String, dynamic> json) {
    productCode = json['productCode'];
    productName = json['productName'];
    ptCode = json['ptCode'];
    ptName = json['ptName'];
    pl1 = json['pl1'];
    level1Name = json['level1Name'];
    pl2 = json['pl2'];
    level2Name = json['level2Name'];
    pl3 = json['pl3'];
    level3Name = json['level3Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productCode'] = this.productCode;
    data['productName'] = this.productName;
    data['ptCode'] = this.ptCode;
    data['ptName'] = this.ptName;
    data['pl1'] = this.pl1;
    data['level1Name'] = this.level1Name;
    data['pl2'] = this.pl2;
    data['level2Name'] = this.level2Name;
    data['pl3'] = this.pl3;
    data['level3Name'] = this.level3Name;
    return data;
  }
}