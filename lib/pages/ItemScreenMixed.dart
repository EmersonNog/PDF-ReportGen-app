// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:aeroporto/pages/ReportPhotoMixed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Croqui.dart';
import 'PieChartScreen.dart';

class ItemScrennMixed extends StatefulWidget {
  final ItemMixed item;

  const ItemScrennMixed(this.item, {super.key});

  @override
  _ItemScrennMixedState createState() => _ItemScrennMixedState();
}

class _ItemScrennMixedState extends State<ItemScrennMixed> {
  final List<PhotoDataMixed> photoDataList = [];
  late File _currentImageFile;
  File? graphImage;
  bool _imageSelected = false;
    final _key = GlobalKey<ExpandableFabState>();
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();


  final List<MultiSelectItem<String>> _descriptionItems = [
    MultiSelectItem('C-01: DESCOLAMENTO DE ELEMENTOS DO FORRO', 'C-01'),
    MultiSelectItem('C-02: DESGASTE DE CALHAS E RUFOS', 'C-02'),
    MultiSelectItem('C-03: DESGASTE SUPERFICIAL DA LAJE', 'C-03'),
    MultiSelectItem('C-04: MANCHAS DE UMIDADE NA ESTRUTURA DA COBERTURA', 'C-04'),
    MultiSelectItem('C-05: DETERIORAÇÃO DA ESTRUTURA DA COBERTURA', 'C-05'),
    MultiSelectItem('C-06: FISSURAS NO FORRO', 'C-06'),
    MultiSelectItem('C-07: FISSURAS NA LAJE', 'C-07'),
    MultiSelectItem('C-08: MANCHAS/EFLORESCÊNCIA NO FORRO', 'C-08'),
    MultiSelectItem('C-09: MANCHAS/EFLORESCÊNCIA NA LAJE', 'C-09'),
    MultiSelectItem('C-10: MANCHAS/EFLORESCÊNCIA NAS TELHAS', 'C-10'),
    MultiSelectItem('C-11: MOFO OU BOLOR NO FORRO', 'C-11'),
    MultiSelectItem('C-12: OXIDAÇÃO DA ESTRUTURA DA COBERTURA', 'C-12'),
    MultiSelectItem('C-13: FISSURAS NO TELHADO', 'C-13'),
    MultiSelectItem('C-OP: OUTRAS PATOLOGIAS NA COBERTURA', 'C-OP'),
    MultiSelectItem('C-NE: PATOLOGIAS NÃO ENCONTRADAS NA COBERTURA', 'C-NE'),
    MultiSelectItem('A-01: ARMADURAS EXPOSTAS NA ESTRUTURA', 'A-01'),
    MultiSelectItem('A-02: DEFORMAÇÕES NA ESTRUTURA', 'A-02'),
    MultiSelectItem('A-03: DESCOLAMENTO DE REVESTIMENTO CERÂMICO NAS PAREDES', 'A-03'),
    MultiSelectItem('A-04: DESGASTE SUPERFICIAL DA ESTRUTURA', 'A-04'),
    MultiSelectItem('A-05: DESPRENDIMENTO DA ARGAMASSA DE REVESTIMENTO', 'A-05'),
    MultiSelectItem('A-06: DETERIORAÇÃO NA CAMADA DE PINTURA', 'A-06'),
    MultiSelectItem('A-07: EFLORESCÊNCIA NAS PAREDES', 'A-07'),
    MultiSelectItem('A-08: EMPOLAMENTO NAS PAREDES', 'A-08'),
    MultiSelectItem('A-09: FISSURAS NA ESTRUTURA', 'A-09'),
    MultiSelectItem('A-10: FISSURAS NAS PAREDES', 'A-10'),
    MultiSelectItem('A-11: MANCHAS DE UMIDADE NAS PAREDES', 'A-11'),
    MultiSelectItem('A-12: MOFO OU BOLOR NAS PAREDES', 'A-12'),
    MultiSelectItem('A-13: VAZAMENTOS HIDRÁULICOS', 'A-13'),
    MultiSelectItem('A-OP: OUTRAS PATOLOGIAS NAS PAREDES', 'A-OP'),
    MultiSelectItem('A-NE: PATOLOGIAS NÃO ENCONTRADAS NAS PAREDES', 'A-NE'),
    MultiSelectItem('I-01: AFUNDAMENTO DO PISO CERÂMICO', 'I-01'),
    MultiSelectItem('I-02: AFUNDAMENTO DO PISO DE CONCRETO', 'I-02'),
    MultiSelectItem('I-03: DESGASTE SUPERFICIAL DO PISO DE CONCRETO', 'I-03'),
    MultiSelectItem('I-04: DESCOLAMENTO DO REVESTIMENTO CERÂMICO DO PISO', 'I-04'),
    MultiSelectItem('I-05: DESPLACAMENTO SUPERFICIAL DO PISO DE CONCRETO', 'I-05'),
    MultiSelectItem('I-06: DETERIORAÇÃO DO PISO DE CONCRETO', 'I-06'),
    MultiSelectItem('I-07: DETERIORAÇÃO DO REJUNTE ENTRE PEÇAS CERÂMICAS', 'I-07'),
    MultiSelectItem('I-08: EFLORESCÊNCIA NO PISO', 'I-08'),
    MultiSelectItem('I-09: EROSÃO DO TERRENO', 'I-09'),
    MultiSelectItem('I-10: MANCHAS DE UMIDADE NO PISO', 'I-10'),
    MultiSelectItem('I-11: QUEBRA/FISSURAS NO PISO CERÂMICO', 'I-11'),
    MultiSelectItem('I-12: RECALQUE DIFERENCIAL APARENTE', 'I-12'),
    MultiSelectItem('I-13: FISSURAS NO PISO DE CONCRETO', 'I-13'),
    MultiSelectItem('I-OP: OUTRAS PATOLOGIAS NO PISO', 'I-OP'),
    MultiSelectItem('I-NE: PATOLOGIAS NÃO ENCONTRADAS NO PISO', 'I-NE'),
  ];

