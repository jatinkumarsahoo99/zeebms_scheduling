// ignore_for_file: non_constant_identifier_names

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'Const.dart';

// import '../modules/OperationalFPC/DailyFPCModel.dart';

class ApiFactory {
  static String userId = "";
  static String LOCAL_URL = "http://localhost:9999";
  static String Enviroment = const String.fromEnvironment('ENV', defaultValue: 'dev');

  /* static String WEB_URL = Enviroment.toLowerCase() == "uat"
      ? "https://app-admin-bms-uat.zeeconnect.in"
      : "https://app-admin-bms-dev.zeeconnect.in";
  static String WEB_URL_COMMON = Enviroment.toLowerCase() == "uat"
      ? "https://app-common-bms-uat.zeeconnect.in"
      : "https://app-common-bms-dev.zeeconnect.in";

  static String BASE_URL =
      Enviroment.toLowerCase() == "uat" ? "https://api-scheduling-bms-uat.zeeconnect.in" : "https://api-scheduling-bms-dev.zeeconnect.in";

  static String BASE_URL_COMMON = Enviroment.toLowerCase() == "uat"
      ? "https://api-common-bms-uat.zeeconnect.in"
      : "https://api-common-bms-dev.zeeconnect.in";
  static String BASE_URL_LOGIN = Enviroment.toLowerCase() == "uat"
      ? "https://api-login-bms-uat.zeeconnect.in"
      : "https://api-login-bms-dev.zeeconnect.in";*/

  static String WEB_URL = Const.getWebAdminUrl();
  static String WEB_URL_COMMON = Const.getWebCommonUrl();

  static String BASE_URL = Const.getBaseSchedulingAPIUrl();

  static String BASE_URL_COMMON = Const.getBaseCommonAPIUrl();
  static String BASE_URL_LOGIN = Const.getBaseLoginAPIUrl();

  ////////////////////// SEARCH ////////////////////////////

  static String SEARCH_SEND_NAME(
    String mail,
    String pageName,
  ) {
    var currentDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(DateTime.now());
    return BASE_URL_COMMON + "/api/MDI/SaveApplicationPagesFootprintData?UserName=$mail&PageName=$pageName&AccessDate=$currentDate";
  }

  static String SEARCH_VARIANCE({required String viewName, required String screenName, required String loginCode}) {
    // return BASE_URL + "/api/$screenName/SearchVariance/$viewName";
    return BASE_URL_COMMON + "/api/CommonSearch/SearchVariance/$viewName";
  }

  static String SEARCH_BINDGRID({required String viewName, required String screenName, required String code}) {
    // return BASE_URL + "/api/$screenName/BindGrid/$viewName,$code";
    return BASE_URL_COMMON + "/api/CommonSearch/BindGrid/$viewName,$code";
  }

  static String SEARCH_MASTER_SEARCH({
    required String name,
    required String valuecolumnname,
    required String TableName,
    required bool chkLikeNotLike,
    required String searchvalue,
    required String screenName,
  }) {
    // return BASE_URL + "/api/$screenName/TextSearch?name=$name&valuecolumnname=$valuecolumnname&TableName=$TableName&chkLikeNotLike=$chkLikeNotLike&searchvalue=$searchvalue";
    return BASE_URL_COMMON +
        "/api/CommonSearch/TextSearch?name=$name&valuecolumnname=$valuecolumnname&TableName=$TableName&chkLikeNotLike=$chkLikeNotLike&searchvalue=$searchvalue";
  }

  static String SEARCH_EXECUTE_SEARCH({
    required String strViewName,
    required String loginCode,
    required String screenName,
  }) {
    // return BASE_URL + "/api/$screenName/SearchExecute?strViewName=$strViewName";
    return BASE_URL_COMMON + "/api/CommonSearch/SearchExecute?strViewName=$strViewName";
  }

  // static String SEARCH_PIVOT({required String screenName,}) => BASE_URL + "/api/$screenName/SearchPivot";
  static String SEARCH_PIVOT({
    required String screenName,
  }) =>
      BASE_URL_COMMON + "/api/CommonSearch/SearchPivot";

  // static String SEARCH_EXCUTE_PIVOT({required String screenName, required String strViewname,}) => BASE_URL + "/api/$screenName/SearchExecutePivot?strViewName=$strViewname";
  static String SEARCH_EXCUTE_PIVOT({
    required String screenName,
    required String strViewname,
  }) =>
      BASE_URL_COMMON + "/api/CommonSearch/SearchExecutePivot?strViewName=$strViewname";

