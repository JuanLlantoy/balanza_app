import 'relatorio_pdf.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ota_update/ota_update.dart';
import 'package:flutter/material.dart';
Future<void> verificarActualizacionAndroid() async {
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

  final List<String> _titles = [
    'DENSIDADE',
    'BALANÇA DA CORREIA',
    'PRESSÃO',
    'NÍVEL',
    'FLUXO / VAZÃO'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
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
            const BalancaModuleScreen(),
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
  const BalancaModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Color(0xFF003366),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF00A859),
              indicatorWeight: 3,
              tabs: [
                Tab(icon: Icon(Icons.calculate), text: "CALCULADORA"),
                Tab(icon: Icon(Icons.assignment), text: "INICIAR REPORTE"),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            BalancaCalculadoraTab(),
            BalancaReporteTab(),
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
  const BalancaCalculadoraTab({super.key});

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
    // Inputs Step 1
    final vTacometro = double.tryParse(_tacometroController.text) ?? 0.0;
    final tVolta = double.tryParse(_tempoVoltaController.text) ?? 0.0;

    // Inputs Step 2
    final pEstatico = double.tryParse(_pesoEstaticoController.text) ?? 0.0;
    final dFaixa = double.tryParse(_faixaPesagemController.text) ?? 0.0;
    final nVoltas = double.tryParse(_numVoltasController.text) ?? 0.0;

    // Inputs Step 3 & 4
    final tsTeste = double.tryParse(_tempoTesteController.text) ?? 0.0;

    setState(() {
      // 1) L = Velocidade * Tempo em uma volta
      _distanciaL = vTacometro * tVolta;

      // 2) C = P / D  (kg/m)
      _carregamentoC = (dFaixa > 0) ? (pEstatico / dFaixa) : 0.0;

      // LT = N * L
      _comprimentoTesteLT = nVoltas * _distanciaL;

      // TTE = (C * LT) / 1000
      _tte = (_carregamentoC * _comprimentoTesteLT) / 1000.0;

      // 3) Q (t/h) = (TTE * 3600) / Ts
      _vazaoQ = (tsTeste > 0) ? ((_tte * 3600) / tsTeste) : 0.0;

      // 4) V (m/s) = LT / Ts
      _velocidadeV = (tsTeste > 0) ? (_comprimentoTesteLT / tsTeste) : 0.0;
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
            title: '1. DISTÂNCIA DA CORREIA (L)',
            color: Colors.blue.shade900,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller: _tacometroController,
                        label: 'Tacômetro (m/s)',
                        icon: Icons.speed,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInput(
                        controller: _tempoVoltaController,
                        label: 'Tempo 1 Volta (s)',
                        icon: Icons.timer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildFormulaResult(
                  formula: 'L = (Velocidade) * (Tempo em uma volta)',
                  resultLabel: 'Distância da Correia (L):',
                  resultValue: '${_distanciaL.toStringAsFixed(2)} metros',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ----------------------------------------------------
          // BLOQUE 2: TONELADAS DE TESTE (TTE)
          // ----------------------------------------------------
          _buildCardSection(
            title: '2. TONELADAS DE TESTE (TTE)',
            color: Colors.teal.shade800,
            child: Column(
              children: [
                _buildInput(
                  controller: _pesoEstaticoController,
                  label: 'Somatória pesos estáticos - P (kg)',
                  icon: Icons.scale,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller: _faixaPesagemController,
                        label: 'Faixa de pesagem - D (m)',
                        icon: Icons.straighten,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInput(
                        controller: _numVoltasController,
                        label: 'N° Voltas de Teste - N',
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
                      Text('• Carregamento simulado C (P/D) = ${_carregamentoC.toStringAsFixed(2)} kg/m'),
                      Text('• Comprimento de teste LT (N x L) = ${_comprimentoTesteLT.toStringAsFixed(2)} m'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildFormulaResult(
                  formula: 'TTE = (C x LT) / 1000',
                  resultLabel: 'Toneladas de Teste (TTE):',
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
            title: '3. VAZÃO SIMULADA (Q) & VELOCIDADE (V)',
            color: Colors.orange.shade900,
            child: Column(
              children: [
                _buildInput(
                  controller: _tempoTesteController,
                  label: 'Tempo do teste - Ts (segundos)',
                  icon: Icons.access_time_filled,
                  helperText: 'Recomendado: pelo menos 6 min (360s) e 3 voltas',
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildResultBox(
                        title: 'VAZÃO SIMULADA (Q)',
                        value: _vazaoQ.toStringAsFixed(2),
                        unit: 't/h (TPH)',
                        color: Colors.amber.shade100,
                        textColor: Colors.amber.shade900,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildResultBox(
                        title: 'VELOCIDADE (V)',
                        value: _velocidadeV.toStringAsFixed(2),
                        unit: 'm/s',
                        color: Colors.blue.shade100,
                        textColor: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
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
  const BalancaReporteTab({super.key});

  @override
  State<BalancaReporteTab> createState() => _BalancaReporteTabState();
}

class _BalancaReporteTabState extends State<BalancaReporteTab> {
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
  final _nvoltasController = TextEditingController();
  final _tempoDeCalibracaoController = TextEditingController();
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
      _toneladasTesteController.text = datos['TonTeste'] ?? '';
      _pesoDinamicoController.text = datos['PesoDinamico'] ?? '';
      _nvoltasController.text = datos['#Voltas'] ?? datos['nVoltas'] ?? '';
      _tempoDeCalibracaoController.text = datos['TempoDeCalibracao'] ?? datos['TempoDeCalibraçao'] ?? '';
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
  final _z1Controller = TextEditingController();
  final _z2Controller = TextEditingController();
  final _z3Controller = TextEditingController();
  final _z4Controller = TextEditingController();
  final _c1ZeroController = TextEditingController();
  final _c2ZeroController = TextEditingController();
  final _c3ZeroController = TextEditingController();
  final _c4ZeroController = TextEditingController();
  final _obsZeroController = TextEditingController();

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

  // 7. Executores
  final List<Map<String, TextEditingController>> _executores = [
    {'nome': TextEditingController(), 'esp': TextEditingController(text: 'INSTRUMENTISTA')},
    {'nome': TextEditingController(), 'esp': TextEditingController(text: 'ELECTRICISTA')},
    {'nome': TextEditingController(), 'esp': TextEditingController(text: 'INSTRUMENTISTA')},
  ];

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

Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, bool readOnly = false}) {    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
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
              const Text(
                'Procedimento de Calibração da Balança',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
              ),
              const SizedBox(height: 10),

              // 1. Datos Generales
              _buildSectionHeader('1. Cabeçalho e Banco de dados'),
              DropdownButtonFormField<String>(
              initialValue: _tagSeleccionado ?? _listaTags.first,
              decoration: const InputDecoration(
              labelText: 'TAG do Equipamento',
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
              _buildTextField('Número de Serviço', _numServicoController),
              Padding(
  padding: const EdgeInsets.symmetric(vertical: 4.0),
  child: DropdownButtonFormField<String>(
    initialValue: _selectedArea,
    decoration: const InputDecoration(
      labelText: 'Área / Planta',
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(),
    ),
    items: const [
      DropdownMenuItem(value: 'Britagem', child: Text('Britagem')),
      DropdownMenuItem(value: 'DMS', child: Text('DMS')),
    ],
    onChanged: (newValue) {
      if (newValue != null) {
        setState(() {
          _selectedArea = newValue;
        });
      }
    },
  ),
),
              _buildTextField('Data do Relatório', _dataController),
              
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildTextField('Distância da correia (m)', _distanciaController, keyboardType: TextInputType.number, readOnly: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('Velocidade (m/s)', _velocidadeController, keyboardType: TextInputType.number, readOnly: true)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField('Q (T/H)', _thController, keyboardType: TextInputType.number, readOnly: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('Divisor', _divisorController, keyboardType: TextInputType.number, readOnly: true)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField('Pulsos', _pulsosController, keyboardType: TextInputType.number, readOnly: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('FAIXA (TPH)', _qmaxController, keyboardType: TextInputType.number, readOnly: true)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField('#Voltas', _nvoltasController, keyboardType: TextInputType.number, readOnly: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('Tempo de Calibraçao (s)', _tempoDeCalibracaoController, keyboardType: TextInputType.number, readOnly: true)),
                ],
              ),
              
              
              // 2. Limpeza
              const Divider(height: 24),
              _buildSectionHeader('2. Limpeza'),
              _buildSwitchRow('2.1 Limpar o ponte de pesagem', _limpeza21, (v) => setState(() => _limpeza21 = v)),
              _buildSwitchRow('2.2 Limpar integrador', _limpeza22, (v) => setState(() => _limpeza22 = v)),
              _buildSwitchRow('2.3 Limpar o sensor de velocidade', _limpeza23, (v) => setState(() => _limpeza23 = v)),
              _buildSwitchRow('2.4 Verifique e ajuste os cabos soltos', _limpeza24, (v) => setState(() => _limpeza24 = v)),
              _buildTextField('Observação Limpeza', _obsLimpezaController),

              // 3. Inspeção de células
              const Divider(height: 24),
              _buildSectionHeader('3. Inspeção de células de carga'),
              _buildSwitchRow('3.1 Alinhar a correia com a ajuda do pessoal mecânico', _inspecao31, (v) => setState(() => _inspecao31 = v)),
              Row(
                children: [
                  Expanded(child: _buildTextField('Medição Célula C1 (mV)', _c1Controller, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('Medição Célula C2 (mV)', _c2Controller, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                ],
              ),
              _buildTextField('Observação Células', _obsCelulasController),

              // 4. Calibração Zero
              const Divider(height: 24),
              _buildSectionHeader('4. Calibração Zero'),
              Row(
                children: [
                  Expanded(child: _buildTextField('OLD CONST ZERO', _oldConstZeroController)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('NEW CONST ZERO', _newConstZeroController)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField('1º ZERO', _z1Controller)),
                  Expanded(child: _buildTextField('2º ZERO', _z2Controller)),
                  Expanded(child: _buildTextField('3º ZERO', _z3Controller)),
                  Expanded(child: _buildTextField('4º ZERO', _z4Controller)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField('1º CONST', _c1ZeroController)),
                  Expanded(child: _buildTextField('2º CONST', _c2ZeroController)),
                  Expanded(child: _buildTextField('3º CONST', _c3ZeroController)),
                  Expanded(child: _buildTextField('4º CONST', _c4ZeroController)),
                ],
              ),
              _buildTextField('Observação Zero', _obsZeroController),

              // 5. Calibração Span
              const Divider(height: 24),
              _buildSectionHeader('5. Calibração Span'),
              Row(
                children: [
                  Expanded(child: _buildTextField('OLD CONST SPAN', _oldConstSpanController)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('NEW CONST SPAN', _newConstSpanController)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField('1º SPAN', _s1Controller)),
                  Expanded(child: _buildTextField('2º SPAN', _s2Controller)),
                  Expanded(child: _buildTextField('3º SPAN', _s3Controller)),
                  Expanded(child: _buildTextField('4º SPAN', _s4Controller)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField('1º CONST', _c1SpanController)),
                  Expanded(child: _buildTextField('2º CONST', _c2SpanController)),
                  Expanded(child: _buildTextField('3º CONST', _c3SpanController)),
                  Expanded(child: _buildTextField('4º CONST', _c4SpanController)),
                ],
              ),
              _buildTextField('Observação Span', _obsSpanController),

              // 6. Observaciones Generales
              const Divider(height: 24),
              _buildSectionHeader('6. Observações Geral / Condição da Correia'),
              _buildTextField('Observações', _obsGeneralController),

              // 7. Executores
              const Divider(height: 24),
              _buildSectionHeader('7. Executores'),
              for (int i = 0; i < _executores.length; i++) ...[
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField('Nome e Sobrenome ${i + 1}', _executores[i]['nome']!),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
  flex: 1,
  child: DropdownButtonFormField<String>(
    initialValue: (_executores[i]['esp']!.text == 'ELETRICISTA') 
        ? 'ELETRICISTA' 
        : 'INSTRUMENTISTA',
    decoration: const InputDecoration(
      labelText: 'Especialidade',
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(),
    ),
    items: const [
      DropdownMenuItem(value: 'INSTRUMENTISTA', child: Text('INSTRUMENTISTA')),
      DropdownMenuItem(value: 'ELETRICISTA', child: Text('ELETRICISTA')),
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
        'z1': _z1Controller.text,
        'z2': _z2Controller.text,
        'z3': _z3Controller.text,
        'z4': _z4Controller.text,
        'c1': _c1ZeroController.text,
        'c2': _c2ZeroController.text,
        'c3': _c3ZeroController.text,
        'c4': _c4ZeroController.text,
        'ideal': '0',
        'Limite permitido': '+/-0.002',
      },
      obsZero: _obsZeroController.text,
      span: {
        'oldConst': _oldConstSpanController.text,
        'newConst': _newConstSpanController.text,
        's1': _s1Controller.text,
        's2': _s2Controller.text,
        's3': _s3Controller.text,
        's4': _s4Controller.text,
        'c1': _c1SpanController.text,
        'c2': _c2SpanController.text,
        'c3': _c3SpanController.text,
        'c4': _c4SpanController.text,
        'ideal': '0',
        'Limite permitido': '+/- 0.001',
      },
      obsSpan: _obsSpanController.text,
      comentarios: _obsGeneralController.text,
      executores: executoresData,
    );
  },
  icon: const Icon(Icons.picture_as_pdf),
  label: const Text('GERAR E SALVAR RELATÓRIO'),
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