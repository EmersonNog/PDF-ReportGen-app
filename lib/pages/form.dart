// ignore_for_file: unused_local_variable, unused_field, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:aeroporto/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/multi_select_field.dart';
import '../widgets/drop_down_field.dart';
import '../widgets/input_field.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as location_accuracy;

class FormData {
  final String cod;
  final String coordenadas;
  //form 1
  final String nomeEntrevistado;
  final String cpfEntrevistado;
  final String nomeProprietario;
  final String cpfProprietario;
  final String contato;
  final String endereco;
  final String cidade;
  final String bairro;
  final String moradores;
  final String situacao;
  final String construcao;
  final String ocupacao;
  //form 2
  final String tipoImovel;
  final String pavimento;
  final String muro;
  final String padraoConstrutivo;
  final String idadeAparente;
  final String aberto;
  final String qtdQuarto;
  final String qtdBanheiro;
  final String qtdSuite;
  final String garagem;
  final String situacaoArea;
  //form 3
  final String tipologiaPiso;
  //form 4
  final String elemento;
  //form 5
  final String itensTipologiaEdi;
  final String itensRevestimento;
  //form 6
  final String tipologiaForro;
  //form 7
  final String tipoligaEstruturaCobertura;
  final String tipologiaTelha;
  //form 8
  final String resumo;

  FormData({
    required this.cod,
    required this.coordenadas,
    //form1
    required this.nomeEntrevistado,
    required this.cpfEntrevistado,
    required this.nomeProprietario,
    required this.cpfProprietario,
    required this.contato,
    required this.endereco,
    required this.cidade,
    required this.bairro,
    required this.moradores,
    required this.situacao,
    required this.construcao,
    required this.ocupacao,
    //form2
    required this.tipoImovel,
    required this.pavimento,
    required this.muro,
    required this.padraoConstrutivo,
    required this.idadeAparente,
    required this.aberto,
    required this.qtdQuarto,
    required this.qtdBanheiro,
    required this.qtdSuite,
    required this.garagem,
    required this.situacaoArea,
    //form3
    required this.tipologiaPiso,
    //form4
    required this.elemento,
    //form 5
    required this.itensTipologiaEdi,
    required this.itensRevestimento,
    //form 6
    required this.tipologiaForro,
    //form 7
    required this.tipoligaEstruturaCobertura,
    required this.tipologiaTelha,
    //form 8
    required this.resumo,
  });
}

class Formulario extends StatefulWidget {
  const Formulario({Key? key, required this.onFormSubmitted}) : super(key: key);

  final void Function(FormData) onFormSubmitted;

  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  late List<Step> _formSteps;

  // Formulario 1
  final FormData _formData = FormData(
    cod: '',
    coordenadas: '',
    // Formulario 1
    nomeEntrevistado: '',
    cpfEntrevistado: '',
    nomeProprietario: '',
    cpfProprietario: '',
    contato: '',
    endereco: '',
    cidade: '',
    bairro: '',
    moradores: '',
    situacao: '',
    construcao: '',
    ocupacao: '',
    // Formulario 2
    tipoImovel: '',
    pavimento: '',
    muro: '',
    padraoConstrutivo: '',
    idadeAparente: '',
    aberto: '',
    qtdQuarto: '',
    qtdBanheiro: '',
    qtdSuite: '',
    garagem: '',
    situacaoArea: '',
    // Formulario 3
    tipologiaPiso: '',
    // Formulario 4
    elemento: '',
    // Fprmulario 5
    itensTipologiaEdi: '',
    itensRevestimento: '',
    // Formulario 6
    tipologiaForro: '',
    // Formulario 7
    tipoligaEstruturaCobertura: '',
    tipologiaTelha: '',
    // Formulario 8
    resumo: '',
  );