  static String ADD_SEARCH_VARIANCE({
    required String strViewName,
    required String loginCode,
    required String screenName,
    required String sVariant,
    // required String pivotTemplate,
  }) {
    // return BASE_URL + "/api/$screenName/InsertSearchVariance?strViewName=$strViewName&sVariant=$sVariant";
    return BASE_URL_COMMON + "/api/CommonSearch/InsertSearchVariance?strViewName=$strViewName&sVariant=$sVariant";
  }

  static String DELETE_SEARCH_VARIANCE({
    required String varianceId,
    required String loginCode,
    required String screenName,
  }) {
    // return BASE_URL + "/api/$screenName/DeleteSearchVariance?VarianceId=$varianceId";
    return BASE_URL_COMMON + "/api/CommonSearch/DeleteSearchVariance?VarianceId=$varianceId";
  }

  /////////////////////////////////////////////////////////

  static String AZURE_REDIRECT_UI = "${kReleaseMode ? WEB_URL : LOCAL_URL}/dashboard";
  static String NOTIFY_URL = (kReleaseMode ? WEB_URL_COMMON : LOCAL_URL);
  static String SPLIT_CLEAR_PAGE = (kReleaseMode ? "in/" : "92/");

  static String MS_TOKEN = "https://login.microsoftonline.com/56bd48cd-f312-49e8-b6c7-7b5b926c03d6/oauth2/token";

  static String LOGIN_API = "$BASE_URL_LOGIN/api/Login/GetLogin?";
  static String LOGOUT_API = "$BASE_URL_LOGIN/api/Login/GetLogout?PersonnelNo=";
  static String USER_INFO = "$BASE_URL_LOGIN/api/Login/GetUserinfo";
  static String PERMISSION_API = "$BASE_URL_COMMON/api/MDI/GetAllFormDetailsAndPermission?Userid=";
  static String MS_PROFILE = "$BASE_URL_LOGIN/api/Login/PostUserProfile";
  static String MS_TOKEN_BACKEND = "$BASE_URL_LOGIN/api/Login/PostApiToken";

  static String MS_TOKEN1 = "https://login.microsoftonline.com/56bd48cd-f312-49e8-b6c7-7b5b926c03d6/oauth2/v2.0/token";
  static String MS_AUTH = "https://login.microsoftonline.com/56bd48cd-f312-49e8-b6c7-7b5b926c03d6/oauth2/v2.0/token";

  // static String MS_GRAPH_USER_DETAILS = "https://graph.microsoft.com/v1.0/me?\$select=employeeId,mail,givenName";
  static String MS_GRAPH_USER_DETAILS =
      "https://graph.microsoft.com/v1.0/me?\$select=employeeId,mail,givenName,jobTitle,givenName,id,mobilePhone,displayName";
  static String MS_LOGOUT = "https://login.microsoftonline.com/common/oauth2/v2.0/logout?post_logout_redirect_uri=";

  /*static String PERMISSION_API =
      BASE_URL + "/api/MDI/GetAllFormDetailsAndPermission?Userid=";
*/
///////////////////////XML Download API////////////////////////
  static String EXPORT_TO_XML = "$BASE_URL_COMMON/api/Common/ConvertTableToXml";
  static String OPERATIONAL_FPC_PROGRAM_SEARCH = "$BASE_URL/api/DailyFPCReport/ProgramSearch?SearchText=";
  static String MOVIE_PLANNER_GET_LOCATIONS = BASE_URL + "/api/MoviePlanner/GetSchedulerLoadLocation";

  static String MOVIE_PLANNER_GET_DATA_ON_LOCATION_SELECT({required location, required userId}) {
    return BASE_URL + '/api/MoviePlanner/GetLocationSelect?Locationcode=$location&logincode=$userId';
  }

  //////////////////// FPC MISMATCH - UI: Sanjaya Jena API: PATTA NIGAM ////////////////
  static String FPC_MISMATCH_LOCATION = BASE_URL + "/api/FpcMismatch/GetLocations";

  static String FPC_MISMATCH_CHANNEL(String userId, String locCode) => BASE_URL + "/api/FpcMismatch/GetChannelMaster?locationCode=$locCode";

