import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class pdfViewerScreenLawyer extends StatefulWidget {
  var pdfUrl;
  pdfViewerScreenLawyer(
    this.pdfUrl,
  );
  @override
  State<pdfViewerScreenLawyer> createState() => _pdfViewerScreenLawyerState(pdfUrl);
}

class _pdfViewerScreenLawyerState extends State<pdfViewerScreenLawyer> {
  var pdfUrl;
  _pdfViewerScreenLawyerState(
    this.pdfUrl,
  );
  PDFDocument? document;
  void initializePdf()async{
    document=await PDFDocument.fromURL(pdfUrl);
    setState(() {
      
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    initializePdf();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: document!=null?
      PDFViewer(document: document!):
      Center(child: CircularProgressIndicator())
    );
  }
}