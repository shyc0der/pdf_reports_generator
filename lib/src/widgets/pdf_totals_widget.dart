import 'package:pdf/widgets.dart';

Widget pdfTotals (List<PdfTotalItems> items)=> Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: items
    ),
  );


class PdfTotalItems extends StatelessWidget {
    PdfTotalItems({required this.label, required this.value, this.bold = false});
    final String label;
    final String value;
    final bool bold;

    @override
    Widget build(Context context) {
      return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SizedBox(
        width: 250,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // labe
            SizedBox(
              width: 140,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(label, textAlign: TextAlign.right, style: !bold ? null : TextStyle(fontWeight: FontWeight.bold , fontSize: 16)),
              ),
            ),

            // value
            SizedBox(
              width: 100,
              child: Text(value, textAlign: TextAlign.right, style: !bold ? null : TextStyle(fontWeight: FontWeight.bold , fontSize: 16))
            )
          ]
        )
      ),
    );
    }
    
  }