  static String FPC_MISMATCH(String location, String channelCode, String dt) =>
      // BASE_URL + "/api/FpcMismatch/BindFPCMismatchGrid/$location,$channelCode,$dt";
      BASE_URL + "/api/FpcMismatch/BindFPCMismatchGrid?LocationCode=$location&ChannelCode=$channelCode&EffectiveDate=$dt";

  static String FPC_MISMATCH_ERROR(String location, String channelCode, String dt) =>
      BASE_URL +
      // "/api/FpcMismatch/BindFPCMismatchGridError/$location,$channelCode,$dt";
      "/api/FpcMismatch/BindFPCMismatchGridError?LocationCode=$location&ChannelCode=$channelCode&EffectiveDate=$dt";

  static String FPC_MISMATCH_ALL(String location, String channelCode, String dt) =>
      BASE_URL +
      // "/api/FpcMismatch/BindFPCMismatchGridAll/$location,$channelCode,$dt";
      "/api/FpcMismatch/BindFPCMismatchGridAll?LocationCode=$location&ChannelCode=$channelCode&EffectiveDate=$dt";

  static String FPC_MISMATCH_PROGRAM(String location, String channelCode, String dt) =>
      // BASE_URL + "/api/FpcMismatch/BindWebFPCGrid/$location,$channelCode,$dt";
      BASE_URL + "/api/FpcMismatch/BindWebFPCGrid?LocationCode=$location&ChannelCode=$channelCode&TelecastDate=$dt";

  static String FPC_MISMATCH_MARK_ERROR = BASE_URL + "/api/FpcMismatch/UpdateRecordError";

  static String FPC_MISMATCH_MARK_UNDO_ERROR = BASE_URL + "/api/FpcMismatch/UpdateUndoError";

  static String FPC_MISMATCH_SAVE = BASE_URL + "/api/FpcMismatch/UpdateRecord";

/////////////////////////////////////End FPC Mismatch////////////////////////////////////////////////////

//////////////////////////////////////////Log Additions API: Deven UI: Sanjaya///////////////////////////////////////////////
  static String LOG_ADDITION_LOCATION = BASE_URL + "/api/Additions/GetLoadLocation";
  static String LOG_ADDITION_CHANNEL = BASE_URL + "/api/Additions/GetLocationSelect?Locationcode=";

  static String LOG_ADDITION_PREVIOUS_ADDITION(
    String locName,
    String chnlName,
    String date,
    String aditionNo,
  ) =>
      BASE_URL + "/api/Additions/GetDisplayPreviousAdditon?locationName=$locName&channelName=$chnlName&Date=$date&additionnumber=$aditionNo";

  static String LOG_ADDITION_SHOW_DETAILS(
          DropDownValue locDetail, DropDownValue chnlDetails, String date, bool isPrimary, bool checkStandBy, bool checkIgnore) =>
      BASE_URL +
      "/api/Additions/GetShowDetails?Locationcode=${locDetail.key}&locationName=${locDetail.value}&channelcode=${chnlDetails.key}&channelName=${chnlDetails.value}&logdate=$date&optPrimary=$isPrimary&chkStandby=$checkStandBy&chkIgnore=$checkIgnore";

  static String LOG_ADDITION_GET_ADDITIONS(DropDownValue locDetail, DropDownValue chnlDetails, String date) =>
      BASE_URL + "/api/Additions/GetPopulateAdditions?Locationcode=${locDetail.key}&channelcode=${chnlDetails.key}&Date=$date";

  static String LOG_ADDITION_SAVE_ADDITION() => BASE_URL + "/api/Additions/PostAddition";

  //////////////////////////////////////////End Log Addition///////////////////////////////////////////////

//////////////// Import Digitex Run Order: UI:SHOEB SHAIKH, API: INDRESH ///////////////

  static String IMPORT_DIGITEX_RUN_ORDER_LOCATION = "$BASE_URL/api/ImportDigitexRunOrder/GetLocations";

  static String IMPORT_DIGITEX_RUN_ORDER_CHANNEL(locationCode) => "$BASE_URL/api/ImportDigitexRunOrder/GetChannels/$locationCode";
  static String IMPORT_DIGITEX_RUN_ORDER_AGENCY = "$BASE_URL/api/ImportDigitexRunOrder/GetAgencyMasters/";
  static String IMPORT_DIGITEX_RUN_ORDER_CLIENT = "$BASE_URL/api/ImportDigitexRunOrder/GetClientMasters/";
  static String IMPORT_DIGITEX_RUN_ORDER_MAP_CLIENT = "$BASE_URL/api/ImportDigitexRunOrder/SaveMissingClientMaster";
  static String IMPORT_DIGITEX_RUN_ORDER_MAP_AGENCY = "$BASE_URL/api/ImportDigitexRunOrder/SaveMissingAgencyMaster";

