// lib/features/attendance/screens/check_in_out_map_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutterapppart2hr/features/attendance/providers/attendance_provider.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';

import '../../../core/utils/app_colors.dart';



class CheckInOutMapScreen extends StatefulWidget {
  final String checkType; // 'I' for In, 'O' for Out

  const CheckInOutMapScreen({super.key, required this.checkType});

  @override
  State<CheckInOutMapScreen> createState() => _CheckInOutMapScreenState();
}

class _CheckInOutMapScreenState extends State<CheckInOutMapScreen> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    try {
      final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await attendanceProvider.fetchCompanyLocation(789);
      final userPosition = await attendanceProvider.getCurrentLocationWithPermissions();

      if(mounted) {
        setState(() {
          _userLocation = LatLng(userPosition.latitude, userPosition.longitude);
          _isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_userLocation != null) {
            _mapController.move(_userLocation!, 16.0);
          }
        });
      }

    } catch (e) {
      if(mounted) {
        setState(() {
          _error = e.toString().replaceFirst("Exception: ", "");
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onFingerprintPressed() async {
    final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    bool success = await attendanceProvider.performCheckInOut(
      attType: widget.checkType,
      empCode: 789//authProvider.currentUser!.empCode,
      ,compEmpCode:789 //authProvider.currentUser!.compEmpCode,
    );

    if(!mounted) return;

    if (success) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Icon(Icons.check_circle_outline, color: AppColors.successColor, size: 50),
          content: Text(
            widget.checkType == 'I' ? l10n.checkInSuccess : l10n.checkOutSuccess,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [TextButton(child: Text(l10n.ok), onPressed: () => Navigator.of(ctx).pop())],
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(attendanceProvider.actionError ?? l10n.unexpectedError),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.checkType == 'I' ? l10n.checkIn : l10n.checkOut),
        backgroundColor: AppColors.primaryColor,
        actions: const [
          LanguageSwitcherButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          if (_isLoading) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50));
          }
          if (_error != null) {
            return _buildErrorWidget();
          }

          final companyLocationInfo = provider.companyLocationInfo;
          List<Marker> markers = [];

          if (_userLocation != null) {
            markers.add(
              Marker(
                width: 80.0,
                height: 80.0,
                point: _userLocation!,
                child: const Icon(Icons.person_pin_circle, color: AppColors.accentColor, size: 40),
              ),
            );
          }

          if (companyLocationInfo != null && companyLocationInfo.lat != null && companyLocationInfo.lon != null) {
            markers.add(
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(companyLocationInfo.lat!, companyLocationInfo.lon!),
                child: const Icon(Icons.business, color: Colors.red, size: 40),
              ),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _userLocation ?? const LatLng(24.1, 45.2), // Default location
                  initialZoom: 16.0,
                  maxZoom: 18,
                  minZoom: 3,
                ),
                children: [
                  TileLayer(
                    // --== THIS IS THE FIX ==--
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.ascon.hr',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: provider.isActionInProgress
                      ? const SpinKitFadingCircle(color: Colors.white, size: 50 )
                      : GestureDetector(
                    onTap: _onFingerprintPressed,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)
                        ],
                      ),
                      child: const Icon(Icons.fingerprint, color: Colors.white, size: 60),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 20),
            Text(l10n.errorOccurred, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("$_error", textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
              onPressed: _initializeScreen,
            )
          ],
        ),
      ),
    );
  }
}
