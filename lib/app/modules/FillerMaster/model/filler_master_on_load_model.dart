import 'package:bms_scheduling/app/data/DropDownValue.dart';

class FillerMasterOnLoadModel {
  FillerMasterOnload? fillerMasterOnload;

  FillerMasterOnLoadModel({this.fillerMasterOnload});

  FillerMasterOnLoadModel.fromJson(Map<String, dynamic> json) {
    fillerMasterOnload = json['fillerMasterOnload'] != null
        ? FillerMasterOnload.fromJson(json['fillerMasterOnload'])
        : null;
  }
}

class FillerMasterOnload {
  List<DropDownValue>? lstLocation;
  List<DropDownValue>? lsttapesource;
  List<DropDownValue>? lstproduction;
  List<DropDownValue>? lstcolor;
  List<DropDownValue>? lstMovieGrade;
  List<DropDownValue2>? lstTapetypemaster;
  List<DropDownValue>? lstfillertypemaster;
  List<DropDownValue>? lstLanguagemaster;
  List<DropDownValue>? lstCensorshipMaster;
  List<DropDownValue>? lstRegion;
  List<DropDownValue>? lstEnegry;
  List<DropDownValue>? lstEra;
  List<DropDownValue>? lstSongGrade;
  List<DropDownValue>? lstMood;
  List<DropDownValue>? lstTempo;
  List<DropDownValue>? lstProducerTape;
  List<DropDownValue>? company;

  FillerMasterOnload(
      {this.lstLocation,
      this.lsttapesource,
      this.lstproduction,
      this.lstcolor,
      this.lstMovieGrade,
      this.lstTapetypemaster,
      this.lstfillertypemaster,
      this.lstLanguagemaster,
      this.lstCensorshipMaster,
      this.lstRegion,
      this.lstEnegry,
      this.lstEra,
      this.lstSongGrade,
      this.lstMood,
      this.lstTempo,
      this.lstProducerTape,
      this.company});

  FillerMasterOnload.fromJson(Map<String, dynamic> json) {
    if (json['lstLocation'] != null) {
      lstLocation = <DropDownValue>[];
      json['lstLocation'].forEach((v) {
        lstLocation!.add(DropDownValue(
            key: v['locationCode'].toString(),
            value: v['locationName'].toString()));
      });
    }
    if (json['lsttapesource'] != null) {
      lsttapesource = <DropDownValue>[];
      json['lsttapesource'].forEach((v) {
        lsttapesource!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstproduction'] != null) {
      lstproduction = <DropDownValue>[];
      json['lstproduction'].forEach((v) {
        lstproduction!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstcolor'] != null) {
      lstcolor = <DropDownValue>[];
      json['lstcolor'].forEach((v) {
        lstcolor!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstMovieGrade'] != null) {
      lstMovieGrade = <DropDownValue>[];
      json['lstMovieGrade'].forEach((v) {
        lstMovieGrade!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstTapetypemaster'] != null) {
      lstTapetypemaster = <DropDownValue2>[];
      json['lstTapetypemaster'].forEach((v) {
        lstTapetypemaster!.add(DropDownValue2(
            key: v['code'].toString(),
            value: v['name'].toString(),
            type: v['isActive'].toString()));
      });
    }
    if (json['lstfillertypemaster'] != null) {
      lstfillertypemaster = <DropDownValue>[];
      json['lstfillertypemaster'].forEach((v) {
        lstfillertypemaster!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstLanguagemaster'] != null) {
      lstLanguagemaster = <DropDownValue>[];
      json['lstLanguagemaster'].forEach((v) {
        lstLanguagemaster!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstCensorshipMaster'] != null) {
      lstCensorshipMaster = <DropDownValue>[];
      json['lstCensorshipMaster'].forEach((v) {
        lstCensorshipMaster!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstRegion'] != null) {
      lstRegion = <DropDownValue>[];
      json['lstRegion'].forEach((v) {
        lstRegion!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstEnegry'] != null) {
      lstEnegry = <DropDownValue>[];
      json['lstEnegry'].forEach((v) {
        lstEnegry!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstEra'] != null) {
      lstEra = <DropDownValue>[];
      json['lstEra'].forEach((v) {
        lstEra!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstSongGrade'] != null) {
      lstSongGrade = <DropDownValue>[];
      json['lstSongGrade'].forEach((v) {
        lstSongGrade!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstMood'] != null) {
      lstMood = <DropDownValue>[];
      json['lstMood'].forEach((v) {
        lstMood!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstTempo'] != null) {
      lstTempo = <DropDownValue>[];
      json['lstTempo'].forEach((v) {
        lstTempo!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }
    if (json['lstProducerTape'] != null) {
      lstProducerTape = <DropDownValue>[];
      json['lstProducerTape'].forEach((v) {
        lstProducerTape!.add(DropDownValue(
            key: v['code'].toString(), value: v['name'].toString()));
      });
    }

    if (json['company'] != null) {
      company = <DropDownValue>[];
      json['company'].forEach((v) {
        company!.add(DropDownValue(
            key: v['companyCode'].toString(),
            value: v['companyName'].toString()));
      });
    }
  }
}
