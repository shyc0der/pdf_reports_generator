library pdf_reports_generator;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf_reports_generator/src/pdf_generator.dart';
import 'package:pdf_reports_generator/src/pdf_template.dart';

export 'package:pdf/pdf.dart';
export 'package:pdf/widgets.dart';
export 'package:pdf_reports_generator/src/pages/invoice_widget.dart';
export 'package:pdf_reports_generator/src/pages/delivery_note_widget.dart';
export 'package:pdf_reports_generator/src/pages/quotation_widget.dart';
export 'package:pdf_reports_generator/src/pages/reports_page.dart';
export 'package:pdf_reports_generator/src/pdf_template.dart';

class PdfGenerate {

  static Future<Document> generate(PdfTemplate pdfTemplate, {PdfPageFormat pageFormat = PdfPageFormat.a4})async{
    return PdfGenerator.generator(
          pageFormat: pageFormat,
          documentType: pdfTemplate.documentType,
          headerInfo: pdfTemplate.headerInfo,
          headerExtras: pdfTemplate.headerExtras,
          body: pdfTemplate.body,
        );
  }
}