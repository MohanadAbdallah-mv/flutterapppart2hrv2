// lib/features/permissions/screens/permission_request_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../models/permission_auth_model.dart';
import '../models/permission_request_model.dart';
import '../../approvals/widgets/auth_timeline_widget.dart';

import '../../../core/providers/hr_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/app_colors.dart';

class PermissionRequestDetailsScreen extends StatefulWidget {
  static const String routeName = '/permission-request-details';
  const PermissionRequestDetailsScreen({super.key});

  @override
  State<PermissionRequestDetailsScreen> createState() => _PermissionRequestDetailsScreenState();
}

class _PermissionRequestDetailsScreenState extends State<PermissionRequestDetailsScreen> {
  final TextEditingController _statementController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HrProvider>(context, listen: false).loadPermissionAuthDetails();
    });
  }

  @override
  void dispose() {
    _statementController.dispose();
    super.dispose();
  }

  String _getPermissionTypeName(BuildContext context, int? type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 1: return l10n.permissionType1;
      case 2: return l10n.permissionType2;
      case 3: return l10n.permissionType3;
      case 4: return l10n.permissionType4;
      default: return l10n.notSpecified;
    }
  }

  String _getReasonTypeName(BuildContext context, int? type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 1: return l10n.reasonType1;
      case 2: return l10n.reasonType2;
      case 3: return l10n.reasonType3;
      default: return l10n.notSpecified;
    }
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

  String _formatTime(String? timeString) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    if (timeString == null) return AppLocalizations.of(context)!.notSpecified;
    try {
      return DateFormat.jm(locale).format(DateTime.parse(timeString));
    } catch (e) {
      return timeString;
    }
  }

  void _showActionDialog(BuildContext context, PermissionRequestItem request) {
    final l10n = AppLocalizations.of(context)!;
    _statementController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (builderContext, setDialogState) {
            final provider = Provider.of<HrProvider>(context, listen: true);
            final isProcessing = provider.isLoading;

            return AlertDialog(
              title: Text(l10n.vacationActionDialogTitle),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorColor,
                        ),
                        onPressed: () => _submitAction(-1, dialogContext, request),
                        child: Text(
                          l10n.reject,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.successColor,
                        ),
                        onPressed: () => _submitAction(1, dialogContext, request),
                        child: Text(
                          l10n.approve,
                          style: const TextStyle(color: Colors.white),
                        ),
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

  Future<void> _submitAction(
      int authFlag,
      BuildContext dialogContext,
      PermissionRequestItem request,
      ) async {
    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    if (authProvider.currentUser == null) return;

    final bool success = await hrProvider.submitAction(
      authTableName: "PY_ORDER_PRM_H",
      authPk1: request.empCode.toString(),
      authPk2: request.serial.toString(),
      usersCode: authProvider.currentUser!.usersCode,
      authFlag: authFlag,
      systemNumber: 63,
      fileSerial: 3,
      usersDesc: _statementController.text.isEmpty
          ? (authFlag == 1 ? l10n.approved : l10n.rejected)
          : _statementController.text,
      authChain: hrProvider.permissionAuthDetails?.items ?? [],
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(dialogContext).pop();
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(hrProvider.error ?? l10n.actionFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.permissionRequestDetails),
        backgroundColor: AppColors.primaryColor,
        actions: const [
          LanguageSwitcherButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Consumer<HrProvider>(
        builder: (context, hrProvider, child) {
          final request = hrProvider.selectedPermissionRequest;

          if (request == null) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(l10n.noDataAvailable)),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(request),
                  const SizedBox(height: 10),
                  Center(
                    child: Tab(
                      text: l10n.approvals,
                      icon: const Icon(Icons.playlist_add_check_circle_rounded),
                    ),
                  ),
                  _buildAuthDetailsTab(hrProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(PermissionRequestItem request) {
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
              style: const TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              l10n.permissionTypeLabel,
              _getPermissionTypeName(context, request.trnsType),
            ),
            _buildDetailRow(
              l10n.reasonTypeLabel,
              _getReasonTypeName(context, request.trnsType),
            ),
            _buildDetailRow(
              l10n.permissionDateLabel,
              _formatDate(request.prmDate),
            ),
            _buildDetailRow(
              l10n.permissionTimeLabel,
              "${_formatTime(request.fromTime)} - ${_formatTime(request.toTime)}",
            ),
            if (request.permReasons != null && request.permReasons!.isNotEmpty)
              _buildDetailRow(l10n.reasonsLabel, request.permReasons!),
            const SizedBox(height: 16),
            if (request.aproveFlag == 0)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.gavel_rounded),
                  label: Text(
                    l10n.takeAction,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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
          Text(
            '$label ',
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
                color: AppColors.textColor.withOpacity(0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthDetailsTab(HrProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    if (provider.isLoading && provider.permissionAuthDetails == null) {
      return const Center(
        heightFactor: 5,
        child: SpinKitFadingCircle(color: AppColors.primaryColor),
      );
    }

    final authItems = provider.permissionAuthDetails?.items;

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
              color: AppColors.primaryColor,
            ),
          ),
        ),
        AuthTimeline(authItems: authItems),
      ],
    );
  }
}