  final _codController = TextEditingController();
  // Formulario 1
  final List<String> _alugado = ['Sim', 'Não'];
  String? _selectedRented;
  final _nameController = TextEditingController();
  final _cpfEntrevistadoController = TextEditingController();
  final _proprietarioController = TextEditingController();
  final _proprietarioCpfController = TextEditingController();
  final _contatoController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _bairroController = TextEditingController();
  final _moradoresController = TextEditingController();
  final _construcaoController = TextEditingController();
  final _ocupacaoController = TextEditingController();
  // Formulario 2
  final List<String> _typeProperty = [
    'Residencial',
    'Comercial',
    'Misto',
    'Institucional'
  ];
  final _pavementController = TextEditingController();
  final List<String> _wall = ['Sim', 'Não'];
  final List<String> _constructivePattern = ['Baixo', 'Médio', 'Alto'];
  final List<String> _apparentAge = [
    'Novo (<10 anos)',
    'Moderado (Entre 10 e 30 anos)',
    'Antigo (entre 30 e 50 anos)',
    'Histórico (>50 anos)'
  ];
  final List<String> _situation = ['Aberto', 'Fechado', 'Recusa'];
  final _numberRooms = TextEditingController();
  final _numberBathrooms = TextEditingController();
  final _numberSuites = TextEditingController();
  final List<String> _garage = ['Sim', 'Não'];
  final List<String> _situationArea = [
    'Normal',
    'Alagadiça',
    'Leito de rua',
    'Área de risco'
  ];
  String? _selectedType;
  String? _selectedWall;
  String? _selectedConstructive;
  String? _selectedSituation;
  String? _selectedGarage;
  String? _selectedAge;
  String? _selectedArea;
  // Formulario 3
  final List<String> _typologyFloor = [
    'Chão Batido',
    'Concreto Aparente',
    'Piso Cerâmico',
    'Piso Porcelanato',
    'Outros'
  ];
  final List<String> _selectedTypology = [];
  // Formulario 4
  final List<String> _typeElementList = [
    'Pilarete',
    'Pilar',
    'Viga',
    'Vigota',
    'Laje',
    'Não se aplica',
  ];
  final List<String> _selectedElements = [];
  // Formulario 5
  final List<String> _typologyItemsEdi = [
    'Adobo',
    'Taipa',
    'Tijolo Ceramico',
    'Bloco de concreto',
    'Gesso',
    'Drywall'
  ];
  final List<String> _coatingTypeItems = [
    'Chapisco',
    'Reboco',
    'Revestimento ceramico',
    'Massa corrida',
    'Massa Acrilica',
    'Tinta PVA',
    'Tinta acrílica',
    'Tinta EPOX',
    'Não se aplica',
  ];
  final List<String> _selectTipologyItemsEdi = [];
  final List<String> _selectedTypeCoatingEdi = [];
  // Formulario 6
  final List<String> _typologyItemsLining = [
    'PVC',
    'Gesso',
    'Madeira',
    'Drywall'
  ];
  final List<String> _selectTipologyItemsLining = [];
  // Formulario 7
  final List<String> _tipologyRoofStructure = [
    'Madeira',
    'Métalica',
    'Laje',
    'Mista',
    'Não se aplica',
  ];
    final List<String> _tipologyTile = [
    'Cerâmica',
    'Fibrocimento',
    'Galvanizada',
    'Não foi possível identificar',
  ];
  final List<String> _selectedTipologyRoofStructure = [];
  final List<String> _selectedTipologyTile = [];
  // Formulario 8
  final _resumo = TextEditingController();

