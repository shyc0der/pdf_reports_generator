import 'package:pdf/widgets.dart';
import 'package:pdf_reports_generator/src/pages/reports_page.dart';
import 'package:pdf_reports_generator/src/widgets/custom_table.dart';
import 'package:pdf_reports_generator/src/widgets/pdf_totals_widget.dart';

class VehicleReportPdf extends ReportsPdf {
  VehicleReportPdf() ;

  @override
  String get title => 'Vehicle Report';

  @override
  String get dateRange {
    DateTime _from = DateTime.now().subtract(const Duration(days: 30));
    DateTime _to = DateTime.now();
    return 'From ${_from.toString().substring(0,16)} To ${_to.toString().substring(0,16)}';
  }

  @override
  List<String>? get filtersApplied => [];

  @override
  List<Widget> get body =>  [
      ...customTable(headers: _tableHeaders, contents: _contents, columnWidths: columnWidths),

      // totals
      Align(
        alignment: Alignment.topRight,
        child: pdfTotals([
          PdfTotalItems(label: 'Sub Total', value: 'Ksh. 2,300,000'),
          PdfTotalItems(label: 'Expenses Total', value: 'Ksh. 560,000'),
          PdfTotalItems(label: 'Total', value: 'Ksh. 1,740,000', bold: true),
        ])
      )
    ];

  final List<String> _tableHeaders = const ['REG_NO', 'NO_OF\nJOBS', 'EXPENSE\nTOTAL(-)', 'TOTAL_JOBS\nAMOUNT', 'TOTAL'];

  List<List<String>> get _contents => [
    for(int i=0; i<30; i++)
    ['KYZ 123E', '$i', '56,000', '230,000', '174,000'],
  ];

  Map<int, TableColumnWidth> get columnWidths=> {
    0: const FlexColumnWidth(4),
    1: const FlexColumnWidth(2),
    2: const FlexColumnWidth(4),
    3: const FlexColumnWidth(4),
    4: const FlexColumnWidth(4),
  };
  
}