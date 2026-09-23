import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CamiaoTab extends StatefulWidget {
  final String lang;
  const CamiaoTab({super.key, required this.lang});

  @override
  State createState() => _CamiaoTabState();
}

class _CamiaoTabState extends State {
  // Lista de tags definida explícitamente como List
  final List _tagOptions = const ['340-CV-015', '340-CV-017'];
  String? _selectedTag;

  final TextEditingController _tonInicioController = TextEditingController();
  final TextEditingController _tonFinController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
  final TextEditingController _horaFinController = TextEditingController();
  final TextEditingController _pesoCamionController = TextEditingController();

  double _pesocorreiaTon = 0.0;
  double _errorPorcentaje = 0.0;
  double _diferenciaBalanzacamioncorreia = 0.0;

  @override
  void initState() {
    super.initState();
    _tonInicioController.addListener(_calcularValores);
    _tonFinController.addListener(_calcularValores);
    _pesoCamionController.addListener(_calcularValores);
  }

  void _calcularValores() {
    final double inicio = double.tryParse(_tonInicioController.text) ?? 0.0;
    final double fin = double.tryParse(_tonFinController.text) ?? 0.0;
    final double manual = double.tryParse(_pesoCamionController.text) ?? 0.0;

    setState(() {
      _pesocorreiaTon = fin - inicio;

      if (manual > 0) {
        _errorPorcentaje = ((_pesocorreiaTon - manual) / manual) * 100;
      } else {
        _errorPorcentaje = 0.0;
      }
      _diferenciaBalanzacamioncorreia = _pesocorreiaTon - manual;
    });
  }

  // Función para generar e imprimir el PDF
  Future _imprimirRelatorio() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text(
                    'Relatório de Teste de Balança de Correia',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Tag da equipe: ${_selectedTag ?? "Não selecionado"}',
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Hora Inicio: ${_horaInicioController.text}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  'Hora Fim: ${_horaFinController.text}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.SizedBox(height: 16),
                pw.Table.fromTextArray(
                  headers: ['Item', 'Valor'],
                  data: [
                    ['Ton. Inicio', '${_tonInicioController.text} t'],
                    ['Ton. Fim', '${_tonFinController.text} t'],
                    ['Peso do Caminhão', '${_pesoCamionController.text} t'],
                    [
                      'Balança da Correia',
                      '${_pesocorreiaTon.toStringAsFixed(2)} t'
                    ],
                    [
                      'Diferença',
                      '${_diferenciaBalanzacamioncorreia.toStringAsFixed(2)} t'
                    ],
                    ['Erro (%)', '${_errorPorcentaje.toStringAsFixed(2)} %'],
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  void dispose() {
    _tonInicioController.dispose();
    _tonFinController.dispose();
    _horaInicioController.dispose();
    _horaFinController.dispose();
    _pesoCamionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Testes de balança de correia com balança Rodoviária',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Dropdown de Tags seguro
         DropdownButtonFormField<String>(
  value: _tagOptions.contains(_selectedTag) ? _selectedTag : null,
  hint: const Text('Selecione o Tag da equipe'),
  decoration: const InputDecoration(
    labelText: 'Tag da equipe',
    border: OutlineInputBorder(),
    isDense: true,
  ),
  items: [
    for (final tag in _tagOptions)
      DropdownMenuItem<String>(
        value: tag,
        child: Text(tag),
      ),
  ],
  onChanged: (String? newValue) {
    setState(() {
      _selectedTag = newValue;
    });
  },
), // DropdownButtonFormField
          const SizedBox(height: 12),

          // Toneladas Inicio y Fin
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _tonInicioController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Ton. Inicio (t)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _tonFinController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Ton. Fim (t)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horarios
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _horaInicioController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Hora Inicio (HH:MM)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _horaFinController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Hora Fin (HH:MM)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sección Inferior (Imágenes + Ingresos / Cálculos)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna Izquierda: Imagen Camión + Imagen Balanza
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/camion.jpg',
                      width: 140,
                      height: 105,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 140,
                        height: 105,
                        color: Colors.grey[300],
                        child: const Icon(Icons.local_shipping, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/balanza.jpg',
                      width: 140,
                      height: 105,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 140,
                        height: 105,
                        color: Colors.grey[300],
                        child: const Icon(Icons.speed, size: 40),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Columna Central: Peso Camión y Balanza Correia
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 105,
                      width: double.infinity,
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Peso do caminhão (t):',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _pesoCamionController,
                                keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*'),
                                  ),
                                ],
                                decoration: const InputDecoration(
                                  hintText: 'Insira o peso do caminhão...',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 105,
                      width: double.infinity,
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Balança da correia (t):',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                  color: Colors.grey.shade50,
                                ),
                                child: Text(
                                  '${_pesocorreiaTon.toStringAsFixed(2)} t',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Columna Derecha: Error y Diferencia
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 105,
                      width: double.infinity,
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Error (%):',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${_errorPorcentaje.toStringAsFixed(2)} %',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 105,
                      width: double.infinity,
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Diferencia (t):',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${_diferenciaBalanzacamioncorreia.toStringAsFixed(2)} t',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Botón de Impresión / Generación de PDF
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _imprimirRelatorio,
              icon: const Icon(Icons.print),
              label: const Text(
                'Imprimir / Gerar PDF',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}