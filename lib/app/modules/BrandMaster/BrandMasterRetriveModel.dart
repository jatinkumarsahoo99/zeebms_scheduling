class BrandMasterRetriveModel {
  List<GetBrandList>? getBrandList;

  BrandMasterRetriveModel({this.getBrandList});

  BrandMasterRetriveModel.fromJson(Map<String, dynamic> json) {
    if (json['getBrandList'] != null) {
      getBrandList = <GetBrandList>[];
      json['getBrandList'].forEach((v) {
        getBrandList!.add(new GetBrandList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.getBrandList != null) {
      data['getBrandList'] = this.getBrandList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetBrandList {
  String? brandCode;
  String? brandName;
  String? brandShortName;
  int? separationTime;
  String? clientName;
  String? clientCode;
  String? productCode;
  String? Productname;
  int? ptCode;
  String? ptName;
  int? pl1;
  String? level1Name;
  int? pl2;
  String? level2Name;
  int? pl3;
  String? level3Name;

  GetBrandList(
      {this.brandCode,
        this.brandName,
        this.brandShortName,
        this.separationTime,
        this.clientName,
        this.clientCode,
        this.productCode,
        this.ptCode,
        this.ptName,
        this.pl1,
        this.level1Name,
        this.pl2,
        this.level2Name,
        this.pl3,
        this.level3Name,
        this.Productname
      });

  GetBrandList.fromJson(Map<String, dynamic> json) {
    brandCode = json['brandCode'];
    brandName = json['brandName'];
    brandShortName = json['brandShortName'];
    separationTime = json['separationTime'];
    clientName = json['clientName'];
    clientCode = json['clientCode'];
    productCode = json['productCode'];
    ptCode = json['ptCode'];
    ptName = json['ptName'];
    pl1 = json['pl1'];
    level1Name = json['level1Name'];
    pl2 = json['pl2'];
    level2Name = json['level2Name'];
    pl3 = json['pl3'];
    level3Name = json['level3Name'];
    Productname = json['Productname']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandCode'] = this.brandCode;
    data['brandName'] = this.brandName;
    data['brandShortName'] = this.brandShortName;
    data['separationTime'] = this.separationTime;
    data['clientName'] = this.clientName;
    data['clientCode'] = this.clientCode;
    data['productCode'] = this.productCode;
    data['ptCode'] = this.ptCode;
    data['ptName'] = this.ptName;
    data['pl1'] = this.pl1;
    data['level1Name'] = this.level1Name;
    data['pl2'] = this.pl2;
    data['level2Name'] = this.level2Name;
    data['pl3'] = this.pl3;
    data['level3Name'] = this.level3Name;
    data['Productname'] = this.Productname;
    return data;
  }
}