  // Formaters
  final _cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final _contatoFormatter = MaskTextInputFormatter(
    mask: '## #.####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final _quantidadeFormatter = MaskTextInputFormatter(mask: '##');

  @override
  void initState() {
    super.initState();
    _formSteps = _buildFormSteps();
  }

  List<Step> _buildFormSteps() {
    return [
      Step(
        title: const Text(
          'IDENTIFICAÇÃO E LOCALIZAÇÃO',
          style: TextStyle(
            fontFamily: 'Prototype',
            fontSize: 18,
          ),
        ),
        content: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              InputField(
                inputController: _codController,
                textLabel: 'Código do Laudo',
                suffixWidget: const Icon(Icons.info),
                isRequired: true,
              ),
              const SizedBox(height: 10),
              InputField(
                inputController: _nameController,
                textLabel: 'Nome do Entrevistado',
                suffixWidget: const Icon(Icons.person),
                isRequired: true,
              ),
              const SizedBox(height: 10),
              InputField(
                inputController: _cpfEntrevistadoController,
                textLabel: 'CPF do Entrevistado',
                suffixWidget: const Icon(Icons.assignment_ind),
                formatter: _cpfFormatter,
                isRequired: true,
              ),
              const SizedBox(height: 10),
              InputField(
                inputController: _proprietarioController,
                textLabel: 'Nome do Proprietário',
                suffixWidget: const Icon(Icons.person_outline),
                isRequired: true,
              ),
              const SizedBox(height: 10),
              InputField(
                inputController: _proprietarioCpfController,
                textLabel: 'CPF do Proprietário',
                suffixWidget: const Icon(Icons.assignment_ind_outlined),
                formatter: _cpfFormatter,
                isRequired: true,
              ),
              const SizedBox(height: 10),
              InputField(
                inputController: _contatoController,
                textLabel: 'Contato',
                suffixWidget: const Icon(Icons.phone),
                isRequired: true,
                formatter: _contatoFormatter,
              ),
              const SizedBox(height: 10),
              InputField(
                inputController: _enderecoController,
                textLabel: 'Endereço',
                suffixWidget: const Icon(Icons.location_on),
                isRequired: true,
              ),
              const SizedBox(height: 10),
              InputField(
                inputController: _cidadeController,
                textLabel: 'Cidade',
                suffixWidget: const Icon(Icons.location_city),
                isRequired: true,
              ),
              const SizedBox(height: 10),
              InputField(
                inputController: _bairroController,
                textLabel: 'Bairro',
                suffixWidget: const Icon(Icons.holiday_village),
                isRequired: true,
              ),
              const SizedBox(height: 10),
              InputField(
                inputController: _moradoresController,
                textLabel: 'Quantidade de Moradores',
                suffixWidget: const Icon(Icons.format_list_numbered),
                formatter: _quantidadeFormatter,
                isRequired: true,
              ),
              const SizedBox(height: 10),
              DropDownField(
                labelText: 'Alugado',
                items: _alugado,
                value: _selectedRented,
                onChanged: (newValue) {
                  setState(() {
                    _selectedRented = newValue;
                  });
                },
              ),
              const SizedBox(height: 10),
              InputField(
                inputController: _construcaoController,
                textLabel: 'Tempo de Construção',
                suffixWidget: const Icon(Icons.construction),
                isRequired: true,
              ),
              const SizedBox(height: 10),
              InputField(
                inputController: _ocupacaoController,
                textLabel: 'Tempo de Ocupação',
                suffixWidget: const Icon(Icons.date_range_sharp),
                isRequired: true,
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 0,
        state: StepState.indexed,
      ),
      Step(
        title: const Text(
          'INFORMAÇÕES GERAIS DO IMÓVEL ',
          style: TextStyle(
            fontFamily: 'Prototype',
            fontSize: 18,
          ),
        ),
        content: Column(
          children: [
            DropDownField(
              labelText: 'Tipo de Imóvel',
              items: _typeProperty,
              value: _selectedType,
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              inputController: _pavementController,
              textLabel: 'Pavimentos',
              suffixWidget: const Icon(Icons.add_road),
              formatter: _quantidadeFormatter,
              isRequired: true,
            ),
            const SizedBox(
              height: 10,
            ),
            DropDownField(
              labelText: 'Muro',
              items: _wall,
              value: _selectedWall,
              onChanged: (newValue) {
                setState(() {
                  _selectedWall = newValue;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropDownField(
              labelText: 'Padrão Construtivo',
              items: _constructivePattern,
              value: _selectedConstructive,
              onChanged: (newValue) {
                setState(() {
                  _selectedConstructive = newValue;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropDownField(
              labelText: 'Idade Aparente',
              items: _apparentAge,
              value: _selectedAge,
              onChanged: (value) {
                setState(() {
                  _selectedAge = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropDownField(
              labelText: 'Situação',
              items: _situation,
              value: _selectedSituation,
              onChanged: (newValue) {
                setState(() {
                  _selectedSituation = newValue;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              inputController: _numberRooms,
              textLabel: 'Quantidade de Quartos',
              suffixWidget: const Icon(Icons.single_bed_outlined),
              formatter: _quantidadeFormatter,
              isRequired: true,
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              inputController: _numberBathrooms,
              textLabel: 'Quantidade de Banheiros',
              suffixWidget: const Icon(Icons.bathroom_outlined),
              formatter: _quantidadeFormatter,
              isRequired: true,
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              inputController: _numberSuites,
              textLabel: 'Quantidade de Suítes',
              suffixWidget:
                  const Icon(Icons.airline_seat_individual_suite_outlined),
              formatter: _quantidadeFormatter,
              isRequired: true,
            ),
            const SizedBox(
              height: 10,
            ),
            DropDownField(
              labelText: 'Garagem',
              items: _garage,
              value: _selectedGarage,
              onChanged: (newValue) {
                setState(() {
                  _selectedGarage = newValue;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropDownField(
              labelText: 'Situação da Área',
              items: _situationArea,
              value: _selectedArea,
              onChanged: (newValue) {
                setState(() {
                  _selectedArea = newValue;
                });
              },
            )
          ],
        ),
        isActive: _currentStep >= 0,
        state: StepState.indexed,
      ),
      Step(
        title: const Text(
          'CONDIÇÕES ESTRUTURAIS DA EDIFICAÇÃO',
          style: TextStyle(
            fontFamily: 'Prototype',
            fontSize: 18,
          ),
        ),
        subtitle: const Text(
          "PISO",
          style: TextStyle(fontFamily: 'Prototype', fontSize: 14),
        ),
        content: Column(
          children: [
            MultiSelectField(
              title: 'Tipologia',
              buttonText: 'Selecione as tipologias',
              cancelText: 'CANCELAR',
              items: _typologyFloor.map((e) => MultiSelectItem(e, e)).toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (selectedItems) {
                _selectedTypology.clear();
                for (var item in selectedItems!) {
                  _selectedTypology.add(item);
                }
                for (var value in _selectedTypology) {}
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        isActive: _currentStep >= 0,
        state: StepState.indexed,
      ),
      Step(
        title: const Text(
          'CONDIÇÕES ESTRUTURAIS DA EDIFICAÇÃO',
          style: TextStyle(
            fontFamily: 'Prototype',
            fontSize: 18,
          ),
        ),
        subtitle: const Text(
          "SUPERESTRUTURA",
          style: TextStyle(fontFamily: 'Prototype', fontSize: 14),
        ),
        content: Column(
          children: [
            MultiSelectField(
              title: 'Tipologia de Superestrutura',
              buttonText: 'Selecione as Tipologias',
              cancelText: 'CANCELAR',
              items:
                  _typeElementList.map((e) => MultiSelectItem(e, e)).toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (selectedItems) {
                _selectedElements
                    .clear(); 
                for (var item in selectedItems!) {
                  _selectedElements.add(
                      item); 
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        isActive: _currentStep >= 0,
        state: StepState.indexed,
      ),
      Step(
        title: const Text(
          'CONDIÇÕES ESTRUTURAIS DA EDIFICAÇÃO',
          style: TextStyle(
            fontFamily: 'Prototype',
            fontSize: 18,
          ),
        ),
        subtitle: const Text(
          "ALVENARIA DE VEDAÇÃO",
          style: TextStyle(fontFamily: 'Prototype', fontSize: 14),
        ),
        content: Column(
          children: [
            MultiSelectField(
              title: 'Tipologia',
              buttonText: 'Selecione uma tipologia',
              cancelText: 'CANCELAR',
              items:
                  _typologyItemsEdi.map((e) => MultiSelectItem(e, e)).toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (selectedItems) {
                _selectTipologyItemsEdi
                    .clear(); 
                for (var item in selectedItems!) {
                  _selectTipologyItemsEdi.add(
                      item);
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            MultiSelectField(
              title: 'Tipo de revestimento',
              buttonText: 'Selecione os revestimentos',
              cancelText: 'CANCELAR',
              items:
                  _coatingTypeItems.map((e) => MultiSelectItem(e, e)).toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (selectedItems) {
                _selectedTypeCoatingEdi
                    .clear(); // Limpa os valores selecionados anteriores, se houverem
                for (var item in selectedItems!) {
                  _selectedTypeCoatingEdi.add(
                      item); // Adiciona o valor selecionado à lista de valores
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        isActive: _currentStep >= 0,
        state: StepState.indexed,
      ),
      Step(
        title: const Text(
          'CONDIÇÕES ESTRUTURAIS DA EDIFICAÇÃO',
          style: TextStyle(
            fontFamily: 'Prototype',
            fontSize: 18,
          ),
        ),
        subtitle: const Text(
          "FORRO",
          style: TextStyle(fontFamily: 'Prototype', fontSize: 14),
        ),
        content: Column(children: [
          
          MultiSelectField(
              title: 'Tipologia',
              buttonText: 'Selecione uma tipologia',
              cancelText: 'CANCELAR',
              items:
                  _typologyItemsLining.map((e) => MultiSelectItem(e, e)).toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (selectedItems) {
                _selectTipologyItemsLining
                    .clear(); 
                for (var item in selectedItems!) {
                  _selectTipologyItemsLining.add(
                      item);
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
          const SizedBox(
            height: 10,),
        ]),
        isActive: _currentStep >= 0,
        state: StepState.indexed,
      ),
      Step(
        title: const Text(
          'COBERTURA',
          style: TextStyle(
            fontFamily: 'Prototype',
            fontSize: 18,
          ),
        ),
        content: Column(children: [
          MultiSelectField(
            title: 'Tipologia da Estrutura da Cobertura',
            buttonText: 'Selecione as tipologias da estrutura',
            cancelText: 'CANCELAR',
            items:
                _tipologyRoofStructure.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            onConfirm: (selectedItems) {
              _selectedTipologyRoofStructure
                  .clear();
              for (var item in selectedItems!) {
                _selectedTipologyRoofStructure.add(
                    item);
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          MultiSelectField(
            title: 'Tipologia das Telhas',
            buttonText: 'Selecione as tipologias das telhas',
            cancelText: 'CANCELAR',
            items:
                _tipologyTile.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            onConfirm: (selectedItems) {
              _selectedTipologyTile
                  .clear();
              for (var item in selectedItems!) {
                _selectedTipologyTile.add(
                    item);
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ]),
        isActive: _currentStep >= 0,
        state: StepState.indexed,
      ),
      Step(
        title: const Text(
          'RESUMO',
          style: TextStyle(
            fontFamily: 'Prototype',
            fontSize: 18,
          ),
        ),
        content: Column(children: [
          TextField(
            controller: _resumo,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Observações para resumo',
              suffixIcon: const Icon(Icons.pending),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.1),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.red)),
              errorStyle: const TextStyle(height: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 10),
          
        ]),
        isActive: _currentStep >= 0,
        state: StepState.indexed,
      )
    ];
  }

  _nextStep() {
    if (_currentStep < _formSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _stepTapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SingleChildScrollView(
                        child: Stepper(
                          physics: const ScrollPhysics(),
                          currentStep: _currentStep,
                          onStepContinue: _nextStep,
                          onStepCancel: _previousStep,
                          onStepTapped: _stepTapped,
                          steps: _formSteps,
                          controlsBuilder:
                              (BuildContext context, ControlsDetails details) {
                            return Row(
                              children: <Widget>[
                                if (_currentStep ==
                                    0)
                                  TextButton(
                                    onPressed: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Home()),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 173, 80, 85),
                                      ),
                                    ),
                                    child: const Text(
                                      'Voltar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                if (_currentStep >
                                    0)
                                  TextButton(
                                    onPressed: details.onStepCancel,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 173, 80, 85),
                                      ),
                                    ),
                                    child: const Text(
                                      'Voltar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                const SizedBox(width: 10),
                                if (_currentStep <
                                    _formSteps.length -
                                        1)
                                  TextButton(
                                    onPressed: details.onStepContinue,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 12, 112, 60),
                                      ),
                                    ),
                                    child: const Text(
                                      'Próximo',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      if (_currentStep == _formSteps.length - 1)
                        FractionallySizedBox(
                          widthFactor: 0.5,
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 176, 37, 44)),
                                ),
                                onPressed: () async {
                                  String? coordenadas;
                                  final PermissionStatus status =
                                      await Permission.location.request();

                                  if (status.isGranted) {
                                    geolocator.Position position =
                                        await geolocator.Geolocator
                                            .getCurrentPosition(
                                      desiredAccuracy: location_accuracy
                                          .LocationAccuracy.best,
                                    );
                                    double latitude = position.latitude;
                                    double longitude = position.longitude;
                                    coordenadas = '$latitude, $longitude';
                                  } else if (status.isDenied ||
                                      status.isPermanentlyDenied) {
                                    openAppSettings();
                                    return;
                                  }
                                  if (coordenadas == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Permita o acesso à localização para gerar o PDF e enviar dados à nuvem.",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                    return;
                                  }
                                  final formData = FormData(
                                    cod: _codController.text,
                                    coordenadas: coordenadas,
                                    //form1
                                    nomeEntrevistado: _nameController.text,
                                    cpfEntrevistado:
                                        _cpfEntrevistadoController.text,
                                    nomeProprietario:
                                        _proprietarioController.text,
                                    cpfProprietario:
                                        _proprietarioCpfController.text,
                                    contato: _contatoController.text,
                                    endereco: _enderecoController.text,
                                    cidade: _cidadeController.text,
                                    bairro: _bairroController.text,
                                    moradores: _moradoresController.text,
                                    situacao: _selectedRented ?? '',
                                    construcao: _construcaoController.text,
                                    ocupacao: _ocupacaoController.text,
                                    //form2
                                    tipoImovel: _selectedType ?? '',
                                    pavimento: _pavementController.text,
                                    muro: _selectedWall ?? '',
                                    padraoConstrutivo:
                                        _selectedConstructive ?? '',
                                    idadeAparente: _selectedAge ?? '',
                                    aberto: _selectedSituation ?? '',
                                    qtdQuarto: _numberRooms.text,
                                    qtdBanheiro: _numberBathrooms.text,
                                    qtdSuite: _numberSuites.text,
                                    garagem: _selectedGarage ?? '',
                                    situacaoArea: _selectedArea ?? '',
                                    //form3
                                    tipologiaPiso: _selectedTypology.join(', '),
                                    //form 4
                                    elemento: _selectedElements.join(', '),
                                    //form 5
                                    itensTipologiaEdi:
                                        _selectTipologyItemsEdi.join(', '),
                                    itensRevestimento:
                                        _selectedTypeCoatingEdi.join(', '),
                                    //form 6
                                    tipologiaForro:
                                        _selectTipologyItemsLining.join(', '),
                                    //form 7
                                    tipoligaEstruturaCobertura: _selectedTipologyRoofStructure.join(', '),
                                    tipologiaTelha:
                                        _selectedTipologyTile.join(', '),
                                    //form 8
                                    resumo: _resumo.text,
                                  );
                                  if (formData.cod.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Row(
                                            children: const [
                                              Icon(Icons.warning_amber_rounded,
                                                  color: Colors.amber),
                                              SizedBox(width: 8),
                                              Text('Aviso',
                                                  style: TextStyle(
                                                      fontFamily: 'Prototype')),
                                            ],
                                          ),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  24, 20, 24, 0),
                                          content: const Text(
                                            'Por favor, preencha o código do laudo antes de gerar o PDF.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    widget.onFormSubmitted(formData);
                                    sendData();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Salvo na nuvem com sucesso!",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      backgroundColor: Colors.greenAccent,
                                    ));
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Gerar PDF'),
                                    SizedBox(width: 10),
                                    Icon(Icons
                                        .picture_as_pdf),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendData() async {
    String id = const Uuid().v1();
    String? coordenadas;

    final PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: location_accuracy.LocationAccuracy.best,
      );
      double latitude = position.latitude;
      double longitude = position.longitude;
      coordenadas = '$latitude, $longitude';
    } else if (status.isDenied) {
      openAppSettings();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }

    try {
      await db.collection("dados").doc(id).set({
        // form1 data
        "cod": _codController.text,
        "coordenadas": coordenadas,
        "nomeEntrevistado": _nameController.text,
        "cpfEntrevistado": _cpfEntrevistadoController.text,
        "nomeProprietario": _proprietarioController.text,
        "cpfProprietario": _proprietarioCpfController.text,
        "contato": _contatoController.text,
        "endereco": _enderecoController.text,
        "cidade": _cidadeController.text,
        "bairro": _bairroController.text,
        "moradores": _moradoresController.text,
        "alugado": _selectedRented,
        "construcao": _construcaoController.text,
        "ocupacao": _ocupacaoController.text,
        // form2 data
        "tipoPropiedade": _selectedType,
        "pavimento": _pavementController.text,
        "parede": _selectedWall,
        "padrãoConstrutivo": _selectedConstructive,
        "idadeAparente": _selectedAge,
        "situacao": _selectedSituation,
        "numQuartos": _numberRooms.text,
        "numBanheiros": _numberBathrooms.text,
        "numSuites": _numberSuites.text,
        "garagem": _selectedGarage,
        "situacaoArea": _selectedArea,
        // form3 data
        "tipologiaChao": _selectedTypology,
        //form4 data
        "tipoElemento": _selectedElements,
        //form 5 data
        "tipologiaEdificacao": _selectTipologyItemsEdi,
        "itensRevestimento": _selectedTypeCoatingEdi,
        //form 6 data
        "itensForro": _selectTipologyItemsLining,
        //form 7 data
        "tipoligaEstruturaCobertura": _selectedTipologyRoofStructure,
        "tipologiaTelha": _selectedTipologyTile,
        //form 8 data
        "resumo": _resumo.text,

      });
    } catch (e) {
      print("Error: $e");
    }
  }
}