import 'dart:typed_data';
import 'package:printing/printing.dart';

Future<void> saveAndLaunchPdf(Uint8List bytes, String fileName) async {
  await Printing.sharePdf(
    bytes: bytes,
    filename: fileName,
  );
}