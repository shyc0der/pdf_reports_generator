import 'package:pdf/widgets.dart';
import 'package:pdf_reports_generator/src/pages/reports_page.dart';
import 'package:pdf_reports_generator/src/widgets/custom_table.dart';
import 'package:pdf_reports_generator/src/widgets/pdf_totals_widget.dart';

class JobsPerVehicleReportPdf extends ReportsPdf {
  JobsPerVehicleReportPdf({
    required this.regNo, required this.jobs, required this.totals,
    required this.rangeFrom, required this.rangeTo, this.filters
  });
  String regNo;
  List<Map> jobs;
  List<double> totals;
  List<String>? filters;
  DateTime rangeFrom;
  DateTime rangeTo;

  @override
  String get title => 'Jobs per vehicle: $regNo';

  @override
  String get dateRange {
    return 'From ${rangeFrom.toString().substring(0,10)} To ${rangeTo.toString().substring(0,10)}';
  }

  @override
  List<String>? get filtersApplied => filters;

  @override
  List<Widget> get body =>  [
      ...customTable(headers: _tableHeaders, contents: _contents, columnWidths: columnWidths),
           

      // totals
      Align(
        alignment: Alignment.topRight,
        child: pdfTotals([
          PdfTotalItems(label: 'Total Cost', value: 'Ksh. ${totals[0].ceilToDouble()}'),
          PdfTotalItems(label: 'Expenses Total', value: 'Ksh. ${totals[1].ceilToDouble()}'),
          PdfTotalItems(label: 'Total', value: 'Ksh. ${totals[2].ceilToDouble()}', bold: true),
        ])
      )
    ];

  final List<String> _tableHeaders = const ['No.', 'ORDERNO', 'DESCRIPTION', 'AMOUNT', 'TOTAL EXPENSES(-)', 'TOTAL'];

  List<List<String>> get _contents => [
    for(int i=0; i<jobs.length; i++)
    [
      '${i+1}',
      jobs[i]['orderNo'].toString(), jobs[i]['description'].toString(), 
      
      (double.tryParse(jobs[i]['amount'].toString())?.ceil()).toString(),
      (double.tryParse(jobs[i]['expenseAmount'].toString())?.ceil()).toString(),
      (double.tryParse(jobs[i]['total'].toString())?.ceil()).toString(),
      
       
    ],
  ];

  Map<int, TableColumnWidth> get columnWidths=> {
    1: const FlexColumnWidth(4),
    2: const FlexColumnWidth(4),
    3: const FlexColumnWidth(4),
    4: const FlexColumnWidth(4),
  };
  
}