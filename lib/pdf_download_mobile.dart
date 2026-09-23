import 'dart:typed_data';
import 'package:printing/printing.dart';

Future<void> saveAndLaunchPdf(Uint8List bytes, String fileName) async {
  await Printing.layoutPdf(
    onLayout: (format) async => bytes,
    name: fileName,
  );
}