  static String IMPORT_DIGITEX_RUN_ORDER_IMPORT(locationCode, channelCode) =>
      "$BASE_URL/api/ImportDigitexRunOrder/LoadDigitexRunOrder?LocationCode=$locationCode&ChannelCode=$channelCode";
  static String IMPORT_DIGITEX_RUN_ORDER_SAVE(locationCode, channelCode, date) =>
      "$BASE_URL/api/ImportDigitexRunOrder/SaveRunOrder?LocationCode=$locationCode&ChannelCode=$channelCode&BookingDate=$date";
//////////////// Filler: UI:VISHAL GORE, API: INDRESH ///////////////

  static String FILLER_LOCATION = "$BASE_URL/api/FillerScheduling/GetLocations";

  static String FILLER_CHANNEL(locationCode) => "$BASE_URL/api/FillerScheduling/GetChannels/$locationCode";

  static String FILLER_CAPTION = "$BASE_URL/api/FillerScheduling/GetFillerCaption/";

  /// to Search Caption in dropdown
  static String FILLER_VALUE_BY_CAPTION(fillerCaption) => "$BASE_URL/api/FillerScheduling/GetFillerCaption/$fillerCaption";

  static String FILLER_VALUES_BY_FILLER_CODE(fillerCode) => "$BASE_URL/api/FillerScheduling/GetFillerValuesByFillerCode/$fillerCode";

  static String FILLER_VALUES_BY_TAPE_CODE(tapeCode) => "$BASE_URL/api/FillerScheduling/GetFillerValuesByTapeCode/$tapeCode";
  static String FILLER_IMPORT_FILE = "$BASE_URL/api/FillerScheduling/ImportFillerExcel";
  static String FILLER_SAVE_IMPORT_FILLERS = "$BASE_URL/api/FillerScheduling/SaveImportExistingFillers";

  static String FPC_DETAILS(locationCode, channelCode, date) =>
      "$BASE_URL/api/FillerScheduling/GetFpcDetails?LocationCode=$locationCode&ChannelCode=$channelCode&TelecastDate=$date";

  static String SEGMENT_DETAILS(programCode, exportTapeCode, episodeNumber, originalRepeatCode, locationCode, channelCode, startTime, date) =>
      "$BASE_URL/api/FillerScheduling/GetSegmentDetails?ProgramCode=$programCode&ExportTapeCode=$exportTapeCode&EpisodeNumber=$episodeNumber&OriginalRepeatCode=$originalRepeatCode&LocationCode=$locationCode&ChannelCode=$channelCode&StartTime=$startTime&StartDate=$date";

  //////////////// Filler: UI: VISHAL G,API: DEVEN ///////////////

  static String COMMERCIAL_LOCATION = "$BASE_URL/api/CommercialScheduling/csload";

  static String COMMERCIAL_CHANNEL(locationCode) => "$BASE_URL/api/CommercialScheduling/GetLocationSelect?Locationcode=$locationCode";

  static String COMMERCIAL_SHOW_FPC_SCHEDULLING_DETAILS(locationCode, channelCode, date) =>
      "$BASE_URL/api/CommercialScheduling/GetShowDetails?Locationcode=$locationCode&ChannelCode=$channelCode&TelecastDate=$date";

  static String COMMERCIAL_SHOW_ON_TAB_DETAILS() => "$BASE_URL/api/CommercialScheduling/GetTabChange";

  static String SAVE_COMMERCIAL_DETAILS() => "$BASE_URL/api/CommercialScheduling/PostSave";

//////// RO CANCELLATION ///////
  static String RO_CANCELLATION_LOCATION = "$BASE_URL/api/ROCancellation/GetCboLocation";
  static String RO_CANCELLATION_CHANNNEL(locationCode) => "$BASE_URL/api/ROCancellation/OnLeaveLocation?LocationCode=$locationCode";

