
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/core/models/loan_auth_model.dart';
import 'package:flutterapppart2hr/core/models/loan_request_model.dart';
import 'package:flutterapppart2hr/core/models/loan_type_model.dart';
import 'package:flutterapppart2hr/core/models/resignation_auth_model.dart';
import 'package:flutterapppart2hr/core/models/resignation_request_model.dart';
import 'package:flutterapppart2hr/core/models/user_transaction_info_model.dart';
import 'package:flutterapppart2hr/core/models/vacation_auth_model.dart';
import 'package:flutterapppart2hr/core/models/vacation_request_model.dart';
import 'package:flutterapppart2hr/features/loans/models/my_loan_request_model.dart';
import 'package:flutterapppart2hr/features/resignations/models/my_resignation_request_model.dart';
import 'package:flutterapppart2hr/features/vacations/models/my_vacation_request_model.dart';

// ... (أضف الـ imports الجديدة دي فوق)
import 'package:flutterapppart2hr/features/permissions/models/my_permission_request_model.dart';
import 'package:flutterapppart2hr/features/permissions/models/permission_auth_model.dart';
import 'package:flutterapppart2hr/features/permissions/models/permission_request_model.dart';

// ---== imports مباشرة العمل (جديدة) ==---
import 'package:flutterapppart2hr/features/resume_work/models/my_resume_work_request_model.dart';
import 'package:flutterapppart2hr/features/resume_work/models/resume_work_request_model.dart';
import 'package:flutterapppart2hr/features/resume_work/models/resume_work_auth_model.dart';


// ---== imports نقل موظف (جديدة) ==---
import 'package:flutterapppart2hr/features/employee_transfer/models/my_employee_transfer_request_model.dart';
import 'package:flutterapppart2hr/features/employee_transfer/models/employee_transfer_request_model.dart';
import 'package:flutterapppart2hr/features/employee_transfer/models/employee_transfer_auth_model.dart';

// ---== Imports جديدة للـ Dropdowns ==---
import 'package:flutterapppart2hr/features/employee_transfer/models/company_model.dart';
import 'package:flutterapppart2hr/features/employee_transfer/models/department_model.dart';


// ---== imports تحريك سيارة (جديدة) ==---
import 'package:flutterapppart2hr/features/car_movement/models/my_car_movement_request_model.dart';
import 'package:flutterapppart2hr/features/car_movement/models/car_movement_request_model.dart';
import 'package:flutterapppart2hr/features/car_movement/models/car_movement_auth_model.dart';


// ---== imports تثبيت راتب (جديدة) ==---
import 'package:flutterapppart2hr/features/salary_confirmation/models/my_salary_confirmation_request_model.dart';
import 'package:flutterapppart2hr/features/salary_confirmation/models/salary_confirmation_request_model.dart';
import 'package:flutterapppart2hr/features/salary_confirmation/models/salary_confirmation_auth_model.dart';

// ---== imports إلغاء تثبيت راتب (جديدة) ==---
import 'package:flutterapppart2hr/features/cancel_salary_confirmation/models/my_cancel_salary_confirmation_request_model.dart';
import 'package:flutterapppart2hr/features/cancel_salary_confirmation/models/cancel_salary_confirmation_request_model.dart';
import 'package:flutterapppart2hr/features/cancel_salary_confirmation/models/cancel_salary_confirmation_auth_model.dart';


import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../api/api_constants.dart';
import '../models/purchase_order_model.dart';
import '../services/data_fetch_service.dart';

// ---== نماذج الموافقات ==---

// ---== نماذج طلباتي ==---

class HrProvider with ChangeNotifier {
  final DataFetchService _dataFetchService = DataFetchService();
  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool _isSubmittingAction = false;
  String? _actionError;
  bool get isSubmittingAction => _isSubmittingAction;
  String? get actionError => _actionError;


  // ---===< 1. حالة الموافقات >===---
  List<VacationRequestItem> _vacationRequests = [];
  VacationRequestItem? _selectedVacationRequest;
  VacationAuthResponse? _vacationAuthDetails;
  List<VacationRequestItem> get vacationRequests => _vacationRequests;
  VacationRequestItem? get selectedVacationRequest => _selectedVacationRequest;
  VacationAuthResponse? get vacationAuthDetails => _vacationAuthDetails;

  List<LoanRequestItem> _loanRequests = [];
  LoanRequestItem? _selectedLoanRequest;
  LoanAuthResponse? _loanAuthDetails;
  List<LoanTypeItem> _loanTypes = [];
  List<LoanRequestItem> get loanRequests => _loanRequests;
  LoanRequestItem? get selectedLoanRequest => _selectedLoanRequest;
  LoanAuthResponse? get loanAuthDetails => _loanAuthDetails;
  List<LoanTypeItem> get loanTypes => _loanTypes;

  List<ResignationRequestItem> _resignationRequests = [];
  ResignationRequestItem? _selectedResignationRequest;
  ResignationAuthResponse? _resignationAuthDetails;
  List<ResignationRequestItem> get resignationRequests => _resignationRequests;
  ResignationRequestItem? get selectedResignationRequest => _selectedResignationRequest;
  ResignationAuthResponse? get resignationAuthDetails => _resignationAuthDetails;

  // ---===< 2. حالة "طلباتي" >===---
  List<MyVacationRequestItem> _myVacationRequests = [];
  MyVacationRequestItem? _selectedMyVacationRequest;
  VacationAuthResponse? _myVacationAuthDetails;
  List<MyVacationRequestItem> get myVacationRequests => _myVacationRequests;
  MyVacationRequestItem? get selectedMyVacationRequest => _selectedMyVacationRequest;
  VacationAuthResponse? get myVacationAuthDetails => _myVacationAuthDetails;

  List<MyLoanRequestItem> _myLoanRequests = [];
  MyLoanRequestItem? _selectedMyLoanRequest;
  LoanAuthResponse? _myLoanAuthDetails;
  List<MyLoanRequestItem> get myLoanRequests => _myLoanRequests;
  MyLoanRequestItem? get selectedMyLoanRequest => _selectedMyLoanRequest;
  LoanAuthResponse? get myLoanAuthDetails => _myLoanAuthDetails;

  List<MyResignationRequestItem> _myResignationRequests = [];
  MyResignationRequestItem? _selectedMyResignationRequest;
  ResignationAuthResponse? _myResignationAuthDetails;
  List<MyResignationRequestItem> get myResignationRequests => _myResignationRequests;
  MyResignationRequestItem? get selectedMyResignationRequest => _selectedMyResignationRequest;
  ResignationAuthResponse? get myResignationAuthDetails => _myResignationAuthDetails;

  // ---== متغيرات مباشرة العمل (جديدة) ==---
  List<ResumeWorkRequestItem> _resumeWorkRequests = [];
  ResumeWorkRequestItem? _selectedResumeWorkRequest;
  ResumeWorkAuthResponse? _resumeWorkAuthDetails;
  List<MyResumeWorkRequestItem> _myResumeWorkRequests = [];
  MyResumeWorkRequestItem? _selectedMyResumeWorkRequest;
  ResumeWorkAuthResponse? _myResumeWorkAuthDetails;

  // ---== متغيرات نقل موظف (جديدة) ==---
  List<EmployeeTransferRequestItem> _employeeTransferRequests = [];
  EmployeeTransferRequestItem? _selectedEmployeeTransferRequest;
  EmployeeTransferAuthResponse? _employeeTransferAuthDetails;
  List<MyEmployeeTransferRequestItem> _myEmployeeTransferRequests = [];
  MyEmployeeTransferRequestItem? _selectedMyEmployeeTransferRequest;
  EmployeeTransferAuthResponse? _myEmployeeTransferAuthDetails;


  // ---== متغيرات تثبيت راتب (جديدة) ==---
  List<SalaryConfirmationRequestItem> _salaryConfirmationRequests = [];
  SalaryConfirmationRequestItem? _selectedSalaryConfirmationRequest;
  SalaryConfirmationAuthResponse? _salaryConfirmationAuthDetails;
  List<MySalaryConfirmationRequestItem> _mySalaryConfirmationRequests = [];
  MySalaryConfirmationRequestItem? _selectedMySalaryConfirmationRequest;
  SalaryConfirmationAuthResponse? _mySalaryConfirmationAuthDetails;

  // ---== متغيرات إلغاء تثبيت راتب (جديدة) ==---
  List<CancelSalaryConfirmationRequestItem> _cancelSalaryConfirmationRequests = [];
  CancelSalaryConfirmationRequestItem? _selectedCancelSalaryConfirmationRequest;
  CancelSalaryConfirmationAuthResponse? _cancelSalaryConfirmationAuthDetails;
  List<MyCancelSalaryConfirmationRequestItem> _myCancelSalaryConfirmationRequests = [];
  MyCancelSalaryConfirmationRequestItem? _selectedMyCancelSalaryConfirmationRequest;
  CancelSalaryConfirmationAuthResponse? _myCancelSalaryConfirmationAuthDetails;


  // ---== Getters مباشرة العمل (جديدة) ==---
  List<ResumeWorkRequestItem> get resumeWorkRequests => _resumeWorkRequests;
  ResumeWorkRequestItem? get selectedResumeWorkRequest => _selectedResumeWorkRequest;
  ResumeWorkAuthResponse? get resumeWorkAuthDetails => _resumeWorkAuthDetails;
  List<MyResumeWorkRequestItem> get myResumeWorkRequests => _myResumeWorkRequests;
  MyResumeWorkRequestItem? get selectedMyResumeWorkRequest => _selectedMyResumeWorkRequest;
  ResumeWorkAuthResponse? get myResumeWorkAuthDetails => _myResumeWorkAuthDetails;




  // ---== Getters نقل موظف (جديدة) ==---
  List<EmployeeTransferRequestItem> get employeeTransferRequests => _employeeTransferRequests;
  EmployeeTransferRequestItem? get selectedEmployeeTransferRequest => _selectedEmployeeTransferRequest;
  EmployeeTransferAuthResponse? get employeeTransferAuthDetails => _employeeTransferAuthDetails;
  List<MyEmployeeTransferRequestItem> get myEmployeeTransferRequests => _myEmployeeTransferRequests;
  MyEmployeeTransferRequestItem? get selectedMyEmployeeTransferRequest => _selectedMyEmployeeTransferRequest;
  EmployeeTransferAuthResponse? get myEmployeeTransferAuthDetails => _myEmployeeTransferAuthDetails;

