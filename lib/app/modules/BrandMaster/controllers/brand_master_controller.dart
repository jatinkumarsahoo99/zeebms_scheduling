import 'dart:convert';

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/ApiFactory.dart';
import '../BrandMasterProductDetails.dart';
import '../ClientDetailsAndBrandModel.dart';



class BrandMasterController extends GetxController {
  //TODO: Implement BrandMasterController
  bool isEnable = true;

  final count = 0.obs;
  var clientDetails = RxList<DropDownValue>();
  DropDownValue? selectedClientDetails;
  DropDownValue? selectedClient;
  DropDownValue? selectedProduct;

  FocusNode clientFocus = FocusNode();
  FocusNode productFocus = FocusNode();
  FocusNode gridFocus = FocusNode();
  FocusNode brandName = FocusNode();

  TextEditingController clientController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController brandShortNameController = TextEditingController();
  TextEditingController separationTimeController = TextEditingController();
  TextEditingController productController = TextEditingController();

  TextEditingController productLevel1Controller = TextEditingController();
  TextEditingController productLevel2Controller = TextEditingController();
  TextEditingController productLevel3Controller = TextEditingController();
  TextEditingController productLevel4Controller = TextEditingController();

  RxList<DropDownValue> clientList = RxList([]);
  RxList<DropDownValue> productList = RxList([]);

  bool isFocusNodeActive = false;
  PlutoGridStateManager? gridStateManager;
  int ? selectedIndex = 0;

  clearAll() {
    Get.delete<BrandMasterController>();
    Get.find<HomeController>().clearPage1();
  }

  fetchClient(String client) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.BRANDMASTER_GETCLIENT+client,
        fun: (map) {
          print(">>>>>>map"+jsonEncode(map));
          isFocusNodeActive = false;
          if (map is List && map.isNotEmpty) {
            clientList.clear();
            map.forEach((e) {
              clientList.add(DropDownValue.fromJsonDynamic(e, "ClientCode", "ClientName"));
            });
          }else{
            clientList.clear();
          }
        });
  }
  fetchProduct(String product) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.BRANDMASTER_GETPRODUCT+ product,
        fun: (map) {
          print(">>>>>>map"+jsonEncode(map));
          isFocusNodeActive = false;
          if (map is List && map.isNotEmpty) {
            productList.clear();
            map.forEach((e) {
              productList.add(DropDownValue.fromJsonDynamic(e, "productcode", "Productname"));
            });
          }else{
            productList.clear();
          }
        });
  }
  ClientDetailsAndBrandModel? clientDetailsAndBrandModel;
  fetchClientDetails(String client){
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.BRANDMASTER_GETCLIENTDETAILS+client,
        fun: (map) {
          print(">>>>>>map"+jsonEncode(map));
          isFocusNodeActive = false;
          if (map is Map && map.containsKey('clientdtails') && map['clientdtails'] != null &&
              map['clientdtails'].length >0 ) {
            clientDetailsAndBrandModel = ClientDetailsAndBrandModel.
            fromJson(map as Map<String,dynamic>);
            update(['grid']);
          }else{
            clientDetailsAndBrandModel = null;
            update(['grid']);
          }
        });
  }

  BrandMasterProductDetails? brandMasterProductDetails;
  getProductDetails(String productCode){
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.BRANDMASTER_GETCLIENTDETAILS+productCode,
        fun: (map) {
          print(">>>>>>map"+jsonEncode(map));
          if(map is Map && map.containsKey('getproduct') &&
              map['getproduct'] != null && map['getproduct'].length>0  ){
            brandMasterProductDetails =BrandMasterProductDetails.fromJson(map as Map<String,dynamic>);
            productLevel1Controller.text =brandMasterProductDetails?.getproduct?[0].ptName??"";
            productLevel2Controller.text =brandMasterProductDetails?.getproduct?[0].level1Name??"";
            productLevel3Controller.text =brandMasterProductDetails?.getproduct?[0].level2Name??"";
            productLevel4Controller.text =brandMasterProductDetails?.getproduct?[0].level3Name??"";
            update(['top']);
          }else{
            brandMasterProductDetails = null;
          }
        });
  }


  getRetriveData(String brandName,String brandCode){
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.BRANDMASTER_GETBRAND+brandCode+"&BrandName"+brandName,
        fun: (map) {

        });
  }




  @override
  void onInit() {
    clientFocus.addListener(() {
      if(clientFocus.hasFocus){
        isFocusNodeActive = true;
      }
      if(!clientFocus.hasFocus && isFocusNodeActive){
        fetchClient(clientController.text);
      }
    });
    productFocus.addListener(() {
      if(productFocus.hasFocus){
        isFocusNodeActive = true;
      }
      if(!productFocus.hasFocus && isFocusNodeActive){
        fetchProduct(productController.text);
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  formHandler(String string) {
    if(string == "Clear"){
      clearAll();
    }
  }
}