  static String RO_CANCELLATION_BOOKINGNO_LEAVE = "$BASE_URL/api/ROCancellation/OnLeaveBookingNumbers";
  static String RO_CANCELLATION_CANCEL_LEAVE = "$BASE_URL/api/ROCancellation/OnLeaveCancelNumber";
  static String RO_CANCELLATION_SAVE = "$BASE_URL/api/ROCancellation/SaveRoCancellation";
  static String RO_CANCELLATION_IMPORT = "$BASE_URL/api/ROCancellation/ImportExcel";
  static String RO_CANCELLATION_ADD_DOC = "$BASE_URL/api/ROCancellation/AddingDocument";
  static String RO_CANCELLATION_VIEW_DOC(id) => "$BASE_URL/api/ROCancellation/ViewDocument?DocId=$id";
  static String RO_CANCELLATION_LIST_DOC = "$BASE_URL/api/ROCancellation/AddingDocument";

  ////////////////////////////// MAM WORK ORDERS API START////////////////////////////////////////////////
  static String get MAM_WORK_ORDER_INITIALIZE => "$BASE_URL/api/MAMWorkOrder/OnLoadWorkOrder";

  /////////////////////////////////// 1st tab api //////////////////////////////////////////
  static String MAM_WORK_ORDER_NON_FPC_LOCATION_LEAVE(String? locationCode) {
    return "$BASE_URL/api/MAMWorkOrder/OnLeaveLocation${(locationCode == null || locationCode.isEmpty) ? '' : '?LocationCode=$locationCode'}";
  }

  static String get MAM_WORK_ORDER_NON_FPC_BMS_SEARCH => "$BASE_URL/api/MAMWorkOrder/OnLoadBMSProgram?Search=";
  static String get MAM_WORK_ORDER_NON_FPC_RMS_SEARCH => "$BASE_URL/api/MAMWorkOrder/OnLoadcboProgram?Search=";
  static String MAM_WORK_ORDER_NON_FPC_ON_BMS_LEAVE(String? val) => "$BASE_URL/api/MAMWorkOrder/OnLeaveBMSPrograms?BMSProgramCode=$val";
  static String get MAM_WORK_ORDER_NON_FPC_GET_DATA => "$BASE_URL/api/MAMWorkOrder/OnLeaveProgram";
  static String get MAM_WORK_ORDER_NON_FPC_SAVE_DATA => "$BASE_URL/api/MAMWorkOrder/SaveWorkOrder";
  /////////////////////////////////// 2nd tab api //////////////////////////////////////////
  static String MAM_WORK_ORDER_WO_ADFPC_GET_CHANNEL(String locationCode, String loginCode) =>
      "$BASE_URL/api/MAMWorkOrder/OnLeaveLocationFPC?LocationCode=$locationCode&LoginCode=$loginCode";
  static String get MAM_WORK_ORDER_WO_ADFPC_GET_DATATABLE_DATA => "$BASE_URL/api/MAMWorkOrder/OnLeaveTelecastDate";
  static String get MAM_WORK_ORDER_WO_ADFPC_SAVE_DATA => "$BASE_URL/api/MAMWorkOrder/SaveWOsFPC";

  /////////////////////////////////// 3rd tab api //////////////////////////////////////////
  static String get MAM_WORK_ORDER_WO_RE_PUSH_GET_DATA => "$BASE_URL/api/MAMWorkOrder/OnLoadRepush";
  static String get MAM_WORK_ORDER_WO_RE_PUSH_GET_JSON => "$BASE_URL/api/MAMWorkOrder/dgvRepushWorkOrderCell";
  static String get MAM_WORK_ORDER_WO_RE_PUSH_SAVE_DATA => "$BASE_URL/api/MAMWorkOrder/RepushReloadWorkService";

  /////////////////////////////////// 4th tab api //////////////////////////////////////////
  static String MAM_WORK_ORDER_WO_CANCEL_GET_CHANNEL(String locationCode, String loginCode) =>
      "$BASE_URL/api/MAMWorkOrder/OnLeaveLocationWOCanc?LocationCode=$locationCode&LoginCode=$loginCode";
  static String get MAM_WORK_ORDER_WO_CANCEL_PROGRAM_SEARCH => "$BASE_URL/api/MAMWorkOrder/OnLoadCancelProgram?Search=";
  static String get MAM_WORK_ORDER_WO_CANCEL_SHOW_DATA => "$BASE_URL/api/MAMWorkOrder/ShowWorkOrder";
  static String get MAM_WORK_ORDER_WO_CANCEL_CANCEL_DATA => "$BASE_URL/api/MAMWorkOrder/CancelWorkOrder";

