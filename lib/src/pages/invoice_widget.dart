import 'package:pdf_reports_generator/src/configs.dart';
import 'package:pdf_reports_generator/src/pdf_generator.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf_reports_generator/src/pdf_template.dart';
import 'package:pdf_reports_generator/src/widgets/custom_table.dart';
import 'package:pdf_reports_generator/src/widgets/pdf_totals_widget.dart';

class InvoiceWidget implements PdfTemplate  {
  InvoiceWidget({required this.client, required this.order});
  Map<String, dynamic> order;
  Map<String, dynamic> client;

  @override
  DocumentType documentType =  DocumentType.invoice;

  @override
  HeaderItems get headerInfo => HeaderItems(
        title: companyName,
        items: [companyEmail, companyAddress, companyPhoneNo],
        descriptionItems: _headerInfoDes,
      );

  List<DescriptionItems> get _headerInfoDes => [
        'InvoiceNo: LSLINV-${order["orderNo"]}',
        order['dateCreated'].toString(),
      ].map((e) => e.toDescriptionItems()).toList();

  @override
  HeaderItems get headerExtras => HeaderItems(
          title:
              "${client['firstName'] ?? ''} ${client['middleName'] ?? ''} ${client['lastName'] ?? ''}",
          items: [
            if (client['email'] != null) client['email'],
            if (client['phoneNO'] != null) 'P:${client['phoneNO']}',
            if (client['address'] != null) client['address'],
          ]);

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
                  label: 'Total',
                  value:
                      'Ksh. ${double.tryParse(
                        (                        
                        order['amount'] -
                        (
                          order['amount'] / (1+ (order['vat'] ?? 0) /100) *                       
                        ((order['vat'] ?? 0) / 100)
                        )
                       ).toString())?.toStringAsFixed(2)}'),
              PdfTotalItems(
                  label: 'Vat@${order['vat'] ?? 0} %',
                  value:
                      'Ksh. ${ double.tryParse(( order['amount'] / (1+ (order['vat'] ?? 0) /100) *                       
                        ((order['vat'] ?? 0) / 100)).toString())?.toStringAsFixed(2)}'),
              PdfTotalItems(
                  label: 'Balance due',
                  value: 'Ksh. ${double.tryParse((order['amount']).toString())?.ceil()}',
                  bold: true),
            ])),
             SizedBox(height: 10),
        Align(
          alignment: Alignment.bottomRight,
          child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [         
          Container(
            padding: const EdgeInsets.all(18),
            child: Text('Signature')),
          Divider(
            thickness: 2,
          ),
        ])),
      
      ];

  List<String> get _tableHeaders => tableHeaders;

  List<List<String>> get _contents => contents;

  Map<int, TableColumnWidth> get columnWidths => {
        0: const FlexColumnWidth(3),
        1: const FlexColumnWidth(10),
        2: const FlexColumnWidth(3),
        3: const FlexColumnWidth(5),
        4: const FlexColumnWidth(3),
      };

  @override
  set headerExtras(HeaderItems? _headerExtras) {
    headerExtras = _headerExtras;
  }

  @override
  set headerInfo(HeaderItems? _headerInfo) {
    headerInfo = _headerInfo;
  }

List<String> get tableHeaders {
    List<String> _tableHeader;
    if (order['title'] == 'Dumping') {
      _tableHeader = const [
        'No.',
        'DESCRIPTION',
        'Rate',
        'NO OF TRIPS',
        'TOTAL'
      ];
    } else if (order['title'] == 'Hire') {
      _tableHeader = const [
        'No.',
        'DESCRIPTION',
        'Rate',
        'NO OF DAYS',
        'TOTAL'
      ];
    } else if (order['title'] == 'Pozoolana') {
      _tableHeader = const [
        'No.',
        'DESCRIPTION',
        'Rate',
        'Tonnes',
        'TOTAL'
      ];
    } 
    
    else {
      _tableHeader = const [
        'No.',
        'DESCRIPTION',
        'QYT',
        'UNIT PRICE',
        'TOTAL'
      ];
    }
    return _tableHeader;
  }

  List<List<String>> get contents {
    List<List<String>> content;
    if (order['title'] == 'Dumping' || order['title'] == 'Hire' || order['title'] == 'Pozoolana') {
      content = [
        [
          '1',
          '${order['title']}: ${order['decription']}',
          order['rate'].toString(),
          order['noOfDays'].toString(),         
          (double.tryParse(order['amount'].toString())?.ceil()).toString(),
        ],
      ];
    } else {
      content = [
        [
          '1',
          '${order['title']}: ${order['decription']}',
          '1',
          (double.tryParse(order['amount'].toString())?.ceil()).toString(),
          (double.tryParse(order['amount'].toString())?.ceil()).toString(),
        ],
      ];
    }
    return content;
  }

}