  // ---== متغيرات تحريك سيارة (جديدة) ==---
  List<CarMovementRequestItem> _carMovementRequests = [];
  CarMovementRequestItem? _selectedCarMovementRequest;
  CarMovementAuthResponse? _carMovementAuthDetails;
  List<MyCarMovementRequestItem> _myCarMovementRequests = [];
  MyCarMovementRequestItem? _selectedMyCarMovementRequest;
  CarMovementAuthResponse? _myCarMovementAuthDetails;


//---== متغيرات جديدة للـ Dropdowns ==---
  List<CompanyItem> _companies = [];
  List<DepartmentItem> _departments = [];

  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _handleError(String? errorMsg) {
    _error = errorMsg;
    notifyListeners();
  }

// ---== دوال تحديد نقل موظف (جديدة) ==---
  void selectEmployeeTransferRequest(EmployeeTransferRequestItem request) {
    _selectedEmployeeTransferRequest = request;
    _employeeTransferAuthDetails = null;
    notifyListeners();
  }

  void selectMyEmployeeTransferRequest(MyEmployeeTransferRequestItem request) {
    _selectedMyEmployeeTransferRequest = request;
    _myEmployeeTransferAuthDetails = null;
    notifyListeners();
  }

  // ---== Getters تحريك سيارة (جديدة) ==---
  List<CarMovementRequestItem> get carMovementRequests => _carMovementRequests;
  CarMovementRequestItem? get selectedCarMovementRequest => _selectedCarMovementRequest;
  CarMovementAuthResponse? get carMovementAuthDetails => _carMovementAuthDetails;
  List<MyCarMovementRequestItem> get myCarMovementRequests => _myCarMovementRequests;
  MyCarMovementRequestItem? get selectedMyCarMovementRequest => _selectedMyCarMovementRequest;
  CarMovementAuthResponse? get myCarMovementAuthDetails => _myCarMovementAuthDetails;

  // ---== Getters تثبيت راتب (جديدة) ==---
  List<SalaryConfirmationRequestItem> get salaryConfirmationRequests => _salaryConfirmationRequests;
  SalaryConfirmationRequestItem? get selectedSalaryConfirmationRequest => _selectedSalaryConfirmationRequest;
  SalaryConfirmationAuthResponse? get salaryConfirmationAuthDetails => _salaryConfirmationAuthDetails;
  List<MySalaryConfirmationRequestItem> get mySalaryConfirmationRequests => _mySalaryConfirmationRequests;
  MySalaryConfirmationRequestItem? get selectedMySalaryConfirmationRequest => _selectedMySalaryConfirmationRequest;
  SalaryConfirmationAuthResponse? get mySalaryConfirmationAuthDetails => _mySalaryConfirmationAuthDetails;


  // ---== Getters إلغاء تثبيت راتب (جديدة) ==---
  List<CancelSalaryConfirmationRequestItem> get cancelSalaryConfirmationRequests => _cancelSalaryConfirmationRequests;
  CancelSalaryConfirmationRequestItem? get selectedCancelSalaryConfirmationRequest => _selectedCancelSalaryConfirmationRequest;
  CancelSalaryConfirmationAuthResponse? get cancelSalaryConfirmationAuthDetails => _cancelSalaryConfirmationAuthDetails;
  List<MyCancelSalaryConfirmationRequestItem> get myCancelSalaryConfirmationRequests => _myCancelSalaryConfirmationRequests;
  MyCancelSalaryConfirmationRequestItem? get selectedMyCancelSalaryConfirmationRequest => _selectedMyCancelSalaryConfirmationRequest;
  CancelSalaryConfirmationAuthResponse? get myCancelSalaryConfirmationAuthDetails => _myCancelSalaryConfirmationAuthDetails;


  // --== حالة إنشاء طلب جديد ==--
  bool _isCreatingRequest = false;
  bool get isCreatingRequest => _isCreatingRequest;


  // ---== دوال تحديد تحريك سيارة (جديدة) ==---
  void selectCarMovementRequest(CarMovementRequestItem request) {
    _selectedCarMovementRequest = request;
    _carMovementAuthDetails = null;
    notifyListeners();
  }

  void selectMyCarMovementRequest(MyCarMovementRequestItem request) {
    _selectedMyCarMovementRequest = request;
    _myCarMovementAuthDetails = null;
    notifyListeners();
  }

  // ---== دوال تحديد تثبيت راتب (جديدة) ==---
  void selectSalaryConfirmationRequest(SalaryConfirmationRequestItem request) {
    _selectedSalaryConfirmationRequest = request;
    _salaryConfirmationAuthDetails = null;
    notifyListeners();
  }

  void selectMySalaryConfirmationRequest(MySalaryConfirmationRequestItem request) {
    _selectedMySalaryConfirmationRequest = request;
    _mySalaryConfirmationAuthDetails = null;
    notifyListeners();
  }

  // ---== دوال تحديد إلغاء تثبيت راتب (جديدة) ==---
  void selectCancelSalaryConfirmationRequest(CancelSalaryConfirmationRequestItem request) {
    _selectedCancelSalaryConfirmationRequest = request;
    _cancelSalaryConfirmationAuthDetails = null;
    notifyListeners();
  }

  void selectMyCancelSalaryConfirmationRequest(MyCancelSalaryConfirmationRequestItem request) {
    _selectedMyCancelSalaryConfirmationRequest = request;
    _myCancelSalaryConfirmationAuthDetails = null;
    notifyListeners();
  }

// ---===< دوال إنشاء الطلبات الجديدة (POST) >===---

  Future<bool> createNewVacationRequest({
    required int empCode,
    required int userCode,
    required int vacationType,
    required DateTime startDate,
    required DateTime endDate,
    required int period,
    required String notes,
    required int compEmpCode,
  }) async {
    return _createRequest(
      requestType: 'vacation',
      empCode: empCode,
      usersCode: userCode,
      bodyBuilder: (nextSerial) => {
        "CompEmpCode": compEmpCode, "EmpCode": empCode, "TrnsType": vacationType,
        "StartDt": DateFormat('yyyy-MM-dd').format(startDate),
        "EndDt": DateFormat('yyyy-MM-dd').format(endDate),
        "Period": period, "TrnsDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "Notes": notes, "AgreeFlag": 0, "SerialPyv": nextSerial,
        "AltKey": "$empCode-$nextSerial","InsertUser":userCode
      },
      endpoint: ApiConstants.createVacationRequestEndpoint,
    );
  }

  Future<bool> createNewLoanRequest({
    required int empCode,
    required int userCode,
    required int loanType,
    required DateTime startDate,
    required int installmentsCount,
    required double totalValue,
    required double installmentValue,
    required String notes,
    required int compEmpCode,
  }) async {
    return _createRequest(
      requestType: 'loan',
      usersCode: userCode,
      empCode: empCode,
      bodyBuilder: (nextSerial) => {
        "EmpCode": empCode, "CompEmpCode": compEmpCode, "LoanType": loanType,
        "LoanStartDate": DateFormat('yyyy-MM-dd').format(startDate),
        "LoanNos": installmentsCount, "LoanValuePys": totalValue, "LoanInstlPys": installmentValue,
        "ReqLoanDate": DateTime.now().toIso8601String(),
        "DescA": notes, "AuthFlag": null, "ReqSerial": nextSerial,
        "AltKey": "$empCode-$nextSerial","InsertUser":userCode
      },
      endpoint: ApiConstants.createLoanRequestEndpoint,
    );
  }

  Future<bool> createNewResignationRequest({
    required int empCode,
    required int usersCode,
    required DateTime endDate,
    required DateTime lastWorkDate,
    required String reasons,
    required int compEmpCode,
  }) async {
    return _createRequest(
      requestType: 'resignation',
      empCode: empCode,
      usersCode: usersCode,
      bodyBuilder: (nextSerial) => {
        "EmpCode": empCode, "CompEmpCode": compEmpCode,
        "LastWorkDt": DateFormat('yyyy-MM-dd').format(lastWorkDate),
        "EndDate": DateFormat('yyyy-MM-dd').format(endDate),
        "TrnsDate": DateTime.now().toIso8601String(),
        "EndReasons": reasons, "AproveFlag": 0, "Serial": nextSerial,
        "AltKey": "$empCode-$nextSerial","InsertUser":usersCode
      },
      endpoint: ApiConstants.createResignationRequestEndpoint,
    );
  }

  // ---===< دوال مساعدة ومنطق عام >===---