  /////////////////////////////////// 5th tab api //////////////////////////////////////////
  static String MAM_WORK_ORDER_WO_HISTORY_GET_CHANNEL(String locationCode, String loginCode) =>
      "$BASE_URL/api/MAMWorkOrder/OnLeaveLocationWOHistory?LocationCode=$locationCode&LoginCode=$loginCode";
  static String get MAM_WORK_ORDER_WO_HISTORY_PROGRAM_SEARCH => "$BASE_URL/api/MAMWorkOrder/OnLoadProgramWOHistory?Search=";
  static String get MAM_WORK_ORDER_WO_HISTORY_SHOW_DATA => "$BASE_URL/api/MAMWorkOrder/GetShowWorkOrderHistory";

  ////////////////////////////// MAM WORK ORDERS API END////////////////////////////////////////////////

  ////////////////////////////// Spot Priority | Sanjaya :UI | Deven Bhole : API ////////////////////////

  static String SPOT_PRIORITY_LOCATION() => "$BASE_URL/api/SetSpotPriority/GetInitial";

  static String SPOT_PRIORITY_CHANNEL() => "$BASE_URL/api/SetSpotPriority/GetChannelList?LocationCode=";

  static String SPOT_PRIORITY_SAVE() => "$BASE_URL/api/SetSpotPriority/PostSave";

  static String SPOT_PRIORITY_SHOW_DETAILS(String loc, String chnlCode, String frmDt, String toDt) =>
      "$BASE_URL/api/SetSpotPriority/GetShowDetails?LocationCode=$loc&Channelcode=$chnlCode&FromDate=$frmDt&ToDate=$toDt";

//////// RO CANCELLATION ///////
  static String RO_RESCHEDULE_INIT = "$BASE_URL/api/RoReschedule/OnLoad_Reschedule";
  static String RO_RESCHEDULE_CHANNNEL(locationCode) => "$BASE_URL/api/RoReschedule/OnLeave_Location?LocationCode=$locationCode";
  static String RO_RESCHEDULE_BOOKINGNO_LEAVE = "$BASE_URL/api/RoReschedule/OnLeave_BookingNumber";

  static String RO_RESCHEDULE_DGVGRID_DOUBLECLICK = "$BASE_URL/api/RoReschedule/OnDoubleClick_dgvViewRO";
  static String RO_RESCHEDULE_SCHEDULENO_LEAVE = "$BASE_URL/api/RoReschedule/OnLeave_ReschedulingNo";
  static String RO_RESCHEDULE_MODIFY = "$BASE_URL/api/RoReschedule/OnClick_Modify";
  static String RO_RESCHEDULE_ADDSPOT = "$BASE_URL/api/RoReschedule/OnClick_AddSpots";
  static String RO_RESCHEDULE_SAVE = "$BASE_URL/api/RoReschedule/OnSave_Rescheduling";

  static String RO_RESCHEDULE_SELECTED_INDEX_CHNAGE_TAPEID = "$BASE_URL/api/RoReschedule/SelectedIndexChanged_TapeID";
////////////////////////////////End Spot Priority ////////////////////////

////////////////////////////// Transmission Log | Sanjaya :UI | Deven Bhole : API ////////////////////////

  static String TRANSMISSION_LOG_LOCATION() => "$BASE_URL/api/Transmissionlog/GetLoadLocation";
  static String TRANSMISSION_LOG_CHANNEL(String locId) => "$BASE_URL/api/Transmissionlog/GetLocationSelect?Locationcode=$locId";
  static String TRANSMISSION_LOG_RETRIVE() => "$BASE_URL/api/Transmissionlog/PostLoadSavedLog";
  static String TRANSMISSION_LOG_CHANNEL_SPEC_SETTING(String locId, String channelId) =>
      "$BASE_URL/api/Transmissionlog/GetChannelSpecsSettings?Locationcode=$locId&ChannelCode=$channelId";
  static String TRANSMISSION_LOG_COLOR_LIST(String locId, String channelId, String telcastDt) =>
      "$BASE_URL/api/Transmissionlog/GetLoadColours?locationcode=$locId&channelcode=$channelId&telecastdate=$telcastDt";
  static String TRANSMISSION_LOG_AUTO(String locId, String channelId, String telecastDt, bool isPromoReq, bool chkTxComm) =>
      "$BASE_URL/api/Transmissionlog/GetAutoClick?Locationcode=$locId&channelcode=$channelId&telecastdate=$telecastDt&addpromosAuto=$isPromoReq&chkTxCommercial=$chkTxComm";

