import 'package:pdf/widgets.dart';
import 'package:pdf_reports_generator/src/pages/reports_page.dart';
import 'package:pdf_reports_generator/src/widgets/custom_table.dart';
import 'package:pdf_reports_generator/src/widgets/pdf_totals_widget.dart';

class ExpensesPerVehicleReportPdf extends ReportsPdf {
  ExpensesPerVehicleReportPdf({
    required this.regNo, required this.expenses, required this.totals,
    required this.rangeFrom, required this.rangeTo, this.filters
  });
  String regNo;
  List<Map> expenses;
  double totals;
  List<String>? filters;
  DateTime rangeFrom;
  DateTime rangeTo;

  @override
  String get title => 'Expenses per vehicle: $regNo';

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
          PdfTotalItems(label: 'Total', value: totals.ceilToDouble().toString(), bold: true),
        ])
      )
    ];

  final List<String> _tableHeaders = const ['NO', 'DATE', 'DESCRIPTION', 'EXPENSE TYPE', 'AMOUNT'];


  List<List<String>> get _contents => [
    for(int _no=0; _no<expenses.length; _no++)
      ['${_no+1}', expenses[_no]['date'].toString().substring(0, 16), expenses[_no]['description'].toString(), expenses[_no]['expenseType'].toString(),
      (double.tryParse(expenses[_no]['totalAmount'].toString())?.ceil()).toString(),
        
       
       ],
  ];

  Map<int, TableColumnWidth> get columnWidths=> {
    // 0: const FlexColumnWidth(1),
    1: const FlexColumnWidth(4),
    2: const FlexColumnWidth(5),
    3: const FlexColumnWidth(3),
    4: const FlexColumnWidth(2),
  };
  
}
