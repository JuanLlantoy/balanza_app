import 'app_translations.dart';
import 'relatorio_pdf.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ota_update/ota_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:country_flags/country_flags.dart';
Future<void> verificarActualizacionAndroid() async {
  if (kDebugMode) return;
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionActual = packageInfo.version;

    final response = await http.get(Uri.parse('https://magical-swan-3fc778.netlify.app/version.json'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String versionServidor = data['version'];
      String urlApk = data['url'];

      if (versionServidor != versionActual) {
        OtaUpdate().execute(urlApk, destinationFilename: 'balanza_app.apk').listen(
          (OtaEvent event) {
            print('Estado de actualización: ${event.status} - ${event.value}%');
          },
        );
      }
    }
  } catch (e) {
    print('Error al verificar actualización: $e');
  }
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  verificarActualizacionAndroid();
  runApp(const SigmaLithiumApp());
}

class SigmaLithiumApp extends StatelessWidget {
  const SigmaLithiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INSTRUMENTAÇÃO SIGMA LITHIUM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003366), // Azul Corporativo Sigma
          primary: const Color(0xFF003366),
          secondary: const Color(0xFF00A859), // Verde litio/industrial
          surface: const Color(0xFFF4F6F9),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003366),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 1; // Inicia por defecto en "Balança" (Índice 1)
  String currentLang = 'pt';
 List<String> get _titles => [
  'DENSIDADE',
  AppTranslations.getText(currentLang, 'titulo'),
  'PRESSÃO',
  'NÍVEL',
  'FLUXO / VAZÃO',
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  title: Text(
  _titles[_selectedIndex],
  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
),
  actions: [
    PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (String newLang) {
        setState(() {
          currentLang = newLang;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
       PopupMenuItem<String>(
       value: 'pt',
      child: Row(
        children: [
          CountryFlag.fromCountryCode('BR', height: 16, width: 22),
          const SizedBox(width: 8),
          const Text('Português'),
        ],
      ),
    ),
    PopupMenuItem<String>(
      value: 'es',
    child: Row(
      children: [
        CountryFlag.fromCountryCode('PE', height: 16, width: 22),
        const SizedBox(width: 8),
        const Text('Español'),
        ],
      ),
    ),
    PopupMenuItem<String>(
      value: 'en',
      child: Row(
        children: [
          CountryFlag.fromCountryCode('ZA', height: 16, width: 22),
          const SizedBox(width: 8),
          const Text('English'),
        ],
      ),
    ),
      ],
    ),
  ],
),
      drawer: NavigationDrawer(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.pop(context); // Cerrar drawer
        },
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF003366),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.precision_manufacturing, size: 42, color: Color(0xFF00A859)),
                SizedBox(height: 10),
                Text(
                  'INSTRUMENTAÇÃO',
                  style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1.2),
                ),
                Text(
                  'SIGMA LITHIUM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop, color: Color(0xFF003366)),
            label: Text('Densidade'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.scale_outlined),
            selectedIcon: Icon(Icons.scale, color: Color(0xFF003366)),
            label: Text('Balança'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.speed_outlined),
            selectedIcon: Icon(Icons.speed, color: Color(0xFF003366)),
            label: Text('Pressão'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.straighten_outlined),
            selectedIcon: Icon(Icons.straighten, color: Color(0xFF003366)),
            label: Text('Nível'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.waves_outlined),
            selectedIcon: Icon(Icons.waves, color: Color(0xFF003366)),
            label: Text('Fluxo'),
          ),
        ],
      ),
   body: IndexedStack(
          index: _selectedIndex,
          children: [ // <-- SE QUITÓ EL 'const' DE AQUÍ
            const ModuloPlaceholder(nombre: 'Densidade', icono: Icons.water_drop),
            BalancaModuleScreen(currentLang: currentLang),
            const ModuloPlaceholder(nombre: 'Pressão', icono: Icons.speed),
            const ModuloPlaceholder(nombre: 'Nível', icono: Icons.straighten),
            const ModuloPlaceholder(nombre: 'Fluxo', icono: Icons.waves),
          ],
        ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF003366),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Densidade'),
          BottomNavigationBarItem(icon: Icon(Icons.scale), label: 'Balança'),
          BottomNavigationBarItem(icon: Icon(Icons.speed), label: 'Pressão'),
          BottomNavigationBarItem(icon: Icon(Icons.straighten), label: 'Nível'),
          BottomNavigationBarItem(icon: Icon(Icons.waves), label: 'Fluxo'),
        ],
      ),
    );
  }
}

// ==========================================
// MÓDULO DE BALANÇA (CON SUB-TAB: CALCULADORA Y REPORTE)
// ==========================================
class BalancaModuleScreen extends StatelessWidget {
  final String currentLang;

  const BalancaModuleScreen({super.key, required this.currentLang});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              labelColor: const Color(0xFF003366),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF00A859),
              indicatorWeight: 3,
              tabs: [
                Tab(
                  icon: const Icon(Icons.calculate),
                  text: AppTranslations.getText(currentLang, 'calculadora'),
                ),
                Tab(
                  icon: const Icon(Icons.assignment),
                  text: AppTranslations.getText(currentLang, 'iniciar_reporte'),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            BalancaCalculadoraTab(lang: currentLang),
            BalancaReporteTab(lang: currentLang),
          ],
        ),
      ),
    );
  }
}
// ==========================================
// PESTAÑA 1: CALCULADORA DE CALIBRAÇÃO 
// ==========================================
class BalancaCalculadoraTab extends StatefulWidget {
  final String lang; // 1. Agregas esta línea

  const BalancaCalculadoraTab({super.key, required this.lang}); // 2. Modificas el constructor

  @override
  State<BalancaCalculadoraTab> createState() => _BalancaCalculadoraTabState();
}

