import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../../CommonDocs/controllers/common_docs_controller.dart';
import '../../CommonDocs/views/common_docs_view.dart';
import '../../CommonSearch/views/common_search_view.dart';
import '../BrandMasterProductDetails.dart';
import '../BrandMasterRetriveModel.dart';
import '../ClientDetailsAndBrandModel.dart';

class BrandMasterController extends GetxController {
  //TODO: Implement BrandMasterController
  bool isEnable = true;

  final count = 0.obs;
  var clientDetails = RxList<DropDownValue>();
  DropDownValue? selectedClientDetails;
  DropDownValue? selectedClient;
  Rxn<DropDownValue>? selectedProduct = Rxn<DropDownValue>(null);

  FocusNode clientFocus = FocusNode();
  FocusNode productFocus = FocusNode();
  FocusNode gridFocus = FocusNode();
  FocusNode brandNameFocus = FocusNode();
  FocusNode brandsShortNameFocus = FocusNode();
  FocusNode separationTimeFocus = FocusNode();

  FocusNode productLevel1Focus = FocusNode();
  FocusNode productLevel2Focus = FocusNode();
  FocusNode productLevel3Focus = FocusNode();
  FocusNode productLevel4Focus = FocusNode();

  TextEditingController clientController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController brandShortNameController = TextEditingController();
  TextEditingController separationTimeController =
      TextEditingController(text: '0');
  TextEditingController productController = TextEditingController();

  TextEditingController productLevel1Controller = TextEditingController();
  TextEditingController productLevel2Controller = TextEditingController();
  TextEditingController productLevel3Controller = TextEditingController();
  TextEditingController productLevel4Controller = TextEditingController();

  RxList<DropDownValue> clientList = RxList([]);
  RxList<DropDownValue> productList = RxList([]);

  bool isFocusNodeActive = false;
  PlutoGridStateManager? gridStateManager;
  int? selectedIndex = 0;

  clearAll() {
    Get.delete<BrandMasterController>();
    Get.find<HomeController>().clearPage1();
  }

