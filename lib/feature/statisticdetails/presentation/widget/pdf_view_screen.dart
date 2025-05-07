import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewScreen extends StatefulWidget {
  final String pdfUrl;
  final String name;
   const PdfViewScreen({super.key, required this.pdfUrl, required this.name});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  List<int>? _documentBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:  Text(widget.name),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.black,
            ),
              onPressed: () async {
                var status = await Permission.storage.request();
                if (status.isGranted) {
                  if (_documentBytes != null) {
                    try {
                      Directory? directory = await getExternalStorageDirectory();
                      String path = directory!.path;
                      File file = File('$path/${widget.name}.pdf');
                      await file.writeAsBytes(_documentBytes!, flush: true);
                      print('PDF saved at: $path/${widget.name}.pdf');
                      OpenFile.open(file.path);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('PDF saved to: $path')),
                      );
                    } catch (e) {
                      print('Saving error: $e');
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Storage permission denied')),
                  );
                }
              }


          ),
        ],
      ),
      body: SfPdfViewer.network(widget.pdfUrl,
        key: _pdfViewerKey,
        onDocumentLoaded: (PdfDocumentLoadedDetails details){
        _documentBytes = details.document.saveSync();
        },
      ),
    );
  }
}
