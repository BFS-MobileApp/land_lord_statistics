import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
              if (_documentBytes != null) {
                try {
                  // Let user pick a directory — SAF-compliant
                  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

                  if (selectedDirectory != null) {
                    final filePath = '$selectedDirectory/${widget.name}.pdf';
                    File file = File(filePath);
                    await file.writeAsBytes(_documentBytes!, flush: true);
                    print('PDF saved at: $filePath');
                    OpenFile.open(filePath);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('PDF saved to: $filePath')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No directory selected')),
                    );
                  }
                } catch (e) {
                  final errorMessage = e.toString();
                  print('Saving error: $errorMessage');

                  // Suppress specific benign errors
                  if (!errorMessage.contains('Access is denied')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Error saving PDF: $errorMessage')),
                    );
                  }
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PDF not loaded yet')),
                );
              }
            },




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
