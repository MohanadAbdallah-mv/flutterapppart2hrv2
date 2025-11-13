import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get appName;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @userCodeHint.
  ///
  /// In en, this message translates to:
  /// **'User Code'**
  String get userCodeHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Available Services'**
  String get services;

  /// No description provided for @purchases.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchases;

  /// No description provided for @purchasesO.
  ///
  /// In en, this message translates to:
  /// **'Purchase orders '**
  String get purchasesO;

  /// No description provided for @purchasesR.
  ///
  /// In en, this message translates to:
  /// **'purchase requisitions '**
  String get purchasesR;

  /// No description provided for @humanResources.
  ///
  /// In en, this message translates to:
  /// **'My requests'**
  String get humanResources;

  /// No description provided for @custody.
  ///
  /// In en, this message translates to:
  /// **'Custody'**
  String get custody;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get about;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'Approval required'**
  String get myProfile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @jobInfo.
  ///
  /// In en, this message translates to:
  /// **'Job Information'**
  String get jobInfo;

  /// No description provided for @financialInfo.
  ///
  /// In en, this message translates to:
  /// **'Financial Information'**
  String get financialInfo;

  /// No description provided for @vacationInfo.
  ///
  /// In en, this message translates to:
  /// **'Vacation request'**
  String get vacationInfo;

  /// No description provided for @loanInfo.
  ///
  /// In en, this message translates to:
  /// **'Loan request'**
  String get loanInfo;

  /// No description provided for @resignationInfo.
  ///
  /// In en, this message translates to:
  /// **'Resignation request'**
  String get resignationInfo;

  /// No description provided for @attendanceInfo.
  ///
  /// In en, this message translates to:
  /// **'Attendance and departure'**
  String get attendanceInfo;

  /// No description provided for @ticketsInfo.
  ///
  /// In en, this message translates to:
  /// **'Tickets Information'**
  String get ticketsInfo;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @job.
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get job;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @systemTitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Resource Management System'**
  String get systemTitle;

  /// No description provided for @systemWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Enterprise Resource Management System'**
  String get systemWelcomeMessage;

  /// No description provided for @loginSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccessMessage;

  /// No description provided for @loginErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again'**
  String get loginErrorMessage;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @noAccountText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountText;

  /// No description provided for @signUpText.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpText;

  /// No description provided for @userCodeValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your user code'**
  String get userCodeValidationError;

  /// No description provided for @passwordValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordValidationError;

  /// No description provided for @passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password is too short'**
  String get passwordLengthError;

  /// No description provided for @profileDetails.
  ///
  /// In en, this message translates to:
  /// **'Profile Details'**
  String get profileDetails;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @employeeCode.
  ///
  /// In en, this message translates to:
  /// **'Employee Code (Company):'**
  String get employeeCode;

  /// No description provided for @employeeName.
  ///
  /// In en, this message translates to:
  /// **'Employee Name:'**
  String get employeeName;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title:'**
  String get jobTitle;

  /// No description provided for @salaryAndAllowances.
  ///
  /// In en, this message translates to:
  /// **'Salary and Allowances Details'**
  String get salaryAndAllowances;

  /// No description provided for @basicSalary.
  ///
  /// In en, this message translates to:
  /// **'Basic Salary:'**
  String get basicSalary;

  /// No description provided for @transportationAllowance.
  ///
  /// In en, this message translates to:
  /// **'Transportation Allowance:'**
  String get transportationAllowance;

  /// No description provided for @workNatureAllowance.
  ///
  /// In en, this message translates to:
  /// **'Work Nature Allowance:'**
  String get workNatureAllowance;

  /// No description provided for @foodAllowance.
  ///
  /// In en, this message translates to:
  /// **'Food Allowance:'**
  String get foodAllowance;

  /// No description provided for @extra.
  ///
  /// In en, this message translates to:
  /// **'Extra:'**
  String get extra;

  /// No description provided for @otherAllowances.
  ///
  /// In en, this message translates to:
  /// **'Other Allowances:'**
  String get otherAllowances;

  /// No description provided for @otherDeductions.
  ///
  /// In en, this message translates to:
  /// **'Other Deductions:'**
  String get otherDeductions;

  /// No description provided for @allowance1.
  ///
  /// In en, this message translates to:
  /// **'Allowance 1:'**
  String get allowance1;

  /// No description provided for @allowance2.
  ///
  /// In en, this message translates to:
  /// **'Allowance 2:'**
  String get allowance2;

  /// No description provided for @allowance3.
  ///
  /// In en, this message translates to:
  /// **'Allowance 3:'**
  String get allowance3;

  /// No description provided for @housingInformation.
  ///
  /// In en, this message translates to:
  /// **'Housing Information'**
  String get housingInformation;

  /// No description provided for @housingAllowanceMonths.
  ///
  /// In en, this message translates to:
  /// **'Housing Allowance Months:'**
  String get housingAllowanceMonths;

  /// No description provided for @housingAllowanceAmount.
  ///
  /// In en, this message translates to:
  /// **'Housing Allowance Amount:'**
  String get housingAllowanceAmount;

  /// No description provided for @workScheduleAndVacation.
  ///
  /// In en, this message translates to:
  /// **'Work Schedule and Vacation Information'**
  String get workScheduleAndVacation;

  /// No description provided for @normalWorkingDays.
  ///
  /// In en, this message translates to:
  /// **'Normal Working Days:'**
  String get normalWorkingDays;

  /// No description provided for @unauthorizedAbsenceDays.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized Absence Days:'**
  String get unauthorizedAbsenceDays;

  /// No description provided for @vacationEvery.
  ///
  /// In en, this message translates to:
  /// **'Vacation Every (Month/Year):'**
  String get vacationEvery;

  /// No description provided for @travelTicketsInformation.
  ///
  /// In en, this message translates to:
  /// **'Travel Tickets Information'**
  String get travelTicketsInformation;

  /// No description provided for @ticketsAmount.
  ///
  /// In en, this message translates to:
  /// **'Tickets Amount:'**
  String get ticketsAmount;

  /// No description provided for @ticketsEvery.
  ///
  /// In en, this message translates to:
  /// **'Tickets Every (Month/Year):'**
  String get ticketsEvery;

  /// No description provided for @ticketsType.
  ///
  /// In en, this message translates to:
  /// **'Tickets Type:'**
  String get ticketsType;

  /// No description provided for @travelCity.
  ///
  /// In en, this message translates to:
  /// **'Travel City:'**
  String get travelCity;

  /// No description provided for @airline.
  ///
  /// In en, this message translates to:
  /// **'Airline:'**
  String get airline;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @noUserDataFound.
  ///
  /// In en, this message translates to:
  /// **'No user data found.'**
  String get noUserDataFound;

  /// No description provided for @invalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid format'**
  String get invalidFormat;

  /// No description provided for @underAction.
  ///
  /// In en, this message translates to:
  /// **'Under Action'**
  String get underAction;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Supplier Name'**
  String get supplierName;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumber;

  /// No description provided for @orderDate.
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get orderDate;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @orderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetailsTitle;

  /// No description provided for @errorLoadingOrder.
  ///
  /// In en, this message translates to:
  /// **'Error loading order details.'**
  String get errorLoadingOrder;

  /// No description provided for @approvals.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get approvals;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @orderNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Order No:'**
  String get orderNumberLabel;

  /// No description provided for @orderDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Date:'**
  String get orderDateLabel;

  /// No description provided for @supplierNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Supplier Name:'**
  String get supplierNameLabel;

  /// No description provided for @totalOrderAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Order Amount:'**
  String get totalOrderAmount;

  /// No description provided for @calculatingTotal.
  ///
  /// In en, this message translates to:
  /// **'Calculating total...'**
  String get calculatingTotal;

  /// No description provided for @takeAction.
  ///
  /// In en, this message translates to:
  /// **'Take Action'**
  String get takeAction;

  /// No description provided for @actionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Decision on Purchase Order'**
  String get actionDialogTitle;

  /// No description provided for @statementLabel.
  ///
  /// In en, this message translates to:
  /// **'Statement (Notes for current action)'**
  String get statementLabel;

  /// No description provided for @statementHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your notes here (optional)...'**
  String get statementHint;

  /// No description provided for @submittingAction.
  ///
  /// In en, this message translates to:
  /// **'Submitting action...'**
  String get submittingAction;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @actionErrorIncompleteData.
  ///
  /// In en, this message translates to:
  /// **'Error: Cannot take action, data is incomplete.'**
  String get actionErrorIncompleteData;

  /// No description provided for @waitForAuthDetails.
  ///
  /// In en, this message translates to:
  /// **'Please wait for approval details to load...'**
  String get waitForAuthDetails;

  /// No description provided for @approvalSuccess.
  ///
  /// In en, this message translates to:
  /// **'Approved successfully.'**
  String get approvalSuccess;

  /// No description provided for @rejectionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Rejection registered successfully.'**
  String get rejectionSuccess;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unexpectedError;

  /// No description provided for @errorLoadingApprovals.
  ///
  /// In en, this message translates to:
  /// **'Error loading approvals:'**
  String get errorLoadingApprovals;

  /// No description provided for @noApprovalData.
  ///
  /// In en, this message translates to:
  /// **'No approval data for this order.'**
  String get noApprovalData;

  /// No description provided for @noRegisteredApprovals.
  ///
  /// In en, this message translates to:
  /// **'No registered approvals for this order.'**
  String get noRegisteredApprovals;

  /// No description provided for @approvalChain.
  ///
  /// In en, this message translates to:
  /// **'Approval Chain:'**
  String get approvalChain;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownUser;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get dateLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes:'**
  String get notesLabel;

  /// No description provided for @authStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get authStatusPending;

  /// No description provided for @authStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get authStatusApproved;

  /// No description provided for @authStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get authStatusRejected;

  /// No description provided for @authStatusUndefined.
  ///
  /// In en, this message translates to:
  /// **'Undefined'**
  String get authStatusUndefined;

  /// No description provided for @errorLoadingServices.
  ///
  /// In en, this message translates to:
  /// **'Error loading services:'**
  String get errorLoadingServices;

  /// No description provided for @noServiceData.
  ///
  /// In en, this message translates to:
  /// **'No services for this order.'**
  String get noServiceData;

  /// No description provided for @noRegisteredServices.
  ///
  /// In en, this message translates to:
  /// **'No registered services for this order.'**
  String get noRegisteredServices;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @errorLoadingItems.
  ///
  /// In en, this message translates to:
  /// **'Error loading items:'**
  String get errorLoadingItems;

  /// No description provided for @noItemData.
  ///
  /// In en, this message translates to:
  /// **'No items for this order.'**
  String get noItemData;

  /// No description provided for @noRegisteredItems.
  ///
  /// In en, this message translates to:
  /// **'No registered items for this order.'**
  String get noRegisteredItems;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @purchaseOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Orders'**
  String get purchaseOrdersTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noPurchaseOrders.
  ///
  /// In en, this message translates to:
  /// **'No purchase orders currently.'**
  String get noPurchaseOrders;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @vacationRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vacation Requests'**
  String get vacationRequestsTitle;

  /// No description provided for @noVacationRequests.
  ///
  /// In en, this message translates to:
  /// **'No vacation requests at the moment.'**
  String get noVacationRequests;

  /// No description provided for @vacationRequestDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vacation Request Details'**
  String get vacationRequestDetailsTitle;

  /// No description provided for @noRequestSelected.
  ///
  /// In en, this message translates to:
  /// **'No request has been selected.'**
  String get noRequestSelected;

  /// No description provided for @vacationActionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Decision on Vacation Request'**
  String get vacationActionDialogTitle;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @requestFor.
  ///
  /// In en, this message translates to:
  /// **'Request for: {employeeName}'**
  String requestFor(Object employeeName);

  /// No description provided for @vacationTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Vacation Type:'**
  String get vacationTypeLabel;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date:'**
  String get startDateLabel;

  /// No description provided for @endDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End Date:'**
  String get endDateLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration:'**
  String get durationLabel;

  /// No description provided for @daysUnit.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysUnit;

  /// No description provided for @noRegisteredApprovalsForRequest.
  ///
  /// In en, this message translates to:
  /// **'No registered approvals for this request.'**
  String get noRegisteredApprovalsForRequest;

  /// No description provided for @myVacationRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Vacation Requests'**
  String get myVacationRequestsTitle;

  /// No description provided for @newRequest.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get newRequest;

  /// No description provided for @newVacationRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'New Vacation Request'**
  String get newVacationRequestTitle;

  /// No description provided for @requestData.
  ///
  /// In en, this message translates to:
  /// **'Request Data'**
  String get requestData;

  /// No description provided for @vacationType.
  ///
  /// In en, this message translates to:
  /// **'Vacation Type'**
  String get vacationType;

  /// No description provided for @vacationTypeAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get vacationTypeAnnual;

  /// No description provided for @vacationTypeRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get vacationTypeRegular;

  /// No description provided for @vacationTypeUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get vacationTypeUnpaid;

  /// No description provided for @vacationStartDate.
  ///
  /// In en, this message translates to:
  /// **'Vacation Start Date'**
  String get vacationStartDate;

  /// No description provided for @vacationEndDate.
  ///
  /// In en, this message translates to:
  /// **'Vacation End Date'**
  String get vacationEndDate;

  /// No description provided for @durationInDays.
  ///
  /// In en, this message translates to:
  /// **'Duration (days)'**
  String get durationInDays;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @saveRequest.
  ///
  /// In en, this message translates to:
  /// **'Save Request'**
  String get saveRequest;

  /// No description provided for @selectVacationTypeValidation.
  ///
  /// In en, this message translates to:
  /// **'Please select a vacation type'**
  String get selectVacationTypeValidation;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get selectDate;

  /// No description provided for @selectDateValidation.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get selectDateValidation;

  /// No description provided for @requestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Request sent successfully.'**
  String get requestSentSuccessfully;

  /// No description provided for @vacationRequest.
  ///
  /// In en, this message translates to:
  /// **'Vacation Request'**
  String get vacationRequest;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From:'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To:'**
  String get to;

  /// No description provided for @requestDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Request Date:'**
  String get requestDateLabel;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @requestInfo.
  ///
  /// In en, this message translates to:
  /// **'Request Information'**
  String get requestInfo;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date:'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date:'**
  String get toDate;

  /// No description provided for @loanRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Loan Requests'**
  String get loanRequestsTitle;

  /// No description provided for @noLoanRequests.
  ///
  /// In en, this message translates to:
  /// **'No loan requests at the moment.'**
  String get noLoanRequests;

  /// No description provided for @loanRequestDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Loan Request Details'**
  String get loanRequestDetailsTitle;

  /// No description provided for @loanActionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Decision on Loan Request'**
  String get loanActionDialogTitle;

  /// No description provided for @requestForLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan request for: {employeeName}'**
  String requestForLoan(Object employeeName);

  /// No description provided for @loanTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Loan Type:'**
  String get loanTypeLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description:'**
  String get descriptionLabel;

  /// No description provided for @loanStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date:'**
  String get loanStartDateLabel;

  /// No description provided for @myLoanRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Loan Requests'**
  String get myLoanRequestsTitle;

  /// No description provided for @newLoanRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'New Loan Request'**
  String get newLoanRequestTitle;

  /// No description provided for @loanType.
  ///
  /// In en, this message translates to:
  /// **'Loan Type'**
  String get loanType;

  /// No description provided for @totalLoanAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Loan Amount'**
  String get totalLoanAmount;

  /// No description provided for @installmentsCount.
  ///
  /// In en, this message translates to:
  /// **'Number of Installments'**
  String get installmentsCount;

  /// No description provided for @installmentValue.
  ///
  /// In en, this message translates to:
  /// **'Installment Value'**
  String get installmentValue;

  /// No description provided for @repaymentStartDate.
  ///
  /// In en, this message translates to:
  /// **'Repayment Start Date'**
  String get repaymentStartDate;

  /// No description provided for @selectLoanTypeValidation.
  ///
  /// In en, this message translates to:
  /// **'Please select a loan type'**
  String get selectLoanTypeValidation;

  /// No description provided for @fieldRequiredValidation.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequiredValidation;

  /// No description provided for @loanRequestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Loan request sent successfully.'**
  String get loanRequestSentSuccessfully;

  /// No description provided for @loanRequest.
  ///
  /// In en, this message translates to:
  /// **'Loan Request'**
  String get loanRequest;

  /// No description provided for @loanValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Loan Value:'**
  String get loanValueLabel;

  /// No description provided for @installmentValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Installment Value:'**
  String get installmentValueLabel;

  /// No description provided for @installmentsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Installments Count:'**
  String get installmentsCountLabel;

  /// No description provided for @repaymentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Repayment Date:'**
  String get repaymentDateLabel;

  /// No description provided for @resignationRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Resignation Requests'**
  String get resignationRequestsTitle;

  /// No description provided for @noResignationRequests.
  ///
  /// In en, this message translates to:
  /// **'No resignation requests at the moment.'**
  String get noResignationRequests;

  /// No description provided for @resignationRequestDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Resignation Request Details'**
  String get resignationRequestDetailsTitle;

  /// No description provided for @resignationActionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Decision on Resignation Request'**
  String get resignationActionDialogTitle;

  /// No description provided for @requestForResignation.
  ///
  /// In en, this message translates to:
  /// **'Resignation request for: {employeeName}'**
  String requestForResignation(Object employeeName);

  /// No description provided for @serviceEndDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Service End Date:'**
  String get serviceEndDateLabel;

  /// No description provided for @lastWorkDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Work Day:'**
  String get lastWorkDayLabel;

  /// No description provided for @reasonsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reasonsLabel;

  /// No description provided for @myResignationRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Resignation Requests'**
  String get myResignationRequestsTitle;

  /// No description provided for @newResignationRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'New Resignation Request'**
  String get newResignationRequestTitle;

  /// No description provided for @resignationEndDate.
  ///
  /// In en, this message translates to:
  /// **'Resignation Date (End of Service)'**
  String get resignationEndDate;

  /// No description provided for @lastWorkDate.
  ///
  /// In en, this message translates to:
  /// **'Last Work Date'**
  String get lastWorkDate;

  /// No description provided for @reasonsForLeaving.
  ///
  /// In en, this message translates to:
  /// **'Reasons for Leaving'**
  String get reasonsForLeaving;

  /// No description provided for @resignationRequest.
  ///
  /// In en, this message translates to:
  /// **'Resignation Request'**
  String get resignationRequest;

  /// No description provided for @resignationDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Resignation Date:'**
  String get resignationDateLabel;

  /// No description provided for @resignationRequestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Resignation request sent successfully.'**
  String get resignationRequestSentSuccessfully;

  /// No description provided for @attendanceAndDeparture.
  ///
  /// In en, this message translates to:
  /// **'Attendance & Departure'**
  String get attendanceAndDeparture;

  /// No description provided for @newRecord.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newRecord;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

  /// No description provided for @newRecordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'New Record'**
  String get newRecordDialogTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @checkInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check-in recorded successfully.'**
  String get checkInSuccess;

  /// No description provided for @checkOutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check-out recorded successfully.'**
  String get checkOutSuccess;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An Error Occurred'**
  String get errorOccurred;

  /// No description provided for @attendanceLog.
  ///
  /// In en, this message translates to:
  /// **'Attendance Log'**
  String get attendanceLog;

  /// No description provided for @viewMonthlyLog.
  ///
  /// In en, this message translates to:
  /// **'View monthly attendance log'**
  String get viewMonthlyLog;

  /// No description provided for @checkedAttendance.
  ///
  /// In en, this message translates to:
  /// **'Checked Attendance'**
  String get checkedAttendance;

  /// No description provided for @viewCheckedLog.
  ///
  /// In en, this message translates to:
  /// **'View checked attendance sheet'**
  String get viewCheckedLog;

  /// No description provided for @attendanceLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance Log'**
  String get attendanceLogTitle;

  /// No description provided for @noAttendanceLogAvailable.
  ///
  /// In en, this message translates to:
  /// **'No attendance log available.'**
  String get noAttendanceLogAvailable;

  /// No description provided for @detailsLinkNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Details link is not available for this month.'**
  String get detailsLinkNotAvailable;

  /// No description provided for @noDataForThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No attendance data for this month.'**
  String get noDataForThisMonth;

  /// No description provided for @noRecordsForThisDay.
  ///
  /// In en, this message translates to:
  /// **'No records for this day.'**
  String get noRecordsForThisDay;

  /// No description provided for @checkInLabel.
  ///
  /// In en, this message translates to:
  /// **'In:'**
  String get checkInLabel;

  /// No description provided for @checkOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Out:'**
  String get checkOutLabel;

  /// No description provided for @checkedAttendanceLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Checked Attendance Sheet'**
  String get checkedAttendanceLogTitle;

  /// No description provided for @noCheckedLogAvailable.
  ///
  /// In en, this message translates to:
  /// **'No checked sheets available.'**
  String get noCheckedLogAvailable;

  /// No description provided for @noDetailsForThisSheet.
  ///
  /// In en, this message translates to:
  /// **'No details for this sheet.'**
  String get noDetailsForThisSheet;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @entry.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get entry;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @delayInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Delay(m)'**
  String get delayInMinutes;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @weekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend'**
  String get weekend;

  /// No description provided for @absence.
  ///
  /// In en, this message translates to:
  /// **'Absence'**
  String get absence;

  /// No description provided for @vacation.
  ///
  /// In en, this message translates to:
  /// **'Vacation'**
  String get vacation;

  /// No description provided for @permissionInfo.
  ///
  /// In en, this message translates to:
  /// **'Permission Requests'**
  String get permissionInfo;

  /// No description provided for @noPermissionRequests.
  ///
  /// In en, this message translates to:
  /// **'No permission requests found.'**
  String get noPermissionRequests;

  /// No description provided for @newPermissionRequest.
  ///
  /// In en, this message translates to:
  /// **'New Permission Request'**
  String get newPermissionRequest;

  /// No description provided for @permissionRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Permission Request Details'**
  String get permissionRequestDetails;

  /// No description provided for @permissionTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Permission Type'**
  String get permissionTypeLabel;

  /// No description provided for @reasonTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason Type'**
  String get reasonTypeLabel;

  /// No description provided for @permissionDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Permission Date'**
  String get permissionDateLabel;

  /// No description provided for @fromTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'From Time'**
  String get fromTimeLabel;

  /// No description provided for @toTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'To Time'**
  String get toTimeLabel;

  /// No description provided for @permissionTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get permissionTimeLabel;

  /// No description provided for @selectPermissionTypeValidation.
  ///
  /// In en, this message translates to:
  /// **'Please select a permission type'**
  String get selectPermissionTypeValidation;

  /// No description provided for @selectReasonTypeValidation.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason type'**
  String get selectReasonTypeValidation;

  /// No description provided for @selectPermissionDateValidation.
  ///
  /// In en, this message translates to:
  /// **'Please select a permission date'**
  String get selectPermissionDateValidation;

  /// No description provided for @selectFromTimeValidation.
  ///
  /// In en, this message translates to:
  /// **'Please select a start time'**
  String get selectFromTimeValidation;

  /// No description provided for @selectToTimeValidation.
  ///
  /// In en, this message translates to:
  /// **'Please select an end time'**
  String get selectToTimeValidation;

  /// No description provided for @permissionRequestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Permission request sent successfully.'**
  String get permissionRequestSentSuccessfully;

  /// No description provided for @timeValidationError.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time.'**
  String get timeValidationError;

  /// No description provided for @permissionType1.
  ///
  /// In en, this message translates to:
  /// **'Permission'**
  String get permissionType1;

  /// No description provided for @permissionType2.
  ///
  /// In en, this message translates to:
  /// **'Forgot Check-in'**
  String get permissionType2;

  /// No description provided for @permissionType3.
  ///
  /// In en, this message translates to:
  /// **'Forgot Check-out'**
  String get permissionType3;

  /// No description provided for @permissionType4.
  ///
  /// In en, this message translates to:
  /// **'External Work Mission'**
  String get permissionType4;

  /// No description provided for @reasonType1.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get reasonType1;

  /// No description provided for @reasonType2.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get reasonType2;

  /// No description provided for @reasonType3.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reasonType3;

  /// No description provided for @actionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Action successful'**
  String get actionSuccess;

  /// No description provided for @actionFailed.
  ///
  /// In en, this message translates to:
  /// **'Action failed'**
  String get actionFailed;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptional;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available.'**
  String get noDataAvailable;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @resumeWorkInfo.
  ///
  /// In en, this message translates to:
  /// **'Resume Work Requests'**
  String get resumeWorkInfo;

  /// No description provided for @noResumeWorkRequests.
  ///
  /// In en, this message translates to:
  /// **'No resume work requests found.'**
  String get noResumeWorkRequests;

  /// No description provided for @newResumeWorkRequest.
  ///
  /// In en, this message translates to:
  /// **'New Resume Work Request'**
  String get newResumeWorkRequest;

  /// No description provided for @resumeWorkRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Resume Work Request Details'**
  String get resumeWorkRequestDetails;

  /// No description provided for @resumeWorkDate.
  ///
  /// In en, this message translates to:
  /// **'Resumption Date'**
  String get resumeWorkDate;

  /// No description provided for @delayReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for Delay'**
  String get delayReason;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Please select vacation start date'**
  String get selectStartDate;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Please select vacation end date'**
  String get selectEndDate;

  /// No description provided for @selectResumeDate.
  ///
  /// In en, this message translates to:
  /// **'Please select resumption date'**
  String get selectResumeDate;

  /// No description provided for @resumeWorkRequestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Resume work request sent successfully.'**
  String get resumeWorkRequestSentSuccessfully;

  /// No description provided for @endDateAfterStartDateError.
  ///
  /// In en, this message translates to:
  /// **'End date must be after start date.'**
  String get endDateAfterStartDateError;

  /// No description provided for @resumeDateAfterStartDateError.
  ///
  /// In en, this message translates to:
  /// **'Resumption date must be after start date.'**
  String get resumeDateAfterStartDateError;

  /// No description provided for @componyCode.
  ///
  /// In en, this message translates to:
  /// **'Company Code'**
  String get componyCode;

  /// No description provided for @dCode.
  ///
  /// In en, this message translates to:
  /// **'organizational structure number'**
  String get dCode;

  /// No description provided for @resumeWorkActionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Decision on Resume Work Request'**
  String get resumeWorkActionDialogTitle;

  /// No description provided for @employeeTransferInfo.
  ///
  /// In en, this message translates to:
  /// **'Employee Transfer Requests'**
  String get employeeTransferInfo;

  /// No description provided for @noEmployeeTransferRequests.
  ///
  /// In en, this message translates to:
  /// **'No employee transfer requests found.'**
  String get noEmployeeTransferRequests;

  /// No description provided for @newEmployeeTransferRequest.
  ///
  /// In en, this message translates to:
  /// **'New Transfer Request'**
  String get newEmployeeTransferRequest;

  /// No description provided for @employeeTransferRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Transfer Request Details'**
  String get employeeTransferRequestDetails;

  /// No description provided for @transferDate.
  ///
  /// In en, this message translates to:
  /// **'Transfer Date'**
  String get transferDate;

  /// No description provided for @newCompanyCode.
  ///
  /// In en, this message translates to:
  /// **'New Company Code'**
  String get newCompanyCode;

  /// No description provided for @newDCode.
  ///
  /// In en, this message translates to:
  /// **'New Department Code'**
  String get newDCode;

  /// No description provided for @newManagerCode.
  ///
  /// In en, this message translates to:
  /// **'New Manager Code'**
  String get newManagerCode;

  /// No description provided for @transferNotesAr.
  ///
  /// In en, this message translates to:
  /// **'Transfer Notes (Arabic)'**
  String get transferNotesAr;

  /// No description provided for @transferNotesEn.
  ///
  /// In en, this message translates to:
  /// **'Transfer Notes (English)'**
  String get transferNotesEn;

  /// No description provided for @selectTransferDate.
  ///
  /// In en, this message translates to:
  /// **'Please select the transfer date'**
  String get selectTransferDate;

  /// No description provided for @employeeTransferRequestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Transfer request sent successfully.'**
  String get employeeTransferRequestSentSuccessfully;

  /// No description provided for @numericFieldsError.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid numbers in code fields.'**
  String get numericFieldsError;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @employeeTransferActionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Decision on Transfer Employee Request'**
  String get employeeTransferActionDialogTitle;

  /// No description provided for @selectCompany.
  ///
  /// In en, this message translates to:
  /// **'Select Company'**
  String get selectCompany;

  /// No description provided for @selectDepartment.
  ///
  /// In en, this message translates to:
  /// **'Select Department'**
  String get selectDepartment;

  /// No description provided for @carMovementInfo.
  ///
  /// In en, this message translates to:
  /// **'Car Movement Requests'**
  String get carMovementInfo;

  /// No description provided for @noCarMovementRequests.
  ///
  /// In en, this message translates to:
  /// **'No car movement requests found.'**
  String get noCarMovementRequests;

  /// No description provided for @newCarMovementRequest.
  ///
  /// In en, this message translates to:
  /// **'New Car Movement Request'**
  String get newCarMovementRequest;

  /// No description provided for @carMovementRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Car Movement Request Details'**
  String get carMovementRequestDetails;

  /// No description provided for @carNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Car Number'**
  String get carNoLabel;

  /// No description provided for @selectCarNoValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter the car number'**
  String get selectCarNoValidation;

  /// No description provided for @carMovementRequestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Car movement request sent successfully.'**
  String get carMovementRequestSentSuccessfully;

  /// No description provided for @carMovementTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Movement Time'**
  String get carMovementTimeLabel;

  /// No description provided for @carMovementDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Movement Date'**
  String get carMovementDateLabel;

  /// No description provided for @selectCarMovementDateValidation.
  ///
  /// In en, this message translates to:
  /// **'Please select the movement date'**
  String get selectCarMovementDateValidation;

  /// No description provided for @carMovementActionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Decision on Car Movement Request'**
  String get carMovementActionDialogTitle;

  /// No description provided for @salaryConfirmationInfo.
  ///
  /// In en, this message translates to:
  /// **'Salary Confirmation Requests'**
  String get salaryConfirmationInfo;

  /// No description provided for @noSalaryConfirmationRequests.
  ///
  /// In en, this message translates to:
  /// **'No salary confirmation requests found.'**
  String get noSalaryConfirmationRequests;

  /// No description provided for @newSalaryConfirmationRequest.
  ///
  /// In en, this message translates to:
  /// **'New Salary Confirmation Request'**
  String get newSalaryConfirmationRequest;

  /// No description provided for @salaryConfirmationRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Salary Confirmation Request Details'**
  String get salaryConfirmationRequestDetails;

  /// No description provided for @dCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Organizational Structure Code'**
  String get dCodeHint;

  /// No description provided for @selectRequestDate.
  ///
  /// In en, this message translates to:
  /// **'Please select the request date'**
  String get selectRequestDate;

  /// No description provided for @selectDCodeValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter the organizational structure code'**
  String get selectDCodeValidation;

  /// No description provided for @salaryConfirmationRequestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Salary confirmation request sent successfully.'**
  String get salaryConfirmationRequestSentSuccessfully;

  /// No description provided for @salaryConfirmationActionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Decision on Salary Confirmation Request'**
  String get salaryConfirmationActionDialogTitle;

  /// No description provided for @cancelSalaryConfirmationInfo.
  ///
  /// In en, this message translates to:
  /// **'Cancel Salary Confirmation Requests'**
  String get cancelSalaryConfirmationInfo;

  /// No description provided for @noCancelSalaryConfirmationRequests.
  ///
  /// In en, this message translates to:
  /// **'No cancel salary confirmation requests found.'**
  String get noCancelSalaryConfirmationRequests;

  /// No description provided for @newCancelSalaryConfirmationRequest.
  ///
  /// In en, this message translates to:
  /// **'New Cancel Salary Confirmation Request'**
  String get newCancelSalaryConfirmationRequest;

  /// No description provided for @cancelSalaryConfirmationRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Cancel Salary Confirmation Request Details'**
  String get cancelSalaryConfirmationRequestDetails;

  /// No description provided for @cancelSalaryConfirmationRequestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Cancel salary confirmation request sent successfully.'**
  String get cancelSalaryConfirmationRequestSentSuccessfully;

  /// No description provided for @cancelSalaryConfirmationActionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Decision on Cancel Salary Confirmation'**
  String get cancelSalaryConfirmationActionDialogTitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
