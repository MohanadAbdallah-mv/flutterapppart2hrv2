// lib/features/resume_work/screens/resume_work_request_details_screen.dart
/*
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../models/resume_work_auth_model.dart';
import '../models/resume_work_request_model.dart';
import '../../approvals/widgets/auth_timeline_widget.dart';

import '../../../core/providers/hr_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/app_colors.dart';

class ResumeWorkRequestDetailsScreen extends StatefulWidget {
  static const String routeName = '/resume-work-request-details';
  const ResumeWorkRequestDetailsScreen({super.key});

  @override
  State<ResumeWorkRequestDetailsScreen> createState() => _ResumeWorkRequestDetailsScreenState();
}

class _ResumeWorkRequestDetailsScreenState extends State<ResumeWorkRequestDetailsScreen> {
  final TextEditingController _statementController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HrProvider>(context, listen: false).loadResumeWorkAuthDetails();
    });
  }

  @override
  void dispose() {
    _statementController.dispose();
    super.dispose();
  }

  String _formatDate(String? dateString) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    if (dateString == null) return AppLocalizations.of(context)!.notSpecified;
    try {
      return DateFormat.yMd(locale).format(DateTime.parse(dateString));
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _submitAction(int authFlag) async {
    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final request = hrProvider.selectedResumeWorkRequest;

    if (request == null || authProvider.currentUser == null) return;

    // reset action error
   // hrProvider.actionError=null;

    final bool success = await hrProvider.submitAction(
      authTableName: "PY_VCNC_RET_H", // --- Table name for Resume Work ---
      authPk1: request.empCode.toString(),
      authPk2: request.serialPyv.toString(), // Key change
      usersCode: authProvider.currentUser!.usersCode,
      authFlag: authFlag,
      fileSerial: 8,
      systemNumber: 63,
      authChain: hrProvider.resumeWorkAuthDetails?.items ?? [],
      usersDesc: _statementController.text.isEmpty
          ? (authFlag == 1 ? l10n.approved : l10n.rejected)
          : _statementController.text,

    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.actionSuccess), backgroundColor: Colors.green));
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hrProvider.actionError ?? l10n.actionFailed), backgroundColor: Colors.red));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resumeWorkRequestDetails),
        actions: const [LanguageSwitcherButton()],
      ),
      body: Consumer<HrProvider>(
        builder: (context, hrProvider, child) {
          final request = hrProvider.selectedResumeWorkRequest;

          return Stack(
            children: [
              if (request != null)
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRequestInfoCard(context, request, isArabic, l10n),
                      const SizedBox(height: 20),
                      _buildAuthDetailsTab(hrProvider),
                      const SizedBox(height: 20),
                      if (request.aproveFlag == 0) // Only show actions if pending
                        _buildActionCard(context, hrProvider),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              if (hrProvider.isLoading && request == null)
                const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0)),

              if (!hrProvider.isLoading && request == null)
                Center(child: Text(l10n.noDataAvailable)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRequestInfoCard(BuildContext context, ResumeWorkRequestItem request, bool isArabic, AppLocalizations l10n) {
    final empName = isArabic ? request.empName : (request.empNameE ?? request.empName);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(empName ?? l10n.notSpecified, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
            const Divider(height: 24),
            _buildInfoRow(l10n.vacationStartDate, _formatDate(request.fDate), Icons.calendar_today_outlined),
            _buildInfoRow(l10n.vacationEndDate, _formatDate(request.tDate), Icons.calendar_today_outlined),
            _buildInfoRow(l10n.resumeWorkDate, _formatDate(request.actTDate), Icons.check_circle_outline, color: AppColors.primaryColor),
            if (request.lateReason != null && request.lateReason!.isNotEmpty)
              _buildInfoRow(l10n.delayReason, request.lateReason!, Icons.notes_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color ?? AppColors.textColor.withOpacity(0.6), size: 20),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.5,
              color: AppColors.textColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.5,
                color: color ?? AppColors.textColor.withOpacity(0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthDetailsTab(HrProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    if (provider.isLoading && provider.resumeWorkAuthDetails == null) {
      return const Center(
        heightFactor: 5,
        child: SpinKitFadingCircle(color: AppColors.primaryColor),
      );
    }

    final authItems = provider.resumeWorkAuthDetails?.items;

    if (authItems == null || authItems.isEmpty) {
      return Center(
        heightFactor: 5,
        child: Text(l10n.noRegisteredApprovals),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            l10n.approvalChain,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AuthTimeline(authItems: authItems),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, HrProvider hrProvider) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(l10n.takeAction, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _statementController,
              decoration: InputDecoration(
                labelText: l10n.notesOptional,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            if (hrProvider.actionError != null) ...[
              Text(hrProvider.actionError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: hrProvider.isLoading ? null : () => _submitAction(-1),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                    child: Text(l10n.reject),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: hrProvider.isLoading ? null : () => _submitAction(1),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                    child: Text(l10n.approve),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/


// lib/features/resume_work/screens/resume_work_request_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../models/resume_work_auth_model.dart';
import '../models/resume_work_request_model.dart';
import '../../../core/providers/hr_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/app_colors.dart';

class ResumeWorkRequestDetailsScreen extends StatefulWidget {
  static const String routeName = '/resume-work-request-details';
  const ResumeWorkRequestDetailsScreen({super.key});

  @override
  State<ResumeWorkRequestDetailsScreen> createState() => _ResumeWorkRequestDetailsScreenState();
}

class _ResumeWorkRequestDetailsScreenState extends State<ResumeWorkRequestDetailsScreen> {
  final TextEditingController _statementController = TextEditingController();
  int _activeAuthStep = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hrProvider = Provider.of<HrProvider>(context, listen: false);
      if (hrProvider.selectedResumeWorkRequest != null) {
        hrProvider.loadResumeWorkAuthDetails();
      }
    });
  }

  void _showActionDialog(BuildContext context, ResumeWorkRequestItem request) {
    final l10n = AppLocalizations.of(context)!;
    _statementController.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (builderContext, setDialogState) {
            final provider = Provider.of<HrProvider>(context, listen: true);
            final isProcessing = provider.isSubmittingAction;

            return AlertDialog(
              title: Text(l10n.resumeWorkActionDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isProcessing)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(l10n.submittingAction),
                        ],
                      ),
                    )
                  else
                    TextFormField(
                      controller: _statementController,
                      decoration: InputDecoration(
                        labelText: l10n.statementLabel,
                        hintText: l10n.statementHint,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              actions: <Widget>[
                if (isProcessing)
                  const SizedBox(height: 52)
                else
                  Row(
                    children: <Widget>[
                      TextButton(
                        child: Text(l10n.cancel),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorColor),
                        onPressed: () => _submitAction(-1, dialogContext, request),
                        child: Text(l10n.reject, style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.successColor),
                        onPressed: () => _submitAction(1, dialogContext, request),
                        child: Text(l10n.approve, style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitAction(int authFlag, BuildContext dialogContext, ResumeWorkRequestItem request) async {
    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    final success = await hrProvider.submitAction(
      usersCode: authProvider.currentUser!.usersCode,
      usersDesc: _statementController.text,
      authFlag: authFlag,
      authTableName: 'PY_VCNC_RET_H',
      authPk1: request.empCode.toString(),
      authPk2: request.serialPyv.toString(),
      authChain: hrProvider.resumeWorkAuthDetails?.items ?? [],
      systemNumber: 63,
      fileSerial: 8,
    );
    if (!mounted) return;

    if (success) {
      Navigator.of(dialogContext).pop();
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(hrProvider.actionError ?? l10n.anErrorOccurred), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<HrProvider>(
      builder: (context, hrProvider, child) {
        final request = hrProvider.selectedResumeWorkRequest;
        if (request == null) {
          return Scaffold(
              appBar: AppBar(), body: Center(child: Text(l10n.noRequestSelected)));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.resumeWorkRequestDetails),
            backgroundColor: AppColors.primaryColor,
            actions: const [
              LanguageSwitcherButton(),
              SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(request),
                  const SizedBox(height: 10),
                  Center(child: Tab(text: l10n.approvals, icon: const Icon(Icons.playlist_add_check_circle_rounded))),
                  _buildAuthDetailsTab(hrProvider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard(ResumeWorkRequestItem request) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    final empName = isArabic ? request.empName : (request.empNameE ?? request.empName);

    return Card(
      margin: const EdgeInsets.all(4.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.requestFor(empName ?? l10n.unknownUser),
              style: const TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold, color: AppColors.primaryColor, height: 1.4),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(l10n.vacationStartDate, _formatDate(request.fDate, "yyyy-MM-dd")),
            _buildDetailRow(l10n.vacationEndDate, _formatDate(request.tDate, "yyyy-MM-dd")),
            _buildDetailRow(l10n.resumeWorkDate, _formatDate(request.actTDate, "yyyy-MM-dd")),
            if (request.lateReason != null && request.lateReason!.isNotEmpty)
              _buildDetailRow(l10n.delayReason, request.lateReason!),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.gavel_rounded),
                label: Text(l10n.takeAction, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: () => _showActionDialog(context, request),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: AppColors.textColor)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 14.5, color: AppColors.textColor.withOpacity(0.75)))),
        ],
      ),
    );
  }

  Widget _buildAuthDetailsTab(HrProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    if (provider.isLoading && provider.resumeWorkAuthDetails == null) {
      return const Center(heightFactor: 5, child: SpinKitFadingCircle(color: AppColors.primaryColor));
    }
    final authItems = provider.resumeWorkAuthDetails?.items;
    if (authItems == null || authItems.isEmpty) {
      return Center(heightFactor: 5, child: Text(l10n.noRegisteredApprovalsForRequest));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(l10n.approvalChain, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
        ),
        _buildAuthTimeline(authItems),
      ],
    );
  }

  Widget _buildAuthTimeline(List<ResumeWorkAuthItem> authItems) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: List.generate(authItems.length, (index) {
          final item = authItems[index];
          final bool isActiveStep = (index == _activeAuthStep);
          bool isCompleted = item.authFlag == 1;
          bool isRejected = item.authFlag == -1;
          IconData stepIconData;
          Color stepColor;

          Color precedingLineColor = AppColors.hintColor.withOpacity(0.4);
          if (index > 0) {
            if (authItems[index - 1].authFlag == 1) precedingLineColor = AppColors.successColor;
            else if (authItems[index - 1].authFlag == -1) precedingLineColor = AppColors.errorColor;
          }

          Color succeedingLineColor = AppColors.hintColor.withOpacity(0.4);
          if (isCompleted) {
            stepIconData = Icons.check_circle_rounded;
            stepColor = AppColors.successColor;
            succeedingLineColor = AppColors.successColor;
          } else if (isRejected) {
            stepIconData = Icons.cancel_rounded;
            stepColor = AppColors.errorColor;
            succeedingLineColor = AppColors.errorColor;
          } else {
            stepIconData = Icons.pending_actions_rounded;
            stepColor = isActiveStep ? AppColors.primaryColor : AppColors.hintColor.withOpacity(0.8);
          }

          final usersName = isArabic ? item.usersName : (item.usersNameE ?? item.usersName);
          final jobDesc = isArabic ? item.jobDesc : (item.jobDescE ?? item.jobDesc);

          return InkWell(
            onTap: () { if (mounted) setState(() => _activeAuthStep = index); },
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      if (index > 0) Expanded(child: Container(width: 2.5, color: precedingLineColor)),
                      Container(height: 30, width: 30, alignment: Alignment.center, child: Icon(stepIconData, color: stepColor, size: isActiveStep ? 28 : 24)),
                      if (index < authItems.length - 1) Expanded(child: Container(width: 2.5, color: succeedingLineColor)),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: index < authItems.length - 1 ? 10 : 0, top: 5),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: isActiveStep ? AppColors.primaryColor.withOpacity(0.05) : Colors.grey.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: isActiveStep ? AppColors.primaryColor.withOpacity(0.5) : Colors.grey.withOpacity(0.3), width: isActiveStep ? 1.0 : 0.7)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(usersName ?? l10n.unknownUser, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isActiveStep ? AppColors.primaryColor : AppColors.textColor)),
                          if (jobDesc != null && jobDesc.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(jobDesc, style: TextStyle(fontSize: 12, color: AppColors.textColor.withOpacity(0.75))),
                          ],
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text('${l10n.dateLabel} ${_formatDate(item.authDate, "dd-MM-yyyy hh:mm a")}', style: TextStyle(fontSize: 11.5, color: AppColors.textColor.withOpacity(0.65))),
                              const Spacer(),
                              Text(_getAuthStatusText(item.authFlag), style: TextStyle(fontSize: 12, color: stepColor, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          if (item.usersDesc != null && item.usersDesc!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
                              child: Text('${l10n.notesLabel} ${item.usersDesc}', style: TextStyle(fontSize: 12, color: AppColors.textColor.withOpacity(0.85), fontStyle: FontStyle.italic)),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getAuthStatusText(int? authFlag) {
    final l10n = AppLocalizations.of(context)!;
    switch (authFlag) {
      case 1: return l10n.approved;
      case -1: return l10n.rejected;
      default: return l10n.underAction;
    }
  }

  String _formatDate(String? dateString, String format) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    if (dateString == null) return l10n.notSpecified;
    try {
      if (format == "yyyy-MM-dd") {
        return DateFormat.yMd(localeProvider.locale.toLanguageTag()).format(DateTime.parse(dateString));
      }
      return DateFormat.yMd(localeProvider.locale.toLanguageTag()).add_jm().format(DateFormat(format, "en_US").parse(dateString));
    } catch (e) {
      return dateString;
    }
  }
}