  UserDataSettings? userDataSettings;

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    update(['grid']);
  }

  fetchClient(String client) {
    isFocusNodeActive = false;
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.BRANDMASTER_GETCLIENT + client,
        fun: (map) {
          isFocusNodeActive = false;
          if (map is List && map.isNotEmpty) {
            List<DropDownValue> dataList = [];
            clientList.clear();
            for (var e in map) {
              dataList.add(
                  DropDownValue.fromJsonDynamic(e, "ClientCode", "ClientName"));
            }
            clientList.addAll(dataList);
          } else {
            clientList.clear();
          }
        });
  }

  fetchProduct(String product) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.BRANDMASTER_GETPRODUCT + product,
        fun: (map) {
          isFocusNodeActive = false;
          if (map is List && map.isNotEmpty) {
            List<DropDownValue> dataList = [];
            productList.clear();
            for (var e in map) {
              dataList.add(DropDownValue.fromJsonDynamic(
                  e, "productcode", "Productname"));
            }
            productList.addAll(dataList);
          } else {
            productList.clear();
          }
        });
  }

  ClientDetailsAndBrandModel? clientDetailsAndBrandModel;
  List<DropDownValue> masterProductList = [];
  fetchOnLoad() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.BRANDMASTER_ONLOAD,
        fun: (map) {
          closeDialogIfOpen();
          // print(">>>>>>onload"+jsonEncode(map));
          isFocusNodeActive = false;
          if (map is Map &&
              map.containsKey('getBrandOnLoadList') &&
              map['getBrandOnLoadList'] != null) {
            if (map['getBrandOnLoadList'].containsKey('lstproduct') &&
                map['getBrandOnLoadList']['lstproduct'] != null &&
                map['getBrandOnLoadList']['lstproduct'].length > 0) {
              masterProductList.clear();
              map['getBrandOnLoadList']['lstproduct'].forEach((e) {
                masterProductList.add(DropDownValue.fromJsonDynamic(
                    e, "productcode", "productname"));
              });
            }
          }
        });
  }

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  Future<String> fetchClientDetails(String client) {
    Completer<String> completer = Completer<String>();
    isFocusNodeActive = false;
    LoadingDialog.call();
    brandNameFocus.requestFocus();
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.BRANDMASTER_GETCLIENTDETAILS +
              Uri.encodeComponent(client.replaceAll("'", "")),
          fun: (map) {
            closeDialogIfOpen();
            isFocusNodeActive = false;
            isFocusNodeActive = false;
            if (map is Map &&
                map.containsKey('clientdtails') &&
                map['clientdtails'] != null &&
                map['clientdtails'].length > 0) {
              clientDetailsAndBrandModel = ClientDetailsAndBrandModel.fromJson(
                  map as Map<String, dynamic>);
              isFocusNodeActive = false;
              update(['grid']);
              completer.complete("");
            } else {
              clientDetailsAndBrandModel = null;
              isFocusNodeActive = false;
              update(['grid']);
              completer.complete("");
            }
          });
    } catch (e) {
      completer.complete("");
    }
    return completer.future;
  }

  BrandMasterProductDetails? brandMasterProductDetails;
  getProductDetails(String productCode) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.BRANDMASTER_GETPRODUCTDETAILS + productCode,
        fun: (map) {
          if (map is Map &&
              map.containsKey('getproduct') &&
              map['getproduct'] != null &&
              map['getproduct'].length > 0) {
            brandMasterProductDetails =
                BrandMasterProductDetails.fromJson(map as Map<String, dynamic>);
            productLevel1Controller.text =
                brandMasterProductDetails?.getproduct?[0].ptName ?? "";
            productLevel2Controller.text =
                brandMasterProductDetails?.getproduct?[0].level1Name ?? "";
            productLevel3Controller.text =
                brandMasterProductDetails?.getproduct?[0].level2Name ?? "";
            productLevel4Controller.text =
                brandMasterProductDetails?.getproduct?[0].level3Name ?? "";
            update(['top']);
          } else {
            brandMasterProductDetails = null;
          }
        });
  }

  String strcode = "0";
  BrandMasterRetriveModel? brandMasterRetriveModel;

  getRetriveData(String brandName) {
    LoadingDialog.call();
    isFocusNodeActive = false;
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.BRANDMASTER_GETBRAND + Uri.encodeComponent(brandName),
        fun: (map) {
          closeDialogIfOpen();
          isFocusNodeActive = false;
          // strcode
          if (map is Map &&
              map.containsKey("getBrandList") &&
              map['getBrandList'] != null) {
            brandMasterRetriveModel =
                BrandMasterRetriveModel.fromJson(map as Map<String, dynamic>);
            strcode =
                brandMasterRetriveModel?.getBrandList?[0].brandCode ?? "0";
            selectedClient = DropDownValue(
                value: brandMasterRetriveModel?.getBrandList?[0].clientName,
                key: brandMasterRetriveModel?.getBrandList?[0].clientCode);
            brandController.text =
                brandMasterRetriveModel?.getBrandList?[0].brandName ?? "";
            brandShortNameController.text =
                brandMasterRetriveModel?.getBrandList?[0].brandShortName ?? "";
            separationTimeController.text =
                (brandMasterRetriveModel?.getBrandList?[0].separationTime ?? "")
                    .toString();
            // for (var element in masterProductList) {
            //   if (element.key.toString().trim() ==
            //       brandMasterRetriveModel?.getBrandList?[0].productCode
            //           .toString()
            //           .trim()) {
            //     selectedProduct?.value = DropDownValue(
            //         value: element.value ?? "Product",
            //         key: brandMasterRetriveModel?.getBrandList?[0].productCode);
            //     break;
            //   }
            // }

            productLevel1Controller.text =
                (brandMasterRetriveModel?.getBrandList?[0].ptName ?? "")
                    .toString();
            productLevel2Controller.text =
                (brandMasterRetriveModel?.getBrandList?[0].level1Name ?? "")
                    .toString();
            productLevel3Controller.text =
                (brandMasterRetriveModel?.getBrandList?[0].level2Name ?? "")
                    .toString();
            productLevel4Controller.text =
                (brandMasterRetriveModel?.getBrandList?[0].level3Name ?? "")
                    .toString();
            if (brandMasterRetriveModel?.getBrandList?[0].productName != null &&
                brandMasterRetriveModel?.getBrandList?[0].productCode != null) {
              selectedProduct?.value = DropDownValue(
                  value:
                      brandMasterRetriveModel?.getBrandList?[0].productName ??
                          "",
                  key: (brandMasterRetriveModel?.getBrandList?[0].productCode ??
                      ""));
            }
            update(['top']);
          } else {
            strcode = "0";
            isFocusNodeActive = false;
          }
        });
  }

  String replaceInvalidChar(String text, {bool upperCase = false}) {
    text = text.trim();
    if (upperCase == false) {
      text = text.toLowerCase();
      text = text
          .split(' ')
          .map((word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
          .join(' ');
    } else {
      text = text.toUpperCase();
    }
    text = text.replaceAll("'", "`");
    return text;
  }

  txtBrandNameLostFocus() {
    isFocusNodeActive = false;
    brandController.text = replaceInvalidChar(brandController.text,upperCase: true);
    if (brandController.text != null && brandController.text != "") {
      getRetriveData(brandController.text);
    }
  }

  docs() async {
    String documentKey = "";
    if (strcode == null || strcode == "") {
      documentKey = "";
    } else {
      documentKey = "Brandmaster $strcode";
    }

    if (documentKey == "") {
      return;
    }

    Get.defaultDialog(
      title: "Documents",
      content: CommonDocsView(documentKey: documentKey),
    ).then((value) {
      Get.delete<CommonDocsController>(tag: "commonDocs");
    });
  }

  fetchDataFromGrid(int index) {
    // clientDetailsAndBrandModel
    if (gridStateManager != null && (gridStateManager?.rows.length ?? 0) > 0) {
      // brandController.text = clientDetailsAndBrandModel!.clientdtails?[index].brandName??"";
      brandController.text =
          gridStateManager?.rows[index ?? 0].cells['brandName']?.value ?? "";

      // brandShortNameController.text = clientDetailsAndBrandModel!.clientdtails?[index].brandName ??"";
      brandShortNameController.text =
          gridStateManager?.rows[index ?? 0].cells['brandName']?.value ?? "";
      // productController.text =clientDetailsAndBrandModel!.clientdtails?[index].productName??"";
      productController.text =
          gridStateManager?.rows[index ?? 0].cells['productName']?.value ?? "";

      // productLevel1Controller.text = clientDetailsAndBrandModel!.clientdtails?[index].level1Name ??"";
      productLevel1Controller.text =
          gridStateManager?.rows[index ?? 0].cells['level1Name']?.value ?? "";

      // productLevel2Controller.text = clientDetailsAndBrandModel!.clientdtails?[index].level1Name ??"";
      productLevel2Controller.text =
          gridStateManager?.rows[index ?? 0].cells['level1Name']?.value ?? "";

      // productLevel3Controller.text = clientDetailsAndBrandModel!.clientdtails?[index].level2Name ??"";
      productLevel3Controller.text =
          gridStateManager?.rows[index ?? 0].cells['level2Name']?.value ?? "";

      // productLevel4Controller.text = clientDetailsAndBrandModel!.clientdtails?[index].level3Name ??"";
      productLevel4Controller.text =
          gridStateManager?.rows[index ?? 0].cells['level3Name']?.value ?? "";

      selectedProduct?.value = DropDownValue(
          value:
              (gridStateManager?.rows[index ?? 0].cells['productName']?.value ??
                  ""),
          key: "product");
      getRetriveData(brandController.text);
      update(['top']);
    }
  }

  void validateAndSaveRecord() {
    if (selectedClient == null) {
      Snack.callError("Client Name cannot be empty");
    } else if (brandController.text == null || brandController.text == "") {
      Snack.callError("Brand Name cannot be empty.");
    } else if (brandController.text == null || brandController.text == "") {
      Snack.callError("Brand Name cannot be empty.");
    } else if (brandShortNameController.text == null ||
        brandController.text == "") {
      Snack.callError("Brand Short Name cannot be empty.");
    } else if (selectedProduct == null) {
      Snack.callError("Product Name cannot be empty.");
    } else if (strcode != "0") {
      LoadingDialog.recordExists(
          "Record Already exist!\n Do you want to modify it?", () {
        isEnable = true;
        saveDataApi();
      });
    } else {
      saveDataApi();
    }
  }

  void saveDataApi() {
    Map<String, dynamic> postData = {
      "brandCode": strcode ?? "0",
      "brandName": brandController.text ?? "",
      "brandShortName": brandShortNameController.text ?? "",
      "productCode": selectedProduct?.value?.key ?? "",
      "clientCode": selectedClient?.key ?? "",
      "modifiedBy": Get.find<MainController>().user?.logincode ?? "",
      "separationTime": separationTimeController.text
    };
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.BRANDMASTER_SAVE,
        json: postData,
        fun: (map) {
          Get.back();
          // closeDialogIfOpen();
          if (map is Map &&
              map.containsKey("brandMater") &&
              map['brandMater'] != null) {
            if (strcode != "0") {
              LoadingDialog.callDataSavedMessage(
                  "Record is updated successfully.", callback: () {
                clearAll();
              });
            } else {
              LoadingDialog.callDataSavedMessage(
                  "Record is inserted successfully.", callback: () {
                clearAll();
              });
            }
          } else {
            LoadingDialog.showErrorDialog(
                (map ?? "Something went wrong").toString());
          }
        });
  }

  @override
  void onInit() {
    brandNameFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          if (brandController.text != null && brandController.text != "") {

            txtBrandNameLostFocus();
          }
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );

    clientFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          if (selectedClient != null && selectedClient?.value != "") {
            fetchClientDetails(selectedClient?.value ?? "").then((value) {
              brandNameFocus.requestFocus();
            });
          }
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );

    gridFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          if (brandController.text.trim() == "") {
            brandNameFocus.requestFocus();
          } else if (brandShortNameController.text.trim() == "") {
            brandsShortNameFocus.requestFocus();
          } else if (selectedProduct?.value == null) {
            productFocus.requestFocus();
          } else {
            gridFocus.nextFocus();
          }

          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );

    productLevel4Focus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          gridFocus.nextFocus();
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );

    super.onInit();
  }

  @override
  void onReady() {
    fetchOnLoad();
    super.onReady();
    fetchUserSetting1();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  formHandler(String string) {
    if (string == "Clear") {
      clearAll();
    } else if (string == "Save") {
      validateAndSaveRecord();
    } else if (string == "Docs") {
      docs();
    } else if (string == "Exit") {
      Get.find<HomeController>().postUserGridSetting2(listStateManager: [
        {"gridStateManager": gridStateManager},
      ]);
    } else if (string == "Search") {
      Get.to(
        const SearchPage(
          key: Key("Brand Master"),
          screenName: "Brand Master",
          appBarName: "Brand Master",
          strViewName: "BMS_vProductLevel",
          isAppBarReq: true,
        ),
      );
    }
  }
}
