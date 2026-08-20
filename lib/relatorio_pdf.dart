// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'pdf_download_stub.dart' if (dart.library.html) 'pdf_download_web.dart' if (dart.library.io) 'pdf_download_mobile.dart';

class RelatorioPDFService {
  static Future<void> descargarPDF({
    required String numeroServico,
    required String tagBalanca,
    required String data,
    required Map<String, String> bancoDados,
    required Map<String, bool> limpeza,
    String obsLimpeza = '',
    required Map<String, bool> inspeccion,
    String obsInspeccion = '',
    String medicionC1 = '',
    String medicionC2 = '',
    required Map<String, String> zero,
    String obsZero = '',
    required Map<String, String> span,
    String obsSpan = '',
    required List<Map<String, String>> executores,
    String comentarios = '',
  }) async {
    final pdf = pw.Document();

    final azulCorporativo = PdfColor.fromHex('#003366');
    final azulClaro = PdfColor.fromHex('#E6ECF5');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            // ENCABEZADO
            pw.Container(
              decoration: pw.BoxDecoration(
                color: azulClaro,
                border: pw.Border.all(color: azulCorporativo, width: 1.5),
              ),
              padding: const pw.EdgeInsets.all(8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('SIGMA MINERAÇÃO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: azulCorporativo, fontSize: 12)),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('RELATÓRIO DE CALIBRAÇÃO DE BALANÇA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: azulCorporativo, fontSize: 11)),
                      pw.Text(tagBalanca, style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Nº SERVIÇO: $numeroServico', style: const pw.TextStyle(fontSize: 8)),
                      pw.Text('DATA: $data', style: const pw.TextStyle(fontSize: 8)),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 10),

            // 1. BANCO DE DADOS
            _buildTituloSeccion('1. Banco de dados', azulCorporativo),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: azulCorporativo),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.center,   // <-- Centra el contenido de las celdas
              headerAlignment: pw.Alignment.center,
              headers: ['L (m)', 'V (m/s)', 'Q t/h', 'Divisior', 'Pulsos', 'Faixa (t/h)', 'Tempo Total (s)', '# Voltas'],
              data: [
                [
                  bancoDados['L'] ?? '',
                  bancoDados['v'] ?? '',
                  bancoDados['th'] ?? '',
                  bancoDados['divisor'] ?? '',
                  bancoDados['pulsos'] ?? '',
                  bancoDados['qmax'] ?? '',
                  bancoDados['tempo'] ?? '',
                  bancoDados['nvoltas'] ?? '',
                ]
              ],
            ),
            pw.SizedBox(height: 10),

            // 2. LIMPEZA
            _buildTituloSeccion('2. Limpeza', azulCorporativo),
            ...limpeza.entries.map((e) => _buildRowCheck(e.key, e.value)),
            _buildCajaObservacion('Observação Limpeza', obsLimpeza),
            pw.SizedBox(height: 10),

            // 3. INSPEÇÃO DE CÉLULAS DE CARGA
            _buildTituloSeccion('3. Inspeção de células de carga', azulCorporativo),
            ...inspeccion.entries.map((e) => _buildRowCheck(e.key, e.value)),
            pw.Container(
              alignment: pw.Alignment.center,
              margin: const pw.EdgeInsets.symmetric(vertical: 4),
              padding: const pw.EdgeInsets.all(6),
              decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
  ),
  child: pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
     pw.Text(
  'Medição Célula C1: ${medicionC1.isEmpty ? '-' : medicionC1} mV', 
  textAlign: pw.TextAlign.center, 
  style: const pw.TextStyle(fontSize: 8),
),
pw.Text(
  'Medição Célula C2: ${medicionC2.isEmpty ? '-' : medicionC2} mV', 
  textAlign: pw.TextAlign.center, 
  style: const pw.TextStyle(fontSize: 8),
),
    ],
  ),
),
            _buildCajaObservacion('Observação Inspeção', obsInspeccion),
            pw.SizedBox(height: 10),

            // 4. CALIBRAÇÃO ZERO
            _buildTituloSeccion('4. Calibração Zero', azulCorporativo),
  // 1. Tabla de Constantes (OLD y NEW)
pw.TableHelper.fromTextArray(
  border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
  headerDecoration: pw.BoxDecoration(color: azulCorporativo),
  cellStyle: const pw.TextStyle(fontSize: 8),
  cellAlignment: pw.Alignment.center,
  headerAlignment: pw.Alignment.center,
  headers: ['OLD CONST ZERO', 'NEW CONST ZERO'],
 data: [
  [
    zero['oldConst'] ?? '',
    zero['newConst'] ?? '',
  ],
],
),

pw.SizedBox(height: 4),

// 2. Tabla de Pruebas (1º a 4º ZERO, Ideal, Diferença)
pw.TableHelper.fromTextArray(
  border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
  headerDecoration: pw.BoxDecoration(color: azulCorporativo),
  cellStyle: const pw.TextStyle(fontSize: 8),
  cellAlignment: pw.Alignment.center,
  headerAlignment: pw.Alignment.center,
  headers: ['1º ZERO', '2º ZERO', '3º ZERO', '4º ZERO', 'Ideal', 'Limite permitido'],
  data: [
    [
      zero['z1'] ?? '',
      zero['z2'] ?? '',
      zero['z3'] ?? '',
      zero['z4'] ?? '',
      '${zero['ideal'] ?? '0'} TON',
      zero['diferenca'] ?? '0.000',
    ],
    // Si usas 1º a 4º CONST en Zero, agregas esta fila:
    [
      zero['c1'] ?? '',
      zero['c2'] ?? '',
      zero['c3'] ?? '',
      zero['c4'] ?? '',
      '',
      '',
    ],
  ],
),
pw.SizedBox(height: 4),