class _BalancaCalculadoraTabState extends State<BalancaCalculadoraTab> {
  // Controllers - Step 1: Distância da Correia
  final _tacometroController = TextEditingController(text: '1.1');
  final _tempoVoltaController = TextEditingController(text: '64.0');

  // Controllers - Step 2: Toneladas de Teste
  final _pesoEstaticoController = TextEditingController(text: '81.63');
  final _faixaPesagemController = TextEditingController(text: '2.0');
  final _numVoltasController = TextEditingController(text: '6');

  // Controllers - Step 3 & 4: Vazão e Velocidade
  final _tempoTesteController = TextEditingController(text: '384');
  // Controllers - Step 5: Span e Error
  final _toneladasTesteController = TextEditingController();

  final _s1Controller = TextEditingController();
  final _s2Controller = TextEditingController();
  final _s3Controller = TextEditingController();
  final _s4Controller = TextEditingController();

  final _err11Controller = TextEditingController();
  final _err22Controller = TextEditingController();
  final _err33Controller = TextEditingController();
  final _err44Controller = TextEditingController();  

  // Outputs
  double _distanciaL = 0.0;
  double _carregamentoC = 0.0;
  double _comprimentoTesteLT = 0.0;
  double _tte = 0.0;
  double _vazaoQ = 0.0;
  double _velocidadeV = 0.0;

