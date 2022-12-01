import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_reports_generator/src/configs.dart';


class PdfGenerator{
  // header
  //    - doc info(type; invoice, total, id)
  //    - extra(client details)

  // body
  //    - content
  //    - summary

  static Future<pw.Document> generator({
    required DocumentType documentType, required PdfPageFormat pageFormat,
    HeaderItems? headerInfo, HeaderItems? headerExtras,
    List<pw.Widget>? body,
  })async{
    final doc = pw.Document();
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/LOGO.JPG')).buffer.asUint8List(),
    );

    doc.addPage(
      pw.MultiPage(
        maxPages: 1000,
        pageTheme: await _myPageTheme(pageFormat),
        header: (_headerContext) {
          return _buildHeader(logo, showAll: _headerContext.pageNumber ==1, documentType: documentType, headerInfo: headerInfo, headerExtras: headerExtras);
        },
        footer: (_footerContext) {
          return pw.Column(
            children: [
              pw.SizedBox(height: 20),
                pw.Container(
                  height: 10,
                  width: double.infinity,
                  color: primaryColorAccent
                ),
                if(_footerContext.pagesCount > 1 ) pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('Page ${_footerContext.pageNumber} of ${_footerContext.pagesCount}'),
                )

            ],
          );
        },
        build: (context){
          return [
            if(body != null) ...body,
          ];
        }
      )
    );

    return doc;
  }

  static pw.Widget _buildHeader(pw.ImageProvider logo, {required DocumentType documentType, HeaderItems? headerInfo, HeaderItems? headerExtras, bool showAll = true}){
    String _documentType = (){
      switch (documentType) {
        case DocumentType.invoice:
            return 'INVOICE'; 
       case DocumentType.deliveryNote:
            return 'DELIVERY NOTE';
        case DocumentType.quotation:
            return 'QUOTATION';
        case DocumentType.reports:
            return 'REPORTS';
        default:
        return 'Document';
      }
    }.call();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // header details; header info, extras. logo
          if(showAll) pw.Row(
            children: [
              // 1st doc about
              pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // document type
                  pw.Text(_documentType, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 21, color: primaryColor)),
                  pw.SizedBox(height: 14),

                  // headers
                  if(documentType == DocumentType.invoice ||documentType == DocumentType.quotation) pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 1), child: pw.Text('From')),
                  if(headerInfo?.title != null)
                    pw.Text(headerInfo!.title!, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15)),
                  
                  if(headerInfo?.items != null)
                    for(var _headerItem in headerInfo!.items)
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 1),
                        child: pw.Text(_headerItem, style: const pw.TextStyle(fontSize: 12))
                      ),


                ] 
              ),
              pw.SizedBox(width: 15),

              // 2nd doc extra info
              pw.Expanded(child: pw.Center(child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if(headerExtras != null) pw.SizedBox(height: 39),
                  if(documentType == DocumentType.invoice ||documentType == DocumentType.quotation) pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 1), child: pw.Text('For')),
                  if(headerExtras?.title != null)
                    pw.Text(headerExtras!.title!, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15)),
                  
                  if(headerExtras?.items != null)
                    for(var _headerItem in headerExtras!.items)
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 1),
                        child: pw.Text(_headerItem, style: const pw.TextStyle(fontSize: 12))
                      ),
                ]
              ))),

              // 3rd logo
              pw.Container(
                // alignment: pw.Alignment.topRight,
                margin: const pw.EdgeInsets.only(top: 35),
                height: 100,
                child: pw.Image(logo)
              )
            ]
          ),

          // document  description
          if(headerInfo?.descriptionItems != null)
          pw.Divider(height: 20, color: PdfColor.fromHex('#808080')),
          if(headerInfo?.descriptionItems != null)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5),
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                for(var _des in headerInfo!.descriptionItems)
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 3),
                    child: pw.Text(_des.value, style: pw.TextStyle(fontSize: _des.bold ? 14 : 12, fontWeight: _des.bold ? pw.FontWeight.bold : null))
                  ),
              ]
            ),
          )
        ]
      ),
    );
  }

  static Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {

  format = format.applyMargin(
      left: 2.0 * PdfPageFormat.cm,
      top: 0.0 * PdfPageFormat.cm,
      right: 2.0 * PdfPageFormat.cm,
      bottom: 0 * PdfPageFormat.cm);
  return pw.PageTheme(
    pageFormat: format,
  );
}
}

class HeaderItems {
  HeaderItems({this.title, this.items = const [], this.descriptionItems = const []});
  String? title;
  List<String> items;
  List<DescriptionItems> descriptionItems;
}

class DescriptionItems {
  DescriptionItems(this.value, [this.bold = false]);
  String value;
  bool bold;
}

extension StringToDescription on String{
  DescriptionItems toDescriptionItems([bool bold = false]){
    return DescriptionItems(this, bold);
  }
}

enum DocumentType{
  invoice, quotation, reports,deliveryNote
}