pw.TableHelper.fromTextArray(
  border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
  headerDecoration: pw.BoxDecoration(color: azulCorporativo),
  cellStyle: const pw.TextStyle(fontSize: 8),
  cellAlignment: pw.Alignment.center,   // <-- AGREGAR ESTA LÍNEA
  headerAlignment: pw.Alignment.center,
  headers: ['1º CONST', '2º CONST', '3º CONST', '4º CONST'],
  data: [
    [
      zero['c1'] ?? '',
      zero['c2'] ?? '',
      zero['c3'] ?? '',
      zero['c4'] ?? '',
    ],
  ],
),
            _buildCajaObservacion('Observação Zero', obsZero),
            pw.SizedBox(height: 10),

            // 5. CALIBRAÇÃO SPAN
            _buildTituloSeccion('5. Calibração Span', azulCorporativo),

// Tabla 1: Valores de OLD CONST SPAN y NEW CONST SPAN
pw.TableHelper.fromTextArray(
  border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
  headerDecoration: pw.BoxDecoration(color: azulCorporativo),
  cellStyle: const pw.TextStyle(fontSize: 8),
  cellAlignment: pw.Alignment.center,
  headerAlignment: pw.Alignment.center,
  headers: ['OLD CONST SPAN', 'NEW CONST SPAN'],
  data: [
    [
      span['oldConst'] ?? '',
      span['newConst'] ?? '', 
    ],
  ],
),

pw.SizedBox(height: 4),

// Tabla 2: Valores de SPAN (Pruebas del 1º al 4º SPAN)
pw.TableHelper.fromTextArray(
  border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
  headerDecoration: pw.BoxDecoration(color: azulCorporativo),
  cellStyle: const pw.TextStyle(fontSize: 8),
  cellAlignment: pw.Alignment.center,
  headerAlignment: pw.Alignment.center,
  headers: ['1º SPAN', '2º SPAN', '3º SPAN', '4º SPAN', 'Ideal', 'Limite permitido'],
  data: [
    [
      span['s1'] ?? '',
      span['s2'] ?? '',
      span['s3'] ?? '',
      span['s4'] ?? '',
      '${span['ideal'] ?? '0'} TON',
      span['diferenca'] ?? '0.000',
    ],
  ],
),

pw.SizedBox(height: 4),

// Tabla 2: Valores de CONST SPAN (Segunda tabla independiente)
pw.TableHelper.fromTextArray(
  border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
  headerDecoration: pw.BoxDecoration(color: azulCorporativo),
  cellStyle: const pw.TextStyle(fontSize: 8),
  cellAlignment: pw.Alignment.center,   // <-- AGREGAR ESTA LÍNEA
  headerAlignment: pw.Alignment.center,
  headers: ['1º CONST', '2º CONST', '3º CONST', '4º CONST'],
  data: [
    [
      span['c1'] ?? '',
      span['c2'] ?? '',
      span['c3'] ?? '',
      span['c4'] ?? '',
    ],
  ],
),
            _buildCajaObservacion('Observação Span', obsSpan),
            pw.SizedBox(height: 10),

            // 6. OBSERVAÇÕES / COMENTÁRIOS
            _buildTituloSeccion('6. Observações Geral / Condição da Correia', azulCorporativo),
            _buildCajaObservacion('Observações', comentarios),
            pw.SizedBox(height: 10),

            // 7. EXECUTORES
            _buildTituloSeccion('7. Executores', azulCorporativo),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: azulCorporativo),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.center,
              headerAlignment: pw.Alignment.center,
              headers: ['Nome', 'Especialidade'],
data: executores.map((item) {
  return [
    item['nome'] ?? '',
    item['especialidade'] ?? 'INSTRUMENTISTA',
  ];
}).toList(),
            ),
          ];
        },
      ),
    );

    final bytes = await pdf.save();
await saveAndLaunchPdf(bytes, 'Relatorio_Calibracao_$tagBalanca.pdf');
  }

  static pw.Widget _buildTituloSeccion(String texto, PdfColor color) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(texto, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: color)),
        pw.Divider(color: color, thickness: 0.5),
        pw.SizedBox(height: 3),
      ],
    );
  }

  static pw.Widget _buildRowCheck(String titulo, bool sim) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(titulo, style: const pw.TextStyle(fontSize: 8)),
          pw.Text(
            sim ? '[ X ] SIM  [   ] NÃO' : '[   ] SIM  [ X ] NÃO',
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCajaObservacion(String etiqueta, String texto) {
    final contenido = texto.trim().isEmpty ? 'Sem observações registradas.' : texto.trim();
    return pw.Container(
      width: double.infinity,
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 4),
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
      ),
      child: pw.Text(
        '$etiqueta: $contenido',
        style: const pw.TextStyle(fontSize: 8),
      ),
    );
  }
}