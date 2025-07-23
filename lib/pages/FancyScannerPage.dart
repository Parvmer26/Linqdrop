import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class FancyScannerPage extends StatefulWidget {
  const FancyScannerPage({super.key});

  @override
  State<FancyScannerPage> createState() => _FancyScannerPageState();
}

class _FancyScannerPageState extends State<FancyScannerPage> with SingleTickerProviderStateMixin {
  bool _isScanned = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isScanned) return;
    final barcode = capture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code != null) {
      setState(() => _isScanned = true);
      Fluttertoast.showToast(msg: "Scanned: $code");

      final Uri? uri = Uri.tryParse(code);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Fluttertoast.showToast(msg: "Scanned text: $code");
      }

      Future.delayed(const Duration(seconds: 4), () {
        setState(() => _isScanned = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview
          MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              facing: CameraFacing.back,
              torchEnabled: false,
            ),
            onDetect: _onDetect,
          ),

          // Scanner frame with bouncing scan line
          Center(
            child: SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                children: [
                  // Frame
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.8),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),

                  // Bouncing scan line
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment(0, (_animationController.value * 2) - 1),
                        child: child,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scanning text
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Text(
              _isScanned ? "QR Detected" : "Align QR within the frame",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.95),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
