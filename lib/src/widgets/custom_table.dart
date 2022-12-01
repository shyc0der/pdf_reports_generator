import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf_reports_generator/src/configs.dart';

List<Table> customTable({required List<String> headers, required List<List<String>> contents, Map<int, TableColumnWidth>? columnWidths}){
  TextStyle _tableHeaderStyle = TextStyle(fontWeight: FontWeight.bold, color: PdfColors.white);


  Alignment _getAlignment(int index, int length){
    if (index == 0) {
      return Alignment.centerLeft;
    }else if (index+1 == length) {
      return Alignment.centerRight;
    } else {
      return Alignment.centerLeft;
    }
  }
  
  return [
    Table(
        border: TableBorder.symmetric(outside: const BorderSide(color: PdfColors.grey)),
        columnWidths: columnWidths,
        children: [
          TableRow( // table header
          repeat: true,
          decoration: const BoxDecoration(color: primaryColor),
            children: [
              for(int i=0; i<headers.length; i++)
                Align(
                  alignment: _getAlignment(i,  headers.length),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(headers[i], style: _tableHeaderStyle)
                  )
                ),
            ]
          ),

          // table body
          for(int i=0; i < contents.length; i++)
          TableRow( // table body content
            decoration: i.isOdd ? const BoxDecoration(color: primaryColorLight) : null,
            children: [
              for(int k=0; k<contents[i].length; k++)
                Align(
                  alignment: _getAlignment(k, headers.length),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3, left: 6, right: 6),
                    child: Text(contents[i][k])
                  )
                ),
            ]
          ),
          TableRow(children: [SizedBox(height: 20),])
        ]
      ),
  ];
}