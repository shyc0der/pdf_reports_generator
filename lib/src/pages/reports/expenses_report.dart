import 'package:pdf/widgets.dart';
import 'package:pdf_reports_generator/src/pages/reports_page.dart';
import 'package:pdf_reports_generator/src/widgets/custom_table.dart';
import 'package:pdf_reports_generator/src/widgets/pdf_totals_widget.dart';

class ExpensesReportPdf extends ReportsPdf {
  ExpensesReportPdf({
    required this.expenses, required this.totals, required this.rangeFrom, required this.rangeTo, this.filters,
  });
  List<Map> expenses;
  double totals;
  DateTime rangeFrom;
  DateTime rangeTo;
  List<String>? filters;

  @override
  String get title => 'Expenses Report';

  @override
  String get dateRange {
    return 'From ${rangeFrom.toString().substring(0,10)} To ${rangeTo.toString().substring(0,10)}';
  }

  @override
  List<String>? get filtersApplied => filters;

  @override
  List<Widget> get body => [
      ...customTable(headers: _tableHeaders, contents: _contents, columnWidths: columnWidths),
           

      // totals
      Align(
        alignment: Alignment.topRight,
        child: pdfTotals([
          PdfTotalItems(label: 'Total', value: 'Ksh. ${totals.ceilToDouble()}', bold: true),
        ])
      )
    ];

  final List<String> _tableHeaders = const [
    'No.', 'DATE', 'DESCRIPTION', 'TYPE', 'STATE', 'REG_NO', 'USER', 'ORDER_NO', 'AMOUNT'
  ];

  List<List<String>> get _contents => [
    for(int i=0; i< expenses.length; i++)
    [ 
      '${i+1}', expenses[i]['date'].toString(), 
      expenses[i]['description'].toString(), expenses[i]['expenseType'].toString(), 
      expenses[i]['state'].toString(), expenses[i]['vehicleRegNo'].toString(), 
      expenses[i]['user'].toString(), expenses[i]['jobId'].toString(), 
      double.parse((expenses[i]['totalAmount']).toStringAsFixed(0)).toString(),      
      ],
  ];

  Map<int, TableColumnWidth> get columnWidths=> {
    1: const FlexColumnWidth(4),
    2: const FlexColumnWidth(4),
    3: const FlexColumnWidth(3),
    4: const FlexColumnWidth(3),
    5: const FlexColumnWidth(3),
    6: const FlexColumnWidth(4),
    7: const FlexColumnWidth(4),
    8: const FlexColumnWidth(3),
  };
  
}