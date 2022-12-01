// orders
// dateCreated, orderNo, title, desc, amount, state, dateApproved, dateClosed, customerEmail, -expenseTotal, totalAmount

// job 
// dateCreated, jobId, orderNo, customerEmail, driverEmail, truckReg, state, dateClosed, amount, -expenseTotal, totalAmount,title,description


// expense
//datecreated, expenseid, type, truckid, state, userid, orderNo, amount

// vehicle
// vehicleregno,totalamountofexpenses,totalamountofjobs,

// expenses per vehicles heading on the vehicle
// DATE,expenseid,expense amount,Expense Type

// jobs per vehicle
// orderno,title, amount,expensetotal, total

import 'package:pdf/widgets.dart';
import 'package:pdf_reports_generator/src/configs.dart';
import 'package:pdf_reports_generator/src/pdf_generator.dart';
import 'package:pdf_reports_generator/src/pdf_template.dart';

export 'package:pdf_reports_generator/src/pages/reports/expenses_per_vehicle.dart';
export 'package:pdf_reports_generator/src/pages/reports/vehicles_report.dart';
export 'package:pdf_reports_generator/src/pages/reports/order_reports.dart';
export 'package:pdf_reports_generator/src/pages/reports/jobs_reports.dart';
export 'package:pdf_reports_generator/src/pages/reports/jobs_per_vehicle_report_pdf.dart';
export 'package:pdf_reports_generator/src/pages/reports/expenses_report.dart';

class ReportsPdf implements PdfTemplate {
  ReportsPdf();
  
  String title = '';
  String dateRange = '';
  final String dateGenerated = DateTime.now().toString().substring(0, 16);
  List<String>? filtersApplied;


  @override
  DocumentType documentType = DocumentType.reports;

  @override
  HeaderItems? headerExtras;

  @override
  HeaderItems? get headerInfo => HeaderItems(
      title: companyName, 
      items: [companyEmail, companyAddress, companyPhoneNo],
      descriptionItems: [title.toDescriptionItems(true), ...['Date Generated: $dateGenerated', dateRange, 
      if(filtersApplied?.isNotEmpty == true) 'Filters Applied: ${filtersApplied.toString()}' ].map((e) => e.toDescriptionItems()).toList()
      ],
    );


  @override
  List<Widget>  body = [];

  @override
  set headerInfo(HeaderItems? _headerInfo) {
    headerInfo = _headerInfo;
  }
  
  
}