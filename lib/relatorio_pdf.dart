// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'pdf_download_stub.dart' if (dart.library.html) 'pdf_download_web.dart' if (dart.library.io) 'pdf_download_mobile.dart';
import 'app_translations.dart';

class RelatorioPDFService {
  static Future<void> descargarPDF({
    required String lang,
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

    // Helper para obtener traducciones de forma sencilla
    String t(String key) => AppTranslations.getText(lang, key);

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
                      pw.Text(t('pdf_titulo'), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: azulCorporativo, fontSize: 11)),
                      pw.Text(tagBalanca, style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('${t('numero_servicio')}: $numeroServico', style: const pw.TextStyle(fontSize: 8)),
                      pw.Text('${t('data_relatorio')}: $data', style: const pw.TextStyle(fontSize: 8)),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 10),

            // 1. BANCO DE DADOS
            _buildTituloSeccion(t('1. Banco de dados'), azulCorporativo),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: azulCorporativo),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.center,
              headerAlignment: pw.Alignment.center,
              headers: ['L (m)', 'V (m/s)', 'Q t/h', t('Divisor'), t('Pulsos'), t('Faixa (t/h)'), t('Tempo Total (s)'), t('#Voltas'), t('Toneladas Teste (TTE)') ],
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
                  bancoDados['toneladasTeste'] ?? '',
                ]
              ],
            ),
            pw.SizedBox(height: 10),

            // 2. LIMPEZA
            _buildTituloSeccion(t('2. Limpeza'), azulCorporativo),
            ...limpeza.entries.map((e) => _buildRowCheck(t(e.key), e.value, t)),
            _buildCajaObservacion(t('Observação Limpeza'), obsLimpeza, t),
            pw.SizedBox(height: 10),

            // 3. INSPEÇÃO DE CÉLULAS DE CARGA
            _buildTituloSeccion(t('3. Inspeção de células de carga'), azulCorporativo),
            ...inspeccion.entries.map((e) => _buildRowCheck(t(e.key), e.value, t)),
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
                    '${t('Medição Célula C1')}: ${medicionC1.isEmpty ? '-' : medicionC1} mV', 
                    textAlign: pw.TextAlign.center, 
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                  pw.Text(
                    '${t('Medição Célula C2')}: ${medicionC2.isEmpty ? '-' : medicionC2} mV', 
                    textAlign: pw.TextAlign.center, 
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ),
            _buildCajaObservacion(t('Observação Inspeção'), obsInspeccion, t),
            pw.SizedBox(height: 10),

            // 4. CALIBRAÇÃO ZERO
            _buildTituloSeccion(t('4. Calibração Zero'), azulCorporativo),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: azulCorporativo),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.center,
              headerAlignment: pw.Alignment.center,
              headers: ['OLD CONST ZERO', 'NEW CONST ZERO', 'NEW ERROR'],
              data: [
                [
                  zero['oldConst'] ?? '',
                  zero['newConst'] ?? '',
                  zero['newError'] ?? '',
                ],
              ],
            ),
            pw.SizedBox(height: 4),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: azulCorporativo),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.center,
              headerAlignment: pw.Alignment.center,
              headers: ['1º ZERO', '2º ZERO', '3º ZERO', '4º ZERO'],
              data: [
                [
                  zero['z1'] ?? '',
                  zero['z2'] ?? '',
                  zero['z3'] ?? '',
                  zero['z4'] ?? '',
                  ],
              ],
            ),
             pw.SizedBox(height: 4),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: azulCorporativo),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.center,
              headerAlignment: pw.Alignment.center,
              headers: ['1º DIF / ERROR', '2º DIF / ERROR', '3º DIF / ERROR', '4º DIF / ERROR',],
              data: [
                [
              zero['err1'] ?? '',
              zero['err2'] ?? '',
              zero['err3'] ?? '',
              zero['err4'] ?? '',
                ],
],
            ),
            pw.SizedBox(height: 4),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: azulCorporativo),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.center,
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
            _buildCajaObservacion(t('Observação Zero'), obsZero, t),
            pw.SizedBox(height: 10),

            // 5. CALIBRAÇÃO SPAN
            _buildTituloSeccion(t('5. Calibração Span'), azulCorporativo),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: azulCorporativo),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.center,
              headerAlignment: pw.Alignment.center,
              headers: ['OLD CONST SPAN', 'NEW CONST SPAN','NEW ERROR'],
              data: [
                [
                  span['oldConst'] ?? '',
                  span['newConst'] ?? '', 
                  span['newError'] ?? '',
                ],
              ],
            ),
            pw.SizedBox(height: 4),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: azulCorporativo),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.center,
              headerAlignment: pw.Alignment.center,
              headers: ['1º SPAN', '2º SPAN', '3º SPAN', '4º SPAN',],
              data: [
                [
                  span['s1'] ?? '',
                  span['s2'] ?? '',
                  span['s3'] ?? '',
                  span['s4'] ?? '',
                   ],
              ],
            ),
            pw.SizedBox(height: 4),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: azulCorporativo),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.center,
              headerAlignment: pw.Alignment.center,
              headers: ['1º DIF / ERROR', '2º DIF / ERROR', '3º DIF / ERROR', '4º DIF / ERROR',],
              data: [
                [
                  span['err11'] ?? '',
                  span['err22'] ?? '',
                  span['err33'] ?? '',
                  span['err44'] ?? '',

                   ],
              ],
            ),
            pw.SizedBox(height: 4),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: azulCorporativo),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.center,
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
            _buildCajaObservacion(t('Observação Span'), obsSpan, t),
            pw.SizedBox(height: 10),

            // 6. OBSERVAÇÕES / COMENTÁRIOS
            _buildTituloSeccion(t('6. Observações Geral / Condição da Correia'), azulCorporativo),
            _buildCajaObservacion(t('Observações'), comentarios, t),
            pw.SizedBox(height: 10),

// 7. EXECUTORES
            _buildTituloSeccion(t('7. Executores'), azulCorporativo),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: azulCorporativo, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: azulCorporativo),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.center,
              headerAlignment: pw.Alignment.center,
              headers: [t('Nome'), t('Especialidade')],
              data: executores
    .where((item) => (item['nome'] != null && item['nome'].toString().trim().isNotEmpty))
    .map((item) {
                // 1. Obtener el texto simple de la especialidad
                String rawEsp = (item['especialidade'] ?? 'INSTRUMENTISTA').toString().toUpperCase();

                // 2. Determinar la clave de traducción ('electricista' o 'instrumentista')
                String claveTraduccion = (rawEsp == 'ELETRICISTA') ? 'eletricista' : 'instrumentista';

                return [
                  item['nome'] ?? '',
                  t(claveTraduccion), // 3. Retorna la traducción correspondiente
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    try {
  final bytes = await pdf.save();
  await saveAndLaunchPdf(bytes, 'Relatorio_Calibracao_$tagBalanca.pdf');
} catch (e) {
  print('Error al generar o lanzar el PDF: $e');
}

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
  static pw.Widget _buildRowCheck(String titulo, bool sim, String Function(String) t) {
    final textoSim = t('SIM');
    final textoNao = t('NÃO');
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(titulo, style: const pw.TextStyle(fontSize: 8)),
          pw.Text(
            sim ? '[ X ] $textoSim   [   ] $textoNao' : '[   ] $textoSim   [ X ] $textoNao',
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCajaObservacion(String etiqueta, String texto, String Function(String) t) {
    final contenido = texto.trim().isEmpty ? t('Sem observações registradas.') : texto.trim();
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