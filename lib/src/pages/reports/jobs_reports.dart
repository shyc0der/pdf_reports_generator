import 'package:pdf/widgets.dart';
import 'package:pdf_reports_generator/src/pages/reports_page.dart';
import 'package:pdf_reports_generator/src/widgets/custom_table.dart';
import 'package:pdf_reports_generator/src/widgets/pdf_totals_widget.dart';

class JobsReportPdf extends ReportsPdf {
  JobsReportPdf(
      {required this.jobs,
      required this.totals,
      required this.rangeFrom,
      required this.rangeTo,
      this.filters});
  List<Map> jobs;
  List<double> totals;
  DateTime rangeFrom;
  DateTime rangeTo;
  List<String>? filters;

  @override
  String get title => 'Jobs Report';

  @override
  String get dateRange {
    return 'From ${rangeFrom.toString().substring(0, 10)} To ${rangeTo.toString().substring(0, 10)}';
  }

  @override
  List<String>? get filtersApplied => filters;

  @override
  List<Widget> get body => [
        ...customTable(
            headers: _tableHeaders,
            contents: _contents,
            columnWidths: columnWidths),

        // totals
        Align(
            alignment: Alignment.topRight,
            child: pdfTotals([
              PdfTotalItems(
                label: 'Job Total',
                value: 'Ksh. ${totals[0].ceilToDouble()}',
              ),
              PdfTotalItems(
                  label: 'Expenses Total', value: 'Ksh. ${totals[1].ceilToDouble()}'),
              PdfTotalItems(
                  label: 'Total', value: 'Ksh. ${totals[0].ceilToDouble()}', bold: true),
            ]))
      ];

  final List<String> _tableHeaders = const [
    'No.', 'DATE', 'ORDER_NO', 'DESCRIPTION', 'STATE',
    'DRIVER', 'REG_NO',
    // 'CUSTOMER',
    'DATE_CLOSED', 'AMOUNT', 'EXPENSES', 'TOTAL'
  ];

  List<List<String>> get _contents => [
        for (int i = 0; i < jobs.length; i++)
          [
            '${i + 1}', jobs[i]['dateCreated'].toString(),
            jobs[i]['orderNo'].toString(),
            '${jobs[i]['title'].toString()}: ${jobs[i]['decription'].toString()}',
            jobs[i]['state'].toString(),
            jobs[i]['driverName'].toString(),
            jobs[i]['vehicleRegNo'].toString(),
            // jobs[i]['customerName'].toString(),
            jobs[i]['dateClosed'].toString(),             
            (double.tryParse(jobs[i]['amount'].toString())?.ceil()).toString(),
            (double.tryParse(jobs[i]['expenseAmount'].toString())?.ceil()).toString(),
            (double.tryParse(jobs[i]['total'].toString())?.ceil()).toString(),
                  
            
          ],
      ];

  Map<int, TableColumnWidth> get columnWidths => {
        1: const FlexColumnWidth(3),
        2: const FlexColumnWidth(3),
        3: const FlexColumnWidth(4),
        4: const FlexColumnWidth(3),
        5: const FlexColumnWidth(3),
        6: const FlexColumnWidth(3),
        7: const FlexColumnWidth(3),
        8: const FlexColumnWidth(3),
        9: const FlexColumnWidth(2),
        10: const FlexColumnWidth(3),
      };
}
