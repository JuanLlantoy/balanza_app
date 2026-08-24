class AppTranslations {
  static const Map<String, Map<String, String>> _keys = {
    'es': {
      // Appbar & Tabs
      'titulo': 'BALANZA DE FAJA',
      'calculadora': 'CALCULADORA',
      'iniciar_reporte': 'INICIAR REPORTE',

      // Encabezados de Reporte y Datos Generales
      'datos_generales': '1. DATOS GENERALES',
      'tag_equipamento': 'TAG del Equipo',
      'formula': 'Fórmula',
      'numero_servicio': 'Número de Servicio',
      'area_planta': 'Área / Planta',
      'britagem': 'Chancado',
      'dms': 'DMS',
      'data_relatorio': 'Fecha de Reporte',
      'distancia_correia': 'Distancia de Faja',
      'Velocidade (m/s)': 'Velocidad (m/s)',
      'velocidade_ms': 'Velocidad (m/s)',
      'Q (T/H)': 'Caudal Q (T/H)',
      'Divisor': 'Divisor',
      'Pulsos': 'Pulsos',
      'FAIXA (TPH)': 'RANGO (TPH)',
      'Faixa (t/h)': 'Rango (t/h)',
      '#Voltas': 'N° Vueltas',
      'Tempo de Calibraçao (s)': 'Tiempo de Calibración (s)',
      'Tempo Total (s)': 'Tiempo Total (s)',
      'Toneladas Teste (TTE)': 'Toneladas De Prueba (TTE)', 

      // Sección 1: Distancia de Faja
      '1. DISTÂNCIA DA CORREIA (L)': '1. DISTANCIA DE FAJA (L)',
      'distancia_faja': '1. DISTANCIA DE FAJA (L)',
      'Tacômetro (m/s)': 'Tacómetro (m/s)',
      'tacometro': 'Tacómetro (m/s)',
      'tacometro_ms': 'Tacómetro (m/s)',
      'Tempo 1 Volta (s)': 'Tiempo 1 Vuelta (s)',
      'tempo_vuelta': 'Tiempo 1 Vuelta (s)',
      'tempo_1_volta_s': 'Tiempo 1 Vuelta (s)',
      'tempo_em_uma_volta': 'Tiempo en una vuelta',
      'distancia_resultado': 'Distancia de Faja (L):',
      'distancia_da_correia_l': 'Distancia de Faja (L):',
      'metros': 'metros',

      // Sección 2: Toneladas de Prueba
      '2. TONELADAS DE TESTE (TTE)': '2. TONELADAS DE PRUEBA (TTE)',
      'toneladas_test': '2. TONELADAS DE PRUEBA (TTE)',
      'Somatória pesos estáticos - P (kg)': 'Sumatoria pesos estáticos - P (kg)',
      'suma_pesos': 'Sumatoria pesos estáticos - P (kg)',
      'Faixa de pesagem - D (m)': 'Rango de pesaje - D (m)',
      'faixa_pesaje': 'Rango de pesaje - D (m)',
      'N° Voltas de Teste - N': 'N° Vueltas de Test - N',
      'n_vueltas': 'N° Vueltas de Test - N',
      'carregamento_simulado': 'Carga simulada C (P/D)',
      'comprimento_teste': 'Longitud de prueba LT (N x L)',
      'toneladas_resultado': 'Toneladas de Prueba (TTE):',
      'toneladas_teste': 'Toneladas de Prueba (TTE)',

      // Sección 3 & 4: Caudal y Velocidad
      'vazao_simulada_velocidade': 'CAUDAL SIMULADO Y VELOCIDAD',
      'tempo_teste_segundos': 'Tiempo de Test (s)',
      'recomendado_tiempo_vueltas': 'Recomendado: Tiempo de N vueltas',
      'vazao_simulada': 'Caudal Simulado',
      'velocidade': 'Velocidad',

      // Formulario de Reporte
      'cliente': 'Nombre del Cliente / Planta',
      'tecnico': 'Técnico / Inspector',
      'fecha': 'Fecha de Inspección',
      'generar_pdf': 'GENERAR REPORTE PDF',

      // Formulario de Limpieza e Inspección
      '2. Limpeza': '2. Limpieza',
      '2.1 Limpar o ponte de pesagem': '2.1 Limpiar el puente de pesaje',
      '2.2 Limpar integrador': '2.2 Limpiar integrador',
      '2.3 Limpar o sensor de velocidade': '2.3 Limpiar el sensor de velocidad',
      '2.4 Verifique e ajuste os cabos soltos': '2.4 Verificar y ajustar cables sueltos',
      'Observação Limpeza': 'Observación Limpieza',
      '3. Inspeção de células de carga': '3. Inspección de células de carga',
      '3.1 Alinhar a correia com a ajuda do pessoal mecânico': '3.1 Alinear la faja con ayuda del personal mecánico',
      'Medição Célula C1 (mV)': 'Medición Célula C1 (mV)',
      'Medição Célula C2 (mV)': 'Medición Célula C2 (mV)',
      'Observação Células': 'Observación Células',
      'Observação Inspeção':'Observación Inspección',
      '4. Calibração Zero': '4. Calibración Zero',
      'Observação Zero': 'Observación Zero',

      // Sección 5: Span
      '5. Calibração Span': '5. Calibración Span',
      'OLD CONST SPAN': 'CONST SPAN ANTERIOR',
      'NEW CONST SPAN': 'CONST SPAN NUEVA',
      '1° SPAN': '1° SPAN',
      '2° SPAN': '2° SPAN',
      '3° SPAN': '3° SPAN',
      '4° SPAN': '4° SPAN',
      '1° CONST': '1° CONST',
      '2° CONST': '2° CONST',
      '3° CONST': '3° CONST',
      '4° CONST': '4° CONST',
      'Observação Span': 'Observación Span',

      // Sección 6 & 7: Observaciones y Executores
      '6. Observações Geral / Condição da Correia': '6. Observaciones Generales / Condición de la Faja',
      'Observações': 'Observaciones',
      '7. Executores': '7. Ejecutores',
      'nome_sobrenome': 'Nombre y Apellido',
      'nome_sobrenome 1': 'Nombre y Apellido 1',
      'nome_sobrenome 2': 'Nombre y Apellido 2',
      'nome_sobrenome 3': 'Nombre y Apellido 3',
      'Especialidade': 'Especialidad',
      'instrumentista': 'Técnico Instrumentista',
      'eletricista' : 'Técnico Electricista',
      'GERAR E SALVAR RELATÓRIO': 'GENERAR Y GUARDAR REPORTE',
      'Número de executores:': 'Numero de ejecutores:',

      // Contenido del PDF
      'pdf_titulo': 'REPORTE TÉCNICO DE CALIBRACIÓN',
      'pdf_subtitulo': 'Balanza de Faja',
      'pdf_resumen': 'Resumen de Cálculos',

      // Texto por defecto cuando no hay observaciones
    'Sem observações registradas.': 'Sin observaciones registradas.',
    
    // Opciones de confirmación
    'SIM': 'SÍ',
    'NÃO': 'NO',

    // Células de carga
    'Medição Célula C1': 'Medición Célula C1',
    'Medição Célula C2': 'Medición Célula C2',

    // Textos de Limpeza (deben coincidir exactamente con las keys de tu Map)
    '2.1 Limpeza dos rolos de carga e retorno': '2.1 Limpieza de polines de carga y retorno',
    '2.2 Limpeza e alinhamento do tambor gravidade': '2.2 Limpieza y alineación del tambor de gravedad',
    '2.3 Verificar estado da correia vulcanizada': '2.3 Verificar estado de la faja vulcanizada',
    '2.4 Inspeção geral de limpeza': '2.4 Inspección general de limpieza',

    // Textos de Inspeção
    '3.1 Inspeção mecânica e elétrica das células': '3.1 Inspección mecánica y eléctrica de celdas',
    },
    'pt': {
      // Appbar & Tabs
      'titulo': 'BALANÇA DA CORREIA',
      'calculadora': 'CALCULADORA',
      'iniciar_reporte': 'INICIAR RELATÓRIO',

      // Encabezados de Reporte y Datos Generales
      'datos_generales': '1. DADOS GERAIS',
      'tag_equipamento': 'TAG do Equipamento',
      'formula': 'Fórmula',
      'numero_servicio': 'Número do Serviço',
      'area_planta': 'Área / Planta',
      'britagem': 'Britagem',
      'dms': 'DMS',
      'data_relatorio': 'Data do Relatório',
      'distancia_correia': 'Distância da Correia',
      'Velocidade (m/s)': 'Velocidade (m/s)',
      'velocidade_ms': 'Velocidade (m/s)',
      'Q (T/H)': 'Vazão Q (T/H)',
      'Divisor': 'Divisor',
      'Pulsos': 'Pulsos',
      'FAIXA (TPH)': 'FAIXA (TPH)',
      'Faixa (t/h)': 'Faixa (t/h)',
      '#Voltas': 'N° Voltas',
      'Tempo de Calibraçao (s)': 'Tempo de Calibração (s)',
      'Tempo Total (s)': 'Tempo Total (s)',
      'Toneladas Teste (TTE)': 'Toneladas Teste (TTE)',

      // Sección 1: Distancia de Faja
      '1. DISTÂNCIA DA CORREIA (L)': '1. DISTÂNCIA DA CORREIA (L)',
      'distancia_faja': '1. DISTÂNCIA DA CORREIA (L)',
      'Tacômetro (m/s)': 'Tacômetro (m/s)',
      'tacometro': 'Tacômetro (m/s)',
      'tacometro_ms': 'Tacômetro (m/s)',
      'Tempo 1 Volta (s)': 'Tempo 1 Volta (s)',
      'tempo_vuelta': 'Tempo 1 Volta (s)',
      'tempo_1_volta_s': 'Tempo 1 Volta (s)',
      'tempo_em_uma_volta': 'Tempo em uma volta',
      'distancia_resultado': 'Distância da Correia (L):',
      'distancia_da_correia_l': 'Distância da Correia (L):',
      'metros': 'metros',

      // Sección 2: Toneladas de Prueba
      '2. TONELADAS DE TESTE (TTE)': '2. TONELADAS DE TESTE (TTE)',
      'toneladas_test': '2. TONELADAS DE TESTE (TTE)',
      'Somatória pesos estáticos - P (kg)': 'Somatória pesos estáticos - P (kg)',
      'suma_pesos': 'Somatória pesos estáticos - P (kg)',
      'Faixa de pesagem - D (m)': 'Faixa de pesagem - D (m)',
      'faixa_pesaje': 'Faixa de pesagem - D (m)',
      'N° Voltas de Teste - N': 'N° Voltas de Teste - N',
      'n_vueltas': 'N° Voltas de Teste - N',
      'carregamento_simulado': 'Carregamento simulado C (P/D)',
      'comprimento_teste': 'Comprimento de teste LT (N x L)',
      'toneladas_resultado': 'Toneladas de Teste (TTE):',
      'toneladas_teste': 'Toneladas de Teste (TTE)',

      // Sección 3 & 4: Caudal y Velocidad
      'vazao_simulada_velocidade': 'VAZÃO SIMULADA E VELOCIDADE',
      'tempo_teste_segundos': 'Tempo de Teste (s)',
      'recomendado_tiempo_vueltas': 'Recomendado: Tempo de N voltas',
      'vazao_simulada': 'Vazão Simulada',
      'velocidade': 'Velocidade',

      // Formulario de Reporte
      'cliente': 'Nome do Cliente / Planta',
      'tecnico': 'Técnico / Inspetor',
      'fecha': 'Data da Inspeção',
      'generar_pdf': 'GERAR RELATÓRIO PDF',

      // Formulario de Limpieza e Inspección
      '2. Limpeza': '2. Limpeza',
      '2.1 Limpar o ponte de pesagem': '2.1 Limpar o ponte de pesagem',
      '2.2 Limpar integrador': '2.2 Limpar integrador',
      '2.3 Limpar o sensor de velocidade': '2.3 Limpar o sensor de velocidade',
      '2.4 Verifique e ajuste os cabos soltos': '2.4 Verifique e ajuste os cabos soltos',
      'Observação Limpeza': 'Observação Limpeza',
      '3. Inspeção de células de carga': '3. Inspeção de células de carga',
      '3.1 Alinhar a correia com a ajuda do pessoal mecânico': '3.1 Alinhar a correia com a ajuda do pessoal mecânico',
      'Medição Célula C1 (mV)': 'Medição Célula C1 (mV)',
      'Medição Célula C2 (mV)': 'Medição Célula C2 (mV)',
      'Observação Células': 'Observação Células',
      'Observação Inspeção':'Observação Inspeção',
      '4. Calibração Zero': '4. Calibração Zero',
      'Observação Zero': 'Observação Zero',

      // Sección 5: Span
      '5. Calibração Span': '5. Calibração Span',
      'OLD CONST SPAN': 'OLD CONST SPAN',
      'NEW CONST SPAN': 'NEW CONST SPAN',
      '1° SPAN': '1° SPAN',
      '2° SPAN': '2° SPAN',
      '3° SPAN': '3° SPAN',
      '4° SPAN': '4° SPAN',
      '1° CONST': '1° CONST',
      '2° CONST': '2° CONST',
      '3° CONST': '3° CONST',
      '4° CONST': '4° CONST',
      'Observação Span': 'Observação Span',

      // Sección 6 & 7: Observaciones y Executores
      '6. Observações Geral / Condição da Correia': '6. Observações Geral / Condição da Correia',
      'Observações': 'Observações',
      '7. Executores': '7. Executores',
      'nome_sobrenome': 'Nome e Sobrenome',
      'nome_sobrenome 1': 'Nome e Sobrenome 1',
      'nome_sobrenome 2': 'Nome e Sobrenome 2',
      'nome_sobrenome 3': 'Nome e Sobrenome 3',
      'Especialidade': 'Especialidade',
      'instrumentista': 'Técnico Instrumentista',
      'eletricista' : 'Técnico Eletricista',
      'GERAR E SALVAR RELATÓRIO': 'GERAR E SALVAR RELATÓRIO',
      'Número de executores:': 'Número de executores:',

      // Contenido del PDF
      'pdf_titulo': 'RELATÓRIO TÉCNICO DE CALIBRAÇÃO',
      'pdf_subtitulo': 'Balança da Correia',
      'pdf_resumen': 'Resumo dos Cálculos',

      'Sem observações registradas.': 'Sem observações registradas.',
    'SIM': 'SIM',
    'NÃO': 'NÃO',
    'Medição Célula C1': 'Medição Célula C1',
    'Medição Célula C2': 'Medição Célula C2',
    '2.1 Limpeza dos rolos de carga e retorno': '2.1 Limpeza dos rolos de carga e retorno',
    '2.2 Limpeza e alinhamento do tambor gravidade': '2.2 Limpeza e alinhamento do tambor gravidade',
    '2.3 Verificar estado da correia vulcanizada': '2.3 Verificar estado da correia vulcanizada',
    '2.4 Inspeção geral de limpeza': '2.4 Inspeção geral de limpeza',
    '3.1 Inspeção mecânica e elétrica das células': '3.1 Inspeção mecânica e elétrica das células',
    },
    'en': {
      // Appbar & Tabs
      'titulo': 'BELT SCALE',
      'calculadora': 'CALCULATOR',
      'iniciar_reporte': 'START REPORT',

      // Encabezados de Reporte y Datos Generales
      'datos_generales': '1. GENERAL DATA',
      'tag_equipamento': 'Equipment TAG',
      'formula': 'Formula',
      'numero_servicio': 'Service Number',
      'area_planta': 'Area / Plant',
      'britagem': 'Crushing',
      'data_relatorio': 'Report Date',
      'distancia_correia': 'Belt Length',
      'Velocidade (m/s)': 'Speed (m/s)',
      'dms': 'DMS',
      'velocidade_ms': 'Speed (m/s)',
      'Q (T/H)': 'Flow Rate Q (T/H)',
      'Divisor': 'Divider',
      'Pulsos': 'Pulses',
      'FAIXA (TPH)': 'RANGE (TPH)',
      'Faixa (t/h)': 'Range (t/h)',
      '#Voltas': 'N° Revolutions',
      'Tempo de Calibraçao (s)': 'Calibration Time (s)',
      'Tempo Total (s)': 'Total Time (s)',
      'Toneladas Teste (TTE)': 'Tons Test (TTE)',

      // Sección 1: Distancia de Faja
      '1. DISTÂNCIA DA CORREIA (L)': '1. BELT LENGTH (L)',
      'distancia_faja': '1. BELT LENGTH (L)',
      'Tacômetro (m/s)': 'Tachometer (m/s)',
      'tacometro': 'Tachometer (m/s)',
      'tacometro_ms': 'Tachometer (m/s)',
      'Tempo 1 Volta (s)': 'Time 1 Revolution (s)',
      'tempo_vuelta': 'Time 1 Revolution (s)',
      'tempo_1_volta_s': 'Time 1 Revolution (s)',
      'tempo_em_uma_volta': 'Time in one revolution',
      'distancia_resultado': 'Belt Length (L):',
      'distancia_da_correia_l': 'Belt Length (L):',
      'metros': 'meters',

      // Sección 2: Toneladas de Prueba
      '2. TONELADAS DE TESTE (TTE)': '2. TEST TONS (TTE)',
      'toneladas_test': '2. TEST TONS (TTE)',
      'Somatória pesos estáticos - P (kg)': 'Static weights sum - P (kg)',
      'suma_pesos': 'Static weights sum - P (kg)',
      'Faixa de pesagem - D (m)': 'Weighing span - D (m)',
      'faixa_pesaje': 'Weighing span - D (m)',
      'N° Voltas de Teste - N': 'N° Test Revolutions - N',
      'n_vueltas': 'N° Test Revolutions - N',
      'carregamento_simulado': 'Simulated load C (P/D)',
      'comprimento_teste': 'Test length LT (N x L)',
      'toneladas_resultado': 'Test Tons (TTE):',
      'toneladas_teste': 'Test Tons (TTE)',

      // Sección 3 & 4: Caudal y Velocidad
      'vazao_simulada_velocidade': 'SIMULATED FLOW RATE & SPEED',
      'tempo_teste_segundos': 'Test Time (s)',
      'recomendado_tiempo_vueltas': 'Recommended: Time for N revolutions',
      'vazao_simulada': 'Simulated Flow Rate',
      'velocidade': 'Speed',

      // Formulario de Reporte
      'cliente': 'Client Name / Plant',
      'tecnico': 'Technician / Inspector',
      'fecha': 'Inspection Date',
      'generar_pdf': 'GENERATE PDF REPORT',

      // Formulario de Limpieza e Inspección
      '2. Limpeza': '2. Cleaning',
      '2.1 Limpar o ponte de pesagem': '2.1 Clean the weighbridge',
      '2.2 Limpar integrador': '2.2 Clean integrator',
      '2.3 Limpar o sensor de velocidade': '2.3 Clean speed sensor',
      '2.4 Verifique e ajuste os cabos soltos': '2.4 Check and adjust loose cables',
      'Observação Limpeza': 'Cleaning Observation',
      '3. Inspeção de células de carga': '3. Load cell inspection',
      '3.1 Alinhar a correia com a ajuda do pessoal mecânico': '3.1 Align belt with mechanical staff assistance',
      'Medição Célula C1 (mV)': 'Cell C1 Measurement (mV)',
      'Medição Célula C2 (mV)': 'Cell C2 Measurement (mV)',
      'Observação Células': 'Load Cell Observation',
      'Observação Inspeção':'Inspection Observation',
      '4. Calibração Zero': '4. Zero Calibration',
      'Observação Zero': 'Zero Observation',

      // Sección 5: Span
      '5. Calibração Span': '5. Span Calibration',
      'OLD CONST SPAN': 'OLD CONST SPAN',
      'NEW CONST SPAN': 'NEW CONST SPAN',
      '1° SPAN': '1° SPAN',
      '2° SPAN': '2° SPAN',
      '3° SPAN': '3° SPAN',
      '4° SPAN': '4° SPAN',
      '1° CONST': '1° CONST',
      '2° CONST': '2° CONST',
      '3° CONST': '3° CONST',
      '4° CONST': '4° CONST',
      'Observação Span': 'Span Observation',

      // Sección 6 & 7: Observaciones y Executores
      '6. Observações Geral / Condição da Correia': '6. General Observations / Belt Condition',
      'Observações': 'Observations',
      '7. Executores': '7. Executors',
      'nome_sobrenome': 'First & Last Name',
      'nome_sobrenome 1': 'First & Last Name 1',
      'nome_sobrenome 2': 'First & Last Name 2',
      'nome_sobrenome 3': 'First & Last Name 3',
      'Especialidade': 'Specialty',
      'instrumentista': 'Instrument technician',
      'eletricista' : 'Electrician technician',
      'GERAR E SALVAR RELATÓRIO': 'GENERATE AND SAVE REPORT',
      'Número de executores:': 'Number of executors:',
  
      // Contenido del PDF
      'pdf_titulo': 'TECHNICAL CALIBRATION REPORT',
      'pdf_subtitulo': 'Belt Scale',
      'pdf_resumen': 'Calculation Summary',

      'Sem observações registradas.': 'No observations recorded.',
    'SIM': 'YES',
    'NÃO': 'NO',
    'Medição Célula C1': 'Load Cell C1 Measurement',
    'Medição Célula C2': 'Load Cell C2 Measurement',
    '2.1 Limpeza dos rolos de carga e retorno': '2.1 Cleaning of carrying and return idlers',
    '2.2 Limpeza e alinhamento do tambor gravidade': '2.2 Cleaning and alignment of take-up pulley',
    '2.3 Verificar estado da correia vulcanizada': '2.3 Check condition of vulcanized belt',
    '2.4 Inspeção geral de limpeza': '2.4 General cleaning inspection',
    '3.1 Inspeção mecânica e elétrica das células': '3.1 Mechanical and electrical cell inspection',
    },
  };

  static String getText(String lang, String key) {
    return _keys[lang]?[key] ?? _keys['es']![key] ?? key;
  }
}