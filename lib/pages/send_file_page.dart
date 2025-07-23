import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_server/http_server.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:file_selector/file_selector.dart';


class SendFilePage extends StatefulWidget {
  const SendFilePage({super.key});

  @override
  State<SendFilePage> createState() => _SendFilePageState();
}

class _SendFilePageState extends State<SendFilePage> {
  File? selectedFile;
  String? downloadLink;
  HttpServer? _server;

  Future<void> _pickFile() async {
    final XFile? file = await openFile();

    if (file != null) {
      final pickedFile = File(file.path);
      setState(() => selectedFile = pickedFile);

      await _startFileServer(pickedFile);
    } else {
      print('User canceled file picker.');
    }
  }



  Future<void> _startFileServer(File file) async {
    // Close previous server if running
    await _server?.close(force: true);

    final ip = await _getLocalIp();
    final port = 8000;
    final fileName = p.basename(file.path);

    final virtualDir = VirtualDirectory(file.parent.path);
    _server = await HttpServer.bind(ip, port);
    virtualDir.serve(_server!);

    setState(() {
      downloadLink = 'http://$ip:$port/$fileName';
    });

    debugPrint('Serving file at: $downloadLink');
  }

  Future<String> _getLocalIp() async {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );
    return interfaces.first.addresses.first.address;
  }

  @override
  void dispose() {
    _server?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send File via QR',style: TextStyle(fontSize: 23,fontWeight: FontWeight.w600))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.folder_open),
                label: const Text('Pick File',style: TextStyle(fontSize: 18)),
                onPressed: _pickFile,
              ),
              const SizedBox(height: 24),
              if (downloadLink != null) ...[
                const Text('Scan this QR to download file:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                QrImageView(
                  data: downloadLink!,
                  size: 250,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 12),
                SelectableText(downloadLink!, textAlign: TextAlign.center),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