  final List<MultiSelectItem<String>> _environmentItems = [
    MultiSelectItem('FA: FACHADA', 'FA'),
    MultiSelectItem('EM: ENTRADA', 'EM'),
    MultiSelectItem('RE: RECEPÇÃO', 'RE'),
    MultiSelectItem('VE: SALÃO DE VENDAS', 'VE'),
    MultiSelectItem('ES: ESTOQUE', 'ES'),
    MultiSelectItem('CX: CAIXA', 'CX'),
    MultiSelectItem('S1: SALA 01', 'S1'),
    MultiSelectItem('S2: SALA 02', 'S2'),
    MultiSelectItem('S3: SALA 03', 'S3'),
    MultiSelectItem('S4: SALA 04', 'S4'),
    MultiSelectItem('Q1: QUARTO 01', 'Q1'),
    MultiSelectItem('Q2: QUARTO 02', 'Q2'),
    MultiSelectItem('Q3: QUARTO 03', 'Q3'),
    MultiSelectItem('Q4: QUARTO 04', 'Q4'),
    MultiSelectItem('B1: BANHEIRO 01', 'B1'),
    MultiSelectItem('B2: BANHEIRO 02', 'B2'),
    MultiSelectItem('B3: BANHEIRO 03', 'B3'),
    MultiSelectItem('B4: BANHEIRO 04', 'B4'),
    MultiSelectItem('CZ: COZINHA', 'CZ'),
    MultiSelectItem('AS: ÁREA SERVIÇO', 'AS'),
    MultiSelectItem('AE: ÁREA EXTERNA', 'AE'),
    MultiSelectItem('O1: OUTRO 01', 'O1'),
    MultiSelectItem('O2: OUTRO 02', 'O2'),
    MultiSelectItem('O3: OUTRO 03', 'O3'),
    MultiSelectItem('O4: OUTRO 04', 'O4'),
  ];
  List<String> _selectedDescriptions = [];
  List<String> _selectedEnvironments = [];

  @override
  void initState() {
    super.initState();
    _initDescriptionItems();
    _initEnvironmentItems();
    _loadPhotos();
  }

  void _initDescriptionItems() {
    for (var photoData in photoDataList) {
      _descriptionItems
          .add(MultiSelectItem(photoData.description, photoData.description));
    }
  }

