import 'package:pdf_reports_generator/src/pdf_generator.dart';

import 'package:pdf/widgets.dart';

abstract class PdfTemplate {
  late DocumentType documentType;

  HeaderItems? headerInfo;
  HeaderItems? headerExtras;

  List<Widget> get body;


}

