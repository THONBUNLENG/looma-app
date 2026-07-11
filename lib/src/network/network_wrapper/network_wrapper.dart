import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../widget/text_widget.dart';

class NetworkWrapper extends StatefulWidget {
  final Widget child;

  const NetworkWrapper({super.key, required this.child});

  @override
  State<NetworkWrapper> createState() => _NetworkWrapperState();
}

class _NetworkWrapperState extends State<NetworkWrapper> {
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _hasConnection = true;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
    _manualCheck();
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final hasConnection = !results.contains(ConnectivityResult.none);
    if (!mounted) return;
    setState(() {
      _hasConnection = hasConnection;
      _isChecking = false;
    });
  }

  Future<void> _manualCheck() async {
    if (!mounted) return;
    setState(() => _isChecking = true);
    await Future.delayed(const Duration(seconds: 8));
    final results = await Connectivity().checkConnectivity();
    if (!mounted) return;
    _updateConnectionStatus(results);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(absorbing: !_hasConnection, child: widget.child),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _hasConnection
              ? const SizedBox.shrink()
              : _OfflineView(isChecking: _isChecking, onRetry: _manualCheck),
        ),
      ],
    );
  }
}

class _OfflineView extends StatelessWidget {
  final bool isChecking;
  final VoidCallback onRetry;

  const _OfflineView({required this.isChecking, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.88),
      child: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/no_connection.json',
                  width: 260,
                  height: 260,
                  fit: BoxFit.contain,
                ),

                if (isChecking) ...[
                  const SizedBox(height: 10),
                  Lottie.asset(
                    'assets/lottie/loading.json',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  TextWidget(
                    "Checking connection...",
                    color: Colors.white70,
                    fontSize: 14,
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: 18),

                TextWidget(
                  "Lost internet connection",
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                TextWidget(
                  "Please check your network and try again",
                  color: Colors.white70,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isChecking ? null : onRetry,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: TextWidget(
                      isChecking ? "Checking ..." : "Try again",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