  /////////////////////////// RO DISTRIBUTION START/////////////////////
  static String get RO_DISTRIBUTION_GET_LOCATION => "$BASE_URL/api/RosDistribution/GetRosDistribution";
  static String get RO_DISTRIBUTION_GET_RETRIVE_DATA => "$BASE_URL/api/RosDistribution/GetView";
  static String get RO_DISTRIBUTION_GET_EMPTY_DATA => "$BASE_URL/api/RosDistribution/GetEmptyList";
  static String get RO_DISTRIBUTION_GET_UN_DATA => "$BASE_URL/api/RosDistribution/GetUnalloacted";
  static String get RO_DISTRIBUTION_GET_SERVICE_DATA => "$BASE_URL/api/RosDistribution/GetServices";
  static String get RO_DISTRIBUTION_GET_ALLOCATION_DATA => "$BASE_URL/api/RosDistribution/GetAllocateClick";
  static String get RO_DISTRIBUTION_GET_DEALLOCATE_DATA => "$BASE_URL/api/RosDistribution/GetRollback";
  static String get RO_DISTRIBUTION_GET_FPC_DOUBLE_CLICK_DATA => "$BASE_URL/api/RosDistribution/GetFpcCellDoubleClick";
  static String get RO_DISTRIBUTION_GET_OPENDEAL_FILTER_DATA => "$BASE_URL/api/RosDistribution/GetOpenDealFilter";
  static String get RO_DISTRIBUTION_GET_ALLOCATE_FPC_DATA => "$BASE_URL/api/RosDistribution/GetAllocateFPC";
  static String get RO_DISTRIBUTION_GET_DEALLOCATE_FPC_DATA => "$BASE_URL/api/RosDistribution/GetDeallocateFPC";
  static String get RO_DISTRIBUTION_GET_INCLUDE_ROS_FILTER_FPC_DATA => "$BASE_URL/api/RosDistribution/GetIncludeROSFilter";
  static String get RO_DISTRIBUTION_GET_OPEN_DEAL_FILTER_FPC_DATA => "$BASE_URL/api/RosDistribution/GetOpenDealFilter";
  static String get RO_DISTRIBUTION_GET_MOVE_SPOT_FILTER_FPC_DATA => "$BASE_URL/api/RosDistribution/GetOpenDealFilter";

  static String RO_DISTRIBUTION_GET_CHANNEL(String locId) => "$BASE_URL/api/RosDistribution/cboLocationCode_Leave?LocationCode=$locId";
  static String RO_DISTRIBUTION_SHOW_DATA(String locId, String channelID, String date) =>
      "$BASE_URL/api/RosDistribution/GetShowBucket?LocationCode=$locId&ChannelCode=$channelID&Date=$date";
  /////////////////////////// RO DISTRIBUTION END/////////////////////
////
  ///
  ///
  ///
  ///
  ///
  ///
////////////////////////////// SLIDE-MASTER-API-START//////////////////////////////////////////////
  static String SLIDE_MASTER_ON_LOAD(String loginCode) => "$BASE_URL/api/SlideMaster/SlideMasteronLoad?LoginCode=$loginCode";
  static String SLIDE_MASTER_GET_CHANNEL(String locationCode) => "$BASE_URL/api/SlideMaster/onLeaveLocation?LocationCode=$locationCode";
  static String get SLIDE_MASTER_RETRIVE_DATA => "$BASE_URL/api/SlideMaster/TapeID_Leave";
////////////////////////////// SLIDE-MASTER-API-END  //////////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  ///////////////// RO BOOKING //////////////////////////
  static String RO_BOOKING_INIT = "$BASE_URL/api/ROBooking/RoBookingOnLoad";
  static String RO_BOOKING_CHANNNEL(locationCode) => "$BASE_URL/api/ROBooking/Location_Leave?LocationCode=$locationCode";

  static String RO_BOOKING_EFFDT_LEAVE(String locId, String channelId, String effDt) =>
      "$BASE_URL/api/ROBooking/EffectiveDate_Leave?LocationCode=$locId&ChannelCode=$channelId&EffectiveDate=$effDt";
  static String RO_BOOKING_CLIENT_LEAVE(String locId, String channelId, String clientCode) =>
      "$BASE_URL/api/ROBooking/ClientInfo?LocationCode=$locId&ChannelCode=$channelId&ClientCode=$clientCode";
}
