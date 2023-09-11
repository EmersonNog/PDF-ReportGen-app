// ignore_for_file: library_private_types_in_public_api, unused_local_variable, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class PieChartScreen extends StatefulWidget {
  final Map<String, double> dataMap;

  const PieChartScreen({super.key, required this.dataMap});

  @override
  _PieChartScreenState createState() => _PieChartScreenState();
}

class _PieChartScreenState extends State<PieChartScreen> {
  late List<Color> colorList;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    colorList = _generateColorList();
  }

  // Função para gerar cores aleatórias
  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  Color _getCenterColor() {
    return Colors.blue; // Replace with the desired color for the center text
  }

  List<Color> _generateColorList() {
    List<Color> colors = [];
    widget.dataMap.forEach((key, value) {
      if (value > 0) {
        final Color randomColor = _getRandomColor();
        if (!colors.contains(randomColor)) {
          colors.add(randomColor);
        }
      }
    });
    return colors;
  }

  Map<String, double> getFilteredDataMap() {
    return Map.fromEntries(
        widget.dataMap.entries.where((entry) => entry.value > 0));
  }

  List<Color> getFilteredColorList() {
    final filteredDataMap = getFilteredDataMap();
    return filteredDataMap.values.map((_) => _getRandomColor()).toList();
  }

  Future<void> _captureAndSaveImage() async {
    try {
      if (globalKey.currentContext == null) {
        print("Error: Widget context is null.");
        return;
      }

      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/pie_chart_temp.png';
      File imageFile = File(imagePath);
      await imageFile.writeAsBytes(pngBytes);

       bool? isImageSaved = await GallerySaver.saveImage(imageFile.path,
        albumName: 'Gráficos');

    if (isImageSaved!) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gráfico salvo na galeria com sucesso', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.greenAccent,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar'),
        ),
      );
    }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error saving image.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredDataMap = getFilteredDataMap();
    final filteredColorList = getFilteredColorList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico de Pizza'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _captureAndSaveImage,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: RepaintBoundary(
              key: globalKey,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 1.3,
                    child: PieChart(
                      dataMap: filteredDataMap,
                      colorList: filteredColorList,
                      animationDuration: const Duration(milliseconds: 1200),
                      chartLegendSpacing: 32.0,
                      chartRadius: MediaQuery.of(context).size.width /
                          2, 
                      initialAngleInDegree: 0,
                      chartType: ChartType.disc,
                      ringStrokeWidth: 32,
                      centerText:
                          "Total: ${widget.dataMap.values.reduce((a, b) => a + b).toInt()}",
                      centerTextStyle: TextStyle(
                          color: _getCenterColor(),
                          fontWeight: FontWeight.bold),
                      legendOptions: const LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.bottom,
                        showLegends: false,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: true,
                        decimalPlaces: 0,
                        chartValueStyle: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: filteredDataMap.entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: filteredColorList[filteredDataMap
                                        .keys
                                        .toList()
                                        .indexOf(entry.key)],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${entry.key}: ${entry.value.toInt()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