  Future<bool> _createRequest({
    required String requestType,
    required int usersCode,
    required int empCode,

    required Map<String, dynamic> Function(int) bodyBuilder,
    required String endpoint,
  }) async {
    _isCreatingRequest = true;
    _error = null;
    notifyListeners();

    try {
      final nextSerial = await _fetchNextSerial(usersCode, requestType);
      final requestBody = bodyBuilder(nextSerial);

      debugPrint("--- Creating New Request ($requestType) ---");
      debugPrint("Endpoint: $endpoint");
      debugPrint("Body: ${json.encode(requestBody)}");

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}$endpoint"),
        headers: {"Content-Type": "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) { // 201 Created
        return true;
      } else {
        throw _handleApiError('createRequest ($requestType)', response);
      }
    } catch (e) {
      _error = e.toString().replaceFirst("Exception: ", "");
      debugPrint("Error in _createRequest: $_error");
      return false;
    } finally {
      _isCreatingRequest = false;
      notifyListeners();
    }
  }

  Future<int> _fetchNextSerial(int userCode, String type) async {

    final url = "${ApiConstants.baseUrl}${ApiConstants.userTransactionsInfoEndpoint}?q=UsersCode=$userCode";
    print('URL is $url');
    final data = await _dataFetchService.fetchDataFromUrl(url);
    if (data == null || data['items'] == null || (data['items'] as List).isEmpty) {
      throw Exception("لم يتم العثور على معلومات الأرقام التسلسلية للمستخدم.");
    }

    final info = UserTransactionInfoItem.fromJson(data['items'][0]);
    int? lastSerial;
    switch (type) {
      case 'vacation': lastSerial = info.lastVcncSeq; break;
      case 'loan': lastSerial = info.lastLoanSeq; break;
      case 'resignation': lastSerial = info.lastEndsrvSeq; break;
      case 'permission': lastSerial = info.lastPrmSeq; break;
      case 'resumeWork': lastSerial = info.lastVcncRetSeq; break;
      case 'employeeTransfer':lastSerial=info.lASTMOVESSEQ; break;
      case 'carMovement':lastSerial=info.lastCarSeq;break;
      case 'salaryConfirmation':lastSerial=info.lastFixSeq;break;
      case 'salaryUnConfirmation':lastSerial=info.lastUnFixSeq;break;
      default: throw Exception("نوع طلب غير معروف لجلب الرقم التسلسلي.");
    }
    if (lastSerial == null) throw Exception("الرقم التسلسلي الأخير ($type) غير موجود.");
    return lastSerial;
  }

  Exception _handleApiError(String functionName, http.Response response) {
    String responseBody = utf8.decode(response.bodyBytes);
    debugPrint("--- API Error in $functionName [${response.statusCode}] ---\n$responseBody");
    String serverErrorMsg = "فشل الإجراء.";
    try {
      final errorData = json.decode(responseBody);
      serverErrorMsg = errorData["title"] ?? errorData["detail"] ?? errorData["o:errorDetails"]?[0]?["detail"] ?? serverErrorMsg;
    } catch (e) {
      if(responseBody.isNotEmpty) serverErrorMsg = responseBody;
    }
    return Exception("خطأ ${response.statusCode}: $serverErrorMsg");
  }

  // دوال تحميل القوائم والاعتمادات ودوال المساعدة الأخرى تبقى كما هي من الردود السابقة
  // ...


  // ---===< 3. دوال تحميل البيانات >===---

  // -- دوال تحميل قوائم الموافقات --
  Future<void> loadVacationRequests(int usersCode) async {
    _isLoading = true; _error = null;
    notifyListeners();
    try {
      final url = "${ApiConstants.baseUrl}${ApiConstants.vacationRequestsEndpoint}?q=UsersCode=$usersCode";
      final data = await _dataFetchService.fetchDataFromUrl(url);
      _vacationRequests = VacationRequestList.fromJson(data!).items;
    } catch (e) {
      _error = "خطأ تحميل طلبات الإجازة: ${e.toString()}";
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  Future<void> loadLoanRequests(int usersCode) async {
    _isLoading = true; _error = null;
    notifyListeners();
    try {
      if (_loanTypes.isEmpty) { await _fetchLoanTypes(); }
      final url = "${ApiConstants.baseUrl}${ApiConstants.loanRequestsEndpoint}?q=UsersCode=$usersCode";
      final data = await _dataFetchService.fetchDataFromUrl(url);
      _loanRequests = LoanRequestList.fromJson(data!).items;
    } catch (e) {
      _error = "خطأ تحميل طلبات السلف: ${e.toString()}";
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  Future<void> loadResignationRequests(int usersCode) async {
    _isLoading = true; _error = null;
    notifyListeners();
    try {
      final url = "${ApiConstants.baseUrl}${ApiConstants.resignationRequestsEndpoint}?q=UsersCode=$usersCode";
      final data = await _dataFetchService.fetchDataFromUrl(url);
      _resignationRequests = ResignationRequestList.fromJson(data!).items;
    } catch (e) {
      _error = "خطأ تحميل طلبات الاستقالة: ${e.toString()}";
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  // -- دوال تحميل قوائم "طلباتي" --
  Future<void> loadMyVacationRequests(int empCode) async {
    await _loadData<MyVacationRequestList>(
      url: "${ApiConstants.baseUrl}${ApiConstants.myVacationRequestsEndpoint}?q=EmpCode=$empCode",
      onSuccess: (data) => _myVacationRequests = data.items,
      onError: (e) => _error = "خطأ تحميل طلبات الإجازة: $e",
    );
    print('Length Data is ${_myVacationRequests.length}');
    print('Value Data is ${_myVacationRequests.length}');
    print('Url is ${ApiConstants.baseUrl+ApiConstants.myVacationRequestsEndpoint}?q=EmpCode=$empCode}');
  }

  Future<void> loadMyLoanRequests(int empCode) async {
    if (_loanTypes.isEmpty) await _fetchLoanTypes();
    await _loadData<MyLoanRequestList>(
      url: "${ApiConstants.baseUrl}${ApiConstants.myLoanRequestsEndpoint}?q=EmpCode=$empCode",
      onSuccess: (data) => _myLoanRequests = data.items,
      onError: (e) => _error = "خطأ تحميل طلبات السلف: $e",
    );
  }

  Future<void> loadMyResignationRequests(int empCode) async {
    await _loadData<MyResignationRequestList>(
      url: "${ApiConstants.baseUrl}${ApiConstants.myResignationRequestsEndpoint}?q=EmpCode=$empCode",
      onSuccess: (data) => _myResignationRequests = data.items,
      onError: (e) => _error = "خطأ تحميل طلبات الاستقالة: $e",
    );
  }

  // دالة عامة لتحميل القوائم
  Future<void> _loadData<T>(
      {required String url, required Function(T) onSuccess, required Function(dynamic) onError}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if(data == null) throw Exception("No data received from the server.");

      // التحويل من json بناءً على النوع T
      if (T == VacationRequestList) onSuccess(VacationRequestList.fromJson(data) as T);
      else if (T == LoanRequestList) onSuccess(LoanRequestList.fromJson(data) as T);
      else if (T == ResignationRequestList) onSuccess(ResignationRequestList.fromJson(data) as T);
      else if (T == MyVacationRequestList) onSuccess(MyVacationRequestList.fromJson(data) as T);
      else if (T == MyLoanRequestList) onSuccess(MyLoanRequestList.fromJson(data) as T);
      else if (T == MyResignationRequestList) onSuccess(MyResignationRequestList.fromJson(data) as T);
      else throw Exception("Unknown data type for parsing: $T");

    } catch (e) {
      onError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---===< 4. دوال تحميل تفاصيل الاعتمادات >===---

  void selectVacationRequest(VacationRequestItem request) { _selectedVacationRequest = request; _vacationAuthDetails = null; notifyListeners(); }
  void selectLoanRequest(LoanRequestItem request) { _selectedLoanRequest = request; _loanAuthDetails = null; notifyListeners(); }
  void selectResignationRequest(ResignationRequestItem request) { _selectedResignationRequest = request; _resignationAuthDetails = null; notifyListeners(); }

  void selectMyVacationRequest(MyVacationRequestItem request) { _selectedMyVacationRequest = request; _myVacationAuthDetails = null; notifyListeners(); }
  void selectMyLoanRequest(MyLoanRequestItem request) { _selectedMyLoanRequest = request; _myLoanAuthDetails = null; notifyListeners(); }
  void selectMyResignationRequest(MyResignationRequestItem request) { _selectedMyResignationRequest = request; _myResignationAuthDetails = null; notifyListeners(); }

  Future<void> loadVacationAuthDetails() async {
    final url = _selectedVacationRequest?.getLink('PyOrderVcncHAuthVO');
    if (url == null) return;
    await _loadAuthDetails<VacationAuthResponse>(url: url, onSuccess: (data) => _vacationAuthDetails = data, fromJson: (json) => VacationAuthResponse.fromJson(json));
  }

  Future<void> loadLoanAuthDetails() async {
    final url = _selectedLoanRequest?.getLink('PyPrsnlLoanReqAuthVO');
    if (url == null) return;
    await _loadAuthDetails<LoanAuthResponse>(url: url, onSuccess: (data) => _loanAuthDetails = data, fromJson: (json) => LoanAuthResponse.fromJson(json));
  }

  Future<void> loadResignationAuthDetails() async {
    final url = _selectedResignationRequest?.getLink('PyEndsrvOrderHAuthVO');
    if (url == null) return;
    await _loadAuthDetails<ResignationAuthResponse>(url: url, onSuccess: (data) => _resignationAuthDetails = data, fromJson: (json) => ResignationAuthResponse.fromJson(json));
  }

  Future<void> loadMyVacationAuthDetails() async {
    final url = _selectedMyVacationRequest?.getLink('PyOrderVcncHAuthVO');
    if (url == null) return;
    await _loadAuthDetails<VacationAuthResponse>(url: url, onSuccess: (data) => _myVacationAuthDetails = data, fromJson: (json) => VacationAuthResponse.fromJson(json));
  }

  Future<void> loadMyLoanAuthDetails() async {
    final url = _selectedMyLoanRequest?.getLink('PyPrsnlLoanReqAuthVO');
    if (url == null) return;
    await _loadAuthDetails<LoanAuthResponse>(url: url, onSuccess: (data) => _myLoanAuthDetails = data, fromJson: (json) => LoanAuthResponse.fromJson(json));
  }

  Future<void> loadMyResignationAuthDetails() async {
    final url = _selectedMyResignationRequest?.getLink('PyEndsrvOrderHAuthVO');
    if (url == null) return;
    await _loadAuthDetails<ResignationAuthResponse>(url: url, onSuccess: (data) => _myResignationAuthDetails = data, fromJson: (json) => ResignationAuthResponse.fromJson(json));
  }

  Future<void> _loadAuthDetails<T>({required String url, required Function(T) onSuccess, required T Function(Map<String, dynamic>) fromJson}) async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if(data == null) throw Exception("No auth details received.");
      onSuccess(fromJson(data));
    } catch (e) {
      _error = "خطأ تحميل الاعتمادات: $e";
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  // ---===< 5. دوال مساعدة ومنطق عام >===---

  Future<void> _fetchLoanTypes() async {
    try {
      final data = await _dataFetchService.fetchDataFromUrl("${ApiConstants.baseUrl}${ApiConstants.loanTypesEndpoint}");
      if(data != null) _loanTypes = LoanTypeList.fromJson(data).items;
    } catch (e) {
      debugPrint("Failed to load loan types: $e");
    }
  }

  String getLoanTypeName(int? typeCode,bool langType) {
    if (typeCode == null) return 'غير محدد';
    try {
      if(langType)
      return _loanTypes.firstWhere((type) => type.loanTypeCode == typeCode).nameA ?? 'غير معروف';
      else
        return _loanTypes.firstWhere((type) => type.loanTypeCode == typeCode).nameE ?? 'غير معروف';
    } catch (e) {
      return 'غير معروف ($typeCode)';
    }
  }

  // ---== Getters جديدة للـ Dropdowns ==---
  List<CompanyItem> get companies => _companies;
  List<DepartmentItem> get departments => _departments;

  String getVacationTypeName(int? typeCode) {
    switch (typeCode) {
      case 12: return 'سنوية';
      case 1: return 'عادية';
      case 2: return 'بدون مرتب';
      case 4: return 'مرضية';
      default: return 'غير معروف';
    }
  }

  String getRequestStatusName(int? flag) {
    switch (flag) {
      case 1: return 'معتمدة';
      case -1: return 'مرفوضة';
      case 0: return 'تحت الإجراء';
      default: return 'جديدة';
    }
  }

// ═══════════════════════════════════════════════════════════
// 🔧 Helper Function للـ Logging الاحترافي
// ضعها في أول الملف بعد الـ imports
// ═══════════════════════════════════════════════════════════
  void _logApiCall({
    required String operation,
    required String url,
    Map<String, dynamic>? requestBody,
    int? statusCode,
    String? responseBody,
    String? error,
  }) {
    debugPrint("\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    debugPrint("┃ 📡 API CALL: $operation");
    debugPrint("┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    debugPrint("┃ 🌐 URL: $url");

    if (requestBody != null) {
      debugPrint("┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      debugPrint("┃ 📤 REQUEST BODY:");
      debugPrint("┃ ${json.encode(requestBody)}");
    }

    if (statusCode != null) {
      final statusEmoji = (statusCode >= 200 && statusCode < 300) ? "✅" : "❌";
      debugPrint("┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      debugPrint("┃ $statusEmoji STATUS CODE: $statusCode");
    }

    if (responseBody != null) {
      debugPrint("┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      debugPrint("┃ 📥 RESPONSE BODY:");
      debugPrint("┃ $responseBody");
    }

    if (error != null) {
      debugPrint("┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      debugPrint("┃ ❌ ERROR:");
      debugPrint("┃ $error");
    }

    debugPrint("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
  }

// ═══════════════════════════════════════════════════════════
// 📦 الكود المعدل - استبدل به الكود القديم فقط
// ═══════════════════════════════════════════════════════════

  // ---== متغيرات جديدة للأذونات ==---
  List<PermissionRequestItem> _permissionRequests = [];
  PermissionRequestItem? _selectedPermissionRequest;
  PermissionAuthResponse? _permissionAuthDetails;

  List<MyPermissionRequestItem> _myPermissionRequests = [];
  MyPermissionRequestItem? _selectedMyPermissionRequest;
  PermissionAuthResponse? _myPermissionAuthDetails;

  // ... (كل الـ Getters الحالية)

  // ---== Getters جديدة للأذونات ==---
  List<PermissionRequestItem> get permissionRequests => _permissionRequests;
  PermissionRequestItem? get selectedPermissionRequest => _selectedPermissionRequest;
  PermissionAuthResponse? get permissionAuthDetails => _permissionAuthDetails;

  List<MyPermissionRequestItem> get myPermissionRequests => _myPermissionRequests;
  MyPermissionRequestItem? get selectedMyPermissionRequest => _selectedMyPermissionRequest;
  PermissionAuthResponse? get myPermissionAuthDetails => _myPermissionAuthDetails;


  // ---== دالة لتحديد الطلب (مثل الإجازات) ==---

  // ... (selectVacationRequest, selectLoanRequest, etc.)

  void selectPermissionRequest(PermissionRequestItem request) {
    _selectedPermissionRequest = request;
    _permissionAuthDetails = null;
    debugPrint("✅ Selected Permission Request: Serial=${request.serial}");
    notifyListeners();
  }

  void selectMyPermissionRequest(MyPermissionRequestItem request) {
    _selectedMyPermissionRequest = request;
    _myPermissionAuthDetails = null;
    debugPrint("✅ Selected My Permission Request: Serial=${request.serial}");
    notifyListeners();
  }

  // ---== دوال جلب البيانات (Fetch) ==---

  // ... (fetchVacationRequests, fetchLoanRequests, etc.)

  // ---== جلب طلبات الأذونات (للموافقة) ==---
  Future<void> fetchPermissionRequests(int usersCode) async {
    final String url = '${ApiConstants.baseUrl}${ApiConstants.permissionRequestsEndpoint}?q=UsersCode=$usersCode';

    _logApiCall(
      operation: "FETCH PERMISSION REQUESTS",
      url: url,
    );

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);

      if (data != null) {
        final permissionList = PermissionRequestList.fromJson(data);
        _permissionRequests = permissionList.items;

        _logApiCall(
          operation: "FETCH PERMISSION REQUESTS",
          url: url,
          statusCode: 200,
          responseBody: "✅ Successfully loaded ${_permissionRequests.length} permission requests",
        );
      } else {
        _permissionRequests = [];

        _logApiCall(
          operation: "FETCH PERMISSION REQUESTS",
          url: url,
          statusCode: 204,
          responseBody: "⚠️ No permission requests found (empty response)",
        );
      }
      _error = null;
    } catch (e, stackTrace) {
      _error = 'Failed to load permission requests: $e';
      _permissionRequests = [];

      _logApiCall(
        operation: "FETCH PERMISSION REQUESTS",
        url: url,
        error: "Exception: $e\n\n📍 Stack Trace:\n$stackTrace",
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---== جلب طلبات الأذونات (طلباتي) ==---
  Future<void> fetchMyPermissionRequests(int empCode) async {
    final String url = '${ApiConstants.baseUrl}${ApiConstants.myPermissionRequestsEndpoint}?q=EmpCode=$empCode&orderBy=Serial:desc';

    _logApiCall(
      operation: "FETCH MY PERMISSION REQUESTS",
      url: url,
    );

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);

      if (data != null) {
        final myPermissionList = MyPermissionRequestList.fromJson(data);
        _myPermissionRequests = myPermissionList.items;

        _logApiCall(
          operation: "FETCH MY PERMISSION REQUESTS",
          url: url,
          statusCode: 200,
          responseBody: "✅ Successfully loaded ${_myPermissionRequests.length} my permission requests",
        );
      } else {
        _myPermissionRequests = [];

        _logApiCall(
          operation: "FETCH MY PERMISSION REQUESTS",
          url: url,
          statusCode: 204,
          responseBody: "⚠️ No my permission requests found (empty response)",
        );
      }
      _error = null;
    } catch (e, stackTrace) {
      _error = 'Failed to load my permission requests: $e';
      _myPermissionRequests = [];

      _logApiCall(
        operation: "FETCH MY PERMISSION REQUESTS",
        url: url,
        error: "Exception: $e\n\n📍 Stack Trace:\n$stackTrace",
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---== دوال جلب تفاصيل الاعتماد ==---

  // ... (loadVacationAuthDetails, loadLoanAuthDetails, etc.)

  // ---== جلب اعتمادات طلب إذن (للموافقة) ==---
  Future<void> loadPermissionAuthDetails() async {
    if (_selectedPermissionRequest == null) {
      debugPrint("⚠️ loadPermissionAuthDetails: No permission request selected!");
      return;
    }

    final authLink = _selectedPermissionRequest!.links.firstWhere(
          (link) => link.rel == 'child' && link.name == 'PyOrderPrmHAuthVO',
      orElse: () => Link(rel: '', href: '', name: '', kind: ''),
    );

    if (authLink.href.isEmpty) {
      _error = "Auth link not found";
      debugPrint("❌ Auth link not found for selected permission request");
      notifyListeners();
      return;
    }

    final String url = authLink.href;

    _logApiCall(
      operation: "LOAD PERMISSION AUTH DETAILS",
      url: url,
    );

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);

      if (data != null) {
        _permissionAuthDetails = PermissionAuthResponse.fromJson(data);

        _logApiCall(
          operation: "LOAD PERMISSION AUTH DETAILS",
          url: url,
          statusCode: 200,
          responseBody: "✅ Successfully loaded permission auth details",
        );
      }
      _error = null;
    } catch (e, stackTrace) {
      _error = 'Failed to load permission auth details: $e';

      _logApiCall(
        operation: "LOAD PERMISSION AUTH DETAILS",
        url: url,
        error: "Exception: $e\n\n📍 Stack Trace:\n$stackTrace",
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---== جلب اعتمادات طلب إذن (طلباتي) ==---
  Future<void> loadMyPermissionAuthDetails() async {
    if (_selectedMyPermissionRequest == null) {
      debugPrint("⚠️ loadMyPermissionAuthDetails: No my permission request selected!");
      return;
    }

    final authLink = _selectedMyPermissionRequest!.links.firstWhere(
          (link) => link.rel == 'child' && link.name == 'PyOrderPrmHAuthVO',
      orElse: () => Link(rel: '', href: '', name: '', kind: ''),
    );

    if (authLink.href.isEmpty) {
      _error = "Auth link not found";
      debugPrint("❌ Auth link not found for selected my permission request");
      notifyListeners();
      return;
    }

    final String url = authLink.href;

    _logApiCall(
      operation: "LOAD MY PERMISSION AUTH DETAILS",
      url: url,
    );

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);

      if (data != null) {
        _myPermissionAuthDetails = PermissionAuthResponse.fromJson(data);

        _logApiCall(
          operation: "LOAD MY PERMISSION AUTH DETAILS",
          url: url,
          statusCode: 200,
          responseBody: "✅ Successfully loaded my permission auth details",
        );
      }
      _error = null;
    } catch (e, stackTrace) {
      _error = 'Failed to load my permission auth details: $e';

      _logApiCall(
        operation: "LOAD MY PERMISSION AUTH DETAILS",
        url: url,
        error: "Exception: $e\n\n📍 Stack Trace:\n$stackTrace",
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // ---== دوال إنشاء الطلبات (POST) ==---

  // ... (createVacationRequest, createLoanRequest, etc.)

  // ---== إنشاء طلب إذن جديد ==---
  Future<bool> createPermissionRequest({
    required int empCode,
    required int compEmpCode,
    required int insertUser,
    required int userCode,
    required int trnsType,
    required int reasonType,
    required DateTime prmDate,
    required DateTime fromTime,
    required DateTime toTime,
    required String permReasons,
    required String notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch next serial
      final nextSerial = await _fetchNextSerial(userCode, 'permission');

      String formatDateTime(DateTime dt) {
        return DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").format(dt);
      }
      String formatDate(DateTime dt) {
        return DateFormat("yyyy-MM-dd'T'00:00:00Z").format(dt);
      }

      final body = {
        "EmpCode": empCode,
        "CompEmpCode": compEmpCode,
        "TrnsDate": formatDateTime(DateTime.now()),
        "TrnsType": trnsType,
        "PrmDate": formatDate(prmDate),
        "FromTime": formatDateTime(fromTime),
        "ToTime": formatDateTime(toTime),
        "AproveFlag": 0,
        "ReasonType": reasonType,
        "PermReasons": permReasons,
        "Notes": notes,
        "Serial": nextSerial,
        "AltKey": "$empCode-$nextSerial",
        "InsertUser": insertUser,
      };

      final String url = ApiConstants.baseUrl + ApiConstants.createPermissionRequestEndpoint;

      _logApiCall(
        operation: "CREATE PERMISSION REQUEST",
        url: url,
        requestBody: body,
      );

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode(body),
      );

      final String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _error = null;

        _logApiCall(
          operation: "CREATE PERMISSION REQUEST",
          url: url,
          requestBody: body,
          statusCode: response.statusCode,
          responseBody: responseBody,
        );

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        String serverErrorMsg = "فشل إنشاء الطلب.";
        try {
          final errorData = json.decode(responseBody);
          serverErrorMsg = errorData["title"] ?? errorData["detail"] ?? serverErrorMsg;
        } catch (_) {
          debugPrint("⚠️ Could not parse error response as JSON");
        }

        _error = serverErrorMsg;

        _logApiCall(
          operation: "CREATE PERMISSION REQUEST",
          url: url,
          requestBody: body,
          statusCode: response.statusCode,
          responseBody: responseBody,
          error: "Server Error: $serverErrorMsg",
        );

        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e, stackTrace) {
      _error = 'Error creating permission request: $e';

      _logApiCall(
        operation: "CREATE PERMISSION REQUEST",
        url: ApiConstants.baseUrl + ApiConstants.createPermissionRequestEndpoint,
        error: "Exception: $e\n\n📍 Stack Trace:\n$stackTrace",
      );

      _isLoading = false;
      notifyListeners();
      return false;
    }
  }


  // دالة الإرسال تبقى كما هي...
  Future<bool> submitAction({
    required int usersCode,
    required String usersDesc,
    required int authFlag,
    required String authTableName,
    required String authPk1,
    required String authPk2,
    required List<dynamic> authChain,
    required int systemNumber,
    required int fileSerial,
  }) async {
    _isSubmittingAction = true;
    _actionError = null;
    notifyListeners();

    try {
      int lastPrevSer = 0;
      if (authChain.isNotEmpty) {
        lastPrevSer = authChain.last.prevSer ?? 0;
      }

      int calculatedPrevSer = (lastPrevSer == 0) ? 1 : int.parse("${lastPrevSer}1");
      final String authDate = DateTime.now().toIso8601String();

      final Map<String, dynamic> requestBody = {
        "AltKey": "$authTableName-$calculatedPrevSer-$authPk1-$authPk2",
        "AuthDate": authDate,
        "AuthFlag": authFlag,
        "AuthPk1": authPk1,
        "AuthPk2": authPk2,
        "AuthPk3": null,
        "AuthPk4": null,
        "AuthPk5": null,
        "AuthTableName": authTableName,
        "FileSerial": fileSerial,
        "PrevSer": calculatedPrevSer,
        "SystemNumber": systemNumber,
        "UsersCode": usersCode,
        "UsersDesc": usersDesc.isEmpty ? (authFlag == 1 ? "تم الاعتماد" : "تم الرفض") : usersDesc,
        "MobileAuth": 1,
      };

      final String url = ApiConstants.submitActionUrl;

      _logApiCall(
        operation: "SUBMIT ACTION",
        url: url,
        requestBody: requestBody,
      );

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode(requestBody),
      );

      final String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _logApiCall(
          operation: "SUBMIT ACTION",
          url: url,
          requestBody: requestBody,
          statusCode: response.statusCode,
          responseBody: responseBody,
        );

        return true;
      } else {
        String serverErrorMsg = "فشل الإجراء.";
        try {
          final errorData = json.decode(responseBody);
          serverErrorMsg = errorData["title"] ?? errorData["detail"] ?? serverErrorMsg;
        } catch (_) {
          debugPrint("⚠️ Could not parse error response as JSON");
        }

        _logApiCall(
          operation: "SUBMIT ACTION",
          url: url,
          requestBody: requestBody,
          statusCode: response.statusCode,
          responseBody: responseBody,
          error: "Server Error: $serverErrorMsg",
        );

        throw Exception("خطأ ${response.statusCode}: $serverErrorMsg");
      }
    } catch (e, stackTrace) {
      _actionError = e.toString().replaceFirst("Exception: ", "");

      _logApiCall(
        operation: "SUBMIT ACTION",
        url: ApiConstants.submitActionUrl,
        error: "Exception: $e\n\n📍 Stack Trace:\n$stackTrace",
      );

      return false;
    } finally {
      _isSubmittingAction = false;
      notifyListeners();
    }
  }

  // ---== دوال تحديد مباشرة العمل (جديدة) ==---
  void selectResumeWorkRequest(ResumeWorkRequestItem request) {
    _selectedResumeWorkRequest = request;
    _resumeWorkAuthDetails = null;
    notifyListeners();
  }

  void selectMyResumeWorkRequest(MyResumeWorkRequestItem request) {
    _selectedMyResumeWorkRequest = request;
    _myResumeWorkAuthDetails = null;
    notifyListeners();
  }


  // ---== دوال جلب مباشرة العمل (جديدة) ==---
  Future<void> fetchResumeWorkRequests(int usersCode) async {
    _setLoadingState(true);
    _handleError(null);
    final url = '${ApiConstants.baseUrl}${ApiConstants.resumeWorkRequestsEndpoint}?q=UsersCode=$usersCode&orderBy=SerialPyv:desc';
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final requestList = ResumeWorkRequestList.fromJson(data);
        _resumeWorkRequests = requestList.items.where((req) => req.aproveFlag == 0).toList();
        _logApiCall(operation: "Fetch Resume Work (Appr.)", url: url, statusCode: 200, responseBody: "Success: ${requestList.items.length} items");
      } else {
        _resumeWorkRequests = [];
        _logApiCall(operation: "Fetch Resume Work (Appr.)", url: url, statusCode: 200, responseBody: "No data");
      }
    } catch (e) {
      _logApiCall(operation: "Fetch Resume Work (Appr.)", url: url, error: e.toString());
      _handleError('Failed to load resume work requests: $e');
      _resumeWorkRequests = [];
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> fetchMyResumeWorkRequests(int empCode) async {
    _setLoadingState(true);
    _handleError(null);
    final url = '${ApiConstants.baseUrl}${ApiConstants.myResumeWorkRequestsEndpoint}?q=EmpCode=$empCode&orderBy=SerialPyv:desc';
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final myList = MyResumeWorkRequestList.fromJson(data);
        _myResumeWorkRequests = myList.items;
        _logApiCall(operation: "Fetch My Resume Work", url: url, statusCode: 200, responseBody: "Success: ${myList.items.length} items");
      } else {
        _myResumeWorkRequests = [];
        _logApiCall(operation: "Fetch My Resume Work", url: url, statusCode: 200, responseBody: "No data");
      }
    } catch (e) {
      _logApiCall(operation: "Fetch My Resume Work", url: url, error: e.toString());
      _handleError('Failed to load my resume work requests: $e');
      _myResumeWorkRequests = [];
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadResumeWorkAuthDetails() async {
    if (_selectedResumeWorkRequest == null) return;

    final authLink = _selectedResumeWorkRequest!.links.firstWhere(
            (link) => link.rel == 'child' && link.name == 'PyVcncRetHAuthVO',
        orElse: () => Link(rel: '', href: '', name: '', kind: ''));

    if (authLink.href.isEmpty) {
      _handleError("Auth link not found");
      _resumeWorkAuthDetails = ResumeWorkAuthResponse(items: []);
      return;
    }

    _setLoadingState(true);
    try {
      final data = await _dataFetchService.fetchDataFromUrl(authLink.href);
      if (data != null) {
        _resumeWorkAuthDetails = ResumeWorkAuthResponse.fromJson(data);
        _logApiCall(operation: "Load Resume Work Auth", url: authLink.href, statusCode: 200, responseBody: "Success: ${_resumeWorkAuthDetails?.items.length} items");
      } else {
        _resumeWorkAuthDetails = ResumeWorkAuthResponse(items: []);
        _logApiCall(operation: "Load Resume Work Auth", url: authLink.href, statusCode: 200, responseBody: "No data");
      }
      _handleError(null);
    } catch (e) {
      _logApiCall(operation: "Load Resume Work Auth", url: authLink.href, error: e.toString());
      _handleError('Failed to load resume work auth details: $e');
      _resumeWorkAuthDetails = ResumeWorkAuthResponse(items: []);
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadMyResumeWorkAuthDetails() async {
    if (_selectedMyResumeWorkRequest == null) return;

    final authLink = _selectedMyResumeWorkRequest!.links.firstWhere(
            (link) => link.rel == 'child' && link.name == 'PyVcncRetHAuthVO',
        orElse: () => Link(rel: '', href: '', name: '', kind: ''));

    if (authLink.href.isEmpty) {
      _handleError("Auth link not found");
      _myResumeWorkAuthDetails = ResumeWorkAuthResponse(items: []);
      return;
    }

    _setLoadingState(true);
    try {
      final data = await _dataFetchService.fetchDataFromUrl(authLink.href);
      if (data != null) {
        _myResumeWorkAuthDetails = ResumeWorkAuthResponse.fromJson(data);
        _logApiCall(operation: "Load My Resume Work Auth", url: authLink.href, statusCode: 200, responseBody: "Success: ${_myResumeWorkAuthDetails?.items.length} items");
      } else {
        _myResumeWorkAuthDetails = ResumeWorkAuthResponse(items: []);
        _logApiCall(operation: "Load My Resume Work Auth", url: authLink.href, statusCode: 200, responseBody: "No data");
      }
      _handleError(null);
    } catch (e) {
      _logApiCall(operation: "Load My Resume Work Auth", url: authLink.href, error: e.toString());
      _handleError('Failed to load my resume work auth details: $e');
      _myResumeWorkAuthDetails = ResumeWorkAuthResponse(items: []);
    } finally {
      _setLoadingState(false);
    }
  }

// ---== إنشاء طلب مباشرة عمل (جديد) ==---
  Future<bool> createResumeWorkRequest({
    required int empCode,
    required int userCode,
    required int compEmpCode,
    required int insertUser,
    required DateTime fDate,
    required DateTime tDate,
    required DateTime actTDate,
    required String? lateReason,
    required String notes,
    required int companyCode,
    required int dCode
  }) async {
    _setLoadingState(true);
    final String url = '${ApiConstants.baseUrl}${ApiConstants.createResumeWorkRequestEndpoint}';

    String formatDateWithTimezone(DateTime dt) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String y = dt.year.toString();
      String m = twoDigits(dt.month);
      String d = twoDigits(dt.day);
      return "$y-$m-${d}T00:00:00+03:00"; // As per API sample
    }
    // Fetch next serial
    final nextSerial = await _fetchNextSerial(userCode, 'resumeWork');

    // Calculation as requested
    final int actPeriod = actTDate.difference(fDate).inDays + 1;
    final body = {
      "EmpCode": empCode,
      "SerialPyv":nextSerial,
      "CompEmpCode": compEmpCode,
      "FDate": formatDateWithTimezone(fDate),
      "TDate": formatDateWithTimezone(tDate),
      "ActTDate": formatDateWithTimezone(actTDate),
      "ActPeriod": actPeriod,
      "LateReason": lateReason,
      "AproveFlag": 0,
      "InsertUser": insertUser,
      "CompanyCode": companyCode, // From sample
      "DCode": dCode, // From sample
      "Notes": notes,
      "AltKey": "$empCode-$nextSerial",
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode(body),
      );

      final String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _logApiCall(operation: "Create Resume Work", url: url, requestBody: body, statusCode: response.statusCode, responseBody: responseBody);
        await fetchMyResumeWorkRequests(empCode); // تحديث القائمة
        _setLoadingState(false);
        return true;
      } else {
        String serverErrorMsg = "فشل إنشاء الطلب.";
        try {
          final errorData = json.decode(responseBody);
          serverErrorMsg = errorData["title"] ?? errorData["detail"] ?? serverErrorMsg;
        } catch (_) {}
        _logApiCall(operation: "Create Resume Work", url: url, requestBody: body, statusCode: response.statusCode, responseBody: responseBody, error: serverErrorMsg);
        _handleError(serverErrorMsg);
        _setLoadingState(false);
        return false;
      }
    } catch (e) {
      _logApiCall(operation: "Create Resume Work", url: url, requestBody: body, error: e.toString());
      _handleError('Error creating resume work request: $e');
      _setLoadingState(false);
      return false;
    }
  }

  // ---== دوال جلب نقل موظف (جديدة) ==---
  Future<void> fetchEmployeeTransferRequests(int usersCode) async {
    _setLoadingState(true);
    _handleError(null);
    final url = '${ApiConstants.baseUrl}${ApiConstants.employeeTransferRequestsEndpoint}?q=UsersCode=$usersCode&orderBy=SerialPym:desc';
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final requestList = EmployeeTransferRequestList.fromJson(data);
        _employeeTransferRequests = requestList.items.where((req) => req.agreeFlag == 0).toList();
        _logApiCall(operation: "Fetch Employee Transfer (Appr.)", url: url, statusCode: 200, responseBody: "Success: ${requestList.items.length} items");
      } else {
        _employeeTransferRequests = [];
        _logApiCall(operation: "Fetch Employee Transfer (Appr.)", url: url, statusCode: 200, responseBody: "No data");
      }
    } catch (e) {
      _logApiCall(operation: "Fetch Employee Transfer (Appr.)", url: url, error: e.toString());
      _handleError('Failed to load employee transfer requests: $e');
      _employeeTransferRequests = [];
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> fetchMyEmployeeTransferRequests(int empCode) async {
    _setLoadingState(true);
    _handleError(null);
    final url = '${ApiConstants.baseUrl}${ApiConstants.myEmployeeTransferRequestsEndpoint}?q=EmpCode=$empCode&orderBy=SerialPym:desc';
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final myList = MyEmployeeTransferRequestList.fromJson(data);
        _myEmployeeTransferRequests = myList.items;
        _logApiCall(operation: "Fetch My Employee Transfer", url: url, statusCode: 200, responseBody: "Success: ${myList.items.length} items");
      } else {
        _myEmployeeTransferRequests = [];
        _logApiCall(operation: "Fetch My Employee Transfer", url: url, statusCode: 200, responseBody: "No data");
      }
    } catch (e) {
      _logApiCall(operation: "Fetch My Employee Transfer", url: url, error: e.toString());
      _handleError('Failed to load my employee transfer requests: $e');
      _myEmployeeTransferRequests = [];
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadEmployeeTransferAuthDetails() async {
    if (_selectedEmployeeTransferRequest == null) return;

    final authLink = _selectedEmployeeTransferRequest!.links.firstWhere(
            (link) => link.rel == 'child' && link.name == 'PyOrderMovesHAuthVO',
        orElse: () => Link(rel: '', href: '', name: '', kind: ''));

    if (authLink.href.isEmpty) {
      _handleError("Auth link not found");
      _employeeTransferAuthDetails = EmployeeTransferAuthResponse(items: []);
      return;
    }

    _setLoadingState(true);
    try {
      final data = await _dataFetchService.fetchDataFromUrl(authLink.href);
      if (data != null) {
        _employeeTransferAuthDetails = EmployeeTransferAuthResponse.fromJson(data);
        _logApiCall(operation: "Load Employee Transfer Auth", url: authLink.href, statusCode: 200, responseBody: "Success: ${_employeeTransferAuthDetails?.items.length} items");
      } else {
        _employeeTransferAuthDetails = EmployeeTransferAuthResponse(items: []);
        _logApiCall(operation: "Load Employee Transfer Auth", url: authLink.href, statusCode: 200, responseBody: "No data");
      }
      _handleError(null);
    } catch (e) {
      _logApiCall(operation: "Load Employee Transfer Auth", url: authLink.href, error: e.toString());
      _handleError('Failed to load employee transfer auth details: $e');
      _employeeTransferAuthDetails = EmployeeTransferAuthResponse(items: []);
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadMyEmployeeTransferAuthDetails() async {
    if (_selectedMyEmployeeTransferRequest == null) return;

    final authLink = _selectedMyEmployeeTransferRequest!.links.firstWhere(
            (link) => link.rel == 'child' && link.name == 'PyOrderMovesHAuthVO',
        orElse: () => Link(rel: '', href: '', name: '', kind: ''));

    if (authLink.href.isEmpty) {
      _handleError("Auth link not found");
      _myEmployeeTransferAuthDetails = EmployeeTransferAuthResponse(items: []);
      return;
    }

    _setLoadingState(true);
    try {
      final data = await _dataFetchService.fetchDataFromUrl(authLink.href);
      if (data != null) {
        _myEmployeeTransferAuthDetails = EmployeeTransferAuthResponse.fromJson(data);
        _logApiCall(operation: "Load My Employee Transfer Auth", url: authLink.href, statusCode: 200, responseBody: "Success: ${_myEmployeeTransferAuthDetails?.items.length} items");
      } else {
        _myEmployeeTransferAuthDetails = EmployeeTransferAuthResponse(items: []);
        _logApiCall(operation: "Load My Employee Transfer Auth", url: authLink.href, statusCode: 200, responseBody: "No data");
      }
      _handleError(null);
    } catch (e) {
      _logApiCall(operation: "Load My Employee Transfer Auth", url: authLink.href, error: e.toString());
      _handleError('Failed to load my employee transfer auth details: $e');
      _myEmployeeTransferAuthDetails = EmployeeTransferAuthResponse(items: []);
    } finally {
      _setLoadingState(false);
    }
  }

  // ---== دوال جديدة خاصة بالـ Dropdowns ==---
  Future<void> fetchCompanies() async {
    _setLoadingState(true);
    _handleError(null);
    final url = '${ApiConstants.baseUrl}${ApiConstants.companiesEndpoint}';
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final list = CompanyList.fromJson(data);
        _companies = list.items;
        _logApiCall(operation: "Fetch Companies", url: url, statusCode: 200, responseBody: "Success: ${list.items.length} items");
      } else {
        _companies = [];
        _logApiCall(operation: "Fetch Companies", url: url, statusCode: 200, responseBody: "No data");
      }
    } catch (e) {
      _logApiCall(operation: "Fetch Companies", url: url, error: e.toString());
      _handleError('Failed to load companies: $e');
      _companies = [];
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> fetchDepartments(int companyCode) async {
    _setLoadingState(true); // Maybe use a specific loader later
    _handleError(null);
    final url = '${ApiConstants.baseUrl}${ApiConstants.departmentsEndpoint}?q=CompanyCode=$companyCode';
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final list = DepartmentList.fromJson(data);
        _departments = list.items;
        _logApiCall(operation: "Fetch Departments", url: url, statusCode: 200, responseBody: "Success: ${list.items.length} items");
      } else {
        _departments = [];
        _logApiCall(operation: "Fetch Departments", url: url, statusCode: 200, responseBody: "No data");
      }
    } catch (e) {
      _logApiCall(operation: "Fetch Departments", url: url, error: e.toString());
      _handleError('Failed to load departments: $e');
      _departments = [];
    } finally {
      _setLoadingState(false);
    }
  }

  void clearDepartments() {
    _departments = [];
    notifyListeners();
  }


  // ---== إنشاء طلب نقل موظف (جديد) ==---
  Future<bool> createEmployeeTransferRequest({
    required int empCode,
    required int userCode,
    required int insertUser,
    required int companyCodeNew,
    required int dCodeNew,
    required int compEmpCodeNew,
    required DateTime movingDate,
    required String? movingNote,
    required String? movingNoteE,
  }) async {
    _setLoadingState(true);
    final String url = '${ApiConstants.baseUrl}${ApiConstants.createEmployeeTransferRequestEndpoint}';

    // (أنا أضفت `userCode` هنا عشان `_fetchNextSerial` يشتغل زي ما حضرتك عامل)
    final nextSerial = await _fetchNextSerial(userCode, 'employeeTransfer');
    String formatDateWithTimezone(DateTime dt) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String y = dt.year.toString();
      String m = twoDigits(dt.month);
      String d = twoDigits(dt.day);
      return "$y-$m-${d}T00:00:00+03:00"; // As per API sample
    }

    final body = {
      "EmpCode": empCode,
      "SerialPym":nextSerial,
      "CompanyCodeNew": companyCodeNew,
      "DCodeNew": dCodeNew,
      "CompEmpCodeNew": compEmpCodeNew,
      "MovingDate": formatDateWithTimezone(movingDate),
      "MovingNote": movingNote,
      "MovingNoteE": movingNoteE,
      "AgreeFlag": 0, // Key change
      "InsertUser": insertUser,
      // Month & Year are handled by backend
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode(body),
      );

      final String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _logApiCall(operation: "Create Employee Transfer", url: url, requestBody: body, statusCode: response.statusCode, responseBody: responseBody);
        await fetchMyEmployeeTransferRequests(empCode); // تحديث القائمة
        _setLoadingState(false);
        return true;
      } else {
        String serverErrorMsg = "فشل إنشاء الطلب.";
        try {
          final errorData = json.decode(responseBody);
          serverErrorMsg = errorData["title"] ?? errorData["detail"] ?? serverErrorMsg;
        } catch (_) {}
        _logApiCall(operation: "Create Employee Transfer", url: url, requestBody: body, statusCode: response.statusCode, responseBody: responseBody, error: serverErrorMsg);
        _handleError(serverErrorMsg);
        _setLoadingState(false);
        return false;
      }
    } catch (e) {
      _logApiCall(operation: "Create Employee Transfer", url: url, requestBody: body, error: e.toString());
      _handleError('Error creating employee transfer request: $e');
      _setLoadingState(false);
      return false;
    }
  }

  // ---== دوال جلب تحريك سيارة (جديدة) ==---
  Future<void> fetchCarMovementRequests(int usersCode) async {
    _setLoadingState(true);
    _handleError(null);
    final url = '${ApiConstants.baseUrl}${ApiConstants.carMovementRequestsEndpoint}?q=UsersCode=$usersCode&orderBy=Serial:desc';
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final requestList = CarMovementRequestList.fromJson(data);
        _carMovementRequests = requestList.items.where((req) => req.aproveFlag == 0).toList();
        _logApiCall(operation: "Fetch Car Movement (Appr.)", url: url, statusCode: 200, responseBody: "Success: ${requestList.items.length} items");
      } else {
        _carMovementRequests = [];
        _logApiCall(operation: "Fetch Car Movement (Appr.)", url: url, statusCode: 200, responseBody: "No data");
      }
    } catch (e) {
      _logApiCall(operation: "Fetch Car Movement (Appr.)", url: url, error: e.toString());
      _handleError('Failed to load car movement requests: $e');
      _carMovementRequests = [];
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> fetchMyCarMovementRequests(int empCode) async {
    _setLoadingState(true);
    _handleError(null);
    final url = '${ApiConstants.baseUrl}${ApiConstants.myCarMovementRequestsEndpoint}?q=EmpCode=$empCode&orderBy=Serial:desc';
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final myList = MyCarMovementRequestList.fromJson(data);
        _myCarMovementRequests = myList.items;
        _logApiCall(operation: "Fetch My Car Movement", url: url, statusCode: 200, responseBody: "Success: ${myList.items.length} items");
      } else {
        _myCarMovementRequests = [];
        _logApiCall(operation: "Fetch My Car Movement", url: url, statusCode: 200, responseBody: "No data");
      }
    } catch (e) {
      _logApiCall(operation: "Fetch My Car Movement", url: url, error: e.toString());
      _handleError('Failed to load my car movement requests: $e');
      _myCarMovementRequests = [];
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadCarMovementAuthDetails() async {
    if (_selectedCarMovementRequest == null) return;

    final authLink = _selectedCarMovementRequest!.links.firstWhere(
            (link) => link.rel == 'child' && link.name == 'PyOrderCarHAuthVRO',
        orElse: () => Link(rel: '', href: '', name: '', kind: ''));

    if (authLink.href.isEmpty) {
      _handleError("Auth link not found");
      _carMovementAuthDetails = CarMovementAuthResponse(items: []);
      return;
    }

    _setLoadingState(true);
    try {
      final data = await _dataFetchService.fetchDataFromUrl(authLink.href);
      if (data != null) {
        _carMovementAuthDetails = CarMovementAuthResponse.fromJson(data);
        _logApiCall(operation: "Load Car Movement Auth", url: authLink.href, statusCode: 200, responseBody: "Success: ${_carMovementAuthDetails?.items.length} items");
      } else {
        _carMovementAuthDetails = CarMovementAuthResponse(items: []);
        _logApiCall(operation: "Load Car Movement Auth", url: authLink.href, statusCode: 200, responseBody: "No data");
      }
      _handleError(null);
    } catch (e) {
      _logApiCall(operation: "Load Car Movement Auth", url: authLink.href, error: e.toString());
      _handleError('Failed to load car movement auth details: $e');
      _carMovementAuthDetails = CarMovementAuthResponse(items: []);
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadMyCarMovementAuthDetails() async {
    if (_selectedMyCarMovementRequest == null) return;

    final authLink = _selectedMyCarMovementRequest!.links.firstWhere(
            (link) => link.rel == 'child' && link.name == 'PyOrderCarHAuthVRO',
        orElse: () => Link(rel: '', href: '', name: '', kind: ''));

    if (authLink.href.isEmpty) {
      _handleError("Auth link not found");
      _myCarMovementAuthDetails = CarMovementAuthResponse(items: []);
      return;
    }

    _setLoadingState(true);
    try {
      final data = await _dataFetchService.fetchDataFromUrl(authLink.href);
      if (data != null) {
        _myCarMovementAuthDetails = CarMovementAuthResponse.fromJson(data);
        _logApiCall(operation: "Load My Car Movement Auth", url: authLink.href, statusCode: 200, responseBody: "Success: ${_myCarMovementAuthDetails?.items.length} items");
      } else {
        _myCarMovementAuthDetails = CarMovementAuthResponse(items: []);
        _logApiCall(operation: "Load My Car Movement Auth", url: authLink.href, statusCode: 200, responseBody: "No data");
      }
      _handleError(null);
    } catch (e) {
      _logApiCall(operation: "Load My Car Movement Auth", url: authLink.href, error: e.toString());
      _myCarMovementAuthDetails = CarMovementAuthResponse(items: []);
    } finally {
      _setLoadingState(false);
    }
  }

  // ---== إنشاء طلب تحريك سيارة (جديد) ==---
  Future<bool> createCarMovementRequest({
    required int empCode,
    required int userCode,
    required int insertUser,
    required int compEmpCode,
    required int trnsType,
    required int reasonType,
    required DateTime prmDate,
    required DateTime fromTime,
    required DateTime toTime,
    required String carNo,
    required String permReasons,
    required String notes,
  }) async {
    _setLoadingState(true);
    final String url = '${ApiConstants.baseUrl}${ApiConstants.createCarMovementRequestEndpoint}';

    final nextSerial = await _fetchNextSerial(userCode, 'carMovement');

    String formatDateTimeWithTimezone(DateTime dt) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String y = dt.year.toString();
      String m = twoDigits(dt.month);
      String d = twoDigits(dt.day);
      String h = twoDigits(dt.hour);
      String min = twoDigits(dt.minute);
      String sec = twoDigits(dt.second);
      return "$y-$m-${d}T$h:$min:$sec+03:00";
    }

    String formatDateWithTimezone(DateTime dt) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String y = dt.year.toString();
      String m = twoDigits(dt.month);
      String d = twoDigits(dt.day);
      return "$y-$m-${d}T00:00:00";
    }

    final body = {
      "EmpCode": empCode,
      "Serial": nextSerial,
      "CarNo": carNo,
      "CompEmpCode": compEmpCode,
      "TrnsDate": formatDateTimeWithTimezone(DateTime.now()),
      "TrnsType": trnsType,
      "PrmDate": formatDateWithTimezone(prmDate),
      "FromTime": formatDateTimeWithTimezone(fromTime),
      "ToTime": formatDateTimeWithTimezone(toTime),
      "AproveFlag": 0,
      "ReasonType": reasonType,
      "PermReasons": permReasons,
      "Notes": notes,
      "InsertUser": insertUser,
      "AltKey": "$empCode-$nextSerial",
      // DCode and DayType are ignored as requested
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode(body),
      );

      final String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _logApiCall(operation: "Create Car Movement", url: url, requestBody: body, statusCode: response.statusCode, responseBody: responseBody);
        await fetchMyCarMovementRequests(empCode); // تحديث القائمة
        _setLoadingState(false);
        return true;
      } else {
        String serverErrorMsg = "فشل إنشاء الطلب.";
        try {
          final errorData = json.decode(responseBody);
          serverErrorMsg = errorData["title"] ?? errorData["detail"] ?? serverErrorMsg;
        } catch (_) {}
        _logApiCall(operation: "Create Car Movement", url: url, requestBody: body, statusCode: response.statusCode, responseBody: responseBody, error: serverErrorMsg);
        _handleError(serverErrorMsg);
        _setLoadingState(false);
        return false;
      }
    } catch (e) {
      _logApiCall(operation: "Create Car Movement", url: url, requestBody: body, error: e.toString());
      _handleError('Error creating car movement request: $e');
      _setLoadingState(false);
      return false;
    }
  }

  // ---== دوال جلب تثبيت راتب (جديدة) ==---
  Future<void> fetchSalaryConfirmationRequests(int usersCode) async {
    _setLoadingState(true);
    _handleError(null);
    final url = '${ApiConstants.baseUrl}${ApiConstants.salaryConfirmationRequestsEndpoint}?q=TypeFlag=0;UsersCode=$usersCode&orderBy=Serial:desc';
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final requestList = SalaryConfirmationRequestList.fromJson(data);
        _salaryConfirmationRequests = requestList.items.where((req) => req.aproveFlag == 0).toList();
        _logApiCall(operation: "Fetch Salary Confirmation (Appr.)", url: url, statusCode: 200, responseBody: "Success: ${requestList.items.length} items");
      } else {
        _salaryConfirmationRequests = [];
        _logApiCall(operation: "Fetch Salary Confirmation (Appr.)", url: url, statusCode: 200, responseBody: "No data");
      }
    } catch (e) {
      _logApiCall(operation: "Fetch Salary Confirmation (Appr.)", url: url, error: e.toString());
      _handleError('Failed to load salary confirmation requests: $e');
      _salaryConfirmationRequests = [];
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> fetchMySalaryConfirmationRequests(int empCode) async {
    _setLoadingState(true);
    _handleError(null);
    final url = '${ApiConstants.baseUrl}${ApiConstants.mySalaryConfirmationRequestsEndpoint}?q=TypeFlag=0;EmpCode=$empCode&orderBy=Serial:desc';
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final myList = MySalaryConfirmationRequestList.fromJson(data);
        _mySalaryConfirmationRequests = myList.items;
        _logApiCall(operation: "Fetch My Salary Confirmation", url: url, statusCode: 200, responseBody: "Success: ${myList.items.length} items");
      } else {
        _mySalaryConfirmationRequests = [];
        _logApiCall(operation: "Fetch My Salary Confirmation", url: url, statusCode: 200, responseBody: "No data");
      }
    } catch (e) {
      _logApiCall(operation: "Fetch My Salary Confirmation", url: url, error: e.toString());
      _handleError('Failed to load my salary confirmation requests: $e');
      _mySalaryConfirmationRequests = [];
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadSalaryConfirmationAuthDetails() async {
    if (_selectedSalaryConfirmationRequest == null) return;

    final authLink = _selectedSalaryConfirmationRequest!.links.firstWhere(
            (link) => link.rel == 'child' && link.name == 'SsFixedSalAuthVRO',
        orElse: () => Link(rel: '', href: '', name: '', kind: ''));

    if (authLink.href.isEmpty) {
      _handleError("Auth link not found");
      _salaryConfirmationAuthDetails = SalaryConfirmationAuthResponse(items: []);
      return;
    }

    _setLoadingState(true);
    try {
      final data = await _dataFetchService.fetchDataFromUrl(authLink.href);
      if (data != null) {
        _salaryConfirmationAuthDetails = SalaryConfirmationAuthResponse.fromJson(data);
        _logApiCall(operation: "Load Salary Confirmation Auth", url: authLink.href, statusCode: 200, responseBody: "Success: ${_salaryConfirmationAuthDetails?.items.length} items");
      } else {
        _salaryConfirmationAuthDetails = SalaryConfirmationAuthResponse(items: []);
        _logApiCall(operation: "Load Salary Confirmation Auth", url: authLink.href, statusCode: 200, responseBody: "No data");
      }
      _handleError(null);
    } catch (e) {
      _logApiCall(operation: "Load Salary Confirmation Auth", url: authLink.href, error: e.toString());
      _handleError('Failed to load salary confirmation auth details: $e');
      _salaryConfirmationAuthDetails = SalaryConfirmationAuthResponse(items: []);
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadMySalaryConfirmationAuthDetails() async {
    if (_selectedMySalaryConfirmationRequest == null) return;

    final authLink = _selectedMySalaryConfirmationRequest!.links.firstWhere(
            (link) => link.rel == 'child' && link.name == 'SsFixedSalAuthVRO',
        orElse: () => Link(rel: '', href: '', name: '', kind: ''));

    if (authLink.href.isEmpty) {
      _handleError("Auth link not found");
      _mySalaryConfirmationAuthDetails = SalaryConfirmationAuthResponse(items: []);
      return;
    }

    _setLoadingState(true);
    try {
      final data = await _dataFetchService.fetchDataFromUrl(authLink.href);
      if (data != null) {
        _mySalaryConfirmationAuthDetails = SalaryConfirmationAuthResponse.fromJson(data);
        _logApiCall(operation: "Load My Salary Confirmation Auth", url: authLink.href, statusCode: 200, responseBody: "Success: ${_mySalaryConfirmationAuthDetails?.items.length} items");
      } else {
        _mySalaryConfirmationAuthDetails = SalaryConfirmationAuthResponse(items: []);
        _logApiCall(operation: "Load My Salary Confirmation Auth", url: authLink.href, statusCode: 200, responseBody: "No data");
      }
      _handleError(null);
    } catch (e) {
      _logApiCall(operation: "Load My Salary Confirmation Auth", url: authLink.href, error: e.toString());
      _mySalaryConfirmationAuthDetails = SalaryConfirmationAuthResponse(items: []);
    } finally {
      _setLoadingState(false);
    }
  }

  // ---== إنشاء طلب تثبيت راتب (جديد) ==---
  Future<bool> createSalaryConfirmationRequest({
    required int empCode,
    required int userCode,
    required int insertUser,
    required int compEmpCode,
    required DateTime trnsDate,
    required String? notes,
  }) async {
    _setLoadingState(true);
    final String url = '${ApiConstants.baseUrl}${ApiConstants.createSalaryConfirmationRequestEndpoint}';

    final nextSerial = await _fetchNextSerial(userCode, 'salaryConfirmation');

    String formatDateWithTimezone(DateTime dt) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String y = dt.year.toString();
      String m = twoDigits(dt.month);
      String d = twoDigits(dt.day);
      return "$y-$m-${d}T00:00:00+03:00"; // As per API sample
    }

    final int typeFlag = 0; // As requested

    final body = {
      "EmpCode": empCode,
      "Serial": nextSerial,
      "TypeFlag": typeFlag,
      "CompEmpCode": compEmpCode,
      "TrnsDate": formatDateWithTimezone(trnsDate),
      "Notes": notes,
      "AproveFlag": 0,
      "AltKey": "$empCode-$nextSerial-$typeFlag", // As requested
      "InsertUser": insertUser,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode(body),
      );

      final String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _logApiCall(operation: "Create Salary Confirmation", url: url, requestBody: body, statusCode: response.statusCode, responseBody: responseBody);
        await fetchMySalaryConfirmationRequests(empCode); // تحديث القائمة
        _setLoadingState(false);
        return true;
      } else {
        String serverErrorMsg = "فشل إنشاء الطلب.";
        try {
          final errorData = json.decode(responseBody);
          serverErrorMsg = errorData["title"] ?? errorData["detail"] ?? serverErrorMsg;
        } catch (_) {}
        _logApiCall(operation: "Create Salary Confirmation", url: url, requestBody: body, statusCode: response.statusCode, responseBody: responseBody, error: serverErrorMsg);
        _handleError(serverErrorMsg);
        _setLoadingState(false);
        return false;
      }
    } catch (e) {
      _logApiCall(operation: "Create Salary Confirmation", url: url, requestBody: body, error: e.toString());
      _handleError('Error creating salary confirmation request: $e');
      _setLoadingState(false);
      return false;
    }
  }

  // ---== دوال جلب إلغاء تثبيت راتب (جديدة) ==---
  Future<void> fetchCancelSalaryConfirmationRequests(int usersCode) async {
    _setLoadingState(true);
    _handleError(null);
    final url = '${ApiConstants.baseUrl}${ApiConstants.salaryConfirmationRequestsEndpoint}?q=TypeFlag=1;UsersCode=$usersCode&orderBy=Serial:desc';
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final requestList = CancelSalaryConfirmationRequestList.fromJson(data);
        _cancelSalaryConfirmationRequests = requestList.items.where((req) => req.aproveFlag == 0).toList();
        _logApiCall(operation: "Fetch Cancel Salary (Appr.)", url: url, statusCode: 200, responseBody: "Success: ${requestList.items.length} items");
      } else {
        _cancelSalaryConfirmationRequests = [];
        _logApiCall(operation: "Fetch Cancel Salary (Appr.)", url: url, statusCode: 200, responseBody: "No data");
      }
    } catch (e) {
      _logApiCall(operation: "Fetch Cancel Salary (Appr.)", url: url, error: e.toString());
      _handleError('Failed to load cancel salary confirmation requests: $e');
      _cancelSalaryConfirmationRequests = [];
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> fetchMyCancelSalaryConfirmationRequests(int empCode) async {
    _setLoadingState(true);
    _handleError(null);
    final url = '${ApiConstants.baseUrl}${ApiConstants.mySalaryConfirmationRequestsEndpoint}?q=TypeFlag=1;EmpCode=$empCode&orderBy=Serial:desc';
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final myList = MyCancelSalaryConfirmationRequestList.fromJson(data);
        _myCancelSalaryConfirmationRequests = myList.items;
        _logApiCall(operation: "Fetch My Cancel Salary", url: url, statusCode: 200, responseBody: "Success: ${myList.items.length} items");
      } else {
        _myCancelSalaryConfirmationRequests = [];
        _logApiCall(operation: "Fetch My Cancel Salary", url: url, statusCode: 200, responseBody: "No data");
      }
    } catch (e) {
      _logApiCall(operation: "Fetch My Cancel Salary", url: url, error: e.toString());
      _handleError('Failed to load my cancel salary confirmation requests: $e');
      _myCancelSalaryConfirmationRequests = [];
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadCancelSalaryConfirmationAuthDetails() async {
    if (_selectedCancelSalaryConfirmationRequest == null) return;

    final authLink = _selectedCancelSalaryConfirmationRequest!.links.firstWhere(
            (link) => link.rel == 'child' && link.name == 'SsFixedSalAuthVRO',
        orElse: () => Link(rel: '', href: '', name: '', kind: ''));

    if (authLink.href.isEmpty) {
      _handleError("Auth link not found");
      _cancelSalaryConfirmationAuthDetails = CancelSalaryConfirmationAuthResponse(items: []);
      return;
    }

    _setLoadingState(true);
    try {
      final data = await _dataFetchService.fetchDataFromUrl(authLink.href);
      if (data != null) {
        _cancelSalaryConfirmationAuthDetails = CancelSalaryConfirmationAuthResponse.fromJson(data);
        _logApiCall(operation: "Load Cancel Salary Auth", url: authLink.href, statusCode: 200, responseBody: "Success: ${_cancelSalaryConfirmationAuthDetails?.items.length} items");
      } else {
        _cancelSalaryConfirmationAuthDetails = CancelSalaryConfirmationAuthResponse(items: []);
        _logApiCall(operation: "Load Cancel Salary Auth", url: authLink.href, statusCode: 200, responseBody: "No data");
      }
      _handleError(null);
    } catch (e) {
      _logApiCall(operation: "Load Cancel Salary Auth", url: authLink.href, error: e.toString());
      _handleError('Failed to load cancel salary confirmation auth details: $e');
      _cancelSalaryConfirmationAuthDetails = CancelSalaryConfirmationAuthResponse(items: []);
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadMyCancelSalaryConfirmationAuthDetails() async {
    if (_selectedMyCancelSalaryConfirmationRequest == null) return;

    final authLink = _selectedMyCancelSalaryConfirmationRequest!.links.firstWhere(
            (link) => link.rel == 'child' && link.name == 'SsFixedSalAuthVRO',
        orElse: () => Link(rel: '', href: '', name: '', kind: ''));

    if (authLink.href.isEmpty) {
      _handleError("Auth link not found");
      _myCancelSalaryConfirmationAuthDetails = CancelSalaryConfirmationAuthResponse(items: []);
      return;
    }

    _setLoadingState(true);
    try {
      final data = await _dataFetchService.fetchDataFromUrl(authLink.href);
      if (data != null) {
        _myCancelSalaryConfirmationAuthDetails = CancelSalaryConfirmationAuthResponse.fromJson(data);
        _logApiCall(operation: "Load My Cancel Salary Auth", url: authLink.href, statusCode: 200, responseBody: "Success: ${_myCancelSalaryConfirmationAuthDetails?.items.length} items");
      } else {
        _myCancelSalaryConfirmationAuthDetails = CancelSalaryConfirmationAuthResponse(items: []);
        _logApiCall(operation: "Load My Cancel Salary Auth", url: authLink.href, statusCode: 200, responseBody: "No data");
      }
      _handleError(null);
    } catch (e) {
      _logApiCall(operation: "Load My Cancel Salary Auth", url: authLink.href, error: e.toString());
      _myCancelSalaryConfirmationAuthDetails = CancelSalaryConfirmationAuthResponse(items: []);
    } finally {
      _setLoadingState(false);
    }
  }

  // ---== إنشاء طلب إلغاء تثبيت راتب (جديد) ==---
  Future<bool> createCancelSalaryConfirmationRequest({
    required int empCode,
    required int userCode,
    required int insertUser,
    required int compEmpCode,
    required DateTime trnsDate,
    required String? notes,
  }) async {
    _setLoadingState(true);
    final String url = '${ApiConstants.baseUrl}${ApiConstants.createSalaryConfirmationRequestEndpoint}'; // Same endpoint
    final nextSerial = await _fetchNextSerial(userCode, 'salaryUnConfirmation');

    String formatDateWithTimezone(DateTime dt) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String y = dt.year.toString();
      String m = twoDigits(dt.month);
      String d = twoDigits(dt.day);
      return "$y-$m-${d}T00:00:00+03:00";
    }

    final int typeFlag = 1; // ---== تم التعديل ==---

    final body = {
      "EmpCode": empCode,
      "Serial": nextSerial,
      "TypeFlag": typeFlag, // ---== تم التعديل ==---
      "CompEmpCode": compEmpCode,
      "TrnsDate": formatDateWithTimezone(trnsDate),
      "Notes": notes,
      "AproveFlag": 0,
      "AltKey": "$empCode-$nextSerial-$typeFlag", // ---== تم التعديل ==---
      "InsertUser": insertUser,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode(body),
      );

      final String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _logApiCall(operation: "Create Cancel Salary", url: url, requestBody: body, statusCode: response.statusCode, responseBody: responseBody);
        await fetchMyCancelSalaryConfirmationRequests(empCode); // تحديث القائمة
        _setLoadingState(false);
        return true;
      } else {
        String serverErrorMsg = "فشل إنشاء الطلب.";
        try {
          final errorData = json.decode(responseBody);
          serverErrorMsg = errorData["title"] ?? errorData["detail"] ?? serverErrorMsg;
        } catch (_) {}
        _logApiCall(operation: "Create Cancel Salary", url: url, requestBody: body, statusCode: response.statusCode, responseBody: responseBody, error: serverErrorMsg);
        _handleError(serverErrorMsg);
        _setLoadingState(false);
        return false;
      }
    } catch (e) {
      _logApiCall(operation: "Create Cancel Salary", url: url, requestBody: body, error: e.toString());
      _handleError('Error creating cancel salary confirmation request: $e');
      _setLoadingState(false);
      return false;
    }
  }
}