  @override
  void initState() {
    super.initState();
    _calcularTodo();
  }

void _calcularTodo() {
    // Inputs Step 1 (con soporte para comas)
    final vTacometro = double.tryParse(_tacometroController.text.replaceAll(',', '.')) ?? 0.0;
    final tVolta = double.tryParse(_tempoVoltaController.text.replaceAll(',', '.')) ?? 0.0;

    // Inputs Step 2
    final pEstatico = double.tryParse(_pesoEstaticoController.text.replaceAll(',', '.')) ?? 0.0;
    final dFaixa = double.tryParse(_faixaPesagemController.text.replaceAll(',', '.')) ?? 0.0;
    final nVoltas = double.tryParse(_numVoltasController.text.replaceAll(',', '.')) ?? 0.0;

    // Inputs Step 3 & 4
    final tsTeste = double.tryParse(_tempoTesteController.text.replaceAll(',', '.')) ?? 0.0;

    // Obtener valores de SPAN y TTE
    final tte = double.tryParse(_toneladasTesteController.text.replaceAll(',', '.')) ?? 0.0;
    final span1 = double.tryParse(_s1Controller.text.replaceAll(',', '.')) ?? 0.0;
    final span2 = double.tryParse(_s2Controller.text.replaceAll(',', '.')) ?? 0.0;
    final span3 = double.tryParse(_s3Controller.text.replaceAll(',', '.')) ?? 0.0;
    final span4 = double.tryParse(_s4Controller.text.replaceAll(',', '.')) ?? 0.0;

    setState(() {
      // 1) Distancia L
      _distanciaL = vTacometro * tVolta;

      // 2) Carregamento C
      _carregamentoC = (dFaixa > 0) ? (pEstatico / dFaixa) : 0.0;

      // Longitud de Prueba LT
      _comprimentoTesteLT = nVoltas * _distanciaL;

      // TTE Calculado internamente
      _tte = (_carregamentoC * _comprimentoTesteLT) / 1000.0;

      // 3) Vazão Q
      _vazaoQ = (tsTeste > 0) ? ((_tte * 3600) / tsTeste) : 0.0;

      // 4) Velocidade V
      _velocidadeV = (tsTeste > 0) ? (_comprimentoTesteLT / tsTeste) : 0.0;

      // 5) Cálculo de DIF / ERROR
      final tteCalculado = tte > 0 ? tte : _tte;

      if (tteCalculado > 0) {
        // SPAN 1
        if (_s1Controller.text.isNotEmpty) {
          double dif1 = span1 - tteCalculado;
          double err1 = (dif1 / tteCalculado) * 100;
          _err11Controller.text = err1.toStringAsFixed(4);
        } else {
          _err11Controller.text = '';
        }

        // SPAN 2
        if (_s2Controller.text.isNotEmpty) {
          double dif2 = span2 - tteCalculado;
          double err2 = (dif2 / tteCalculado) * 100;
          _err22Controller.text = err2.toStringAsFixed(3);
        } else {
          _err22Controller.text = '';
        }

        // SPAN 3
        if (_s3Controller.text.isNotEmpty) {
          double dif3 = span3 - tteCalculado;
          double err3 = (dif3 / tteCalculado) * 100;
          _err33Controller.text = err3.toStringAsFixed(2);
        } else {
          _err33Controller.text = '';
        }

        // SPAN 4
        if (_s4Controller.text.isNotEmpty) {
          double dif4 = span4 - tteCalculado;
          double err4 = (dif4 / tteCalculado) * 100;
          _err44Controller.text = err4.toStringAsFixed(2);
        } else {
          _err44Controller.text = '';
        }
      } else {
        _err11Controller.text = '';
        _err22Controller.text = '';
        _err33Controller.text = '';
        _err44Controller.text = '';
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ----------------------------------------------------
          // BLOQUE 1: DISTÂNCIA DA CORREIA (L)
          // ----------------------------------------------------
          _buildCardSection(
            title: AppTranslations.getText(widget.lang, '1. DISTÂNCIA DA CORREIA (L)'),
            color: Colors.blue.shade900,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller: _tacometroController,
                        label: AppTranslations.getText(widget.lang,'Tacômetro (m/s)'),
                        icon: Icons.speed,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInput(
                        controller: _tempoVoltaController,
                        label: AppTranslations.getText(widget.lang,'Tempo 1 Volta (s)'),
                        icon: Icons.timer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildFormulaResult(
                  formula: 'L = (${AppTranslations.getText(widget.lang, 'velocidade')}) * (${AppTranslations.getText(widget.lang, 'tempo_em_uma_volta')})',
                  resultLabel: AppTranslations.getText(widget.lang, 'distancia_da_correia_l'),
                  resultValue: '${_distanciaL.toStringAsFixed(2)} ${AppTranslations.getText(widget.lang, 'metros')}',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ----------------------------------------------------
          // BLOQUE 2: TONELADAS DE TESTE (TTE)
          // ----------------------------------------------------
          _buildCardSection(
            title: AppTranslations.getText(widget.lang,'2. TONELADAS DE TESTE (TTE)'),
            color: Colors.teal.shade800,
            child: Column(
              children: [
                _buildInput(
                  controller: _pesoEstaticoController,
                  label: AppTranslations.getText(widget.lang,'Somatória pesos estáticos - P (kg)'),
                  icon: Icons.scale,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller: _faixaPesagemController,
                        label: AppTranslations.getText(widget.lang,'Faixa de pesagem - D (m)'),
                        icon: Icons.straighten,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInput(
                        controller: _numVoltasController,
                        label: AppTranslations.getText(widget.lang,'N° Voltas de Teste - N'),
                        icon: Icons.repeat,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('• ${AppTranslations.getText(widget.lang, 'carregamento_simulado')} = ${_carregamentoC.toStringAsFixed(2)} kg/m'),
                      Text('• ${AppTranslations.getText(widget.lang, 'comprimento_teste')} = ${_comprimentoTesteLT.toStringAsFixed(2)} m'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildFormulaResult(
                  formula: '${AppTranslations.getText(widget.lang, 'formula')}: TTE = (C x LT) / 1000',
                  resultLabel: AppTranslations.getText(widget.lang, 'toneladas_teste'),
                  resultValue: '${_tte.toStringAsFixed(3)} TPH (Ton)',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ----------------------------------------------------
          // BLOQUE 3 & 4: VAZÃO SIMULADA Y VELOCIDAD
          // ----------------------------------------------------
          _buildCardSection(
            title: '3. ${AppTranslations.getText(widget.lang, 'vazao_simulada_velocidade')}',
            color: Colors.orange.shade900,
            child: Column(
              children: [
                _buildInput(
                  controller: _tempoTesteController,
                  label: AppTranslations.getText(widget.lang, 'tempo_teste_segundos'),
                  icon: Icons.access_time_filled,
                  helperText: AppTranslations.getText(widget.lang, 'recomendado_tiempo_vueltas'),
),
const SizedBox(height: 14),
Row(
  children: [
    Expanded(
      child: _buildResultBox(
        title: AppTranslations.getText(widget.lang, 'vazao_simulada'),
        value: _vazaoQ.toStringAsFixed(2),
        unit: 't/h (TPH)',
        color: Colors.amber.shade100,
        textColor: Colors.amber.shade900,
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: _buildResultBox(
        title: AppTranslations.getText(widget.lang, 'velocidade'),
        value: _velocidadeV.toStringAsFixed(2),
        unit: 'm/s',
        color: Colors.blue.shade100,
        textColor: Colors.blue.shade900,
      ),
    ),
  ],
   ), // Row
      ],
    ), // Column
  ),
  ]
  ),
  );
}
  // Inputs auxiliares
  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? helperText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => _calcularTodo(),
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildCardSection({
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: color,
              ),
            ),
            const Divider(),
            const SizedBox(height: 6),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildFormulaResult({
    required String formula,
    required String resultLabel,
    required String resultValue,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF003366).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF003366).withValues(alpha: 0.3)),
      ), // BoxDecoration
      child: Column(
        children: [
          Text(
            'Fórmula: $formula',
            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                resultLabel,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(width: 8),
              Text(
                resultValue,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF003366),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultBox({
    required String title,
    required String value,
    required String unit,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
          ),
          Text(
            unit,
            style: TextStyle(fontSize: 11, color: textColor.withValues(alpha:0.8)),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PESTAÑA 2: INICIAR REPORTE (PLANTILLA)
// ==========================================

// Importa aquí tu servicio PDF
// import 'relatorio_pdf.dart'; 

class BalancaReporteTab extends StatefulWidget {
final String lang;
const BalancaReporteTab({super.key, required this.lang});

  @override
  State<BalancaReporteTab> createState() => _BalancaReporteTabState();
}

class _BalancaReporteTabState extends State<BalancaReporteTab> {
  // Variables para ejecutores dinámicos
  int _cantidadEjecutores = 1;
   
  // 1. Datos Generales y Banco de Datos
  final _tagController = TextEditingController(text: '211-CV-001 / 211-WIT-0056');
  final _numServicoController = TextEditingController(text: '######');
  final _dataController = TextEditingController(text: DateTime.now().toString().split(' ')[0]);
  String _selectedArea = 'Britagem';
  final _obsGeneralController = TextEditingController();

  final _distanciaController = TextEditingController(text: '70.400');
  final _velocidadeController = TextEditingController(text: '1.1');
  final _thController = TextEditingController(text: '161.62');
  final _divisorController = TextEditingController(text: '1');
  final _pulsosController = TextEditingController(text: '14939');
  final _qmaxController = TextEditingController(text: '400');
  final _tempoController = TextEditingController(text: '384');
  final _toneladasTesteController = TextEditingController(text: '17.24');
  final _pesoDinamicoController = TextEditingController(text: '81.63');
  final _nvoltasController = TextEditingController(text: '6');
  final _tempoDeCalibracaoController = TextEditingController(text:'384');
  // Controladores adicionales para Span y Error
  final _newConstSpan2Controller = TextEditingController();


void _calcularTodo() {
    // Inputs de SPAN y TTE
    final tte = double.tryParse(_toneladasTesteController.text.replaceAll(',', '.')) ?? 0.0;
    final span1 = double.tryParse(_s1Controller.text.replaceAll(',', '.')) ?? 0.0;
    final span2 = double.tryParse(_s2Controller.text.replaceAll(',', '.')) ?? 0.0;
    final span3 = double.tryParse(_s3Controller.text.replaceAll(',', '.')) ?? 0.0;
    final span4 = double.tryParse(_s4Controller.text.replaceAll(',', '.')) ?? 0.0;

    // Inputs de ZERO y RANGE (Qmax)
    final rangeTPH = double.tryParse(_qmaxController.text.replaceAll(',', '.')) ?? 0.0;
    final z1 = double.tryParse(_z1Controller.text.replaceAll(',', '.')) ?? 0.0;
    final z2 = double.tryParse(_z2Controller.text.replaceAll(',', '.')) ?? 0.0;
    final z3 = double.tryParse(_z3Controller.text.replaceAll(',', '.')) ?? 0.0;
    final z4 = double.tryParse(_z4Controller.text.replaceAll(',', '.')) ?? 0.0;

    final double tteCalculado = tte > 0 ? tte : 0.0;

    setState(() {
      // ---------------- CÁLCULO DE SPAN ----------------
      if (tteCalculado > 0) {
        if (_s1Controller.text.isNotEmpty) {
          double dif1 = span1 - tteCalculado;
          double err1 = (dif1 / tteCalculado) * 100;
          _err11Controller.text = "${dif1.toStringAsFixed(3)} t / ${err1.toStringAsFixed(3)}%";
        } else {
          _err11Controller.text = '';
        }

        if (_s2Controller.text.isNotEmpty) {
          double dif2 = span2 - tteCalculado;
          double err2 = (dif2 / tteCalculado) * 100;
          _err22Controller.text = "${dif2.toStringAsFixed(3)} t / ${err2.toStringAsFixed(3)}%";
        } else {
          _err22Controller.text = '';
        }

        if (_s3Controller.text.isNotEmpty) {
          double dif3 = span3 - tteCalculado;
          double err3 = (dif3 / tteCalculado) * 100;
          _err33Controller.text = "${dif3.toStringAsFixed(3)} t / ${err3.toStringAsFixed(3)}%";
        } else {
          _err33Controller.text = '';
        }

        if (_s4Controller.text.isNotEmpty) {
          double dif4 = span4 - tteCalculado;
          double err4 = (dif4 / tteCalculado) * 100;
          _err44Controller.text = "${dif4.toStringAsFixed(3)} t / ${err4.toStringAsFixed(3)}%";
        } else {
          _err44Controller.text = '';
        }
      } else {
        _err11Controller.text = '';
        _err22Controller.text = '';
        _err33Controller.text = '';
        _err44Controller.text = '';
      }

      // ---------------- CÁLCULO DE ZERO (Respecto a RANGE) ----------------
      if (rangeTPH > 0) {
        if (_z1Controller.text.isNotEmpty) {
          double dif1 = z1 - 0;
          double errZ1 = (z1 / rangeTPH) * 100;
           _err1ZController.text = "${dif1.toStringAsFixed(3)} t / ${errZ1.toStringAsFixed(3)}%";
        } else {
           _err1ZController.text = '';
        }

        if (_z2Controller.text.isNotEmpty) {
          double dif2 = z2 - 0;
          double errZ2 = (z2 / rangeTPH) * 100;
          _err2ZController.text = "${dif2.toStringAsFixed(3)} t / ${errZ2.toStringAsFixed(3)}%";
        } else {
          _err2ZController.text = '';
        }

        if (_z3Controller.text.isNotEmpty) {
          double dif3 = z3 - 0;
          double errZ3 = (z3 / rangeTPH) * 100;
          _err3ZController.text = "${dif3.toStringAsFixed(3)} t / ${errZ3.toStringAsFixed(3)}%";
        } else {
         _err3ZController.text = '';
        }

        if (_z4Controller.text.isNotEmpty) {
          double dif4 = z4 - 0;
          double errZ4 = (z4 / rangeTPH) * 100;
          _err4ZController.text = "${dif4.toStringAsFixed(3)} t / ${errZ4.toStringAsFixed(3)}%";
        } else {
          _err4ZController.text = '';
        }
      } else {
        _err1ZController.text = '';
        _err2ZController.text = '';
        _err3ZController.text = '';
        _err4ZController.text = '';
      }
    });
  }
  // LISTA DE TAGS
  final List<String> _listaTags = [
    '211-CV-001 / 211-WIT-0056',
    '212-CV-003 / 212-WIT-0076',
    '225-CV-006 / 225-WIT-0136',
    '227-CV-007 / 227-WIT-0206',
    '311-CV-012 / 311-WIT-0236',
    '340-CV-015 / 340-WIT-1376',
    '340-CV-017 / 340-WIT-1386',
  ];

  // BANCO DE DATOS SEGÚN TAG
  final Map<String, Map<String, String>> _bancoDeDadosTag = {
    '211-CV-001 / 211-WIT-0056': {
      'Distancia': '70.400',
      'Velocidade': '1.10',
      'Q t/h': '161.62',
      'Divisor': '1',
      'Pulsos': '14939',
      'FAIXA': '400',
      'TonTeste': '17.24',
      'PesoDinamico': '81.63',
      '#Voltas': '6',
      'TempoDeCalibracao': '384',
      'Toneladas Teste (TTE)': '17.24',
    },
    '212-CV-003 / 212-WIT-0076': {
      'Distancia': '189.20',
      'Velocidade': '1.10',
      'Q t/h': '162.598',
      'Divisor': '1',
      'Pulsos': '20564',
      'FAIXA': '500',
      'TonTeste': '23.31',
      'PesoDinamico': '82.12',
      '#Voltas': '3',
      'TempoDeCalibracao': '516',
      'Toneladas Teste (TTE)': '23.31',
    },
    '225-CV-006 / 225-WIT-0136': {
      'Distancia': '188.16',
      'Velocidade': '1.68',
      'Q t/h': '247.15',
      'Divisor': '4',
      'Pulsos': '6777',
      'FAIXA': '450',
      'TonTeste': '30.76',
      'PesoDinamico': '81.73',
      '#Voltas': '4',
      'TempoDeCalibracao': '448',
      'Toneladas Teste (TTE)': '30.76',
      },
    '227-CV-007 / 227-WIT-0206': {
      'Distancia': '287.12',
      'Velocidade': '0.97',
      'Q t/h': '143.57',
      'Divisor': '1',
      'Pulsos': '30962',
      'FAIXA': '400',
      'TonTeste': '35.415',
      'PesoDinamico': '82.23',
      '#Voltas': '3',
      'TempoDeCalibracao': '888',
      'Toneladas Teste (TTE)': '35.41',
       },
    '311-CV-012 / 311-WIT-0236': {
      'Distancia': '165.350',
      'Velocidade': '1.09',
      'Q t/h': '134.383',
      'Divisor': '1',
      'Pulsos': '17957',
      'FAIXA': '300',
      'TonTeste': '17.06',
      'PesoDinamico': '68.78',
      '#Voltas': '4',
      'TempoDeCalibracao': '384',
      'Toneladas Teste (TTE)': '17.06',
      },
    '340-CV-015 / 340-WIT-1376': {
      'Distancia': '110.9',
      'Velocidade': '0.279',
      'Q t/h': '5.92',
      'Divisor': '1',
      'Pulsos': '11811',
      'FAIXA': '12',
      'TonTeste': '1.961',
      'PesoDinamico': '11.79',
      '#Voltas': '3',
      'TempoDeCalibracao': '1191',
      'Toneladas Teste (TTE)': '1.938',
       },
    '340-CV-017 / 340-WIT-1386': {
      'Distancia': '110.9',
      'Velocidade': '0.279',
      'Q t/h': '5.92',
      'Divisor': '1',
      'Pulsos': '11811',
      'FAIXA': '55',
      'TonTeste': '1.961',
      'PesoDinamico': '11.78',
      '#Voltas': '3',
      'TempoDeCalibracao': '396',
      'Toneladas Teste (TTE)': '1.866',
    },
    };

  String? _tagSeleccionado;

  // FUNCIÓN PARA AUTOCOMPLETAR
  void _seleccionarTag(String? nuevoTag) {
    if (nuevoTag == null || !_bancoDeDadosTag.containsKey(nuevoTag)) return;
    final datos = _bancoDeDadosTag[nuevoTag]!;

      setState(() {
        _tagSeleccionado = nuevoTag;
        _tagController.text = nuevoTag;
        _distanciaController.text = datos['Distancia'] ?? '';
        _velocidadeController.text = datos['Velocidade'] ?? '';
        _thController.text = datos['Q t/h'] ?? '';
        _divisorController.text = datos['Divisor'] ?? '';
        _pulsosController.text = datos['Pulsos'] ?? '';
        _qmaxController.text = datos['FAIXA'] ?? '';
        _pesoDinamicoController.text = datos['PesoDinamico'] ?? '';
        _nvoltasController.text = datos['#Voltas'] ?? datos['nVoltas'] ?? '';
        _tempoDeCalibracaoController.text = datos['TempoDeCalibracao'] ?? datos['TempoDeCalibraçao'] ?? '';
        _toneladasTesteController.text = datos['Toneladas Teste (TTE)'] ?? datos['TonTeste'] ?? '';
    });
  }

  // 2. Limpeza (Switches SIM/NÃO)
  bool _limpeza21 = true;
  bool _limpeza22 = true;
  bool _limpeza23 = true;
  bool _limpeza24 = true;
  final _obsLimpezaController = TextEditingController();

  // 3. Inspeção de Células
  bool _inspecao31 = true;
  final _c1Controller = TextEditingController();
  final _c2Controller = TextEditingController();
  final _obsCelulasController = TextEditingController();

  // 4. Calibração Zero
  final _oldConstZeroController = TextEditingController();
  final _newConstZeroController = TextEditingController();
  final _newZero2Controller = TextEditingController();
  final _z1Controller = TextEditingController();
  final _z2Controller = TextEditingController();
  final _z3Controller = TextEditingController();
  final _z4Controller = TextEditingController();
  final _c1ZeroController = TextEditingController();
  final _c2ZeroController = TextEditingController();
  final _c3ZeroController = TextEditingController();
  final _c4ZeroController = TextEditingController();
  final _obsZeroController = TextEditingController();
  final _err1ZController = TextEditingController();
  final _err2ZController = TextEditingController();
  final _err3ZController = TextEditingController();
  final _err4ZController = TextEditingController();
  
  // 5. Calibração Span
  final _oldConstSpanController = TextEditingController();
  final _newConstSpanController = TextEditingController();
  final _s1Controller = TextEditingController();
  final _s2Controller = TextEditingController();
  final _s3Controller = TextEditingController();
  final _s4Controller = TextEditingController();
  final _c1SpanController = TextEditingController();
  final _c2SpanController = TextEditingController();
  final _c3SpanController = TextEditingController();
  final _c4SpanController = TextEditingController();
  final _obsSpanController = TextEditingController();
  final _err11Controller = TextEditingController();
  final _err22Controller = TextEditingController();
  final _err33Controller = TextEditingController();
  final _err44Controller = TextEditingController();

  // 7. Executores
  final List<Map<String, TextEditingController>> _executores = [
    {'nome': TextEditingController(), 'esp': TextEditingController(text: 'INSTRUMENTISTA')},
    {'nome': TextEditingController(), 'esp': TextEditingController(text: 'ELECTRICISTA')},
    {'nome': TextEditingController(), 'esp': TextEditingController(text: 'INSTRUMENTISTA')},
  ];

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calcularTodo();
    });
  }
@override
  void dispose() {
    _tagController.dispose();
    _numServicoController.dispose();
    _obsGeneralController.dispose();
    _distanciaController.dispose();
    _velocidadeController.dispose();
    _thController.dispose();
    _divisorController.dispose();
    _pulsosController.dispose();
    _qmaxController.dispose();
    _tempoController.dispose();
    _toneladasTesteController.dispose();
    _pesoDinamicoController.dispose();
    _nvoltasController.dispose();
    _tempoDeCalibracaoController.dispose();
    _obsLimpezaController.dispose();
    _c1Controller.dispose();
    _c2Controller.dispose();
    _obsCelulasController.dispose();
    _oldConstZeroController.dispose();
    _newConstZeroController.dispose();
    _newZero2Controller.dispose();
    _z1Controller.dispose();
    _z2Controller.dispose();
    _z3Controller.dispose();
    _z4Controller.dispose();
    _c1ZeroController.dispose();
    _c2ZeroController.dispose();
    _c3ZeroController.dispose();
    _c4ZeroController.dispose();
    _obsZeroController.dispose();
    _oldConstSpanController.dispose();
    _newConstSpanController.dispose();
    _s1Controller.dispose();
    _s2Controller.dispose();
    _s3Controller.dispose();
    _s4Controller.dispose();
    _c1SpanController.dispose();
    _c2SpanController.dispose();
    _c3SpanController.dispose();
    _c4SpanController.dispose();
    _obsSpanController.dispose();
    // Liberar controladores de error de Zero
_err1ZController.dispose();
_err2ZController.dispose();
_err3ZController.dispose();
_err4ZController.dispose();

// Liberar controladores de error de Span
_err11Controller.dispose();
_err22Controller.dispose();
_err33Controller.dispose();
_err44Controller.dispose();
    for (var e in _executores) {
      e['nome']?.dispose();
      e['esp']?.dispose();
    }
    super.dispose();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          Text(
            value ? 'SIM' : 'NÃO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: value ? Colors.green : Colors.red,
              fontSize: 12,
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFF00A859),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

Widget _buildTextField(
    String label, 
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text, 
    bool readOnly = false,
    ValueChanged<String>? onChanged, // <--- Se agrega el callback opcional
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onChanged: onChanged, // <--- Se vincula directamente al TextField
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTranslations.getText(widget.lang, 'procedimiento_calibracion'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
              ),
              const SizedBox(height: 10),

              // 1. Datos Generales
              _buildSectionHeader(AppTranslations.getText(widget.lang, 'datos_generales')),
              DropdownButtonFormField<String>(
              initialValue: _tagSeleccionado ?? _listaTags.first,
              decoration: InputDecoration(
              labelText: AppTranslations.getText(widget.lang, 'tag_equipamento'),
              border: OutlineInputBorder(),
              isDense: true,
  ),
  items: _listaTags.map((String tag) {
    return DropdownMenuItem<String>(
      value: tag,
      child: Text(tag, style: const TextStyle(fontSize: 12)),
    );
  }).toList(),
  onChanged: (novoTag) {
    _seleccionarTag(novoTag);
  },
),
              _buildTextField(AppTranslations.getText(widget.lang, 'numero_servicio'), _numServicoController),
             
  Padding(
  padding: const EdgeInsets.symmetric(vertical: 4.0),
  child: DropdownButtonFormField<String>(
    key: ValueKey('${widget.lang}_$_selectedArea'),
    initialValue: _selectedArea,
    decoration: InputDecoration(
      labelText: AppTranslations.getText(widget.lang, 'area_planta'),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: const OutlineInputBorder(),
    ),
    items: [
      DropdownMenuItem(
        value: 'Britagem',
        child: Text(AppTranslations.getText(widget.lang, 'britagem')),
      ),
      DropdownMenuItem(
        value: 'DMS',
        child: Text(AppTranslations.getText(widget.lang, 'dms')),
      ),
    ],
    onChanged: (newValue) {
      if (newValue != null) {
        setState(() {
          _selectedArea = newValue;
        });
      }
    },
  ), // DropdownButtonFormField
            ), // Padding
            _buildTextField(AppTranslations.getText(widget.lang, 'data_relatorio'), _dataController),
              
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildTextField(AppTranslations.getText(widget.lang, 'distancia_correia'), _distanciaController, keyboardType: TextInputType.number, readOnly: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField(AppTranslations.getText(widget.lang,'Velocidade (m/s)'), _velocidadeController, keyboardType: TextInputType.number, readOnly: true)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField(AppTranslations.getText(widget.lang,'Q (T/H)'), _thController, keyboardType: TextInputType.number, readOnly: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField(AppTranslations.getText(widget.lang,'Divisor'), _divisorController, keyboardType: TextInputType.number, readOnly: true)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField(AppTranslations.getText(widget.lang,'Pulsos'), _pulsosController, keyboardType: TextInputType.number, readOnly: true)),
                  const SizedBox(width: 8),
                  Expanded(
  child: _buildTextField(
    AppTranslations.getText(widget.lang, 'FAIXA (TPH)'), 
    _qmaxController, 
    keyboardType: TextInputType.number,
    onChanged: (_) => _calcularTodo(),
  ),
)
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField(AppTranslations.getText(widget.lang,'#Voltas'), _nvoltasController, keyboardType: TextInputType.number, readOnly: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField(AppTranslations.getText(widget.lang,'Tempo de Calibraçao (s)'), _tempoDeCalibracaoController, keyboardType: TextInputType.number, readOnly: true)),
                ],
              ),
             Row(
  children: [
    Expanded(
      child: _buildTextField(
        AppTranslations.getText(widget.lang, 'Toneladas Teste (TTE)'),
        _toneladasTesteController,
        keyboardType: TextInputType.number,
        onChanged: (_) => _calcularTodo(),
      ),
    ),
  ],
),
              // 2. Limpeza
              const Divider(height: 24),
              _buildSectionHeader(AppTranslations.getText(widget.lang,'2. Limpeza')),
              _buildSwitchRow(AppTranslations.getText(widget.lang,'2.1 Limpar o ponte de pesagem'), _limpeza21, (v) => setState(() => _limpeza21 = v)),
              _buildSwitchRow(AppTranslations.getText(widget.lang,'2.2 Limpar integrador'), _limpeza22, (v) => setState(() => _limpeza22 = v)),
              _buildSwitchRow(AppTranslations.getText(widget.lang,'2.3 Limpar o sensor de velocidade'), _limpeza23, (v) => setState(() => _limpeza23 = v)),
              _buildSwitchRow(AppTranslations.getText(widget.lang,'2.4 Verifique e ajuste os cabos soltos'), _limpeza24, (v) => setState(() => _limpeza24 = v)),
              _buildTextField(AppTranslations.getText(widget.lang,'Observação Limpeza'), _obsLimpezaController),

              // 3. Inspeção de células
              const Divider(height: 24),
              _buildSectionHeader(AppTranslations.getText(widget.lang,'3. Inspeção de células de carga')),
              _buildSwitchRow(AppTranslations.getText(widget.lang,'3.1 Alinhar a correia com a ajuda do pessoal mecânico'), _inspecao31, (v) => setState(() => _inspecao31 = v)),
              Row(
                children: [
                  Expanded(child: _buildTextField(AppTranslations.getText(widget.lang,'Medição Célula C1 (mV)'), _c1Controller, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField(AppTranslations.getText(widget.lang,'Medição Célula C2 (mV)'), _c2Controller, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                ],
              ),
              _buildTextField(AppTranslations.getText(widget.lang,'Observação Células'), _obsCelulasController),

              // 4. Calibração Zero
              // 4. Calibração Zero
const Divider(height: 24),
_buildSectionHeader(AppTranslations.getText(widget.lang, '4. Calibração Zero')),
Row(
  children: [
    Expanded(child: _buildTextField(AppTranslations.getText(widget.lang, 'OLD CONST ZERO'), _oldConstZeroController)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField(AppTranslations.getText(widget.lang, 'NEW CONST ZERO'), _newConstZeroController)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('NEW ERROR',  _newZero2Controller)),
  ],
),
Row(
  children: [
    Expanded(child: _buildTextField('1º ZERO', _z1Controller, onChanged: (_) => _calcularTodo())),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('2º ZERO', _z2Controller, onChanged: (_) => _calcularTodo())),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('3º ZERO', _z3Controller, onChanged: (_) => _calcularTodo())),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('4º ZERO', _z4Controller, onChanged: (_) => _calcularTodo())),
  ],
),
Row(
  children: [
    Expanded(child: _buildTextField('1º DIF / ERROR', _err1ZController, readOnly: true)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('2º DIF / ERROR', _err2ZController, readOnly: true)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('3º DIF / ERROR', _err3ZController, readOnly: true)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('4º DIF / ERROR', _err4ZController, readOnly: true)),
  ],
),

Row(
  children: [
    Expanded(child: _buildTextField('1º CONST', _c1ZeroController)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('2º CONST', _c2ZeroController)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('3º CONST', _c3ZeroController)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('4º CONST', _c4ZeroController)),
  ],
),
const SizedBox(height: 8),

              _buildTextField(AppTranslations.getText(widget.lang,'Observação Zero'), _obsZeroController),

              // 5. Calibração Span
const Divider(height: 24),
_buildSectionHeader(AppTranslations.getText(widget.lang, '5. Calibração Span')),

// Fila 1: Old Const Span, New Const Span, New Const Span 2
Row(
  children: [
    Expanded(child: _buildTextField('OLD CONST SPAN', _oldConstSpanController)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('NEW CONST SPAN', _newConstSpanController)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('NEW ERROR', _newConstSpan2Controller)),
  ],
),
const SizedBox(height: 8),

// Fila 2: Casillas de SPAN (1° a 4°)
// Fila 2: Casillas de SPAN (1º a 4º)
Row(
  children: [
    Expanded(child: _buildTextField('1º SPAN', _s1Controller, onChanged: (_) => _calcularTodo())),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('2º SPAN', _s2Controller, onChanged: (_) => _calcularTodo())),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('3º SPAN', _s3Controller, onChanged: (_) => _calcularTodo())),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('4º SPAN', _s4Controller, onChanged: (_) => _calcularTodo())),
  ],
),
const SizedBox(height: 8),

// Fila 3: Casillas de DIFERENCIA / ERROR (AQUÍ VAN LAS NUEVAS CASILLAS)
Row(
  children: [
    Expanded(child: _buildTextField('1º DIF / ERROR', _err11Controller, readOnly: true)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('2º DIF / ERROR', _err22Controller, readOnly: true)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('3º DIF / ERROR', _err33Controller, readOnly: true)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('4º DIF / ERROR', _err44Controller, readOnly: true)),
  ],
),
const SizedBox(height: 8),

// Fila 4: Casillas de CONSTANTES (1° a 4°)
Row(
  children: [
    Expanded(child: _buildTextField('1º CONST', _c1SpanController)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('2º CONST', _c2SpanController)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('3º CONST', _c3SpanController)),
    const SizedBox(width: 8),
    Expanded(child: _buildTextField('4º CONST', _c4SpanController)),
  ],
),
const SizedBox(height: 8),

_buildTextField(AppTranslations.getText(widget.lang, 'Observação Span'), _obsSpanController),

              // 6. Observaciones Generales
              const Divider(height: 24),
              _buildSectionHeader(AppTranslations.getText(widget.lang,'6. Observações Geral / Condição da Correia')),
              _buildTextField(AppTranslations.getText(widget.lang,'Observações'), _obsGeneralController),

              // 7. Executores
              const Divider(height: 24),
              _buildSectionHeader(AppTranslations.getText(widget.lang, '7. Executores')),
              Row(
  children: [
    Text(
      AppTranslations.getText(widget.lang, 'Número de executores:'),
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    const SizedBox(width: 12),
    DropdownButton<int>(
      value: _cantidadEjecutores,
      items: List.generate(6, (i) => i + 1).map((num) {
        return DropdownMenuItem<int>(
          value: num,
          child: Text('$num'),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _cantidadEjecutores = val;
          });
        }
      },
    ),
  ],
),
const SizedBox(height: 12),
              for (int i = 0; i < _executores.length; i++) ...[
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField('${AppTranslations.getText(widget.lang, 'nome_sobrenome')} ${i + 1}', _executores[i]['nome']!),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
  flex: 1,
  child: DropdownButtonFormField<String>(
    key: ValueKey('${widget.lang}_${i}_${_executores[i]['esp']!.text}'),
    initialValue: (_executores[i]['esp']!.text == 'ELETRICISTA')
      ? 'ELETRICISTA'
      : 'INSTRUMENTISTA',
    decoration: InputDecoration(
      labelText: AppTranslations.getText(widget.lang, 'especialidade'),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(),
    ),
   items: [
  DropdownMenuItem(
    value: 'INSTRUMENTISTA', 
    child: Text(AppTranslations.getText(widget.lang, 'instrumentista')),
  ),
  DropdownMenuItem(
    value: 'ELETRICISTA', 
    child: Text(AppTranslations.getText(widget.lang, 'eletricista')),
  ),
],
    onChanged: (newValue) {
      if (newValue != null) {
        setState(() {
          _executores[i]['esp']!.text = newValue;
        });
      }
    },
  ),
),
                  ],
                ),
              ],
const SizedBox(height: 20),
ElevatedButton.icon(
  onPressed: () async {
   List<Map<String, String>> executoresData = _executores.map((e) {
  return {
    'nome': e['nome']?.text ?? '',
    'especialidade': (e['esp']?.text.isEmpty ?? true) 
        ? 'INSTRUMENTISTA' 
        : e['esp']!.text, // <-- Aaquí debe decir 'especialidade'
  };
}).toList();
    await RelatorioPDFService.descargarPDF(
      lang: widget.lang,
      numeroServico: _numServicoController.text,
      tagBalanca: _tagController.text,
      data: _dataController.text,
      bancoDados: {
        'L': _distanciaController.text,
        'v': _velocidadeController.text,
        'th': _thController.text,
        'divisor': _divisorController.text,
        'pulsos': _pulsosController.text,
        'qmax': _qmaxController.text,
        'tempo': _tempoController.text,
        'nvoltas': _nvoltasController.text,
        'tempoDeCalibracao': _tempoDeCalibracaoController.text,
        'toneladasTeste': _toneladasTesteController.text,
      },
      limpeza: {
        '2.1 Limpeza dos rolos de carga e retorno': _limpeza21,
        '2.2 Limpeza e alinhamento do tambor gravidade': _limpeza22,
        '2.3 Verificar estado da correia vulcanizada': _limpeza23,
        '2.4 Inspeção geral de limpeza': _limpeza24,
      },
      obsLimpeza: _obsLimpezaController.text,
     inspeccion: {
  '3.1 Inspeção mecânica e elétrica das células': _inspecao31,
},
    obsInspeccion: _obsCelulasController.text,
medicionC1: _c1Controller.text,
medicionC2: _c2Controller.text,
      zero: {
        'oldConst': _oldConstZeroController.text,
        'newConst': _newConstZeroController.text,
        'newError' : _newZero2Controller.text,
        'z1': _z1Controller.text,
        'z2': _z2Controller.text,
        'z3': _z3Controller.text,
        'z4': _z4Controller.text,
        'c1': _c1ZeroController.text,
        'c2': _c2ZeroController.text,
        'c3': _c3ZeroController.text,
        'c4': _c4ZeroController.text,
        'err1': _err1ZController.text,
        'err2': _err2ZController.text,
        'err3': _err3ZController.text,
        'err4': _err4ZController.text,
      },
      obsZero: _obsZeroController.text,
      span: {
        'oldConst': _oldConstSpanController.text,
        'newConst': _newConstSpanController.text,
        'newError': _newConstSpan2Controller.text,
        's1': _s1Controller.text,
        's2': _s2Controller.text,
        's3': _s3Controller.text,
        's4': _s4Controller.text,
        'err11': _err11Controller.text,
        'err22': _err22Controller.text,
        'err33': _err33Controller.text,
        'err44': _err44Controller.text,
        'c1': _c1SpanController.text,
        'c2': _c2SpanController.text,
        'c3': _c3SpanController.text,
        'c4': _c4SpanController.text,

      },
      obsSpan: _obsSpanController.text,
      comentarios: _obsGeneralController.text,
      executores: executoresData,
    );
  },
  icon: const Icon(Icons.picture_as_pdf),
  label: Text(AppTranslations.getText(widget.lang,'GERAR E SALVAR RELATÓRIO')),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF00A859),
    foregroundColor: Colors.white,
    minimumSize: const Size.fromHeight(50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
), // ElevatedButton.icon
      ],
    ), // Column
  ), // Padding
), // SingleChildScrollView
    );
  }
}
// ===================================================
// PLACEHOLDER PARA OTROS MÓDULOS (DENSIDADE, PRESSÃO, ETC.)
// ===================================================
class ModuloPlaceholder extends StatelessWidget {
  final String nombre;
  final IconData icono;

  const ModuloPlaceholder({
    super.key,
    required this.nombre,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icono, 
            size: 80, 
            color: Color.fromARGB(255, 9, 107, 58).withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Módulo $nombre',
            style: const TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold, 
              color: Color.fromARGB(255, 5, 138, 82),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Em desenvolvimento para a Sigma Lithium',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}