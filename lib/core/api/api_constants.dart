// lib/core/api/api_constants.dart

class ApiConstants {
  static const String baseUrl = 'http://salwmynew.ddns.net:7101/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1';
  //http://37.27.112.187:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1


  // Endpoints لطلبات GET
  static const String usersEndpoint = '/UsersVO1';
  static const String userSalaryInfoEndpoint = '/PySlrsInfoVO1';
  static const String userTransactionsInfoEndpoint = '/UsersTrnInfoVRO1';

  // --== Endpoints سابقة ==--
  static const String purchaseOrdersEndpoint = '/PrOrderProcessVRO1';

  // --== Endpoints جديدة ==--  //PyOrderVcncHVO1
  static const String vacationRequestsEndpoint = '/PyOrderVcncHProcessVRO1';
  static const String loanRequestsEndpoint = '/PyPrsnlLoanReqProcessVRO1';
  static const String resignationRequestsEndpoint = '/PyEndsrvOrderHProcessVRO1';
  static const String loanTypesEndpoint = '/PyPrsnlLoanTypesVRO1';

  // Endpoint لطلب POST الخاص بالإجراءات (مشترك)
  static const String submitActionUrl = "$baseUrl/SeUsersAuthVO1";

  // ---== Endpoints طلباتي ==---
  static const String myVacationRequestsEndpoint = '/PyOrderVcncHVO1';
  static const String myLoanRequestsEndpoint = '/PyPrsnlLoanReqVO1';
  static const String myResignationRequestsEndpoint = '/PyEndsrvOrderHVO1';

  // ---== Endpoints طلباتي (POST) ==---
  static const String createVacationRequestEndpoint = '/PyOrderVcncHVO1';
  static const String createLoanRequestEndpoint = '/PyPrsnlLoanReqVO1';
  static const String createResignationRequestEndpoint = '/PyEndsrvOrderHVO1';


  // ---== Endpoints الحضور والانصراف ==---
  static const String attendanceMonthsEndpoint = '/TaEmpSheetDummyMastVRO1'; // <-- الإضافة المصححة
// ---== إضافة جديدة ==---
  static const String checkedAttendanceMonthsEndpoint = '/TaEmpSheetMastVRO1';

  // ---== إضافة جديدة ==---
  static const String createAttendanceLogEndpoint = '/TaEmpSheetDummyVO1';

  static const String userTransactionInfoEndpoint = '/UsersTrnInfoVRO1';
  // -- الإضافة الجديدة --
  static const String checkInOutEndpoint = '$baseUrl/TaEmpSheetDummyVO1';





  // lib/core/api/api_constants.dart

  // ... (كل السطور القديمة)

  // ---== Endpoints الأذونات (جديد) ==---
  static const String permissionRequestsEndpoint = '/PyOrderPrmHProcessVRO1';

  // ... (باقي السطور)

  // ---== Endpoints طلباتي (الأذونات - جديد) ==---
  static const String myPermissionRequestsEndpoint = '/PyOrderPrmHVO1';

  // ... (باقي السطور)

  // ---== Endpoints طلباتي (الأذونات POST - جديد) ==---
  static const String createPermissionRequestEndpoint = '/PyOrderPrmHVO1';


  // ---== Endpoints مباشرة العمل (جديد) ==---
  static const String resumeWorkRequestsEndpoint = '/PyVcncRetHProcessVRO1';

  // ... (باقي السطور ... مثل myPermissionRequestsEndpoint)

  // ---== Endpoints طلباتي (مباشرة العمل - جديد) ==---
  static const String myResumeWorkRequestsEndpoint = '/PyVcncRetHVO1';

  // ... (باقي السطور ... مثل createPermissionRequestEndpoint)

  // ---== Endpoints طلباتي (مباشرة العمل POST - جديد) ==---
  static const String createResumeWorkRequestEndpoint = '/PyVcncRetHVO1';

  // ---== Endpoints نقل موظف (جديد) ==---
  static const String employeeTransferRequestsEndpoint = '/PyOrderMovesHProcessVO1';

  // ... (باقي السطور ... مثل myResumeWorkRequestsEndpoint)

  // ---== Endpoints طلباتي (نقل موظف - جديد) ==---
  static const String myEmployeeTransferRequestsEndpoint = '/PyOrderMovesHVO1';

  // ... (باقي السطور ... مثل createResumeWorkRequestEndpoint)

  // ---== Endpoints طلباتي (نقل موظف POST - جديد) ==---
  static const String createEmployeeTransferRequestEndpoint = '/PyOrderMovesHVO1';

  // ---== Endpoints خاصة بالـ Dropdowns (جديدة) ==---
  static const String companiesEndpoint = '/SeCompanyVRO1';
  static const String departmentsEndpoint = '/PyDeptHierVRO1';


  // ---== Endpoints تحريك سيارة (جديد) ==---
  static const String carMovementRequestsEndpoint = '/PyOrderCarHProcessVRO1';

  // ... (باقي السطور ... مثل myEmployeeTransferRequestsEndpoint)

  // ---== Endpoints طلباتي (تحريك سيارة - جديد) ==---
  static const String myCarMovementRequestsEndpoint = '/PyOrderCarHVO1';

  // ... (باقي السطور ... مثل createEmployeeTransferRequestEndpoint)

  // ---== Endpoints طلباتي (تحريك سيارة POST - جديد) ==---
  static const String createCarMovementRequestEndpoint = '/PyOrderCarHVO1';


  // ---== Endpoints تثبيت راتب (جديد) ==---
  static const String salaryConfirmationRequestsEndpoint = '/SsFixedSalProcessVRO1';

  // ... (باقي السطور ... مثل myCarMovementRequestsEndpoint)

  // ---== Endpoints طلباتي (تثبيت راتب - جديد) ==---
  static const String mySalaryConfirmationRequestsEndpoint = '/SsFixedSalVO1';

  // ... (باقي السطور ... مثل createCarMovementRequestEndpoint)

  // ---== Endpoints طلباتي (تثبيت راتب POST - جديد) ==---
  static const String createSalaryConfirmationRequestEndpoint = '/SsFixedSalVO1';

}