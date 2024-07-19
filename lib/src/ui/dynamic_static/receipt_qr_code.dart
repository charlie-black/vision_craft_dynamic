import 'dart:io';
import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';

class GenerateReceiptQRCode {
  final String referenceId;

  GenerateReceiptQRCode({required this.referenceId});

  Future<void> generateAndOpenPDF() async {
    try {
      final qrValidationResult = QrValidator.validate(
        data: referenceId,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.Q,
      );
      if (qrValidationResult.status == QrValidationStatus.valid) {
        final qrCode = qrValidationResult.qrCode;

        final qrImageData = await QrPainter(
          data: referenceId,
          version: QrVersions.auto,
          errorCorrectionLevel: QrErrorCorrectLevel.Q,
        ).toImageData(200);

        final Uint8List qrImageUint8List = qrImageData!.buffer.asUint8List();

        final pdf = pw.Document();

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Container(
                  width: 200,
                  height: 200,
                  child: pw.Image(
                    pw.MemoryImage(qrImageUint8List),
                  ),
                ),
              );
            },
          ),
        );

        final output = await getTemporaryDirectory();
        final file = File("${output.path}/qrcode.pdf");
        await file.writeAsBytes(await pdf.save());

        await OpenFile.open(file.path);
      } else {
        throw Exception('Failed to generate QR code');
      }
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }
}
