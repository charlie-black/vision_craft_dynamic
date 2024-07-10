import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPDFScreen extends StatefulWidget {
  final ModuleItem moduleItem;
  final String documentUrl;
  const ViewPDFScreen(
      {super.key, required this.moduleItem, required this.documentUrl});

  @override
  State<ViewPDFScreen> createState() => _ViewPDFScreenState();
}

class _ViewPDFScreenState extends State<ViewPDFScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(widget.moduleItem.moduleName),
      ),
      body: SfPdfViewer.network(
        widget.documentUrl,
        canShowPageLoadingIndicator: true,
      ));
}