  void _initEnvironmentItems() {
    for (var photoData in photoDataList) {
      _environmentItems
          .add(MultiSelectItem(photoData.environment, photoData.environment));
    }
  }

  Future<void> _savePhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> photosData = [];

    for (var photoData in photoDataList) {
      Map<String, dynamic> photoDataMap = {
        'path': photoData.path,
        'description': photoData.description,
        'environment': photoData.environment,
      };
      photosData.add(photoDataMap);
    }

    await prefs.setString(
        '${widget.item.id}_mixed_photosData', jsonEncode(photosData));
  }

  Future<void> _loadPhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? photosDataJson =
        prefs.getString('${widget.item.id}_mixed_photosData');

    if (photosDataJson != null) {
      List<dynamic> photosData = jsonDecode(photosDataJson);
      List<PhotoDataMixed> loadedPhotos = [];

      for (var photoData in photosData) {
        loadedPhotos.add(PhotoDataMixed(
          photoData['path'],
          photoData['description'],
          photoData['environment'],
        ));
      }

      setState(() {
        photoDataList.clear();
        photoDataList.addAll(loadedPhotos);
      });
    }
  }

  Map<String, int> environmentCounters = {};

  Future<void> downloadAndSaveToGallery() async {
    final externalDir = await getExternalStorageDirectory();
    final directoryPath = '${externalDir!.path}/${widget.item.name}';
    final directory = Directory(directoryPath);

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    for (int i = 0; i < photoDataList.length; i++) {
      final photoData = photoDataList[i];
      final file = File(photoData.path);

      final environmentCode = getEnvironmentCode(photoData.environment);
      final photoName =
          '${widget.item.name}-$environmentCode-${getCounterForEnvironment(environmentCode)}.jpg';
      final targetFile = File('${directory.path}/$photoName');

      try {
        await file.copy(targetFile.path);
        await GallerySaver.saveImage(targetFile.path,
            albumName: widget.item.name);
      } catch (e) {
        print('Failed to copy photo: $e');
      }

      incrementCounterForEnvironment(environmentCode);
    }

    environmentCounters.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Fotos salvas na galeria com sucesso",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }

  String getEnvironmentCode(String environmentName) {
    String code = '';
    if (environmentName.isNotEmpty) {
      final parts = environmentName.split('-');
      if (parts.length == 2) {
        code = parts[1];
      } else {
        code = environmentName;
      }
    }
    return code;
  }

  int getNextCounterForEnvironment(String environmentCode) {
    if (environmentCounters.containsKey(environmentCode)) {
      return environmentCounters[environmentCode]! + 1;
    } else {
      environmentCounters[environmentCode] = 1;
      return 1;
    }
  }

  int getCounterForEnvironment(String environmentCode) {
    if (environmentCounters.containsKey(environmentCode)) {
      return environmentCounters[environmentCode]!;
    } else {
      environmentCounters[environmentCode] = 1;
      return 1;
    }
  }

  void incrementCounterForEnvironment(String environmentCode) {
    if (environmentCounters.containsKey(environmentCode)) {
      environmentCounters[environmentCode] =
          environmentCounters[environmentCode]! + 1;
    } else {
      environmentCounters[environmentCode] = 1;
    }
  }

  Future<void> _showLargeImageDialog(String imagePath) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Image.file(
            File(imagePath),
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  Map<String, int> countDescriptionOccurrences(
      List<PhotoDataMixed> photoDataList) {
    Map<String, int> descriptionOccurrences = {};

    for (var photoData in photoDataList) {
      List<String> descriptions = photoData.description.split('\n');
      for (var description in descriptions) {
        descriptionOccurrences[description] =
            (descriptionOccurrences[description] ?? 0) + 1;
      }
    }

    return descriptionOccurrences;
  }

  Map<String, double> _generatePieChartData() {
    Map<String, int> descriptionOccurrences =
        countDescriptionOccurrences(photoDataList);

    Map<String, double> pieChartData = {};
    descriptionOccurrences.forEach((key, value) {
      pieChartData[key] = value.toDouble();
    });

    return pieChartData;
  }

  void pickChartImage() async {
    final imagePicker = ImagePicker();
    final XFile? imageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (imageFile != null) {
      setState(() {
        graphImage = File(imageFile.path);
      _imageSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ReportPhotoMixed()),
            );
          },
        ),
        actions: [
          if (_imageSelected) 
            const Center(
              child: Text(
                'Gráfico selecionado',
                style: TextStyle(color: Color(0xFFffc52c)),
              ),
            ),
            if(!_imageSelected)
              const Center(
              child: Text(
                'Sem gráfico',
                style: TextStyle(color: Color.fromARGB(255, 221, 221, 221)),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_outlined),
            onPressed: () {
              pickChartImage();
            },
          ),
          IconButton(
            icon: const Icon(Icons.architecture_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Croqui()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (photoDataList.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'Nenhuma foto encontrada.',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: photoDataList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          File(photoDataList[index].path),
                          height: 100,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Descrição:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          Text(
                            photoDataList[index].description,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Ambiente:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          Text(
                            photoDataList[index].environment,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 20,
                            ),
                            onPressed: () => editPhotoInfo(index),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () =>
                                _showDeletePhotoConfirmationDialog(index),
                          ),
                        ],
                      ),
                      onTap: () {
                        _showLargeImageDialog(photoDataList[index].path);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          key: _key,
          duration: const Duration(milliseconds: 500),
          distance: 70.0,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            backgroundColor: Colors.cyan[600],
            child: const FaIcon(FontAwesomeIcons.bars),
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            child: const FaIcon(FontAwesomeIcons.xmark),
            backgroundColor: Colors.cyan[600],
          ),
          overlayStyle: ExpandableFabOverlayStyle(
            blur: 10,
          ),
          type: ExpandableFabType.up,
          onOpen: () {
            debugPrint('onOpen');
          },
          afterOpen: () {
            debugPrint('afterOpen');
          },
          onClose: () {
            debugPrint('onClose');
          },
          afterClose: () {
            debugPrint('afterClose');
          },
          children: [
            Row(
              children: [
                const Text("Gráfico", style: TextStyle(fontFamily: 'Prototype')),
                FloatingActionButton.small(
                  backgroundColor: Colors.teal,
                  heroTag: null,
                  child: const FaIcon(
                    FontAwesomeIcons.chartPie,
                    size: 20,
                  ),
                  onPressed: () {
                    if (photoDataList.isEmpty) {
                      _showNoElementChart();
                    } else {
                      Map<String, double> dataMap = _generatePieChartData();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PieChartScreen(dataMap: dataMap),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text("Baixar fotos", style: TextStyle(fontFamily: 'Prototype')),
                FloatingActionButton.small(
                  backgroundColor: Colors.teal,
                  heroTag: null,
                  onPressed: downloadAndSaveToGallery,
                  child: const Icon(
                    Icons.file_download,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text("Gerar PDF", style: TextStyle(fontFamily: 'Prototype')),
                FloatingActionButton.small(
                  backgroundColor: Colors.teal,
                  heroTag: null,
                  child: const Icon(
                    Icons.picture_as_pdf,
                  ),
                  onPressed: () {
                    if (photoDataList.isEmpty) {
                      _showNoImagePDF();
                    } else {
                      generatePdfAndSave();
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text("Foto da galeria", style: TextStyle(fontFamily: 'Prototype')),
                FloatingActionButton.small(
                  backgroundColor: Colors.teal,
                  heroTag: null,
                  child: const Icon(
                    Icons.photo_library,
                  ),
                  onPressed: () {
                    pickPhotosFromGallery(1);
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text("Tirar foto", style: TextStyle(fontFamily: 'Prototype'),),
                FloatingActionButton.small(
                  backgroundColor: Colors.teal,
                  heroTag: null,
                  child: const FaIcon(
                    FontAwesomeIcons.camera,
                    size: 20,
                  ),
                  onPressed: () {
                    capturePhotos(1);
                  },
                ),
              ],
            ),
          ],
        )
    );
  }

  Future<void> generatePdfAndSave() async {
    final doc = pw.Document();

    for (int i = 0; i < photoDataList.length; i++) {
      final photoData = photoDataList[i];
      await addPhotoToPdf(
          doc, photoData.path, photoData.description, photoData.environment);
    }

    await addEvaluationToPdf(doc);

    final output = await getTemporaryDirectory();
    final outputFile = File('${output.path}/${widget.item.name}.pdf');

    await outputFile.writeAsBytes(await doc.save());
    OpenFile.open(outputFile.path);
  }

  Future<void> addEvaluationToPdf(pw.Document doc) async {
    final descriptionOccurrences = countDescriptionOccurrences(photoDataList);

    final gpCertare = pw.MemoryImage(
      (await rootBundle.load('assets/images/footer/gp_certare.png'))
          .buffer
          .asUint8List(),
    );
    final companyCertare = pw.MemoryImage(
      (await rootBundle.load('assets/images/footer/company_certare.png'))
          .buffer
          .asUint8List(),
    );
    final htb = pw.MemoryImage(
      (await rootBundle.load('assets/images/footer/htb.png'))
          .buffer
          .asUint8List(),
    );
    final ccr = pw.MemoryImage(
      (await rootBundle.load('assets/images/footer/CCR.jpg'))
          .buffer
          .asUint8List(),
    );

    final filteredDescriptionOccurrences = descriptionOccurrences.entries
        .where((entry) => entry.key.isNotEmpty)
        .toList();

    doc.addPage(pw.MultiPage(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.all(1 * PdfPageFormat.cm),
          textDirection: pw.TextDirection.ltr,
          orientation: pw.PageOrientation.portrait,
        ),
        header: (final context) =>
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                color: PdfColor.fromHex('#649c7f'),
                height: 40,
                width: 459,
                child: pw.Text("LAUDO CAUTELAR DE VISTORIA DE VIZINHANÇA",
                    style: pw.TextStyle(
                        fontSize: 15,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold)),
                margin: const pw.EdgeInsets.fromLTRB(0, -15, 0, 5),
                padding: const pw.EdgeInsets.only(left: 10),
              ),
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                color: PdfColor.fromHex('#ADADAD'),
                height: 40,
                width: 80,
                child: pw.Text("CÓD.: ${widget.item.name}",
                    style: pw.TextStyle(
                        fontSize: 15,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold)),
                margin: const pw.EdgeInsets.fromLTRB(0, -15, 0, 5),
                padding: const pw.EdgeInsets.only(left: 10),
              ),
            ]),
        footer: (context) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: -25),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(gpCertare, width: 100),
                  pw.SizedBox(width: 10),
                  pw.Image(companyCertare, width: 100),
                  pw.SizedBox(width: 10),
                  pw.Image(htb, width: 100),
                  pw.SizedBox(width: 10),
                  pw.Image(ccr, width: 100),
                ])),
        build: (context) {
          final List<pw.Widget> pageWidgets = [];
          const int itemsPerPage = 29;

          final entries = descriptionOccurrences.entries.toList();

          for (int i = 0; i < entries.length; i += itemsPerPage) {
            final chunk = entries.sublist(
                i,
                i + itemsPerPage > entries.length
                    ? entries.length
                    : i + itemsPerPage);

            final titleContainer = pw.Container(
              alignment: pw.Alignment.center,
              color: PdfColor.fromHex('#649c7f'),
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: pw.Text(
                "AVALIAÇÃO QUANTITATIVA DE DESCRIÇÃO DA EDIFICAÇÃO",
                style: pw.TextStyle(
                  color: PdfColor.fromHex('#FFFFFF'),
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              margin: const pw.EdgeInsets.only(bottom: 5),
            );

            final table = pw.Table.fromTextArray(
              cellAlignment: pw.Alignment.centerLeft,
              cellAlignments: {1: pw.Alignment.center},
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 10),
              headers: ['DESCRIÇÃO', 'QUANTIDADE'],
              data: chunk
                  .map((entry) => [entry.key, entry.value.toString()])
                  .toList(),
            );

            final tableContainer = pw.Container(
              alignment: pw.Alignment.topCenter,
              color: PdfColor.fromHex('#F0F0F0'),
              height: 690,
              padding: const pw.EdgeInsets.all(20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [table],
              ),
            );

            final column = pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                titleContainer,
                tableContainer
              ], // Wrap both containers in the Column
            );

            pageWidgets.add(column);
          }

          return pageWidgets;
        }));
    if (graphImage != null) {
      doc.addPage(
        pw.MultiPage(
          pageTheme: const pw.PageTheme(
            margin: pw.EdgeInsets.all(1 * PdfPageFormat.cm),
            textDirection: pw.TextDirection.ltr,
            orientation: pw.PageOrientation.portrait,
          ),
          header: (final context) =>
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              color: PdfColor.fromHex('#649c7f'),
              height: 40,
              width: 459,
              child: pw.Text("LAUDO CAUTELAR DE VISTORIA DE VIZINHANÇA",
                  style: pw.TextStyle(
                      fontSize: 15,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold)),
              margin: const pw.EdgeInsets.fromLTRB(0, -15, 0, 5),
              padding: const pw.EdgeInsets.only(left: 10),
            ),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              color: PdfColor.fromHex('#ADADAD'),
              height: 40,
              width: 80,
              child: pw.Text("CÓD.: ${widget.item.name}",
                  style: pw.TextStyle(
                      fontSize: 15,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold)),
              margin: const pw.EdgeInsets.fromLTRB(0, -15, 0, 5),
              padding: const pw.EdgeInsets.only(left: 10),
            ),
          ]),
          footer: (context) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: -25),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Image(gpCertare, width: 100),
                    pw.SizedBox(width: 10),
                    pw.Image(companyCertare, width: 100),
                    pw.SizedBox(width: 10),
                    pw.Image(htb, width: 100),
                    pw.SizedBox(width: 10),
                    pw.Image(ccr, width: 100),
                  ])),
          build: (context) {
            return [
              pw.Row(children: [
                pw.Expanded(
                  child: pw.Container(
                    alignment: pw.Alignment.center,
                    color: PdfColor.fromHex('#649c7f'),
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 0, vertical: 5),
                    child: pw.Text(
                      "GRÁFICO DE OCORRÊNCIAS DE PATOLOGIAS",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#FFFFFF'),
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    margin: const pw.EdgeInsets.only(bottom: 5),
                  ),
                ),
              ]),
              pw.Container(
                color: PdfColor.fromHex('#F0F0F0'),
                width: 550,
                height: 690,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: -100),
                      child: pw.Image(
                        pw.MemoryImage(graphImage!.readAsBytesSync()),
                        width: 300,
                      ),
                    )
                  ],
                ),
              ),
            ];
          },
        ),
      );
    }
  }

  Future<void> addPhotoToPdf(pw.Document doc, String? imagePath,
      String? description, String? environment) async {
    if (imagePath == null) return;
    final file = File(imagePath);
    if (!file.existsSync()) return;

    final Uint8List bytes = await file.readAsBytes();
    final pdfImage = pw.MemoryImage(bytes);

    final gpCertare = pw.MemoryImage(
      (await rootBundle.load('assets/images/footer/gp_certare.png'))
          .buffer
          .asUint8List(),
    );
    final companyCertare = pw.MemoryImage(
      (await rootBundle.load('assets/images/footer/company_certare.png'))
          .buffer
          .asUint8List(),
    );
    final htb = pw.MemoryImage(
      (await rootBundle.load('assets/images/footer/htb.png'))
          .buffer
          .asUint8List(),
    );
    final ccr = pw.MemoryImage(
      (await rootBundle.load('assets/images/footer/CCR.jpg'))
          .buffer
          .asUint8List(),
    );

    doc.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.symmetric(
              horizontal: 1 * PdfPageFormat.cm, vertical: 1 * PdfPageFormat.cm),
          textDirection: pw.TextDirection.ltr,
          orientation: pw.PageOrientation.portrait,
        ),
        header: (final context) =>
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
          pw.Container(
            alignment: pw.Alignment.centerLeft,
            color: PdfColor.fromHex('#649c7f'),
            height: 40,
            width: 459,
            child: pw.Text("LAUDO CAUTELAR DE VISTORIA DE VIZINHANÇA",
                style: pw.TextStyle(
                    fontSize: 15,
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold)),
            margin: const pw.EdgeInsets.fromLTRB(0, -15, 0, 5),
            padding: const pw.EdgeInsets.only(left: 10),
          ),
          pw.Container(
            alignment: pw.Alignment.centerLeft,
            color: PdfColor.fromHex('#ADADAD'),
            height: 40,
            width: 80,
            child: pw.Text("CÓD.: ${widget.item.name}",
                style: pw.TextStyle(
                    fontSize: 15,
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold)),
            margin: const pw.EdgeInsets.fromLTRB(0, -15, 0, 5),
            padding: const pw.EdgeInsets.only(left: 10),
          ),
        ]),
        footer: (context) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: -25),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(gpCertare, width: 100),
                  pw.SizedBox(width: 10),
                  pw.Image(companyCertare, width: 100),
                  pw.SizedBox(width: 10),
                  pw.Image(htb, width: 100),
                  pw.SizedBox(width: 10),
                  pw.Image(ccr, width: 100),
                ])),
        build: (pw.Context context) => [
          pw.Container(
            alignment: pw.Alignment.center,
            color: PdfColor.fromHex('#649c7f'),
            padding: const pw.EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            child: pw.Text(
              "RELATÓRIO FOTOGRÁFICO",
              style: pw.TextStyle(
                color: PdfColor.fromHex('#FFFFFF'),
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            margin: const pw.EdgeInsets.only(bottom: 5),
          ),
          pw.Container(
            color: PdfColor.fromHex('#F0F0F0'),
            height: 700,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Image(pdfImage, height: 305),
                ),
                pw.SizedBox(height: 20),
                pw.Column(children: [
                  _buildDescriptionColumn(description!),
                  _buildEnvironmentColumn(environment!),
                ])
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildDescriptionColumn(String description) {
    final items = description.split('\n');

    if (items.length <= 18) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Text(
              "DESCRIÇÃO:",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                for (final item in items)
                  pw.Text(item, style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      );
    } else {
      final firstColumnItems = items.sublist(0, 18);
      final secondColumnItems = items.sublist(18);

      return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.only(left: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    "DESCRIÇÃO:\n\n",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                for (final item in firstColumnItems)
                  pw.Text(item, style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
          ),
          pw.SizedBox(width: 20),
          pw.Container(
            padding: const pw.EdgeInsets.only(left: -18),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  alignment: pw.Alignment.topCenter, // Align top-center
                  child: pw.Text(
                    "DESCRIÇÃO:\n\n",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                for (final item in secondColumnItems)
                  pw.Text(item, style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
          ),
        ],
      );
    }
  }

  pw.Widget _buildEnvironmentColumn(String environment) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 20),
        pw.Text(
          "AMBIENTE:",
          textAlign: pw.TextAlign.left,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 2),
        pw.Text(environment, style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 5),
      ],
    );
  }

  Future<void> pickPhotosFromGallery(int desiredCount) async {
    final imagePicker = ImagePicker();

    for (int i = 0; i < desiredCount; i++) {
      final List<XFile> imageFiles = await imagePicker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (imageFiles == null) break;

      for (var imageFile in imageFiles) {
        setState(() {
          _currentImageFile = File(imageFile.path);
        });
        _selectedDescriptions.clear();
        _selectedEnvironments.clear();
        await showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: const Color.fromARGB(255, 192, 180, 179),
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Informações da Foto'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_currentImageFile != null)
                    Image.file(
                      _currentImageFile,
                      height: 200,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  MultiSelectDialogField(
                    items: _descriptionItems,
                    title: const Text('Descrição'),
                    selectedItemsTextStyle: const TextStyle(color: Colors.blue),
                    buttonText: const Text('Selecione as descrições'),
                    onConfirm: (values) {
                      setState(() {
                        _selectedDescriptions = values;
                      });
                    },
                    initialValue: _selectedDescriptions,
                  ),
                  MultiSelectDialogField(
                    items: _environmentItems,
                    title: const Text('Ambiente'),
                    selectedItemsTextStyle: const TextStyle(color: Colors.blue),
                    buttonText: const Text('Selecione os ambientes'),
                    onConfirm: (values) {
                      setState(() {
                        _selectedEnvironments = values;
                      });
                    },
                    initialValue: _selectedEnvironments,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      photoDataList.add(PhotoDataMixed(
                        imageFile.path,
                        _selectedDescriptions.join('\n'),
                        _selectedEnvironments.join('\n'),
                      ));
                    });
                    Navigator.pop(context);
                    _savePhotos();
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      }

      String environmentCode =
          getEnvironmentCode(_selectedEnvironments.join('_'));
      int counter = getNextCounterForEnvironment(environmentCode);
      String photoName = '${widget.item.name}_$environmentCode-$counter.jpg';
    }
  }

  Future<void> capturePhotos(int desiredCount) async {
    final imagePicker = ImagePicker();

    _selectedDescriptions.clear();
    _selectedEnvironments.clear();

    for (int i = 0; i < desiredCount; i++) {
      final imageFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (imageFile == null) break;

      await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: const Color.fromARGB(255, 192, 180, 179),
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Informações da Foto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MultiSelectDialogField(
                  items: _descriptionItems,
                  title: const Text('Descrição'),
                  selectedItemsTextStyle: const TextStyle(color: Colors.blue),
                  buttonText: const Text('Selecione as descrições'),
                  onConfirm: (values) {
                    setState(() {
                      _selectedDescriptions = values;
                    });
                  },
                  initialValue: _selectedDescriptions,
                ),
                MultiSelectDialogField(
                  items: _environmentItems,
                  title: const Text('Ambiente'),
                  selectedItemsTextStyle: const TextStyle(color: Colors.blue),
                  buttonText: const Text('Selecione os ambientes'),
                  onConfirm: (values) {
                    setState(() {
                      _selectedEnvironments = values;
                    });
                  },
                  initialValue: _selectedEnvironments,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    photoDataList.add(PhotoDataMixed(
                      imageFile.path,
                      _selectedDescriptions.join('\n'),
                      _selectedEnvironments.join('\n'),
                    ));
                  });
                  Navigator.pop(context);
                  _savePhotos();
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      );

      String environmentCode =
          getEnvironmentCode(_selectedEnvironments.join('_'));
      int counter = getNextCounterForEnvironment(environmentCode);
      String photoName = '${widget.item.name}_$environmentCode-$counter.jpg';
    }
  }

  void editPhotoInfo(int index) async {
    final List<String> initialValuesDescriptions =
        photoDataList[index].description.split('\n');
    final List<String> initialValuesEnvironments =
        photoDataList[index].environment.split('\n');

    List<String> selectedDescriptions = [...initialValuesDescriptions];
    List<String> selectedEnvironments = [...initialValuesEnvironments];

    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color.fromARGB(255, 192, 180, 179),
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Informações da Foto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MultiSelectDialogField(
                items: _descriptionItems,
                title: const Text('Descrição'),
                selectedItemsTextStyle: const TextStyle(color: Colors.blue),
                buttonText: const Text('Selecione as descrições'),
                onConfirm: (values) {
                  setState(() {
                    selectedDescriptions = values;
                  });
                },
                initialValue: selectedDescriptions,
              ),
              MultiSelectDialogField(
                items: _environmentItems,
                title: const Text('Ambiente'),
                selectedItemsTextStyle: const TextStyle(color: Colors.blue),
                buttonText: const Text('Selecione os ambientes'),
                onConfirm: (values) {
                  setState(() {
                    selectedEnvironments = values;
                  });
                },
                initialValue: selectedEnvironments,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Filtrar os dados vazios antes de atualizar o objeto photoDataList[index].
                final filteredDescriptions = selectedDescriptions
                    .where((desc) => desc.isNotEmpty)
                    .toList();
                final filteredEnvironments = selectedEnvironments
                    .where((env) => env.isNotEmpty)
                    .toList();

                setState(() {
                  photoDataList[index].description =
                      filteredDescriptions.join('\n');
                  photoDataList[index].environment =
                      filteredEnvironments.join('\n');
                });
                Navigator.pop(context);
                _savePhotos();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void removePhoto(int index) {
    setState(() {
      photoDataList.removeAt(index);
    });
    _savePhotos();
  }

  void _showNoElementChart() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sem Dados'),
          content:
              const Text('Não há elementos armazenados para gerar o gráfico.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _showNoImagePDF() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nenhuma Imagem Encontrada'),
          content: const Text('Não foi possível encontrar nenhuma imagem.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeletePhotoConfirmationDialog(int index) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar?'),
          content: const Text('Você quer mesmo deletar essa foto?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                removePhoto(index);
                Navigator.pop(context);
              },
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }
}
