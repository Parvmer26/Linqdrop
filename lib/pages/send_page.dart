import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  final TextEditingController _controller = TextEditingController();
  String? _qrData;

  void _generateQR() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _qrData = text;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter some text or link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send via QR',style: TextStyle(fontSize: 23,fontWeight: FontWeight.w600))),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter link or text',
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateQR,
              child: const Text('Generate QR Code',style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),
            if (_qrData != null)
              QrImageView(
                data: _qrData!,
                version: QrVersions.auto,
                size: 250.0,
                backgroundColor: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
