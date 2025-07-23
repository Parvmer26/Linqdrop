import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';           // for clipboard
import 'package:share_plus/share_plus.dart';

import 'FancyScannerPage.dart';      // for sharing

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  String? scannedData;
  bool isScanned = false;

  void _onDetect(BarcodeCapture capture) async {
    if (isScanned) return;

    final Barcode? barcode = capture.barcodes.first;
    final String? code = barcode?.rawValue;

    if (code != null && code.isNotEmpty) {
      print('Scanned: $code');

      setState(() {
        scannedData = code;
        isScanned = true;
      });

      Fluttertoast.showToast(
        msg: Uri.tryParse(code)?.hasScheme == true
            ? "Link opened!"
            : "Text received!",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );

      final Uri? uri = Uri.tryParse(code);
      if (uri != null && (uri.hasScheme || uri.hasAbsolutePath)) {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          print('Could not launch: $uri');
        }
      } else {
        print('Invalid URI');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR to Receive')),
      body: isScanned
          ? Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 20),
            const Text('Received:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            SelectableText(
              scannedData ?? '',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: scannedData!));
                    Fluttertoast.showToast(
                      msg: "Copied to clipboard!",
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  onPressed: () async {
                    if (scannedData != null && scannedData!.trim().isNotEmpty) {
                      try {
                        await Share.share(
                          scannedData!,
                          subject: 'Shared via Linqdrop',
                        );
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: 'Share failed: $e',
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Nothing to share",
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                ),

              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  scannedData = null;
                  isScanned = false;
                });
              },
              icon: const Icon(Icons.restart_alt),
              label: const Text('Scan Again'),
            ),
          ],
        ),
      )
          :  Center(
    // child: ElevatedButton.icon(
    // icon: Icon(Icons.qr_code_scanner),
    // label: Text("Open Fancy Scanner"),
    // onPressed: () {
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>FancyScannerPage()));
    // },
    // ),
    )

    );
  }
}
