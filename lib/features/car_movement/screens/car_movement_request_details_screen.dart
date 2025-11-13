// lib/features/car_movement/screens/car_movement_request_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../models/car_movement_auth_model.dart';
import '../models/car_movement_request_model.dart';
import '../../../core/providers/hr_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/app_colors.dart';

class CarMovementRequestDetailsScreen extends StatefulWidget {
  static const String routeName = '/car-movement-request-details';
  const CarMovementRequestDetailsScreen({super.key});

  @override
  State<CarMovementRequestDetailsScreen> createState() => _CarMovementRequestDetailsScreenState();
}

class _CarMovementRequestDetailsScreenState extends State<CarMovementRequestDetailsScreen> {
  final TextEditingController _statementController = TextEditingController();
  int _activeAuthStep = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hrProvider = Provider.of<HrProvider>(context, listen: false);
      if (hrProvider.selectedCarMovementRequest != null) {
        hrProvider.loadCarMovementAuthDetails();
      }
    });
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

  void _showActionDialog(BuildContext context, CarMovementRequestItem request) {
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
              title: Text(l10n.carMovementActionDialogTitle),
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

  Future<void> _submitAction(int authFlag, BuildContext dialogContext, CarMovementRequestItem request) async {
    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    final success = await hrProvider.submitAction(
      usersCode: authProvider.currentUser!.usersCode,
      usersDesc: _statementController.text,
      authFlag: authFlag,
      authTableName: 'PY_ORDER_CAR_H',
      authPk1: request.empCode.toString(),
      authPk2: request.serial.toString(),
      authChain: hrProvider.carMovementAuthDetails?.items ?? [],
      systemNumber: 63,
      fileSerial: 11,
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
        final request = hrProvider.selectedCarMovementRequest;
        if (request == null) {
          return Scaffold(
              appBar: AppBar(), body: Center(child: Text(l10n.noRequestSelected)));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.carMovementRequestDetails),
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

  Widget _buildHeaderCard(CarMovementRequestItem request) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    final empName = isArabic ? request.empName : (request.empNameE ?? request.empName);
    final permissionType = _getPermissionTypeName(context, request.trnsType);

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
            _buildDetailRow(l10n.carNoLabel, request.carNo ?? l10n.notSpecified),
            _buildDetailRow(l10n.permissionTypeLabel, permissionType),
            _buildDetailRow(l10n.permissionDateLabel, _formatDate(request.prmDate, "yyyy-MM-dd")),
            _buildDetailRow(l10n.permissionTimeLabel, '${_formatTime(request.fromTime)} - ${_formatTime(request.toTime)}'),
            if (request.permReasons != null && request.permReasons!.isNotEmpty)
              _buildDetailRow(l10n.reasonsLabel, request.permReasons!),
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
    if (provider.isLoading && provider.carMovementAuthDetails == null) {
      return const Center(heightFactor: 5, child: SpinKitFadingCircle(color: AppColors.primaryColor));
    }
    final authItems = provider.carMovementAuthDetails?.items;
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

  Widget _buildAuthTimeline(List<CarMovementAuthItem> authItems) {
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

  String _formatTime(String? timeString) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    if (timeString == null) return l10n.notSpecified;
    try {
      return DateFormat.jm(localeProvider.locale.toLanguageTag()).format(DateTime.parse(timeString));
    } catch (e) {
      return timeString;
    }
  }
}